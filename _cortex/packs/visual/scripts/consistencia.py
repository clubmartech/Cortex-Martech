#!/usr/bin/env python3
"""consistencia.py — confere peças (HTML, CSS, SVG) contra os design tokens.

Uso:
  consistencia.py <tokens.json> <peça> [<peça> …] [--tolerancia 6] [--json]

Acusa: cor fora da paleta (distância RGB acima da tolerância), família tipográfica fora dos tokens,
peso tipográfico não declarado, `font-weight` acima do maior peso permitido.
Não julga composição nem qualidade: isso é revisão humana. Sai com 1 se houver achado.
"""
import argparse
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _comum  # noqa: E402
import tokens as T  # noqa: E402

COR = re.compile(r"#(?:[0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b|rgba?\(\s*\d{1,3}\s*,\s*\d{1,3}\s*,\s*\d{1,3}[^)]*\)")
FAMILIA = re.compile(r"font-family\s*[:=]\s*[\"']?([^;\"'>]+)", re.I)
PESO = re.compile(r"font-weight\s*[:=]\s*[\"']?(\d{3})", re.I)
GENERICAS = {"serif", "sans-serif", "monospace", "system-ui", "cursive", "fantasy", "inherit", "initial",
             "-apple-system", "blinkmacsystemfont", "segoe ui", "roboto", "helvetica", "arial", "ui-sans-serif",
             "var(--tipografia-familia-texto)", "var(--tipografia-familia-titulo)"}
NEUTRAS = {"#ffffff", "#000000", "#fff", "#000"}


def _hex(c):
    c = c.strip().lower()
    if c.startswith("rgb"):
        n = [int(x) for x in re.findall(r"\d{1,3}", c)[:3]]
        return "#%02x%02x%02x" % tuple(n)
    c = c[:7] if len(c) == 9 else c
    if len(c) == 4:
        c = "#" + "".join(ch * 2 for ch in c[1:])
    return c


def _dist(a, b):
    ra, rb = T.hex_rgb(a), T.hex_rgb(b)
    return max(abs(x - y) for x, y in zip(ra, rb))


def paleta(arvore):
    fl = T.folhas(arvore)
    cores, familias, pesos = set(), set(), set()
    for caminho in fl:
        try:
            v = T.resolver(fl, caminho)
        except ValueError:
            continue
        tipo = T.tipo_de(arvore, caminho)
        if v is None:
            continue
        if tipo == "color":
            cores.add(_hex(v))
        elif tipo == "fontFamily":
            for f in (v if isinstance(v, list) else [v]):
                familias.add(str(f).strip().strip("\"'").lower())
        elif tipo == "fontWeight":
            pesos.add(int(v))
    temas = (((arvore.get("$extensions") or {}).get("cortex") or {}).get("temas") or {})
    for sobrepoe in temas.values():
        for v in sobrepoe.values():
            if isinstance(v, str) and T.HEX.match(v):
                cores.add(_hex(v))
    return cores, familias, pesos


def auditar(arvore, arquivos, tolerancia=6, neutras=True):
    cores, familias, pesos = paleta(arvore)
    achados = []
    for arq in arquivos:
        texto = Path(arq).read_text(encoding="utf-8", errors="replace")
        vistas = set()
        for m in COR.finditer(texto):
            c = _hex(m.group(0))
            if c in vistas or (neutras and c in NEUTRAS):
                continue
            vistas.add(c)
            if not cores or min(_dist(c, p) for p in cores) > tolerancia:
                achados.append({"arquivo": str(arq), "tipo": "cor", "valor": c,
                                "msg": "cor fora da paleta: %s" % c})
        for m in FAMILIA.finditer(texto):
            for f in m.group(1).split(","):
                nome = f.strip().strip("\"'").lower()
                if nome and nome not in familias and nome not in GENERICAS and not nome.startswith("var("):
                    achados.append({"arquivo": str(arq), "tipo": "fonte", "valor": nome,
                                    "msg": "família fora dos tokens: %s" % nome})
        for m in PESO.finditer(texto):
            p = int(m.group(1))
            if pesos and p not in pesos:
                achados.append({"arquivo": str(arq), "tipo": "peso", "valor": p,
                                "msg": "peso %d não declarado (permitidos: %s)" % (p, ", ".join(map(str, sorted(pesos))))})
    unicos, vistos = [], set()
    for a in achados:
        chave = (a["arquivo"], a["tipo"], str(a["valor"]))
        if chave not in vistos:
            vistos.add(chave)
            unicos.append(a)
    return unicos


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("tokens")
    ap.add_argument("pecas", nargs="+")
    ap.add_argument("--tolerancia", type=int, default=6, help="diferença máxima por canal RGB (0–255)")
    ap.add_argument("--sem-neutras", action="store_true", help="também acusa branco e preto puros")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args(argv)
    achados = auditar(_comum.ler_json(a.tokens), a.pecas, a.tolerancia, not a.sem_neutras)
    if a.json:
        print(json.dumps(achados, ensure_ascii=False, indent=2))
    else:
        for x in achados:
            print("%s: %s" % (x["arquivo"], x["msg"]))
        print("consistência: %d achado(s) em %d peça(s)" % (len(achados), len(a.pecas)))
    return 1 if achados else 0


if __name__ == "__main__":
    sys.exit(main())
