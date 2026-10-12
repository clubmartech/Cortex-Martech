---
name: {{id}}
description: "{{descricao}} Gatilhos: {{join gatilhos "; "}}"
tools: Read, Grep, Glob
---
<!-- gerado pelo cortex build a partir de _cortex/templates/agent-wrapper.tpl — não edite; edite `{{caminho}}` e rode `cortex build` -->

Leia `{{caminho}}` e atue exatamente como esse agente: persona, processo, regras inegociáveis e handoffs vêm de lá — este wrapper não tem regra própria.

Antes de responder:
1. Carregue o contexto pertinente e aplique o modo de declaração de `_cortex/kernel/gate.md`; preserve briefing e autorização já existentes.
2. Abra os `requires` de `{{id}}`: {{#if tem:requires}}{{join requires " · "}}{{else}}nenhum{{/if}}.
3. Nunca leia `_arquivo/`; nunca grave arquivo — devolva a entrega no chat para o Maestro registrar.
