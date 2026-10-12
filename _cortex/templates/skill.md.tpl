---
tipo: {{novo.tipo}}
id: {{novo.id}}
descricao: "[PENDENTE: verbo + o que esta skill entrega, em até 160 caracteres]"
familia: {{novo.familia}}
output: texto
canal: {{novo.canal}}
ferramenta:
produto: {{novo.produto}}
publico:
gatilhos: ["[PENDENTE: frase que a pessoa diria]", "[PENDENTE: outra frase]", "[PENDENTE: terceira frase]"]
requires:
owner: {{novo.owner}}
origem: time
validado_em: {{agora}}
---

# {{novo.id}} — {{novo.tipo}}

> **Quando usar:** [PENDENTE: preencher — o sinal do pedido]. **Agente que me roteia:** [PENDENTE: id do agente — declare-o em `requires`]. **Gate:** `_cortex/kernel/gate.md`.

## Contexto de uso

- **Família:** `{{default novo.familia "[PENDENTE: família]"}}`{{#if novo.canal}} · **canal:** `{{novo.canal}}`{{/if}} · **oferta:** `{{novo.produto}}`{{#if novo.produto == "todos"}} (pergunte apenas se necessária e ainda ambígua){{/if}}
- **Entra com:** briefing suficiente ou cartão existente + [PENDENTE: preencher — insumos obrigatórios]
- **Não serve para:** [PENDENTE: preencher — o que parece esta skill mas é outra rota]

## Processo

1. [PENDENTE: preencher — passo a passo acionável]
2. …
3. Marque incerteza com os marcadores de `_cortex/kernel/anti-alucinacao.md` §4.
4. Entregue no destino autorizado; pergunte somente se o destino necessário continuar indefinido.

## Output esperado

- **Formato:** [PENDENTE: preencher — estrutura exata da saída]
- **Tamanho / limites:** [PENDENTE: preencher]
- **Exemplo curto:** [PENDENTE: preencher]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Criado pelo `cortex new {{novo.tipo}}`. | {{novo.owner}} |
