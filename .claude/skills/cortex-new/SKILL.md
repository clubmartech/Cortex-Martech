---
name: cortex-new
description: "Cria uma skill, sub-skill, agente ou doc num time do Cortex com frontmatter válido e seções obrigatórias, via cortex new. Use quando a pessoa disser: cria uma skill, quero um agente novo, documenta esse processo num doc novo, adiciona uma sub-skill de canal, novo arquivo na base."
---

# /cortex-new — criar skill | sub-skill | agent | doc

1. Pergunte **só o mínimo**, numa única AskUserQuestion (opções a partir de `python3 _cortex/cli/cortex.py config get times`, `papeis`, `canais`, `produtos`):
   - **tipo**: skill · sub-skill · agent · doc
   - **time**: slug de `times[]`
   - **id**: kebab-case, sem prefixo `skill-`, único na base (regra `_cortex/CONTRATOS.md` §2.1) — sugira um a partir do que a pessoa descreveu
   - **família** (skill/agent): `FAMILIA` ou `FAMILIA.sub` entre as ativas do `ROTAS.md` §1 (doc deixa vazio)
   - **canal** (opcional): slug de `canais[]`
   - **owner**: slug de `papeis[]` do time (padrão: o primeiro papel do time) — nunca nome de pessoa
2. Rode `python3 _cortex/cli/cortex.py new <tipo> --time <slug> --id <id> [--familia F] [--canal c] [--owner p] [--produto slug|todos]`. O arquivo nasce em `times/<time>/{skills|agents|docs}/<id>.md` (agentes: `<id>.agent.md`) a partir de `_cortex/templates/{skill,agent,doc}.md.tpl`, já com os 14 campos e as seções obrigatórias de CONTRATOS §2.4.
3. Abra o arquivo criado e preencha com a pessoa os `[PENDENTE: …]` — `descricao` (verbo + entrega, ≤160), ≥3 `gatilhos` em frases, `requires` (ids que o arquivo precisa, começando pelo agente que roteia a skill), processo e output. Nunca invente regra de negócio: pergunte.
4. Rode `python3 _cortex/cli/cortex.py lint --file <caminho>` até zerar os ERRO; depois `build` (entra no `ROTAS.md`/`CATALOGO.md` e ganha wrapper em `.claude/skills/<id>/`) e `doctor --quick`.
5. Lembre a pessoa: registrar no `## Histórico` quem ratificou (papel `governanca.ratificador`) e que a skill só é roteável se a família dela estiver ativa no `ROTAS.md`.
