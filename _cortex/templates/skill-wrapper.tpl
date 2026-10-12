---
name: {{id}}
description: "{{descricao}} Gatilhos: {{join gatilhos "; "}}"
---
<!-- gerado pelo cortex build a partir de _cortex/templates/skill-wrapper.tpl — não edite; edite `{{caminho}}` e rode `cortex build` -->

Esta skill é um atalho. Abra e siga `{{caminho}}` — ele é a fonte; este wrapper não tem regra própria.

Antes de produzir:
1. Aplique `_cortex/kernel/gate.md`: contexto proporcional, declaração conforme configuração e reaproveitamento do briefing e da autorização existentes.
2. Abra os `requires` de `{{id}}`: {{#if tem:requires}}{{join requires " · "}}{{else}}nenhum{{/if}}.
3. Confirme a rota no `ROTAS.md`{{#if familia}} (família `{{familia}}`){{/if}} e respeite o orçamento de leitura.
