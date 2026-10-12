#!/usr/bin/env python3
"""radar.py — plano de busca e triagem de referências visuais do nicho.

Uso:
  radar.py plano  <fontes-de-referencia.md> [--termos "a; b"] [--por-fonte 3] [--incluir-pagas] [--saida pasta]
      Lê `visual.*` do cortex.config.yaml e o registro de fontes; gera `plano.md`, `plano.json`
      e um `lote.json` vazio no formato que a triagem espera.
  radar.py triar  <lote.json> [--anteriores a.triado.json …] [--minimo 10] [--por-autor 3]
      Soma as notas (6 critérios, 0–3), aplica licença, nota mínima, limite por autor, URL repetida,
      confere cotas por tipo e saturação; grava `<lote>.triado.json` e `<lote>.triado.md` para aprovação.

O script não navega nem baixa nada: a busca é feita pela IA ou pela pessoa, no navegador ou por API,
respeitando `acesso`, `uso` e `proibido` de cada fonte. Triagem não é aprovação: a pessoa aprova.
"""
import argparse
import datetime
import json
import sys
from pathlib import Path
from urllib.parse import quote, quote_plus

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _comum  # noqa: E402
import acervo as A  # noqa: E402

CRITERIOS = ("aderencia", "execucao", "distancia_cliche", "aplicabilidade", "licenca", "atualidade")
COTAS_PADRAO = {"foto": 30, "carrossel": 20, "video": 20, "web": 15, "tipografia-cor": 15}
GRUPO_TIPO = {"foto": "foto", "banco-livre": "foto", "carrossel": "carrossel", "post": "carrossel",
              "video": "video", "motion": "video", "web": "web", "ui": "web", "tipografia": "tipografia-cor",
              "cor": "tipografia-cor", "prompt": "foto", "moodboard": "foto", "portfolio": "web"}
PRIORIDADE = {"propria": 0, "nicho": 1, "sugerida": 2}


def vocabulario(cfg, extras=None):
    """Termos de busca: os declarados + o nicho + o segmento. A IA expande (pt/en, cenas, anti-clichês)."""
    v = _comum.obter(cfg, "visual", {}) or {}
    termos = list(v.get("termos_nicho") or [])
    for chave in (v.get("nicho"), _comum.obter(cfg, "organizacao.segmento")):
        if chave and chave not in termos:
            termos.append(str(chave))
    for t in extras or []:
        if t and t not in termos:
            termos.append(t)
    return termos


def fontes_ordenadas(registro, cfg, incluir_pagas=False):
    vetadas = set(_comum.obter(cfg, "visual.fontes_vetadas", []) or [])
    saida = []
    for f in registro.get("fontes") or []:
        if f.get("id") in vetadas or f.get("vetada"):
            continue
        if f.get("acesso") == "pago" and not incluir_pagas:
            continue
        saida.append(f)
    proprias = _comum.obter(cfg, "visual.fontes_proprias", []) or []
    for i, f in enumerate(proprias):
        if isinstance(f, dict) and f.get("url"):
            saida.append({"id": f.get("id") or "propria-%d" % (i + 1), "nome": f.get("nome") or f["url"],
                          "url": f["url"], "tipo": f.get("tipo") or "post", "acesso": f.get("acesso") or "login",
                          "uso": "so-referencia", "como_buscar": "perfil", "metodo": "navegador", "origem": "propria"})
    return sorted(saida, key=lambda f: PRIORIDADE.get(f.get("origem"), 3))


def plano(cfg, registro, extras=None, por_fonte=3, incluir_pagas=False):
    termos = vocabulario(cfg, extras)
    consultas = []
    for f in fontes_ordenadas(registro, cfg, incluir_pagas):
        modo = f.get("como_buscar") or "manual"
        base = {"fonte": f.get("id"), "nome": f.get("nome"), "tipo": f.get("tipo"), "metodo": f.get("metodo") or "navegador",
                "acesso": f.get("acesso"), "uso": f.get("uso"), "proibido": f.get("proibido") or [], "origem": f.get("origem")}
        if "{q}" in modo:
            for t in termos[:por_fonte]:
                enc = quote(t) if "/{q}" in modo else quote_plus(t)
                consultas.append(dict(base, termo=t, url=modo.replace("{q}", enc)))
        else:
            consultas.append(dict(base, termo=None, url=f.get("url"), instrucao=modo))
    cotas = _comum.obter(cfg, "visual.cotas", None) or COTAS_PADRAO
    return {"gerado_em": datetime.date.today().isoformat(), "nicho": _comum.obter(cfg, "visual.nicho"),
            "termos": termos, "cotas": cotas, "consultas": consultas}


def plano_md(p):
    linhas = ["# Plano do radar — %s" % (p.get("nicho") or "nicho a definir"), "",
              "Termos: " + (" · ".join(p["termos"]) or "[PENDENTE: definir `visual.nicho` e `visual.termos_nicho`]"),
              "", "Cotas por tipo (%): " + " · ".join("%s %s" % kv for kv in p["cotas"].items()), "",
              "| Origem | Fonte | Tipo | Termo | Acesso | Uso | Onde |", "|---|---|---|---|---|---|---|"]
    for c in p["consultas"]:
        onde = c.get("url") or ""
        if c.get("instrucao") and c["instrucao"] not in ("perfil",):
            onde += " (%s)" % c["instrucao"]
        linhas.append("| %s | %s | %s | %s | %s | %s | %s |" % (c.get("origem") or "", c.get("nome") or c["fonte"], c.get("tipo") or "",
                                                            c.get("termo") or "—", c.get("acesso") or "", c.get("uso") or "", onde))
    linhas += ["", "Proibido em toda fonte: raspagem em massa, download de mídia de terceiros para peça, marca d'água ou handle alheio."]
    return "\n".join(linhas) + "\n"


def lote_vazio(nome):
    return {"lote": nome, "itens": [], "_formato": {
        "id": "ref-001", "url": "https://…", "titulo": "", "autor": "", "fonte": "id do registro", "tipo": "foto|carrossel|video|web|tipografia|cor",
        "formato": "", "licenca": "so-referencia|cc0|pexels|…", "tags": {"estilo": [], "mood": [], "cor": []},
        "mecanismos": ["o que faz a peça funcionar, em termos próprios"], "observar": "", "nao_copiar": "",
        "notas": {c: "0–3" for c in CRITERIOS}}}


def triar(lote, anteriores=None, minimo=10, por_autor=3, cotas=None):
    itens = lote.get("itens") or []
    vistos_url = set()
    mec_antigos = set()
    for ant in anteriores or []:
        for it in ant.get("itens") or []:
            mec_antigos.update(m.lower() for m in it.get("mecanismos") or [])
            if it.get("url"):
                vistos_url.add(A._url_norm(it["url"]))
    for it in itens:
        notas = it.get("notas") or {}
        faltam = [c for c in CRITERIOS if not isinstance(notas.get(c), (int, float))]
        it["nota_total"] = sum(int(notas.get(c) or 0) for c in CRITERIOS)
        motivo = None
        if not it.get("url"):
            motivo = "sem URL"
        elif faltam:
            motivo = "notas ausentes: " + ", ".join(faltam)
        elif it.get("licenca") in A.LICENCAS_RECUSADAS:
            motivo = "licença recusada (%s)" % it["licenca"]
        elif A._url_norm(it["url"]) in vistos_url:
            motivo = "URL repetida"
        elif it["nota_total"] < minimo:
            motivo = "nota %d abaixo do mínimo %d" % (it["nota_total"], minimo)
        if it.get("url"):
            vistos_url.add(A._url_norm(it["url"]))
        it["decisao"] = "descartado" if motivo else "candidato"
        it["motivo"] = motivo
    por = {}
    for it in sorted([i for i in itens if i["decisao"] == "candidato"], key=lambda x: -x["nota_total"]):
        autor = (it.get("autor") or "").strip().lower()
        if autor:
            por[autor] = por.get(autor, 0) + 1
            if por[autor] > por_autor:
                it["decisao"], it["motivo"] = "descartado", "mais de %d do mesmo autor" % por_autor
    cand = [i for i in itens if i["decisao"] == "candidato"]
    cotas = cotas or COTAS_PADRAO
    contagem = {}
    for it in cand:
        g = GRUPO_TIPO.get(it.get("tipo"), it.get("tipo") or "outro")
        contagem[g] = contagem.get(g, 0) + 1
    total = len(cand) or 1
    desvio = {g: {"meta_pct": cotas.get(g, 0), "real_pct": round(100 * contagem.get(g, 0) / total)} for g in set(cotas) | set(contagem)}
    mec_novos = sorted({m.lower() for i in cand for m in i.get("mecanismos") or []} - mec_antigos)
    resumo = {"total": len(itens), "candidatos": len(cand), "descartados": len(itens) - len(cand),
              "cotas": desvio, "mecanismos_novos": mec_novos,
              "saturado": bool(anteriores) and not mec_novos}
    return dict(lote, itens=itens, resumo=resumo)


def triado_md(t):
    r = t["resumo"]
    linhas = ["# Triagem — lote %s" % (t.get("lote") or ""), "",
              "%d itens · %d candidatos · %d descartados%s" % (r["total"], r["candidatos"], r["descartados"],
                                                             " · **saturado: nenhum mecanismo novo — parar o radar**" if r["saturado"] else ""), "",
              "Cotas (meta → real, %): " + " · ".join("%s %s→%s" % (g, d["meta_pct"], d["real_pct"]) for g, d in sorted(r["cotas"].items())), "",
              "Mecanismos novos: " + (", ".join(r["mecanismos_novos"]) or "nenhum"), "",
              "## Para aprovar", "", "Triagem não é aprovação. Marque `decisao: aprovado` só no que a pessoa aprovou.", "",
              "| id | Nota | Tipo | Autor | Observar | Não copiar | Licença | URL |", "|---|---|---|---|---|---|---|---|"]
    for i in sorted([x for x in t["itens"] if x["decisao"] != "descartado"], key=lambda x: -x["nota_total"]):
        linhas.append("| %s | %d | %s | %s | %s | %s | %s | %s |" % (i.get("id"), i["nota_total"], i.get("tipo") or "", i.get("autor") or "",
                                                                    i.get("observar") or "", i.get("nao_copiar") or "", i.get("licenca") or "", i.get("url")))
    linhas += ["", "## Descartados", ""]
    linhas += ["- %s — %s" % (i.get("id") or i.get("url"), i["motivo"]) for i in t["itens"] if i["decisao"] == "descartado"]
    return "\n".join(linhas) + "\n"


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("plano")
    p.add_argument("fontes")
    p.add_argument("--termos", default="")
    p.add_argument("--por-fonte", type=int, default=3)
    p.add_argument("--incluir-pagas", action="store_true")
    p.add_argument("--saida", default="_saida/visual/radar-%s" % datetime.date.today().isoformat())
    t = sub.add_parser("triar")
    t.add_argument("lote")
    t.add_argument("--anteriores", nargs="*", default=[])
    t.add_argument("--minimo", type=int, default=10)
    t.add_argument("--por-autor", type=int, default=3)
    a = ap.parse_args(argv)
    root = _comum.raiz()
    cfg = _comum.config(root)
    if a.cmd == "plano":
        extras = [x.strip() for x in a.termos.split(";") if x.strip()]
        pl = plano(cfg, _comum.yaml_do_md(a.fontes), extras, a.por_fonte, a.incluir_pagas)
        saida = Path(a.saida) if Path(a.saida).is_absolute() else root / a.saida
        _comum.gravar_json(saida / "plano.json", pl)
        _comum.gravar_texto(saida / "plano.md", plano_md(pl))
        if not (saida / "lote.json").exists():
            _comum.gravar_json(saida / "lote.json", lote_vazio(saida.name))
        print("plano: %d consulta(s) em %d fonte(s) → %s" % (len(pl["consultas"]), len({c["fonte"] for c in pl["consultas"]}), saida))
        if not pl["termos"]:
            print("AVISO sem termos: preencha `visual.nicho`/`visual.termos_nicho` ou use --termos")
        return 0
    lote = _comum.ler_json(a.lote)
    ants = [_comum.ler_json(x) for x in a.anteriores]
    tr = triar(lote, ants, a.minimo, a.por_autor, _comum.obter(cfg, "visual.cotas", None))
    base = Path(a.lote)
    nome = base.with_suffix("")
    _comum.gravar_json(str(nome) + ".triado.json", tr)
    _comum.gravar_texto(str(nome) + ".triado.md", triado_md(tr))
    r = tr["resumo"]
    print("triagem: %d candidato(s), %d descartado(s)%s → %s.triado.md" % (r["candidatos"], r["descartados"],
                                                                          ", SATURADO" if r["saturado"] else "", nome))
    return 0


if __name__ == "__main__":
    sys.exit(main())
