---
tipo: doc
id: matriz-mensagens
descricao: "Guarda a matriz produto × público — dor, benefício, prova, objeção, nunca dizer — validada pelo product marketing, de onde o redator deriva peças."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["matriz de mensagens", "qual a mensagem validada para esse público", "benefício aprovado por público", "o que o redator pode afirmar", "mensagem oficial do produto", "célula da matriz"]
requires:
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

# Matriz de mensagens — {{organizacao.nome}}

> **Esta matriz nasce vazia de mensagens, de propósito.** Cada célula é preenchida por `mensagens-por-publico`, a partir de um posicionamento aprovado, com prova e fonte. O Redator do pack marketing deriva a peça **da célula**; célula sem prova não vai para peça externa. Atualizada pelo papel `{{papel "product-marketer"}}`; toda mudança vira linha no `## Histórico`.

**Como ler:** uma seção por produto; dentro, uma linha por público do produto. Colunas: dor (na linguagem do público) → benefício (o que muda para ele) → prova (com fonte e status) → objeção e resposta → nunca dizer. Marcadores: `[HIPÓTESE]` dor sem fonte · `[NECESSITA FONTE]` prova ausente · `[PENDENTE: …]` célula por preencher.

## Públicos (do config)

| Público | Tipo | Dor declarada | Objeção declarada |
|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` — {{pu.nome}} | {{pu.tipo}} | {{pu.dor}} | {{pu.objecao}} |
{{/each}}

{{#each produtos as p}}## {{p.nome}} (`{{p.slug}}`)

Promessa (config): {{#if p.promessa}}{{p.promessa}}{{else}}`[PENDENTE: preencher]`{{/if}} · Ficha: `times/{{time.slug}}/docs/ficha-produto-{{p.slug}}.md`

| Público | Dor | Benefício | Prova | Objeção → resposta | Nunca dizer |
|---|---|---|---|---|---|
{{#each p.publicos as ps}}| `{{ps}}` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[NECESSITA FONTE]` | `[PENDENTE: preencher]` | herdado da ficha |
{{/each}}
{{/each}}
## Provas a conseguir

Células marcadas `[NECESSITA FONTE]` geram uma linha aqui. Quando a prova chega, a célula é atualizada e a linha sai.

| Prova | Produto | Público | Quem consegue | Prazo | Status |
|---|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | | |

## Como atualizar

1. Rodar `mensagens-por-publico` para o produto; aprovar no chat.
2. Substituir a célula; registrar a fonte da prova.
3. Linha no `## Histórico` com o produto e o público alterados.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
