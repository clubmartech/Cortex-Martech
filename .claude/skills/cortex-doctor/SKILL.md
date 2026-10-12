---
name: cortex-doctor
description: "Roda o checkup da base do Cortex (14 checks) e explica os achados por severidade, com o que corrigir primeiro. Use quando a pessoa disser: roda o doctor do Cortex, audita a base do Cortex, checa a documentação, tem algo quebrado nas rotas, confere o frontmatter, validar antes do commit, o hook apontou erro."
---

# /cortex-doctor — checkup da base

1. Rode `python3 _cortex/cli/cortex.py doctor` na raiz (a pasta com `_cortex/`). Para um arquivo só: `doctor <caminho>`. Para o checkup rápido (≤1 s): `doctor --quick`.
2. Leia a saída (também em `_cortex/.build/last-doctor.json`). Os checks são: 1 estrutura · 2 config · 3 frontmatter · 4 placeholders · 5 links e remissões · 6 rotas · 7 tamanho · 8 drift (rode `build`) · 9 segurança · 10 histórico · 11 nomenclatura · 12 duplicatas · 13 encoding · 14 interfaces entre skills.
3. Explique em pt-BR, nesta ordem:
   - **ERRO** — bloqueia: o `doctor` sai com código 1 e o hook recusa escrita com esses problemas. Diga o arquivo, o que está errado e o conserto exato (campo, valor, caminho).
   - **AVISO** — não bloqueia: agrupe por tipo (`[PENDENTE]` a preencher, gatilhos < 3, sub-família inativa, skill órfã, `rode build`).
   - **INFO** — contexto.
4. Se houver correções automáticas (ordem do frontmatter, `validado_em` ≠ 1ª data do Histórico, `## Histórico` ausente), ofereça `doctor --fix` **antes** de rodar — ele reescreve arquivos.
5. Se o achado for "gerado desatualizado" ou "wrapper desatualizado", a correção é `python3 _cortex/cli/cortex.py build`, nunca editar o gerado à mão.
6. Nunca "corrija" removendo conteúdo que você não entende: aponte e pergunte. Arquivos do kernel (`_cortex/kernel/`) só mudam com ratificação do papel `governanca.ratificador`.
