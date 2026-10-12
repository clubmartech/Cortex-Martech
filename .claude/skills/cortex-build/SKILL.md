---
name: cortex-build
description: "Regera os arquivos derivados do Cortex (ROTAS.md, AGENTS.md, CLAUDE.md, CATALOGO.md, boot.md, wrappers de skills/agentes) e lista o que mudou. Use quando a pessoa disser: roda o build, regera as rotas, atualiza o catálogo, criei uma skill nova, mudei o config, instalei um pack, o doctor pediu build."
---

# /cortex-build — regerar os derivados

1. Rode `python3 _cortex/cli/cortex.py build` na raiz. Opções: `--only rotas|catalogo|wrappers|contexto|boot|interfaces` para uma etapa; `--first-run` **só** no primeiro uso ou quando a pessoa pedir explicitamente para regerar `contexto/**` (sobrescreve o contexto; exija autorização específica já presente no pedido ou solicite-a se faltar).
2. O build é idempotente: só grava arquivo cujo conteúdo mudou. Ordem: contexto (apenas ausentes) → packs pendentes de `packs[]` → catálogo/manifesto → `ROTAS.md`, `AGENTS.md`, `CLAUDE.md`, `CATALOGO.md`, `_cortex/.build/boot.md` → wrappers em `.claude/skills/<id>/SKILL.md` e `.claude/agents/<id>.md` (órfãos removidos, exceto `cortex-*`).
3. Relate em pt-BR: a lista de arquivos alterados (`✎`), wrappers removidos (`✕`) e avisos (`!` — valor ausente em template, pack sem pasta, template faltando). "0 arquivos alterados" significa que nada mudou desde o último build.
4. Depois do build, rode `python3 _cortex/cli/cortex.py doctor --quick` e diga se ficou limpo. Se a pessoa criou skill/agent, confira que o id apareceu no `ROTAS.md` §2 ou no `CATALOGO.md`; se não apareceu, o frontmatter está inválido (`doctor <arquivo>` explica).
5. Nunca edite `ROTAS.md`, `AGENTS.md`, `CLAUDE.md`, `CATALOGO.md` ou wrappers à mão — mude a fonte (`cortex.config.yaml`, `_cortex/packs/<id>/pack.yaml`, o `.md` de origem ou o template) e rode o build de novo. Lembre que `AGENTS.md`/`CLAUDE.md` novos só são lidos na próxima sessão.

A extensão opcional de interfaces é validada antes das escritas. `interfaces check` diagnostica suas fontes; `build --only interfaces` atualiza somente o índice. Mudanças na quantidade de contratos ou perfis também pedem build completo para atualizar rotas e boot.
