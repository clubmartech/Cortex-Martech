"""packs — list / install / diff de packs (CONTRATOS §5)."""
import datetime
import re
from pathlib import Path

from . import config as _cfg, ctx as _ctx, fs, render, routes


class PackError(RuntimeError):
    pass


def listar(root, cfg):
    """Lista de dicts {id, nome, versao, descricao, instalado, time}."""
    instalados = {p.get("id"): p for p in ((cfg or {}).get("packs") or []) if isinstance(p, dict)}
    saida = []
    for pid in routes.packs_disponiveis(root):
        p = routes.carregar_pack(root, pid) or {}
        inst = instalados.get(pid)
        saida.append({"id": pid, "nome": p.get("nome") or pid, "versao": str(p.get("versao") or ""),
                      "descricao": p.get("descricao") or "", "instalado": inst is not None,
                      "time": (inst or {}).get("instalado_em") or ""})
    for pid, inst in instalados.items():
        if pid not in [s["id"] for s in saida]:
            saida.append({"id": pid, "nome": pid, "versao": str(inst.get("versao") or ""), "descricao": "",
                          "instalado": True, "time": inst.get("instalado_em") or "", "ausente": True})
    return saida


def _time_para(cfg, pack, time_slug=None):
    times = (cfg or {}).get("times") or []
    if time_slug:
        for t in times:
            if t.get("slug") == time_slug:
                return t
        raise PackError("time `%s` não existe em times[] (%s)" % (time_slug, ", ".join(t.get("slug", "") for t in times)))
    for t in times:
        if t.get("pack") == pack.get("id"):
            return t
    for t in times:
        if t.get("slug") == pack.get("time_padrao"):
            return t
    if len(times) == 1:
        return times[0]
    raise PackError("informe --time <slug>: nenhum time do config aponta para o pack `%s` (times: %s)"
                    % (pack.get("id"), ", ".join(t.get("slug", "") for t in times)))


def _destino(time, caminho_tpl):
    rel = caminho_tpl[:-4] if caminho_tpl.endswith(".tpl") else caminho_tpl
    return "times/%s/%s" % (time.get("slug"), rel)


def _forca_origem(texto, pack):
    marca = "pack:%s@%s" % (pack.get("id"), pack.get("versao"))
    if texto.startswith("---"):
        cab, sep, resto = texto[3:].partition("\n---")
        if sep:
            if re.search(r"^origem:.*$", cab, re.M):
                cab = re.sub(r"^origem:.*$", "origem: " + marca, cab, count=1, flags=re.M)
            else:
                cab = cab.rstrip("\n") + "\norigem: " + marca + "\n"
            return "---" + cab + sep + resto
    return texto


def itens_para(cfg, pack, caminho_tpl):
    """Lista sobre a qual um template `...{{item.slug}}...` itera.

    `pack.yaml` pode declarar `itens: {"docs/fonte-{{item.slug}}.md.tpl": "integracoes:dados,analytics"}`.
    Fonte = nome de uma lista do config (`produtos`, `publicos`, `marcas`, `canais`, `integracoes`, `vozes`),
    opcionalmente filtrada por `tipo` com `:a,b`. Padrão: `produtos`."""
    espec = (pack.get("itens") or {}).get(caminho_tpl) or "produtos"
    lista, _, tipos = str(espec).partition(":")
    itens = list(cfg.get(lista.strip()) or [])
    if tipos.strip():
        aceitos = {t.strip() for t in tipos.split(",") if t.strip()}
        itens = [i for i in itens if isinstance(i, dict) and i.get("tipo") in aceitos]
    return itens


def renderizar(root, cfg, pack, time, base_ctx=None):
    """{destino_relativo: conteúdo} de todos os arquivos que o pack instancia para este config."""
    base_ctx = base_ctx or _ctx.montar(root, cfg)
    ativas, _ = routes.subfamilias_pack(cfg, pack)
    arquivos = list(pack.get("arquivos_base") or [])
    for s in ativas:
        for a in s.get("arquivos") or []:
            if a not in arquivos:
                arquivos.append(a)
    saida, faltando = {}, []
    for caminho_tpl in arquivos:
        tpl = fs.ler(root, "%s/%s" % (pack["_dir"], caminho_tpl))
        if tpl is None:
            faltando.append(caminho_tpl)
            continue
        itens = [None]
        if "{{item." in caminho_tpl:
            itens = itens_para(cfg, pack, caminho_tpl)
        for item in itens:
            c = dict(base_ctx)
            c.update({"pack": pack, "time": time})
            if item is not None:
                c["item"] = item
            nome, _ = render.render(caminho_tpl, c, cfg)
            conteudo, _ = render.render(tpl, c, cfg)
            saida[_destino(time, nome)] = _forca_origem(conteudo, pack)
    return saida, faltando, [s["id"] for s in ativas]


def instalar(root, cfg, pack_id, time_slug=None, gravar_config=True, base_ctx=None):
    """Instala o pack. Devolve dict com criados, existentes, faltando, time, subfamilias."""
    pack = routes.carregar_pack(root, pack_id)
    if pack is None:
        raise PackError("pack `%s` não existe em %s/ (disponíveis: %s)"
                        % (pack_id, routes.PACKS_DIR, ", ".join(routes.packs_disponiveis(root)) or "nenhum"))
    for chave in pack.get("requer_config") or []:
        if not _cfg.truthy(cfg.get(chave)):
            raise PackError("pack `%s` exige `%s` preenchido no config" % (pack_id, chave))
    time = _time_para(cfg, pack, time_slug)
    arquivos, faltando, ativas = renderizar(root, cfg, pack, time, base_ctx)
    criados, existentes = [], []
    for relp, conteudo in arquivos.items():
        if fs.existe(root, relp):
            existentes.append(relp)
            continue
        fs.gravar(root, relp, conteudo)
        criados.append(relp)
    # registra no config
    entrada = None
    for p in cfg.setdefault("packs", []):
        if isinstance(p, dict) and p.get("id") == pack_id:
            entrada = p
    if entrada is None:
        entrada = {"id": pack_id}
        cfg["packs"].append(entrada)
    entrada["versao"] = str(pack.get("versao") or "")
    entrada["instalado_em"] = "times/%s" % time.get("slug")
    entrada["subfamilias_ativas"] = ativas
    if not time.get("pack"):
        time["pack"] = pack_id
    cfg_mudou = _cfg.gravar(root, cfg) if gravar_config else False
    return {"pack": pack_id, "time": time.get("slug"), "criados": criados, "existentes": existentes,
            "faltando": faltando, "subfamilias_ativas": ativas, "config_alterado": cfg_mudou}


def diff(root, cfg, pack_id, time_slug=None):
    """Compara o render atual com o instalado. Devolve {iguais, divergentes, ausentes, faltando}."""
    pack = routes.carregar_pack(root, pack_id)
    if pack is None:
        raise PackError("pack `%s` não existe em %s/" % (pack_id, routes.PACKS_DIR))
    time = _time_para(cfg, pack, time_slug)
    arquivos, faltando, _ = renderizar(root, cfg, pack, time)
    iguais, divergentes, ausentes = [], [], []
    for relp, conteudo in arquivos.items():
        atual = fs.ler(root, relp)
        if atual is None:
            ausentes.append(relp)
        elif atual == conteudo:
            iguais.append(relp)
        else:
            divergentes.append(relp)
    return {"pack": pack_id, "time": time.get("slug"), "iguais": iguais, "divergentes": divergentes,
            "ausentes": ausentes, "faltando": faltando}


def pendentes(root, cfg):
    """Packs em cfg.packs[] cuja pasta `times/<time>/` ainda não tem nada instanciado."""
    saida = []
    for p in (cfg or {}).get("packs") or []:
        if not isinstance(p, dict):
            continue
        dest = p.get("instalado_em") or ""
        pasta = Path(root) / dest
        if not dest or not pasta.is_dir() or not any(pasta.rglob("*.md")):
            saida.append(p.get("id"))
    return saida
