#!/usr/bin/env python3
"""acervo.py — manifesto do acervo visual (próprio + referências) e galeria HTML.

Uso:
  acervo.py validar  <manifesto.json> [--json]
  acervo.py hash     <manifesto.json>                     calcula sha256 dos arquivos locais
  acervo.py importar <manifesto.json> <lote.triado.json>   traz as referências aprovadas do radar
  acervo.py galeria  <manifesto.json> --saida acervo.html  galeria filtrável, sem dependências

Item: id, titulo, tipo (referencia|proprio|gerado), origem (terceiro|proprio|ia), licenca, data,
url e/ou arquivo, e opcionais funcao, formato, autor, credito, miniatura, tags {estilo, mood, cor, tema},
observar, nao_copiar, sha256, aprovado, lote.
Regras: licença primeiro; mídia de terceiro "so-referencia" não entra no escopo da IA; CC BY exige crédito.
Sai com 1 se houver ERRO.
"""
import argparse
import datetime
import hashlib
import html
import json
import re
import sys
from pathlib import Path
from urllib.parse import urlsplit

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _comum  # noqa: E402

LICENCAS_LIVRES = {"cc0", "dominio-publico", "pexels", "pixabay", "unsplash", "propria", "gerada-ia"}
LICENCAS_CREDITO = {"cc-by"}
LICENCAS_REFERENCIA = {"so-referencia"}
LICENCAS_RECUSADAS = {"cc-by-sa", "cc-by-nc", "cc-by-nd", "cc-by-nc-sa", "cc-by-nc-nd", "desconhecida"}
LICENCAS = LICENCAS_LIVRES | LICENCAS_CREDITO | LICENCAS_REFERENCIA | LICENCAS_RECUSADAS
TIPOS = {"referencia", "proprio", "gerado"}
ORIGENS = {"terceiro", "proprio", "ia"}
OBRIGATORIOS = ("id", "titulo", "tipo", "origem", "licenca", "data")


def vazio():
    return {"versao": 1, "itens": []}


def _url_norm(u):
    p = urlsplit(u.strip())
    return (p.netloc.lower().removeprefix("www.") + p.path.rstrip("/")).lower()


def sha256(caminho):
    h = hashlib.sha256()
    with open(caminho, "rb") as f:
        for bloco in iter(lambda: f.read(1 << 16), b""):
            h.update(bloco)
    return h.hexdigest()


def _dentro_do_escopo(arquivo, raiz):
    """Arquivo dentro da raiz do Cortex e fora das pastas excluídas do escopo da IA."""
    try:
        rel = Path(arquivo).resolve().relative_to(Path(raiz).resolve()).as_posix()
    except ValueError:
        return False
    return not rel.split("/")[0] in {"_assets", "_saida", "_arquivo"}


def validar(manifesto, base, raiz=None):
    erros, avisos = [], []
    ids, urls, hashes = {}, {}, {}
    for i, it in enumerate(manifesto.get("itens") or []):
        rot = it.get("id") or "item %d" % i
        falta = [c for c in OBRIGATORIOS if not it.get(c)]
        if falta:
            erros.append("%s: campo(s) obrigatório(s) ausente(s): %s" % (rot, ", ".join(falta)))
        if not (it.get("url") or it.get("arquivo")):
            erros.append("%s: precisa de `url` ou `arquivo`" % rot)
        if it.get("id") in ids:
            erros.append("%s: id repetido" % rot)
        ids[it.get("id")] = True
        if it.get("tipo") and it["tipo"] not in TIPOS:
            erros.append("%s: tipo `%s` desconhecido (%s)" % (rot, it["tipo"], ", ".join(sorted(TIPOS))))
        if it.get("origem") and it["origem"] not in ORIGENS:
            erros.append("%s: origem `%s` desconhecida" % (rot, it["origem"]))
        lic = it.get("licenca")
        if lic and lic not in LICENCAS:
            erros.append("%s: licença `%s` desconhecida — use uma de %s" % (rot, lic, ", ".join(sorted(LICENCAS))))
        if lic in LICENCAS_CREDITO and not it.get("credito"):
            erros.append("%s: CC BY exige `credito` (autor + fonte) para aparecer na peça" % rot)
        if lic in LICENCAS_RECUSADAS:
            (erros if it.get("aprovado") else avisos).append(
                "%s: licença `%s` é recusada para uso — %s" % (rot, lic, "não pode estar aprovada" if it.get("aprovado") else "fica só como registro"))
        if it.get("origem") == "terceiro" and lic in LICENCAS_REFERENCIA and it.get("arquivo"):
            alvo = (base / it["arquivo"]) if not Path(it["arquivo"]).is_absolute() else Path(it["arquivo"])
            if raiz and _dentro_do_escopo(alvo, raiz):
                erros.append("%s: mídia de terceiro só-referência dentro do escopo da IA — mova para `_assets/` ou guarde só o link" % rot)
            else:
                avisos.append("%s: mídia de terceiro guardada localmente — uso interno de estudo, nunca em peça" % rot)
        if it.get("tipo") == "referencia" and it.get("aprovado") and not it.get("observar"):
            avisos.append("%s: referência aprovada sem `observar` (o que estudar nela)" % rot)
        if it.get("url"):
            u = _url_norm(it["url"])
            if u in urls:
                erros.append("%s: mesma URL de %s" % (rot, urls[u]))
            urls[u] = rot
        if it.get("arquivo"):
            alvo = (base / it["arquivo"]) if not Path(it["arquivo"]).is_absolute() else Path(it["arquivo"])
            if not alvo.exists():
                erros.append("%s: arquivo não encontrado: %s" % (rot, it["arquivo"]))
            else:
                h = sha256(alvo)
                if it.get("sha256") and it["sha256"] != h:
                    erros.append("%s: sha256 não confere (arquivo mudou?)" % rot)
                elif not it.get("sha256"):
                    avisos.append("%s: sem sha256 — rode `acervo.py hash`" % rot)
                if h in hashes:
                    erros.append("%s: arquivo idêntico a %s" % (rot, hashes[h]))
                hashes[h] = rot
    return erros, avisos


def importar(manifesto, lote):
    """Copia do lote triado os itens com `decisao: aprovado` ainda ausentes do manifesto."""
    existentes = {_url_norm(i["url"]) for i in manifesto["itens"] if i.get("url")}
    novos = 0
    hoje = datetime.date.today().isoformat()
    for r in lote.get("itens") or []:
        if r.get("decisao") != "aprovado" or not r.get("url") or _url_norm(r["url"]) in existentes:
            continue
        manifesto["itens"].append({
            "id": r.get("id") or "ref-%s" % hashlib.sha1(r["url"].encode()).hexdigest()[:8],
            "titulo": r.get("titulo") or r["url"], "tipo": "referencia", "origem": "terceiro",
            "licenca": r.get("licenca") or "so-referencia", "data": hoje, "url": r["url"],
            "autor": r.get("autor"), "funcao": r.get("tipo"), "formato": r.get("formato"),
            "tags": r.get("tags") or {}, "observar": r.get("observar"), "nao_copiar": r.get("nao_copiar"),
            "fonte": r.get("fonte"), "nota": r.get("nota_total"), "aprovado": True, "lote": lote.get("lote"),
        })
        existentes.add(_url_norm(r["url"]))
        novos += 1
    return novos


GALERIA = """<!doctype html><html lang="pt-BR"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1"><title>%(titulo)s</title><style>
:root{--fundo:#f7f7f8;--card:#fff;--texto:#16161a;--suave:#5c5c66;--borda:#e2e2e8;--marca:#4b3fd1}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){--fundo:#0f0f13;--card:#18181e;--texto:#f2f2f5;--suave:#a5a5b0;--borda:#2b2b33;--marca:#8f86ff}}
:root[data-theme=dark]{--fundo:#0f0f13;--card:#18181e;--texto:#f2f2f5;--suave:#a5a5b0;--borda:#2b2b33;--marca:#8f86ff}
*{box-sizing:border-box}body{margin:0;background:var(--fundo);color:var(--texto);font:15px/1.45 system-ui,sans-serif}
header{padding:20px 16px 8px;max-width:1200px;margin:auto}h1{margin:0 0 4px;font-size:22px}p.sub{margin:0;color:var(--suave)}
.filtros{display:flex;flex-wrap:wrap;gap:8px;padding:8px 16px;max-width:1200px;margin:auto}
select,input{font:inherit;padding:6px 8px;border:1px solid var(--borda);border-radius:8px;background:var(--card);color:var(--texto);max-width:100%%}
main{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:14px;padding:12px 16px 40px;max-width:1200px;margin:auto}
article{background:var(--card);border:1px solid var(--borda);border-radius:12px;overflow:hidden;display:flex;flex-direction:column}
.mini{aspect-ratio:4/3;background:var(--borda);display:flex;align-items:center;justify-content:center;color:var(--suave);font-size:13px;overflow:hidden}
.mini img{width:100%%;height:100%%;object-fit:cover}.corpo{padding:10px 12px;display:flex;flex-direction:column;gap:6px}
.corpo b{font-size:14px;overflow-wrap:anywhere}.tag{display:inline-block;font-size:11px;padding:2px 6px;border-radius:99px;border:1px solid var(--borda);color:var(--suave);margin:0 4px 4px 0}
.lic{color:var(--marca);border-color:var(--marca)}a{color:var(--marca)}small{color:var(--suave)}
</style></head><body><header><h1>%(titulo)s</h1><p class="sub"><span id="n"></span> itens · gerado em %(data)s · referências de terceiros são só estudo: observar, nunca copiar.</p></header>
<div class="filtros"><input id="q" placeholder="buscar" aria-label="buscar"><select id="ftipo" aria-label="tipo"></select><select id="ffuncao" aria-label="função"></select><select id="festilo" aria-label="estilo"></select><select id="flic" aria-label="licença"></select></div>
<main id="grade"></main>
<script id="dados" type="application/json">%(dados)s</script>
<script>
const itens=JSON.parse(document.getElementById('dados').textContent);
const g=document.getElementById('grade'),q=document.getElementById('q');
const campos={ftipo:i=>[i.tipo],ffuncao:i=>[i.funcao],festilo:i=>(i.tags&&i.tags.estilo)||[],flic:i=>[i.licenca]};
for(const [id,f] of Object.entries(campos)){const s=document.getElementById(id);const vals=[...new Set(itens.flatMap(f).filter(Boolean))].sort();
 s.innerHTML='<option value="">'+({ftipo:'tipo',ffuncao:'função',festilo:'estilo',flic:'licença'}[id])+': todos</option>'+vals.map(v=>'<option>'+esc(v)+'</option>').join('');s.onchange=desenhar}
q.oninput=desenhar;
function esc(s){return String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function dom(u){try{return new URL(u).hostname.replace('www.','')}catch(e){return ''}}
function desenhar(){const t=q.value.toLowerCase();const vis=itens.filter(i=>{for(const [id,f] of Object.entries(campos)){const v=document.getElementById(id).value;if(v&&!f(i).includes(v))return false}
 return !t||JSON.stringify(i).toLowerCase().includes(t)});document.getElementById('n').textContent=vis.length+' de '+itens.length;
 g.innerHTML=vis.map(i=>{const tags=Object.values(i.tags||{}).flat().map(x=>'<span class="tag">'+esc(x)+'</span>').join('');
 const mini=i.miniatura?'<img loading="lazy" alt="" src="'+esc(i.miniatura)+'">':esc(dom(i.url)||i.tipo);
 return '<article><div class="mini">'+mini+'</div><div class="corpo"><b>'+esc(i.titulo)+'</b><div><span class="tag lic">'+esc(i.licenca)+'</span>'+tags+'</div>'+
 (i.observar?'<small>Observar: '+esc(i.observar)+'</small>':'')+(i.nao_copiar?'<small>Não copiar: '+esc(i.nao_copiar)+'</small>':'')+
 (i.credito?'<small>Crédito: '+esc(i.credito)+'</small>':'')+(i.url?'<a href="'+esc(i.url)+'" target="_blank" rel="noopener noreferrer">abrir fonte</a>':'')+'</div></article>'}).join('')}
desenhar();
</script></body></html>
"""


def galeria(manifesto, titulo="Acervo visual"):
    dados = json.dumps(manifesto.get("itens") or [], ensure_ascii=False).replace("</", "<\\/")
    return GALERIA % {"titulo": html.escape(titulo), "data": datetime.date.today().isoformat(), "dados": dados}


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    for nome in ("validar", "hash", "importar", "galeria"):
        p = sub.add_parser(nome)
        p.add_argument("manifesto")
        if nome == "importar":
            p.add_argument("lote")
        p.add_argument("--saida")
        p.add_argument("--titulo", default="Acervo visual")
        p.add_argument("--json", action="store_true")
    a = ap.parse_args(argv)
    caminho = Path(a.manifesto)
    manifesto = _comum.ler_json(caminho) if caminho.exists() else vazio()
    base = caminho.resolve().parent
    if a.cmd == "validar":
        erros, avisos = validar(manifesto, base, _comum.raiz(base))
        if a.json:
            print(json.dumps({"erros": erros, "avisos": avisos}, ensure_ascii=False, indent=2))
        else:
            for e in erros:
                print("ERRO  " + e)
            for w in avisos:
                print("AVISO " + w)
            print("acervo: %d item(ns), %d erro(s), %d aviso(s)" % (len(manifesto.get("itens") or []), len(erros), len(avisos)))
        return 1 if erros else 0
    if a.cmd == "hash":
        n = 0
        for it in manifesto.get("itens") or []:
            if it.get("arquivo"):
                alvo = base / it["arquivo"]
                if alvo.exists():
                    it["sha256"] = sha256(alvo)
                    n += 1
        _comum.gravar_json(caminho, manifesto)
        print("sha256 calculado em %d item(ns)" % n)
        return 0
    if a.cmd == "importar":
        n = importar(manifesto, _comum.ler_json(a.lote))
        _comum.gravar_json(caminho, manifesto)
        print("importado(s): %d — total %d" % (n, len(manifesto["itens"])))
        return 0
    if a.cmd == "galeria":
        saida = a.saida or str(caminho.with_name("acervo.html"))
        _comum.gravar_texto(saida, galeria(manifesto, a.titulo))
        print("gravado: %s" % saida)
        return 0


if __name__ == "__main__":
    sys.exit(main())
