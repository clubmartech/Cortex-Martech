"""routes — famílias do kernel, sub-famílias dos packs (ativas/inativas) e lista de agentes."""
from pathlib import Path

from . import config as _cfg
from . import fs, yamlmini

PACKS_DIR = "_cortex/packs"
# rotas fixas do kernel (ROTAS.md §2.x) — ids que o kernel sempre referencia
AGENTES_KERNEL_ROTEADOS = {"maestro", "entrevistador", "revisor", "registrador", "documentador", "skill-creator"}


class BuildError(RuntimeError):
    pass


def familias():
    return [{"id": f, "orcamento": o, "sinal": s} for f, o, s in _cfg.FAMILIAS_KERNEL]


def carregar_pack(root, pack_id):
    """pack.yaml carregado (dict) ou None se o pack não existe em _cortex/packs/."""
    t = fs.ler(root, "%s/%s/pack.yaml" % (PACKS_DIR, pack_id))
    if t is None:
        return None
    p = yamlmini.load(t)
    p.setdefault("id", pack_id)
    p["_dir"] = "%s/%s" % (PACKS_DIR, pack_id)
    return p


def packs_disponiveis(root):
    base = Path(root) / PACKS_DIR
    if not base.is_dir():
        return []
    return sorted(d.name for d in base.iterdir() if d.is_dir() and (d / "pack.yaml").exists())


def subfamilias(root, cfg, orcamento_padrao=None):
    """(ativas, inativas, avisos) de todos os packs do config. Falha se obrigatorio > orcamento."""
    ativas, inativas, avisos = [], [], []
    cfg = cfg or {}
    for pk in cfg.get("packs") or []:
        pid = pk.get("id") if isinstance(pk, dict) else pk
        pack = carregar_pack(root, pid)
        if pack is None:
            avisos.append("pack `%s` listado no config não existe em %s/" % (pid, PACKS_DIR))
            continue
        a, i = subfamilias_pack(cfg, pack, orcamento_padrao)
        ativas.extend(a)
        inativas.extend(i)
    ordem = {f: i for i, f in enumerate(_cfg.ORDEM_FAMILIAS)}
    ativas.sort(key=lambda s: (ordem.get(s["familia"], 99), s["id"]))
    inativas.sort(key=lambda s: (ordem.get(s["id"].split(".")[0], 99), s["id"]))
    return ativas, inativas, avisos


def subfamilias_pack(cfg, pack, orcamento_padrao=None):
    """(ativas, inativas) de um único pack carregado."""
    ativas, inativas = [], []
    cfg = cfg or {}
    pid = pack.get("id")
    orc_padrao = orcamento_padrao or (cfg.get("rotas") or {}).get("orcamento_padrao") or 5
    if True:
        for sf in pack.get("subfamilias") or []:
            sid = sf.get("id") or ""
            familia = sid.split(".")[0]
            cond = sf.get("condicao") or "sempre"
            orc = sf.get("orcamento") or orc_padrao
            obrig = list(sf.get("obrigatorio") or [])
            if len(obrig) > orc:
                raise BuildError("sub-família `%s` (pack %s) declara %d arquivos obrigatórios, acima do orçamento %d"
                                 % (sid, pid, len(obrig), orc))
            desligadas = (cfg.get("rotas") or {}).get("familias_inativas", []) or []
            if familia in desligadas or sid in desligadas:  # família inteira ou só a sub-família
                inativas.append({"id": sid, "nome": sf.get("nome") or sid, "pack": pid, "condicao": cond,
                                 "motivo": "`%s` desativada em rotas.familias_inativas" % (sid if sid in desligadas else familia)})
                continue
            if _cfg.avaliar_condicao(cond, cfg):
                ativas.append({
                    "id": sid, "familia": familia, "nome": sf.get("nome") or sid,
                    "sinais": list(sf.get("sinais") or []), "obrigatorio": obrig,
                    "condicional": [dict(c) for c in (sf.get("condicional") or []) if isinstance(c, dict)],
                    "complementar": list(sf.get("complementar") or []), "orcamento": orc,
                    "pack": pid, "condicao": cond, "arquivos": list(sf.get("arquivos") or []),
                })
            else:
                inativas.append({"id": sid, "nome": sf.get("nome") or sid, "pack": pid, "condicao": cond,
                                 "motivo": _cfg.motivo_condicao(cond, cfg)})
    return ativas, inativas


def vocabulario_familia(ativas):
    return [f for f, _, _ in _cfg.FAMILIAS_KERNEL] + [s["id"] for s in ativas]


def agentes(docs):
    """`{id, caminho, origem, descricao, subagente}` de todo tipo: agent; kernel primeiro."""
    saida = []
    for d in docs:
        if d.tipo == "agent" and d.id:
            saida.append({"id": d.id, "caminho": d.caminho, "origem": d.fm.get("origem") or "",
                          "descricao": d.fm.get("descricao") or "", "subagente": bool(d.fm.get("subagente"))})
    saida.sort(key=lambda a: (0 if a["caminho"].startswith("_cortex/kernel/") else 1, a["caminho"]))
    return saida


def ids_roteados(ativas):
    """Todos os ids citados em rotas ativas + rotas fixas do kernel."""
    ids = set(AGENTES_KERNEL_ROTEADOS)
    for s in ativas:
        ids.update(s["obrigatorio"])
        ids.update(s["complementar"])
        for c in s["condicional"]:
            a = str(c.get("abrir") or "")
            if a and not a.startswith("§"):
                ids.add(a)
    return ids


def sugeridos(root, cfg):
    """Packs disponíveis cuja condição `sugerir_se` é verdadeira para o config e que não estão instalados."""
    from . import config as _cfg
    instalados = set(_cfg.packs_instalados(cfg))
    out = []
    for pid in packs_disponiveis(root):
        if pid in instalados:
            continue
        pack = carregar_pack(root, pid)
        cond = str((pack or {}).get("sugerir_se") or "nunca")
        if _cfg.avaliar_condicao(cond, cfg):
            out.append({"id": pid, "nome": pack.get("nome") or pid, "condicao": cond,
                        "time_padrao": pack.get("time_padrao") or "", "requer_config": pack.get("requer_config") or []})
    return out

