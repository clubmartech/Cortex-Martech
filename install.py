#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""install.py — instala o Cortex numa pasta de destino.

Uso: python3 install.py <destino>

Copia `_cortex/` (sem `.build`), `.claude/` (settings, hooks e as 4 skills `cortex-*`),
`install.py` e `README.md`; cria as pastas vazias do escopo; não sobrescreve arquivo
existente no destino (exceto se --force). Só stdlib.
"""
import argparse
import os
import shutil
import sys
from pathlib import Path

ORIGEM = Path(__file__).resolve().parent
PASTAS_VAZIAS = ["contexto", "times", "iniciativas", "briefings", "_saida", "_assets", "_arquivo", "_cortex/.build"]
IGNORAR = {"__pycache__", ".build", ".pyc"}


def _ignore(dirname, names):
    return [n for n in names if n in IGNORAR or n.endswith(".pyc") or n.startswith("~$")]


def copiar_arvore(src, dst, force, log):
    copiados = pulados = 0
    for dp, dn, fn in os.walk(src):
        dn[:] = [d for d in dn if d not in IGNORAR]
        rel = Path(dp).relative_to(src)
        for f in fn:
            if f.endswith(".pyc") or f.startswith("~$"):
                continue
            s = Path(dp) / f
            d = dst / rel / f
            if d.exists() and not force:
                pulados += 1
                continue
            d.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(s, d)
            copiados += 1
    log("  %-28s %d copiado(s), %d já existia(m)" % (str(src.relative_to(ORIGEM)) + "/", copiados, pulados))


def main():
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass
    ap = argparse.ArgumentParser(description="Instala o Cortex numa pasta.")
    ap.add_argument("destino")
    ap.add_argument("--force", action="store_true", help="sobrescreve arquivos do kernel já existentes no destino")
    args = ap.parse_args()
    dst = Path(args.destino).expanduser().resolve()
    if dst == ORIGEM:
        print("destino é a própria pasta de origem; nada a fazer.")
        return 1
    dst.mkdir(parents=True, exist_ok=True)
    print("Instalando o Cortex em %s" % dst)
    copiar_arvore(ORIGEM / "_cortex", dst / "_cortex", args.force, print)
    claude_src = ORIGEM / ".claude"
    if claude_src.is_dir():
        # settings + hooks + só as skills fixas cortex-*; wrappers gerados ficam de fora
        for sub in ("settings.json",):
            s = claude_src / sub
            d = dst / ".claude" / sub
            if s.exists() and (args.force or not d.exists()):
                d.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(s, d)
        copiar_arvore(claude_src / "hooks", dst / ".claude" / "hooks", args.force, print)
        for sk in sorted((claude_src / "skills").glob("cortex-*")):
            copiar_arvore(sk, dst / ".claude" / "skills" / sk.name, args.force, print)
    for f in ("install.py", "README.md"):
        s, d = ORIGEM / f, dst / f
        if s.exists() and (args.force or not d.exists()):
            shutil.copy2(s, d)
    for p in PASTAS_VAZIAS:
        (dst / p).mkdir(parents=True, exist_ok=True)
    print("\nPróximos passos:")
    print("  1. cd \"%s\"" % dst)
    print("  2. No Claude Code: abra a pasta e rode a skill /cortex-init (questionário bloco a bloco).")
    print("     Sem Claude Code: preencha um YAML a partir de _cortex/onboarding/exemplos/ e rode")
    print("     python3 _cortex/cli/cortex.py init --answers <respostas.yaml>")
    print("  3. python3 _cortex/cli/cortex.py doctor   (rotina de auditoria)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
