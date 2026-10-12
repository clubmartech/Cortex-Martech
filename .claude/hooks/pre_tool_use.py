#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Hook PreToolUse do Cortex (CONTRATOS §9).

1. caminho dentro de `_arquivo/` -> deny
2. Write/Edit em arquivo gerado (origem: gerado, ROTAS/CATALOGO/AGENTS/CLAUDE, wrappers) -> deny
3. Write/Edit em .md do escopo -> lint do conteúdo proposto; ERRO -> deny com a lista
4. Write de arquivo novo no escopo com operacao.criar_arquivo_sem_pedido: false -> ask
Falha interna -> allow silencioso (exit 0).
"""
import json
import os
import sys
import unicodedata
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import _cortex_hook as H  # noqa: E402

ESCRITA = {"Write", "Edit", "MultiEdit"}


def decidir(decisao, motivo):
    saida = json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse", "permissionDecision": decisao, "permissionDecisionReason": motivo,
    }}, ensure_ascii=False)
    sys.stdout.buffer.write((saida + "\n").encode("utf-8"))  # bytes UTF-8, independente do code page do console
    sys.stdout.flush()
    sys.exit(0)


def _no_escopo(relp):
    """.md dentro do escopo do scanner (CONTRATOS §10)?"""
    from lib import scope
    if not relp.lower().endswith(".md") or relp.startswith(".."):
        return False
    partes = relp.split("/")
    if any(p in scope.EXCLUIR_DIRS for p in partes[:-1]):
        return False
    if partes[0] == "_cortex" and len(partes) > 2 and partes[1] in scope.EXCLUIR_CORTEX:
        return False
    if scope._fora(relp, scope.excluir_extra(H.raiz())):
        return False
    return not scope.eh_isento(relp)


def main():
    H.utf8()
    root = H.raiz()
    dados = H.ler_stdin_json()
    if root is None or not dados:
        return 0
    tool = dados.get("tool_name") or ""
    ti = dados.get("tool_input") or {}
    caminho = ti.get("file_path") or ti.get("path") or ti.get("notebook_path")
    if not caminho:
        return 0
    cwd = dados.get("cwd") or str(root)
    p = Path(caminho)
    if not p.is_absolute():
        p = Path(cwd) / p
    try:
        p_res = p.resolve()
    except OSError:
        p_res = p
    # o macOS devolve o caminho do disco em NFD ("Área" decomposto) e a
    # ferramenta manda NFC. Sem normalizar os dois lados, relpath sai com "../.." e o hook
    # libera tudo em silêncio em qualquer pasta com acento no caminho.
    root = Path(unicodedata.normalize("NFC", str(root)))
    p_res = Path(unicodedata.normalize("NFC", str(p_res)))
    H.carregar_cli(root)
    from lib import scope, fs, config as _cfg
    # 1. _arquivo/
    if scope.dentro_de(root, p_res, "_arquivo"):
        decidir("deny", "`_arquivo/` nunca é lido nem editado como fonte (AGENTS.md §4). Se precisar do conteúdo, peça à pessoa que o traga de volta para a base.")
    if tool not in ESCRITA:
        return 0
    try:
        relp = os.path.relpath(p_res, root).replace("\\", "/")
    except ValueError:
        return 0
    if relp.startswith(".."):
        return 0
    # 2. gerados
    if scope.eh_gerado(root, relp):
        decidir("deny", "`%s` é gerado pelo `cortex build` — edite a fonte (cortex.config.yaml, o template em _cortex/templates/ ou o .md de origem) e rode `python3 _cortex/cli/cortex.py build`." % relp)
    # 3. lint do conteúdo proposto
    if _no_escopo(relp):
        atual = fs.ler(root, relp)
        if tool == "Write":
            conteudo = ti.get("content") or ""
        else:
            if atual is None:
                return 0
            conteudo = atual
            edits = ti.get("edits") if tool == "MultiEdit" else [ti]
            for e in edits or []:
                old, new = e.get("old_string") or "", e.get("new_string") or ""
                if old == "":
                    continue
                conteudo = conteudo.replace(old, new) if e.get("replace_all") else conteudo.replace(old, new, 1)
        import cortex
        cfg = _cfg.carregar(root)
        ach = cortex.lint_conteudo(root, cfg, relp, conteudo)
        erros = [a for a in ach if a.sev == "ERRO"]
        if erros:
            lista = "\n".join("- [check %d] %s" % (a.check, a.msg) for a in erros[:12])
            decidir("deny", "`cortex lint` recusou o conteúdo de `%s` (%d erro(s)):\n%s\nCorrija e tente de novo (CONTRATOS §2)." % (relp, len(erros), lista))
        # 4. arquivo novo sem pedido
        if tool == "Write" and atual is None:
            op = (cfg or {}).get("operacao") or {}
            if not op.get("criar_arquivo_sem_pedido", False):
                decidir("ask", "`%s` é um arquivo novo na base e `operacao.criar_arquivo_sem_pedido` é false — confirme que a pessoa pediu este arquivo." % relp)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main() or 0)
    except SystemExit:
        raise
    except Exception:
        sys.exit(0)
