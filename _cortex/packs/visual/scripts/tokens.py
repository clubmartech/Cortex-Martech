#!/usr/bin/env python3
"""tokens.py — design tokens no formato DTCG (Design Tokens Community Group).

Uso:
  tokens.py iniciar  <tokens.json>                 cria o esqueleto (valores nulos = a preencher)
  tokens.py validar  <tokens.json> [--json]        estrutura, aliases, tipos e contraste WCAG
  tokens.py exportar <tokens.json> [--saida f.css] variáveis CSS (tema claro e, se houver, escuro)
  tokens.py amostra  <tokens.json> --saida f.html  página-amostra: cores com contraste, tipografia, espaço

Formato: grupos aninhados; folha = objeto com `$value` e `$type`. Alias = "{grupo.token}".
Extensões do Cortex em `$extensions.cortex`:
  "contraste": [{"frente": "cor.texto", "fundo": "cor.fundo", "minimo": 4.5}]
  "temas": {"escuro": {"cor.fundo": "#0b0b10", "cor.texto": "#f5f5f7"}}
Sai com 1 se houver ERRO.
"""
import argparse
import html
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _comum  # noqa: E402

TIPOS = {"color", "dimension", "fontFamily", "fontWeight", "duration", "cubicBezier", "number", "shadow", "typography"}
HEX = re.compile(r"^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$")
ALIAS = re.compile(r"^\{([^{}]+)\}$")
DIM = re.compile(r"^-?\d+(\.\d+)?(px|rem|em|%)$")
DUR = re.compile(r"^\d+(\.\d+)?(ms|s)$")

ESQUELETO = {
    "$description": "Design tokens da marca — preencher a partir da direção aprovada (skill documentar-design-system). null = a preencher.",
    "cor": {
        "marca": {"primaria": {"$type": "color", "$value": None}, "secundaria": {"$type": "color", "$value": None},
                  "destaque": {"$type": "color", "$value": None}},
        "fundo": {"$type": "color", "$value": None},
        "superficie": {"$type": "color", "$value": None},
        "texto": {"$type": "color", "$value": None},
        "texto-suave": {"$type": "color", "$value": None},
        "borda": {"$type": "color", "$value": None},
    },
    "tipografia": {
        "familia": {"titulo": {"$type": "fontFamily", "$value": None}, "texto": {"$type": "fontFamily", "$value": None}},
        "peso": {"regular": {"$type": "fontWeight", "$value": 400}, "destaque": {"$type": "fontWeight", "$value": 600}},
        "tamanho": {"corpo": {"$type": "dimension", "$value": "16px"}, "titulo": {"$type": "dimension", "$value": None}},
    },
    "espaco": {"1": {"$type": "dimension", "$value": "4px"}, "2": {"$type": "dimension", "$value": "8px"},
               "3": {"$type": "dimension", "$value": "16px"}, "4": {"$type": "dimension", "$value": "24px"},
               "5": {"$type": "dimension", "$value": "40px"}},
    "raio": {"padrao": {"$type": "dimension", "$value": None}},
    "motion": {"duracao": {"$type": "duration", "$value": "200ms"},
               "curva": {"$type": "cubicBezier", "$value": [0.2, 0, 0, 1]}},
    "$extensions": {"cortex": {
        "contraste": [{"frente": "cor.texto", "fundo": "cor.fundo", "minimo": 4.5},
                      {"frente": "cor.texto-suave", "fundo": "cor.fundo", "minimo": 4.5},
                      {"frente": "cor.texto", "fundo": "cor.superficie", "minimo": 4.5}],
        "temas": {},
    }},
}


# ------------------------------------------------------------------ leitura
def folhas(arvore, prefixo=""):
    """{caminho: folha} para todo objeto com `$value`."""
    saida = {}
    for k, v in (arvore or {}).items():
        if k.startswith("$") or not isinstance(v, dict):
            continue
        caminho = "%s.%s" % (prefixo, k) if prefixo else k
        if "$value" in v:
            saida[caminho] = v
        else:
            saida.update(folhas(v, caminho))
    return saida


def tipo_de(arvore, caminho):
    """`$type` da folha ou herdado do grupo mais próximo (regra DTCG)."""
    atual, herdado = arvore, arvore.get("$type")
    for parte in caminho.split("."):
        atual = atual.get(parte, {}) if isinstance(atual, dict) else {}
        herdado = atual.get("$type", herdado) if isinstance(atual, dict) else herdado
    return herdado


def resolver(fl, caminho, vistos=None):
    """Valor final seguindo aliases; levanta ValueError em ciclo ou alias quebrado."""
    vistos = vistos or []
    if caminho in vistos:
        raise ValueError("alias em ciclo: %s" % " → ".join(vistos + [caminho]))
    if caminho not in fl:
        raise ValueError("alias para token inexistente: {%s}" % caminho)
    v = fl[caminho]["$value"]
    m = ALIAS.match(v) if isinstance(v, str) else None
    return resolver(fl, m.group(1), vistos + [caminho]) if m else v


# ------------------------------------------------------------------ cor e contraste
def hex_rgb(h):
    h = h.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def luminancia(h):
    def canal(c):
        c = c / 255
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (canal(c) for c in hex_rgb(h))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contraste(a, b):
    """Razão de contraste WCAG 2.x entre duas cores hex (1 a 21)."""
    la, lb = sorted((luminancia(a), luminancia(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


# ------------------------------------------------------------------ validação
def validar(arvore):
    """Devolve (erros, avisos)."""
    erros, avisos = [], []
    fl = folhas(arvore)
    if not fl:
        return ["nenhum token encontrado (folha = objeto com `$value`)"], []
    for caminho, folha in fl.items():
        tipo = tipo_de(arvore, caminho)
        v = folha.get("$value")
        if tipo is None:
            erros.append("%s: sem `$type` (nem herdado do grupo)" % caminho)
            continue
        if tipo not in TIPOS:
            erros.append("%s: `$type` desconhecido: %s" % (caminho, tipo))
            continue
        if v is None:
            avisos.append("%s: valor a preencher" % caminho)
            continue
        if isinstance(v, str) and ALIAS.match(v):
            try:
                v = resolver(fl, caminho)
            except ValueError as e:
                erros.append("%s: %s" % (caminho, e))
                continue
            if v is None:
                avisos.append("%s: aponta para token ainda sem valor" % caminho)
                continue
        if tipo == "color" and not (isinstance(v, str) and HEX.match(v)):
            erros.append("%s: cor deve ser hex (#rgb, #rrggbb ou #rrggbbaa), veio %r" % (caminho, v))
        elif tipo == "dimension" and not (isinstance(v, str) and DIM.match(v)):
            erros.append("%s: dimensão deve ter unidade (px, rem, em, %%), veio %r" % (caminho, v))
        elif tipo == "duration" and not (isinstance(v, str) and DUR.match(v)):
            erros.append("%s: duração deve ser ms ou s, veio %r" % (caminho, v))
        elif tipo == "fontWeight" and not (isinstance(v, int) and 1 <= v <= 1000):
            erros.append("%s: peso deve ser inteiro de 1 a 1000, veio %r" % (caminho, v))
        elif tipo == "cubicBezier" and not (isinstance(v, list) and len(v) == 4):
            erros.append("%s: cubicBezier deve ter 4 números" % caminho)
        elif tipo == "fontFamily" and not (isinstance(v, (str, list)) and v):
            erros.append("%s: família tipográfica vazia" % caminho)
    ext = ((arvore.get("$extensions") or {}).get("cortex") or {})
    temas = {"padrão": {}}
    temas.update(ext.get("temas") or {})
    for nome, sobrepoe in temas.items():
        for par in ext.get("contraste") or []:
            try:
                a = sobrepoe.get(par["frente"]) or resolver(fl, par["frente"])
                b = sobrepoe.get(par["fundo"]) or resolver(fl, par["fundo"])
            except (KeyError, ValueError) as e:
                erros.append("contraste %s: %s" % (nome, e))
                continue
            if a is None or b is None:
                avisos.append("contraste %s %s × %s: cor a preencher" % (nome, par["frente"], par["fundo"]))
                continue
            if not (HEX.match(str(a)) and HEX.match(str(b))):
                erros.append("contraste %s %s × %s: cor não é hex" % (nome, par["frente"], par["fundo"]))
                continue
            r = contraste(str(a)[:7], str(b)[:7])
            minimo = float(par.get("minimo", 4.5))
            if r < minimo:
                erros.append("contraste %s: %s × %s = %.2f:1, abaixo de %.1f:1 (WCAG)" % (nome, par["frente"], par["fundo"], r, minimo))
    return erros, avisos


# ------------------------------------------------------------------ exportação
def _css_valor(v):
    if isinstance(v, list):
        if all(isinstance(x, (int, float)) for x in v) and len(v) == 4:
            return "cubic-bezier(%s)" % ", ".join(str(x) for x in v)
        return ", ".join('"%s"' % x if " " in str(x) else str(x) for x in v)
    return str(v)


def css(arvore):
    fl = folhas(arvore)
    linhas = [":root {"]
    for caminho in fl:
        try:
            v = resolver(fl, caminho)
        except ValueError:
            continue
        if v is not None:
            linhas.append("  --%s: %s;" % (caminho.replace(".", "-"), _css_valor(v)))
    linhas.append("}")
    escuro = (((arvore.get("$extensions") or {}).get("cortex") or {}).get("temas") or {}).get("escuro")
    if escuro:
        bloco = ["  --%s: %s;" % (k.replace(".", "-"), v) for k, v in escuro.items()]
        linhas += ["", "@media (prefers-color-scheme: dark) {", "  :root:not([data-theme=\"light\"]) {"]
        linhas += ["  " + b for b in bloco] + ["  }", "}", "", ":root[data-theme=\"dark\"] {"] + bloco + ["}"]
    return "\n".join(linhas) + "\n"


def amostra(arvore, titulo="Design system"):
    fl = folhas(arvore)
    cores, demais = [], []
    for caminho in fl:
        try:
            v = resolver(fl, caminho)
        except ValueError:
            continue
        if v is None:
            continue
        (cores if tipo_de(arvore, caminho) == "color" else demais).append((caminho, v))
    fundo = next((v for c, v in cores if c == "cor.fundo"), "#ffffff")
    cards = "".join(
        '<figure><div class="sw" style="background:%s"></div><figcaption><b>%s</b><br>%s<br>%.1f:1 sobre fundo</figcaption></figure>'
        % (v, html.escape(c), v, contraste(v[:7], fundo[:7])) for c, v in cores)
    linhas = "".join("<tr><td>%s</td><td>%s</td></tr>" % (html.escape(c), html.escape(_css_valor(v))) for c, v in demais)
    erros, avisos = validar(arvore)
    estado = "%d erro(s), %d valor(es) a preencher" % (len(erros), len(avisos))
    return """<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>%s</title><style>%s
body{margin:0;padding:24px 16px;font-family:var(--tipografia-familia-texto,system-ui);background:var(--cor-fundo,#fff);color:var(--cor-texto,#111)}
main{max-width:1000px;margin:auto}.grade{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:16px}
figure{margin:0}.sw{height:80px;border-radius:8px;border:1px solid #8884}figcaption{font-size:13px;margin-top:6px}
table{border-collapse:collapse;width:100%%}td{border-bottom:1px solid #8884;padding:6px 4px;font-size:14px;overflow-wrap:anywhere}
</style></head><body><main><h1>%s</h1><p>%s</p><h2>Cores</h2><div class="grade">%s</div><h2>Demais tokens</h2><table>%s</table></main></body></html>
""" % (html.escape(titulo), css(arvore), html.escape(titulo), html.escape(estado), cards, linhas)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    for nome in ("iniciar", "validar", "exportar", "amostra"):
        p = sub.add_parser(nome)
        p.add_argument("arquivo")
        p.add_argument("--saida")
        p.add_argument("--json", action="store_true")
        p.add_argument("--titulo", default="Design system")
    a = ap.parse_args(argv)
    if a.cmd == "iniciar":
        if Path(a.arquivo).exists():
            print("já existe: %s — nada feito" % a.arquivo)
            return 0
        _comum.gravar_json(a.arquivo, ESQUELETO)
        print("criado: %s" % a.arquivo)
        return 0
    arvore = _comum.ler_json(a.arquivo)
    if a.cmd == "validar":
        erros, avisos = validar(arvore)
        if a.json:
            print(json.dumps({"erros": erros, "avisos": avisos}, ensure_ascii=False, indent=2))
        else:
            for e in erros:
                print("ERRO  " + e)
            for w in avisos:
                print("AVISO " + w)
            print("tokens: %d erro(s), %d aviso(s)" % (len(erros), len(avisos)))
        return 1 if erros else 0
    if a.cmd == "exportar":
        texto = css(arvore)
        if a.saida:
            _comum.gravar_texto(a.saida, texto)
            print("gravado: %s" % a.saida)
        else:
            sys.stdout.write(texto)
        return 0
    if a.cmd == "amostra":
        if not a.saida:
            ap.error("amostra exige --saida")
        _comum.gravar_texto(a.saida, amostra(arvore, a.titulo))
        print("gravado: %s" % a.saida)
        return 0


if __name__ == "__main__":
    sys.exit(main())
