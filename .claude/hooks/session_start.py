#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Hook SessionStart do Cortex (CONTRATOS §9): injeta boot.md + resumo do doctor --quick.
Sem config ou onboarding incompleto: instrução para /cortex-init + §1 do gate. Nunca falha a sessão."""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _cortex_hook as H  # noqa: E402


def secao_gate(root):
    p = root / "_cortex" / "kernel" / "gate.md"
    if not p.exists():
        return ""
    texto = p.read_text(encoding="utf-8", errors="replace")
    m = re.search(r"^## *1\..*?$", texto, re.M)
    if not m:
        return ""
    resto = texto[m.start():]
    fim = re.search(r"^## *(?!1\.)\d", resto, re.M)
    return resto[: fim.start()] if fim else resto[:3000]


def main():
    H.utf8()
    root = H.raiz()
    if root is None:
        print("Cortex: raiz não encontrada (sem `_cortex/`). Nada injetado.")
        return 0
    H.carregar_cli(root)
    from lib import config as _cfg, checks, fs, build
    cfg = _cfg.carregar(root)
    status = _cfg.status_onboarding(cfg)
    if cfg is None or status != "complete":
        print("# Cortex — onboarding pendente")
        if cfg is None:
            print("Não existe `cortex.config.yaml`. Antes de atender qualquer pedido de criação ou estratégia, rode a skill `/cortex-init` "
                  "(questionário bloco a bloco em `_cortex/onboarding/questionario.md`).")
        else:
            print("`meta.onboarding.status: %s`. Conclua os blocos pendentes com `/cortex-init` antes de produzir." % status)
        try:  # checkup pré-onboarding: máquina, ferramentas (só nomes) e materiais existentes
            from lib import checkup as _checkup
            print("\n" + _checkup.resumo(_checkup.executar(root)))
        except Exception as e:
            print("\n(checkup pré-onboarding falhou: %s — rode `python3 _cortex/cli/cortex.py checkup`)" % e)
        g = secao_gate(root)
        if g:
            print("\n" + g.strip())
        return 0
    ach = checks.rodar(root, cfg, {1, 2, 4, 9})
    erros = [a for a in ach if a.sev == "ERRO"]
    avisos = [a for a in ach if a.sev == "AVISO"]
    boot = fs.ler(root, "_cortex/.build/boot.md")
    if boot is None:
        try:
            build.executar(root, cfg, only="boot", log=lambda *_: None)
            boot = fs.ler(root, "_cortex/.build/boot.md")
        except Exception:
            boot = None
    if boot:
        print(boot.rstrip())
    else:
        print("# Cortex — boot.md ausente; rode `python3 _cortex/cli/cortex.py build`.")
    print("\n**doctor --quick:** %d erro(s), %d aviso(s)." % (len(erros), len(avisos)), end="")
    if erros:
        print(" Corrija antes de produzir (`python3 _cortex/cli/cortex.py doctor`):")
        for a in erros[:5]:
            print("- [%d] %s — %s" % (a.check, a.arquivo, a.msg))
    else:
        print()
    # O --quick roda só os checks 1, 2, 4 e 9. Em 2026-10-09 ele dizia "0 erro" enquanto o doctor
    # completo tinha 60 (frontmatter, links, histórico). O boot passa a mostrar os dois.
    try:
        import json
        ultimo = json.loads((root / "_cortex" / ".build" / "last-doctor.json").read_text(encoding="utf-8"))
        if not ultimo.get("quick"):
            print("**último doctor completo** (%s): %d erro(s), %d aviso(s)%s" % (
                ultimo.get("quando", "?"), ultimo.get("erros", 0), ultimo.get("avisos", 0),
                " — rode `python3 _cortex/cli/cortex.py doctor` para ver." if ultimo.get("erros") else "."))
    except Exception:
        pass
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main() or 0)
    except Exception as e:
        print("Cortex: hook de sessão falhou (%s). Siga `AGENTS.md`." % e)
        sys.exit(0)
