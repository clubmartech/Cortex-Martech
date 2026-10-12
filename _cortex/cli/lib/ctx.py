"""ctx — monta o contexto de renderização (CONTRATOS §7.1) a partir do config e do escopo."""
import datetime

from . import catalog, config as _cfg, fs, routes, interfaces

KERNEL_VERSION = "_cortex/kernel/VERSION"


def hoje():
    return datetime.date.today().isoformat()


def versao_kernel(root):
    t = fs.ler(root, KERNEL_VERSION)
    return (t or "").strip() or "?"


def montar(root, cfg, docs=None, catalogo=None, ancoras=None):
    """Contexto completo. `docs` = lista de catalog.Doc já varrida (evita varrer duas vezes)."""
    cfg = cfg or {}
    docs = docs if docs is not None else catalog.varrer(root)
    ativas, inativas, avisos = routes.subfamilias(root, cfg)
    if catalogo is None:
        catalogo, _, ancoras, _ = catalog.montar(root, cfg, docs)
    total_kb, total_tokens = catalog.totais(catalogo)
    ctx = dict(cfg)
    ctx.update({
        "agora": hoje(),
        "interfaces_contexto": interfaces.resumo(root, cfg),
        "declarar_leituras": (cfg.get("sessao") or {}).get("declaracao_leituras", "sempre") == "sempre",
        "kernel": {"versao": versao_kernel(root)},
        "registro_primario": _cfg.registro_primario(cfg),
        "marca_mae": _cfg.marca_mae(cfg),
        "familias": routes.familias(),
        "subfamilias_ativas": ativas,
        "subfamilias_inativas": inativas,
        "agentes": routes.agentes(docs),
        "catalogo": catalogo,
        "ancoras": ancoras or [],
        "total_kb": total_kb,
        "total_tokens": total_tokens,
        "vocabularios": _cfg.vocabularios(cfg, routes.vocabulario_familia(ativas)),
        "_avisos": avisos,
    })
    return ctx
