"""config — cortex.config.yaml: carga, validação (mini-schema), vocabulários e condições (§6)."""
import json
import re
from pathlib import Path

from . import yamlmini

ARQUIVO = "cortex.config.yaml"
SCHEMA = "_cortex/onboarding/schema/cortex.config.schema.json"
FAMILIAS_KERNEL = [
    ("CRIAR", 5, "peça ou artefato novo"),
    ("PLANEJAR", 7, "campanha, plano, experimento, budget, evento, conta-alvo"),
    ("ANALISAR", 6, "resultado, relatório, funil, atribuição"),
    ("CONSULTAR", 3, "dado já documentado, read-only"),
    ("OPERAR", 4, "base de contatos, automação, integração"),
    ("REVISAR", 2, "humanizar, QA de texto pronto"),
    ("REGISTRAR", 3, "subir no registro, ata, card"),
    ("DOCUMENTAR", 4, "documentar produto/processo, atualizar dado da base"),
    ("GOVERNAR", 4, "criar/corrigir skill, auditar, configurar o Cortex"),
]
ORDEM_FAMILIAS = [f[0] for f in FAMILIAS_KERNEL]


def carregar(root):
    p = Path(root) / ARQUIVO
    if not p.exists():
        return None
    return yamlmini.load(p.read_text(encoding="utf-8"))


def gravar(root, cfg):
    from .fs import gravar as _gravar
    return _gravar(root, ARQUIVO, yamlmini.dump(cfg))


def carregar_schema(root):
    p = Path(root) / SCHEMA
    if not p.exists():
        return None
    return json.loads(p.read_text(encoding="utf-8"))


# ---------------------------------------------------------------- validação

def _tipo_ok(v, t):
    return {
        "object": isinstance(v, dict),
        "array": isinstance(v, list),
        "string": isinstance(v, str),
        "integer": isinstance(v, int) and not isinstance(v, bool),
        "number": isinstance(v, (int, float)) and not isinstance(v, bool),
        "boolean": isinstance(v, bool),
    }.get(t, True)


def validar(cfg, schema, caminho="$"):
    """Mini-validador: type/required/enum/properties/items/minItems/pattern. Lista de erros."""
    erros = []
    if schema is None:
        return erros
    t = schema.get("type")
    if t and not _tipo_ok(cfg, t):
        erros.append("%s: esperava %s, veio %s" % (caminho, t, type(cfg).__name__ if cfg is not None else "vazio"))
        return erros
    if "enum" in schema and cfg not in schema["enum"]:
        erros.append("%s: valor `%s` fora de %s" % (caminho, cfg, schema["enum"]))
    if "pattern" in schema and isinstance(cfg, str) and not re.search(schema["pattern"], cfg):
        erros.append("%s: `%s` não casa com o padrão %s" % (caminho, cfg, schema["pattern"]))
    if isinstance(cfg, dict):
        for r in schema.get("required", []):
            if r not in cfg or cfg[r] is None:
                erros.append("%s: falta a chave obrigatória `%s`" % (caminho, r))
        for k, sub in schema.get("properties", {}).items():
            if k in cfg and cfg[k] is not None:
                erros.extend(validar(cfg[k], sub, caminho + "." + k))
    if isinstance(cfg, list):
        if "minItems" in schema and len(cfg) < schema["minItems"]:
            erros.append("%s: precisa de pelo menos %d item(ns)" % (caminho, schema["minItems"]))
        if "items" in schema:
            for i, x in enumerate(cfg):
                erros.extend(validar(x, schema["items"], "%s[%d]" % (caminho, i)))
    return erros


def validar_referencias(cfg):
    """Slugs únicos e referências cruzadas (check 2)."""
    erros = []

    def slugs(chave):
        return [x.get("slug") for x in (cfg.get(chave) or []) if isinstance(x, dict)]

    for chave in ("marcas", "produtos", "publicos", "canais", "integracoes", "times", "papeis", "vozes"):
        vistos = set()
        for s in slugs(chave):
            if s in vistos:
                erros.append("%s: slug `%s` repetido" % (chave, s))
            vistos.add(s)
    papeis = set(slugs("papeis"))
    marcas = set(slugs("marcas"))
    publicos = set(slugs("publicos"))
    packs_cfg = [p.get("id") for p in (cfg.get("packs") or []) if isinstance(p, dict)]
    for t in cfg.get("times") or []:
        for p in t.get("papeis") or []:
            if p not in papeis:
                erros.append("times[%s].papeis: papel `%s` não existe em papeis[]" % (t.get("slug"), p))
        if t.get("pack") and t.get("pack") not in packs_cfg:
            erros.append("times[%s].pack: pack `%s` não está em packs[]" % (t.get("slug"), t.get("pack")))
    rat = (cfg.get("governanca") or {}).get("ratificador")
    if rat and rat not in papeis:
        erros.append("governanca.ratificador: papel `%s` não existe em papeis[]" % rat)
    for p in cfg.get("produtos") or []:
        if p.get("marca") not in marcas:
            erros.append("produtos[%s].marca: marca `%s` não existe" % (p.get("slug"), p.get("marca")))
        for pub in p.get("publicos") or []:
            if pub not in publicos:
                erros.append("produtos[%s].publicos: público `%s` não existe" % (p.get("slug"), pub))
    for pp in cfg.get("papeis") or []:
        if pp.get("time") and pp.get("time") not in set(slugs("times")):
            erros.append("papeis[%s].time: time `%s` não existe" % (pp.get("slug"), pp.get("time")))
    return erros


# ---------------------------------------------------------------- acessores

def marca_mae(cfg):
    marcas = (cfg or {}).get("marcas") or []
    for m in marcas:
        if m.get("mae"):
            return m
    return marcas[0] if marcas else {}


def registro_primario(cfg):
    for i in (cfg or {}).get("integracoes") or []:
        if i.get("registro_primario"):
            return i
    return {}


def packs_instalados(cfg):
    return [p.get("id") for p in ((cfg or {}).get("packs") or []) if isinstance(p, dict)]


def vocabularios(cfg, familias):
    """Mapa de listas: familia, output, canal, ferramenta, produto, publico, owner."""
    from . import fm
    cfg = cfg or {}

    def slugs(k):
        return [x.get("slug") for x in (cfg.get(k) or []) if isinstance(x, dict) and x.get("slug")]

    return {
        "familia": list(familias),
        "output": list(fm.OUTPUTS),
        "canal": slugs("canais"),
        "ferramenta": slugs("integracoes"),
        "produto": slugs("produtos") + ["todos"],
        "publico": slugs("publicos"),
        "owner": slugs("papeis") + ["cortex"],
    }


def status_onboarding(cfg):
    if not cfg:
        return "ausente"
    return ((cfg.get("meta") or {}).get("onboarding") or {}).get("status") or "pending"


# ---------------------------------------------------------------- condições §6

def caminho(obj, expr):
    """Resolve `a.b.c` em dicts/listas (índice numérico em lista). None se ausente."""
    cur = obj
    for parte in expr.split("."):
        if isinstance(cur, dict):
            if parte not in cur:
                return None
            cur = cur[parte]
        elif isinstance(cur, list):
            if parte.isdigit() and int(parte) < len(cur):
                cur = cur[int(parte)]
            else:
                # `publicos.territorio` → algum item tem o campo truthy
                vals = [x.get(parte) for x in cur if isinstance(x, dict)]
                vals = [v for v in vals if truthy(v)]
                return vals or None
        else:
            return None
    return cur


def truthy(v):
    if v is None or v is False:
        return False
    if isinstance(v, (str, list, dict)):
        return len(v) > 0
    if isinstance(v, (int, float)):
        return v != 0
    return bool(v)


def _token(tok, cfg, extras):
    tok = tok.strip()
    if tok in ("sempre", "true"):
        return True
    if tok in ("nunca", "false"):
        return False
    m = re.match(r"^([A-Za-z_][\w.@]*)\s*(==|!=)\s*(.*)$", tok)
    if m:
        esq = resolver(m.group(1), cfg, extras)
        dir_ = m.group(3).strip()
        if len(dir_) >= 2 and dir_[0] == dir_[-1] and dir_[0] in "\"'":
            dir_ = dir_[1:-1]
        esq_s = "" if esq is None else (str(esq).lower() if isinstance(esq, bool) else str(esq))
        return (esq_s == dir_) if m.group(2) == "==" else (esq_s != dir_)
    if ":" not in tok:
        return truthy(resolver(tok, cfg, extras))
    pref, _, val = tok.partition(":")
    cfg = cfg or {}
    if pref == "canal":
        return val in [c.get("slug") for c in cfg.get("canais") or []]
    if pref == "integracao":
        return val in [i.get("tipo") for i in cfg.get("integracoes") or []]
    if pref == "ferramenta":
        return val in [i.get("slug") for i in cfg.get("integracoes") or []]
    if pref == "oferta":
        return val in [p.get("tipo") for p in cfg.get("produtos") or []]
    if pref == "modelo_comercial":
        return (cfg.get("organizacao") or {}).get("modelo_comercial") == val
    if pref == "segmento":
        return (cfg.get("organizacao") or {}).get("segmento") == val
    if pref == "tem":
        return truthy(resolver(val, cfg, extras))
    if pref == "pack":
        return val in packs_instalados(cfg)
    if pref == "ambiente":
        return val in ((cfg.get("sessao") or {}).get("ambiente") or [])
    if pref == "time":
        return val in [t.get("slug") for t in cfg.get("times") or []]
    if pref == "papel":
        return val in [p.get("slug") for p in cfg.get("papeis") or []]
    if pref == "publico":
        return val in [p.get("tipo") for p in cfg.get("publicos") or []]
    return truthy(resolver(tok, cfg, extras))


def resolver(expr, cfg, extras):
    """Procura o caminho primeiro nos extras (contexto de render) e depois no config."""
    if extras:
        if callable(extras):
            v = extras(expr)
            if v is not None:
                return v
        else:
            v = caminho(extras, expr)
            if v is not None:
                return v
    return caminho(cfg or {}, expr)


def avaliar_condicao(expr, cfg, extras=None):
    """`a and b or not c` (and liga mais forte que or; `not` no início do token)."""
    expr = (expr or "").strip()
    if expr == "":
        return True
    for grupo_or in re.split(r"\s+or\s+", expr):
        ok = True
        for tok in re.split(r"\s+and\s+", grupo_or):
            tok = tok.strip()
            neg = False
            if tok.startswith("not "):
                neg, tok = True, tok[4:].strip()
            v = _token(tok, cfg, extras)
            if neg:
                v = not v
            if not v:
                ok = False
                break
        if ok:
            return True
    return False


_MOTIVOS = {
    "canal": "nenhum canal `{v}` configurado",
    "integracao": "nenhuma integração do tipo `{v}`",
    "ferramenta": "integração `{v}` não configurada",
    "oferta": "nenhuma oferta do tipo `{v}`",
    "modelo_comercial": "modelo comercial não é `{v}`",
    "segmento": "segmento não é `{v}`",
    "tem": "`{v}` não definido no config",
    "pack": "pack `{v}` não instalado",
    "ambiente": "ambiente `{v}` não está em sessao.ambiente",
    "time": "nenhum time `{v}` configurado",
    "papel": "nenhum papel `{v}` configurado",
    "publico": "nenhum público do tipo `{v}`",
}


def motivo_condicao(expr, cfg, extras=None):
    """Explica em linguagem natural por que a condição é falsa."""
    partes = []
    for grupo_or in re.split(r"\s+or\s+", expr or ""):
        falsos = []
        for tok in re.split(r"\s+and\s+", grupo_or):
            tok = tok.strip()
            neg = tok.startswith("not ")
            base = tok[4:].strip() if neg else tok
            v = _token(base, cfg, extras)
            if neg:
                v = not v
            if not v:
                pref, _, val = base.partition(":")
                txt = _MOTIVOS.get(pref, "condição `{v}` falsa").format(v=val or base)
                if neg:
                    txt = "`%s` está configurado (condição negada)" % base
                falsos.append(txt)
        if falsos:
            partes.append(" e ".join(falsos))
    return " · ".join(partes) if partes else "condição falsa"
