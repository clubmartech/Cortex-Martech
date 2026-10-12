"""build — contexto inicial, packs pendentes, catálogo/manifesto, gerados e wrappers (CONTRATOS §1, §8)."""
import json
from pathlib import Path

from . import catalog, ctx as _ctx, fs, packs, render, routes, wrappers, interfaces

TPL = "_cortex/templates"
GERADOS = [  # (destino, template)
    ("ROTAS.md", "ROTAS.md.tpl"),
    ("AGENTS.md", "AGENTS.md.tpl"),
    ("CLAUDE.md", "CLAUDE.md.tpl"),
    ("ABERTURA-SESSAO.md", "ABERTURA-SESSAO.md.tpl"),
    ("_cortex/.build/boot.md", "boot.md.tpl"),
]
CATALOGO_MD = ("CATALOGO.md", "CATALOGO.md.tpl")
PASTAS = ["contexto", "contexto/brandcenter", "contexto/brandcenter/marcas", "contexto/produtos",
          "contexto/publicos", "contexto/integracoes", "times", "iniciativas", "briefings",
          "_saida", "_assets", "_arquivo", "_cortex/.build", ".claude/hooks", ".claude/skills"]
ONLY = {"rotas", "catalogo", "wrappers", "contexto", "boot", "interfaces"}


class BuildError(RuntimeError):
    pass


def _tpl(root, nome):
    t = fs.ler(root, "%s/%s" % (TPL, nome))
    if t is None:
        raise BuildError("template ausente: %s/%s" % (TPL, nome))
    return t


def _render(root, nome, contexto, cfg, faltantes):
    out, falt = render.render(_tpl(root, nome), contexto, cfg)
    for f in falt:
        faltantes.append("%s: {{%s}}" % (nome, f))
    return out


# ---------------------------------------------------------------- contexto inicial

def plano_contexto(root, cfg, contexto, first_run=False):
    """{destino: conteúdo} dos arquivos de contexto a gerar (ausentes, ou todos com first_run)."""
    cfg = cfg or {}
    itens = [("contexto/organizacao.md", "organizacao.md.tpl", None),
             ("contexto/brandcenter/brandcenter.md", "brandcenter.md.tpl", None),
             ("briefings/_modelo.md", "briefing.md.tpl", None),
             (".env.example", "env.example.tpl", None),
             (".gitignore", "gitignore.tpl", None),
             (".claude/settings.json", "settings.json.tpl", None)]
    for m in cfg.get("marcas") or []:
        itens.append(("contexto/brandcenter/marcas/%s.md" % m.get("slug"), "marca.md.tpl", m))
    for p in cfg.get("produtos") or []:
        itens.append(("contexto/produtos/%s/%s.md" % (p.get("slug"), p.get("slug")), "produto.md.tpl", p))
    for p in cfg.get("publicos") or []:
        itens.append(("contexto/publicos/%s.md" % p.get("slug"), "publico.md.tpl", p))
    for v in cfg.get("vozes") or []:
        dest = v.get("doc") or "contexto/vozes/%s.md" % v.get("slug")
        itens.append((dest, "voz.md.tpl", v))
    for i in cfg.get("integracoes") or []:
        itens.append(("contexto/integracoes/%s.md" % i.get("slug"), "integracao.md.tpl", i))
    saida, faltantes = {}, []
    for dest, tpl, item in itens:
        if not first_run and fs.existe(root, dest):
            continue
        if not (Path(root) / TPL / tpl).exists():
            faltantes.append("template ausente: %s" % tpl)
            continue
        c = dict(contexto)
        if item is not None:
            c["item"] = item
        saida[dest] = _render(root, tpl, c, cfg, faltantes)
    return saida, faltantes


# ---------------------------------------------------------------- gerados

def plano_gerados(root, cfg, docs=None):
    """Calcula em memória tudo que o build gera. Devolve dict com saídas, manifest, catálogo, wrappers."""
    docs = docs if docs is not None else catalog.varrer(root)
    faltantes = []
    contexto = _ctx.montar(root, cfg, docs)
    avisos = list(contexto.get("_avisos") or [])
    saidas = {}
    for dest, tpl in GERADOS:
        saidas[dest] = _render(root, tpl, contexto, cfg, faltantes)
    # substitui os gerados em memória para medir o catálogo com o conteúdo novo
    por_caminho = {d.caminho: d for d in docs}
    for dest, conteudo in saidas.items():
        if dest.startswith("_cortex/.build/"):
            continue
        por_caminho[dest] = catalog.Doc(dest, conteudo)
    docs2 = sorted(por_caminho.values(), key=lambda d: d.caminho)
    anterior = fs.ler(root, CATALOGO_MD[0])
    if anterior is not None:
        por_caminho[CATALOGO_MD[0]] = catalog.Doc(CATALOGO_MD[0], anterior)
    catalogo = manifest = ancoras = None
    conteudo_cat = None
    for _ in range(5):  # ponto fixo: o CATALOGO lista o próprio tamanho
        docs2 = sorted(por_caminho.values(), key=lambda d: d.caminho)
        catalogo, manifest, ancoras, _ = catalog.montar(root, cfg, docs2)
        c2 = _ctx.montar(root, cfg, docs2, catalogo, ancoras)
        novo = _render(root, CATALOGO_MD[1], c2, cfg, faltantes)
        if novo == conteudo_cat:
            break
        conteudo_cat = novo
        por_caminho[CATALOGO_MD[0]] = catalog.Doc(CATALOGO_MD[0], novo)
    saidas[CATALOGO_MD[0]] = conteudo_cat
    docs2 = sorted(por_caminho.values(), key=lambda d: d.caminho)
    catalogo, manifest, ancoras, _ = catalog.montar(root, cfg, docs2)
    esp = wrappers.esperados(root, docs2, contexto, cfg)
    manifest["wrappers"] = {_wid(k): fs.hash_texto(v) for k, v in esp.items()}
    return {"saidas": saidas, "manifest": manifest, "catalogo": catalogo, "wrappers": esp,
            "faltantes": sorted(set(faltantes)), "avisos": avisos, "docs": docs2, "contexto": contexto}


def _wid(relp):
    partes = relp.split("/")
    return partes[2] if relp.startswith(wrappers.SKILLS_DIR) else partes[-1][:-3]


# ---------------------------------------------------------------- execução

def executar(root, cfg, first_run=False, only=None, log=print):
    """Roda o build completo (ou só a etapa `only`). Devolve lista de arquivos alterados."""
    if only and only not in ONLY:
        raise BuildError("--only aceita: " + "|".join(sorted(ONLY)))
    # Validar antes de qualquer escrita: uma referência quebrada não gera estado parcial.
    registry = interfaces.carregar(root, cfg)
    errors = interfaces.verificar(registry)
    if errors:
        raise BuildError("\n".join(errors))
    alterados, removidos, avisos = [], [], []
    if only in (None, "interfaces") and registry is not None:
        if catalog.gravar_json(root, interfaces.INDEX, interfaces.indice(registry)):
            alterados.append(interfaces.INDEX)
    if only == "interfaces":
        return _fim(alterados, removidos, avisos, log)
    for p in PASTAS:
        fs.mkdir(root, p)

    if only in (None, "contexto"):
        contexto = _ctx.montar(root, cfg)
        plano, falt = plano_contexto(root, cfg, contexto, first_run)
        avisos.extend(falt)
        for dest, conteudo in plano.items():
            if fs.gravar(root, dest, conteudo):
                alterados.append(dest)
        if only == "contexto":
            return _fim(alterados, removidos, avisos, log)

    if only is None:
        for pid in packs.pendentes(root, cfg):
            try:
                r = packs.instalar(root, cfg, pid)
                alterados.extend(r["criados"])
                if r["faltando"]:
                    avisos.append("pack `%s`: templates ausentes: %s" % (pid, ", ".join(r["faltando"])))
                if r["config_alterado"]:
                    alterados.append("cortex.config.yaml")
            except packs.PackError as e:
                avisos.append("pack `%s` não instalado: %s" % (pid, e))

    plano = plano_gerados(root, cfg)
    avisos.extend(plano["avisos"])
    for f in plano["faltantes"]:
        avisos.append("valor ausente no template — " + f)
    quais = {
        None: set(plano["saidas"]),
        "rotas": {"ROTAS.md", "AGENTS.md", "CLAUDE.md"},
        "boot": {"_cortex/.build/boot.md"},
        "catalogo": {"CATALOGO.md"},
        "wrappers": set(),
    }[only]
    for dest in quais:
        if fs.gravar(root, dest, plano["saidas"][dest]):
            alterados.append(dest)
    if only in (None, "catalogo"):
        if catalog.gravar_json(root, catalog.CATALOGO, plano["catalogo"]):
            alterados.append(catalog.CATALOGO)
    if only in (None, "wrappers"):
        alt, rem, _ = wrappers.gerar(root, plano["docs"], plano["contexto"], cfg)
        alterados.extend(alt)
        removidos.extend(rem)
    if only in (None, "catalogo", "wrappers"):
        # manifesto: só muda se hashes mudarem (gerado_em é só a data)
        atual = catalog.ler_manifest(root) or {}
        novo = plano["manifest"]
        if atual.get("ids") == novo["ids"] and atual.get("wrappers") == novo["wrappers"]:
            novo["gerado_em"] = atual.get("gerado_em", novo["gerado_em"])
        if catalog.gravar_json(root, catalog.MANIFEST, novo):
            alterados.append(catalog.MANIFEST)
    return _fim(alterados, removidos, avisos, log)


def _fim(alterados, removidos, avisos, log):
    for a in alterados:
        log("  ✎ " + a)
    for r in removidos:
        log("  ✕ " + r + " (wrapper órfão removido)")
    for a in avisos:
        log("  ! " + a)
    n = len(alterados) + len(removidos)
    log("%d arquivo(s) alterado(s)." % n if n else "0 arquivos alterados.")
    return alterados, removidos, avisos
