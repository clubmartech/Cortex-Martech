---
tipo: skill
id: aula
descricao: "Monta o material de aula — objetivo verificável, conceito, exemplo, exercício e resumo — coerente com o módulo da oferta e com a voz de quem ensina."
familia: CRIAR.aula
output: roteiro
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o roteiro da aula", "material didático para", "descrição da aula de", "exercício para o módulo", "plano de aula sobre", "resumo da aula para o aluno"]
requires: editor · linha-editorial · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Material de aula — o que o aluno sai sabendo

## Contexto de uso

- **Família:** `CRIAR.aula` · **oferta:** `todos` → **pergunte qual oferta e qual módulo**; abra o doc-raiz em `contexto/produtos/<slug>/<slug>.md`, seção do módulo.
- **Entra com:** `BRIEFING VALIDADO ✅` (oferta, módulo, objetivo de aprendizagem, público = aluno, material existente) + decisão de formato do Editor.
- **Não serve para:** texto para quem ainda não comprou (`artigo`), peça de divulgação da oferta (pack marketing).

## Processo

1. Abra o doc-raiz da oferta e a seção do módulo; o material **não afirma** nada que a oferta não cubra. Lacuna no doc → declare, não invente.
2. Escreva o **objetivo verificável**: "ao final, o aluno consegue …" (verbo observável).
3. **Conceito** em linguagem do público, com a tese da casa (`times/{{time.slug}}/docs/linha-editorial.md` §3).
4. **Exemplo** real ou realista, do campo do aluno.
5. **Exercício** que prova o objetivo, com critério de correção.
6. **Resumo** em até 5 linhas, para revisão.
7. Se a aula tem **voz** (quem ensina), aplique o doc da voz em `contexto/vozes/` antes do tom da marca.
8. Checklist: objetivo verificável · coerente com o módulo · exemplo · exercício com critério · sem afirmação fora da oferta.
9. Entregue no chat. Revisão humana antes de publicar ou gravar.

## Output esperado

- **Formato:** título da aula · módulo · objetivo · conceito · exemplo · exercício (+ critério) · resumo · materiais citados.
- **Tamanho / limites:** o da tabela de formatos; uma aula = um objetivo.
- **Exemplo curto:** "**Objetivo:** ao final, o aluno consegue desenhar o fluxo de um dado do formulário até o relatório, apontando onde cada perda pode acontecer."

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
