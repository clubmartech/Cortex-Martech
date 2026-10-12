"""fm — frontmatter Cortex de 14 campos (CONTRATOS §2): separar, parse tolerante, montar, hashes."""
import hashlib
import json
import os
import re
import unicodedata

CAMPOS = ["tipo", "id", "descricao", "familia", "output", "canal", "ferramenta", "produto",
          "publico", "gatilhos", "requires", "owner", "origem", "validado_em"]
TIPOS = {"agent", "skill", "sub-skill", "doc", "pack"}
OUTPUTS = ["texto", "html", "arte", "apresentacao", "roteiro", "plano", "analise", "relatorio",
           "dado", "briefing", "registro", "documentacao", "roteamento", "nenhum"]
LISTAS = {"gatilhos", "requires"}
PRECISA_ASPAS = re.compile(r"[:#\[{`&*|>]")
RE_DATA = re.compile(r"^\d{4}-\d{2}-\d{2}$")
SECOES_OBRIGATORIAS = {
    "agent": ["Quem eu sou", "Como me ativar", "Contexto que eu sempre carrego", "Meu processo",
              "Briefing que eu exijo", "Regras inegociáveis", "Handoffs", "O que eu entrego", "Histórico"],
    "skill": ["Contexto de uso", "Processo", "Output esperado", "Histórico"],
    "sub-skill": ["Contexto de uso", "Processo", "Output esperado", "Histórico"],
    "doc": ["Histórico"],
    "pack": ["Histórico"],
}


def separar(texto):
    """(fm_text, body) — fm_text é None quando não há frontmatter."""
    s = texto.lstrip("﻿")
    if not s.startswith("---"):
        return None, texto
    primeira = s.split("\n", 1)[0].strip()
    if primeira != "---":
        return None, texto
    resto = s[3:]
    m = re.search(r"\n---[ \t]*(\n|$)", resto)
    if not m:
        return None, texto
    return resto[: m.start()].lstrip("\n"), resto[m.end():]


def _limpa(v):
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
        inner = v[1:-1]
        return inner.replace('\\"', '"') if v[0] == '"' else inner
    return v


def multivalor(v):
    if v is None or v == "":
        return []
    if isinstance(v, list):
        return [str(x).strip() for x in v if str(x).strip()]
    return [x.strip() for x in str(v).split("·") if x.strip()]


def parse_com_erros(bloco):
    """Parser tolerante. Devolve (dict, erros). Listas em `gatilhos`/`requires`; demais, string."""
    dados, erros = {}, []
    if bloco is None:
        return dados, ["sem frontmatter"]
    linhas = bloco.split("\n")
    i = 0
    while i < len(linhas):
        linha = linhas[i]
        m = re.match(r"^([A-Za-z_][\w\-]*):[ \t]*(.*)$", linha)
        if not m:
            if linha.strip() and not linha.startswith((" ", "\t", "#")):
                erros.append("linha ilegível no frontmatter: `%s`" % linha.strip()[:60])
            i += 1
            continue
        chave, valor = m.group(1), m.group(2).strip()
        if chave in dados:
            erros.append("campo `%s` repetido" % chave)
        if valor.startswith("["):
            buf = valor
            while buf.count("[") > buf.count("]") and i + 1 < len(linhas):
                i += 1
                buf += " " + linhas[i].strip()
            try:
                dados[chave] = [str(x) for x in json.loads(buf)]
            except Exception:
                itens = re.findall(r'"([^"]*)"', buf)
                if not itens and buf.strip("[] "):
                    itens = [x.strip().strip("'\"") for x in buf.strip("[]").split(",") if x.strip()]
                dados[chave] = itens
                if not itens and buf.strip("[] "):
                    erros.append("lista ilegível em `%s`" % chave)
            i += 1
            continue
        if valor == "" and i + 1 < len(linhas) and linhas[i + 1].lstrip().startswith("- "):
            itens = []
            while i + 1 < len(linhas) and linhas[i + 1].lstrip().startswith("- "):
                i += 1
                itens.append(_limpa(linhas[i].lstrip()[2:]))
            dados[chave] = itens
            i += 1
            continue
        if re.search(r":\s", valor) and not valor.startswith(("\"", "'")):
            erros.append("`%s` tem \": \" sem aspas — quebra o YAML" % chave)
        if valor.startswith("#"):
            erros.append("`%s` começa com `#` sem aspas" % chave)
        dados[chave] = _limpa(valor)
        i += 1
    if "requires" in dados and not isinstance(dados["requires"], list):
        dados["requires"] = multivalor(dados["requires"])
    if "gatilhos" in dados and not isinstance(dados["gatilhos"], list):
        dados["gatilhos"] = multivalor(dados["gatilhos"]) if dados["gatilhos"] else []
    if "subagente" in dados:
        dados["subagente"] = str(dados["subagente"]).strip().lower() in ("true", "sim", "yes", "1")
    return dados, erros


def parse(bloco):
    return parse_com_erros(bloco)[0]


def ler(texto):
    """(fm_dict|None, body, erros) a partir do texto completo do arquivo."""
    bloco, corpo = separar(texto)
    if bloco is None:
        return None, corpo, ["sem frontmatter"]
    d, erros = parse_com_erros(bloco)
    return d, corpo, erros


def ordem_campos(bloco):
    """Sequência dos campos conhecidos na ordem em que aparecem no bloco."""
    return [m.group(1) for m in re.finditer(r"^([A-Za-z_][\w\-]*):", bloco or "", re.M)]


def _sem_acento(s):
    return "".join(c for c in unicodedata.normalize("NFD", s) if not unicodedata.combining(c))


IDS_FIXOS = {"briefings/_modelo.md": "modelo-briefing"}


def id_esperado(caminho):
    """Regra determinística §2.1 (sem o sufixo de escopo, que depende de colisão).

    Extensões por caminho (lacuna do CONTRATOS §2.1): `contexto/integracoes/<slug>.md` → `integracao-<slug>`
    (id citado pelo ROTAS.md.tpl) e `briefings/_modelo.md` → `modelo-briefing`.
    """
    rel = str(caminho).replace("\\", "/")
    if rel in IDS_FIXOS:
        return IDS_FIXOS[rel]
    base = os.path.basename(rel)
    if rel.startswith("contexto/integracoes/") and rel.count("/") == 2:
        base = "integracao-" + base
    if base.lower().endswith(".md"):
        base = base[:-3]
    if base.endswith(".agent"):
        base = base[:-6]
    base = re.sub(r"(?<=[a-z0-9])([A-Z])", r"-\1", base)
    base = _sem_acento(base).replace("_", "-").replace(" ", "-").lower()
    base = re.sub(r"[^a-z0-9\-]", "", base).strip("-")
    for pref in ("sub-skill-", "skill-"):
        if base.startswith(pref) and len(base[len(pref):].split("-")) > 1:
            base = base[len(pref):]
            break
    return re.sub(r"-+", "-", base)


def escopo_de(caminho):
    """Sufixo de escopo para colisão de nome (§2.1 regra 4)."""
    partes = str(caminho).replace("\\", "/").split("/")
    if partes[0] == "times" and len(partes) > 2:
        return partes[1]
    if partes[0] == "iniciativas" and len(partes) > 2:
        return partes[1]
    if partes[0] == "_cortex":
        return "kernel"
    return partes[0] if len(partes) > 1 else "raiz"


def precisa_aspas(v):
    return bool(PRECISA_ASPAS.search(v)) or v[:1].isdigit() if v else False


def _escalar(v, campo):
    v = "" if v is None else str(v)
    if v == "":
        return ""
    if campo == "descricao" or (PRECISA_ASPAS.search(v) and campo != "validado_em"):
        return '"' + v.replace('"', '\\"') + '"'
    return v


def montar(d):
    """Bloco `---…---` com os 14 campos na ordem fixa (+ `subagente` após `tipo` se true)."""
    linhas = ["---"]
    for c in CAMPOS:
        v = d.get(c, "")
        if c == "gatilhos":
            itens = multivalor(v) if not isinstance(v, list) else v
            linhas.append("gatilhos: " + json.dumps([str(x) for x in itens], ensure_ascii=False))
        elif c == "requires":
            linhas.append("requires: " + " · ".join(multivalor(v)))
        elif c in ("canal", "produto", "publico", "ferramenta") and isinstance(v, list):
            linhas.append("%s: %s" % (c, " · ".join(multivalor(v))))
        else:
            linhas.append(("%s: %s" % (c, _escalar(v, c))).rstrip())
        if c == "tipo" and d.get("subagente") in (True, "true"):
            linhas.append("subagente: true")
    linhas.append("---")
    return "\n".join(linhas) + "\n"


def headings(corpo):
    corpo = re.sub(r"^```.*?^```", "", corpo, flags=re.S | re.M)
    return [m.group(1).strip() for m in re.finditer(r"^#{2,3} +(.+?)\s*$", corpo, re.M)]


def _h(s):
    return hashlib.sha256(s.encode("utf-8")).hexdigest()[:16]


def hash_fm(bloco):
    return _h(bloco or "")


def hash_headings(corpo):
    return _h("\n".join(headings(corpo)))


def hash_conteudo(texto):
    return _h(texto)


def primeira_data_historico(corpo):
    m = re.search(r"^##+ *Hist[óo]rico\b.*$", corpo, re.M)
    if not m:
        return None, False
    trecho = corpo[m.end():]
    prox = re.search(r"^## ", trecho, re.M)
    if prox:
        trecho = trecho[: prox.start()]
    for linha in trecho.split("\n"):
        mm = re.match(r"^\s*\|\s*(\d{4}-\d{2}-\d{2})\s*\|", linha)
        if mm:
            return mm.group(1), True
    return None, True


def secoes_faltantes(tipo, corpo):
    hs = [h.lower() for h in headings(corpo)]
    faltam = []
    for s in SECOES_OBRIGATORIAS.get(tipo, []):
        if not any(h == s.lower() or h.startswith(s.lower()) or _sem_acento(h) == _sem_acento(s.lower()) for h in hs):
            faltam.append(s)
    return faltam
