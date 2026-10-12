"""Utilidades compartilhadas pelos hooks do Claude Code (raiz, import do CLI, stdin JSON)."""
import json
import os
import sys
sys.dont_write_bytecode = True  # base no Google Drive: sem __pycache__ sincronizado
from pathlib import Path


def raiz():
    """CLAUDE_PROJECT_DIR, ou a raiz deduzida do caminho deste script (.claude/hooks/x.py)."""
    env = os.environ.get("CLAUDE_PROJECT_DIR")
    if env and (Path(env) / "_cortex").is_dir():
        return Path(env).resolve()
    aqui = Path(__file__).resolve()
    cand = aqui.parents[2]
    if (cand / "_cortex").is_dir():
        return cand
    env2 = os.environ.get("CORTEX_ROOT")
    if env2 and (Path(env2) / "_cortex").is_dir():
        return Path(env2).resolve()
    return None


def carregar_cli(root):
    """Importa o módulo `cortex` (CLI) a partir da raiz; `lib.*` fica importável junto."""
    cli = str(root / "_cortex" / "cli")
    if cli not in sys.path:
        sys.path.insert(0, cli)
    import cortex  # noqa: F401
    return cortex


def ler_stdin_json():
    try:
        raw = sys.stdin.read()
        return json.loads(raw) if raw.strip() else {}
    except Exception:
        return {}


def utf8():
    for s in (sys.stdout, sys.stderr):
        try:
            s.reconfigure(encoding="utf-8")
        except Exception:
            pass
