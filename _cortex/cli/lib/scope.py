"""scope — escopo do scanner (CONTRATOS §10) e descoberta da raiz."""
import os
import re
import sys
from pathlib import Path

EXCLUIR_DIRS = {"_arquivo", "_saida", "_assets", ".claude", ".git", ".obsidian",
                "__pycache__", "node_modules", ".build"}
# subpastas de _cortex que ficam fora do escopo de .md canônicos
EXCLUIR_CORTEX = {".build", "packs", "templates", "onboarding", "cli"}
ISENTOS = {"_cortex/CONTRATOS.md", "_cortex/MELHORIAS-APLICADAS.md", "README.md"}
GERADOS_RAIZ = {"AGENTS.md", "CLAUDE.md", "ROTAS.md", "CATALOGO.md", "ABERTURA-SESSAO.md"}
PASTAS_OBRIGATORIAS = ["_cortex", "_cortex/kernel", "_cortex/templates", "_cortex/cli",
                       "contexto", "times", "briefings", "_saida", "_assets", "_arquivo"]


def descobrir_raiz(inicio=None):
    """Raiz = env CORTEX_ROOT, ou a primeira pasta (subindo) que contém `_cortex/`."""
    env = os.environ.get("CORTEX_ROOT")
    if env and (Path(env) / "_cortex").is_dir():
        return Path(env).resolve()
    candidatos = []
    if inicio:
        candidatos.append(Path(inicio))
    candidatos.append(Path.cwd())
    candidatos.append(Path(sys.argv[0]).resolve().parent if sys.argv and sys.argv[0] else Path.cwd())
    for c in candidatos:
        p = c.resolve()
        for _ in range(12):
            if (p / "_cortex").is_dir() and (p / "_cortex" / "CONTRATOS.md").exists():
                return p
            if p.parent == p:
                break
            p = p.parent
    return None


def excluir_extra(root):
    """`escopo.excluir` no config: caminhos relativos (pasta ou arquivo) fora do escopo.
    Para instalar o Cortex na raiz de um projeto que já tem acervo próprio sem varrer tudo."""
    try:
        from . import config as _c
        lst = ((_c.carregar(root) or {}).get("escopo") or {}).get("excluir") or []
    except Exception:
        lst = []
    return {str(x).strip().strip("/") for x in lst if str(x).strip()}


def _fora(relp, excl):
    return any(relp == e or relp.startswith(e + "/") for e in excl)


def rel(root, path):
    return os.path.relpath(str(path), str(root)).replace("\\", "/")


def arquivos_md(root):
    """Todos os .md do escopo, como caminhos relativos (com `/`), ordenados."""
    root = Path(root)
    saida = []
    excl = excluir_extra(root)
    for dp, dn, fn in os.walk(root):
        relp = rel(root, dp)
        if relp == ".":
            relp = ""
        partes = relp.split("/") if relp else []
        if partes and partes[0] == "_cortex" and len(partes) >= 2 and partes[1] in EXCLUIR_CORTEX:
            dn[:] = []
            continue
        dn[:] = sorted(d for d in dn if d not in EXCLUIR_DIRS and not (partes == ["_cortex"] and d in EXCLUIR_CORTEX)
                       and not _fora((relp + "/" + d) if relp else d, excl))
        for f in sorted(fn):
            if not f.lower().endswith(".md") or f.startswith("~$") or f.startswith("."):
                continue
            arq = (relp + "/" + f) if relp else f
            if not _fora(arq, excl):
                saida.append(arq)
    return saida


def arquivos_todos(root):
    """Todos os arquivos (qualquer extensão) do escopo — para o check de binários."""
    root = Path(root)
    saida = []
    excl = excluir_extra(root)
    for dp, dn, fn in os.walk(root):
        relp = rel(root, dp)
        if relp == ".":
            relp = ""
        partes = relp.split("/") if relp else []
        if partes and partes[0] == "_cortex" and len(partes) >= 2 and partes[1] == ".build":
            dn[:] = []
            continue
        dn[:] = sorted(d for d in dn if d not in EXCLUIR_DIRS and not _fora((relp + "/" + d) if relp else d, excl))
        for f in sorted(fn):
            arq = (relp + "/" + f) if relp else f
            if not _fora(arq, excl):
                saida.append(arq)
    return saida


def grupo(path):
    p = str(path).replace("\\", "/")
    if p.startswith("_cortex/kernel/"):
        return "kernel"
    for g in ("contexto", "times", "iniciativas", "briefings"):
        if p.startswith(g + "/"):
            return g
    return "raiz"


def eh_isento(path):
    return str(path).replace("\\", "/") in ISENTOS


def eh_gerado(root, path):
    """Arquivo gerado pelo build: pelo caminho fixo ou por `origem: gerado` no frontmatter."""
    p = str(path).replace("\\", "/")
    if p == "_cortex/.build/boot.md":
        return True
    try:
        texto = (Path(root) / p).read_text(encoding="utf-8", errors="replace")[:4000]
    except OSError:
        texto = None
    marcado = texto is not None and (bool(re.search(r"^origem:\s*gerado\s*$", texto, re.M))
                                     or "gerado pelo cortex build" in texto)
    # CLAUDE.md, AGENTS.md e wrappers só são "gerados" se o build os escreveu.
    # Sem isto o hook nega editar o CLAUDE.md escrito à mão de um projeto que já existia.
    if p in GERADOS_RAIZ:
        return texto is None or marcado
    if p.startswith(".claude/skills/"):
        nome = p.split("/")[2] if len(p.split("/")) > 2 else ""
        return (not nome.startswith("cortex-")) and marcado
    if p.startswith(".claude/agents/"):
        return marcado
    return marcado


def dentro_de(root, path, pasta):
    """`path` (absoluto ou relativo) está dentro de `root/pasta`? Comparação normalizada."""
    try:
        base = (Path(root) / pasta).resolve()
        alvo = Path(path)
        if not alvo.is_absolute():
            alvo = Path(root) / alvo
        alvo = alvo.resolve()
        a, b = str(alvo), str(base)
        if os.name == "nt":
            a, b = a.lower(), b.lower()
        return a == b or a.startswith(b + os.sep)
    except OSError:
        return False
