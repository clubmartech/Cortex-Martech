---
tipo: doc
id: ficha-produto-{{item.slug}}
descricao: "Estende o doc-raiz de {{item.nome}} para o product marketing — módulos, públicos, dores, objeções, concorrentes e o que nunca afirmar."
familia:
output: nenhum
canal:
ferramenta:
produto: {{item.slug}}
publico:
gatilhos: ["ficha de produto de {{item.nome}}", "módulos de {{item.nome}}", "o que nunca afirmar sobre {{item.nome}}", "com quem {{item.nome}} disputa o cliente", "dores que {{item.nome}} resolve", "públicos de {{item.nome}}", "telas de {{item.nome}}"]
requires:
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

# Ficha de produto — {{item.nome}}

> **Esta ficha estende, não substitui.** O doc-raiz `contexto/produtos/{{item.slug}}/{{item.slug}}.md` responde *o que é e por que o cliente compra*; esta ficha guarda o que o Product Marketer e o Documentador de Produto usam no dia a dia: módulos, públicos, dores, objeções, concorrência, telas e a lista do que nunca afirmar. Quando os dois falam da mesma coisa, um aponta para o outro. Atualizada pelo papel `{{papel "product-marketer"}}` com aprovação; cada mudança vira linha no `## Histórico`.

## Visão (do config)

| Campo | Valor |
|---|---|
| Nome | **{{item.nome}}** (`{{item.slug}}`) |
| Tipo | {{item.tipo}} |
| Marca que assina | `{{item.marca}}` |
| Públicos | {{join item.publicos ", "}} |
| Dor principal | {{#if item.dor_principal}}{{item.dor_principal}}{{else}}`[PENDENTE: preencher]`{{/if}} |
| Promessa | {{#if item.promessa}}{{item.promessa}}{{else}}`[PENDENTE: preencher]`{{/if}} |
| Estágio da oferta | `[PENDENTE: novo · maduro · em descontinuação]` |
| Doc-raiz | `contexto/produtos/{{item.slug}}/{{item.slug}}.md` |

{{#if item.modulos}}## Módulos

Um bloco por módulo. "O que é" e "o que não é" evitam que a peça prometa o que outro módulo entrega.

{{#each item.modulos as m}}### `{{m}}`

| Campo | Valor |
|---|---|
| O que é | `[PENDENTE: preencher]` |
| O que não é | `[PENDENTE: preencher]` |
| Para quem (público) | `[PENDENTE: preencher]` |
| Dor que resolve | `[PENDENTE: preencher]` |
| Mensagem central | `[PENDENTE: preencher]` |
| Funcionalidades documentadas | `[PENDENTE: links das fichas em times/]` |

{{/each}}{{else}}## Módulos

{{item.nome}} não tem módulos declarados em `cortex.config.yaml`. Se a oferta ganhar partes com nome próprio, declarar em `produtos[].modulos` e rodar `cortex build`; esta seção passa a listar um bloco por módulo.

{{/if}}## Públicos e dores

Públicos declarados para este produto: **{{join item.publicos ", "}}**. Manter só as linhas deles; a dor específica deste produto pode ser mais concreta que a dor geral do público.

| Público | Dor geral (config) | Dor específica neste produto | Momento em que dói | Fonte |
|---|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` — {{pu.nome}} | {{pu.dor}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[NECESSITA FONTE]` |
{{/each}}

## Objeções e respostas

| Público | Objeção (config) | Resposta curta | Prova | Status |
|---|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` | {{pu.objecao}} | `[PENDENTE: preencher]` | `[NECESSITA FONTE]` | `[HIPÓTESE]` |
{{/each}}

## Posicionamento (saída de `posicionamento-produto`)

| Público | Problema | Promessa | Provas | Diferenciais (até 3) |
|---|---|---|---|---|
| `[PENDENTE: público]` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[NECESSITA FONTE]` | `[PENDENTE: preencher]` |

Matriz completa dor → benefício → prova: `times/{{time.slug}}/docs/matriz-mensagens.md`.

## Concorrência e alternativas

`[PENDENTE: preencher]` — uma linha por concorrente ou categoria de alternativa (planilha, processo manual, não fazer nada). Battlecards detalhados em `times/{{time.slug}}/docs/battlecard-{{item.slug}}-<concorrente>.md`.

| Concorrente ou alternativa | Para qual público aparece | Onde ganhamos | Onde perdemos | Fonte | Battlecard |
|---|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | `[NECESSITA FONTE]` | |

## Provas disponíveis

| Prova | Tipo (dado · case · depoimento · tela · artigo publicado) | Fonte | Status | Onde cabe |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | `[NECESSITA FONTE]` | |

Publicações que valem como prova: `times/{{time.slug}}/docs/indice-publicacoes.md`.

## Telas

Arquivos em `_assets/produtos/{{item.slug}}/` (fora do escopo do scanner). Uma linha por tela ou gif, com a funcionalidade e a data da captura — tela desatualizada é prova falsa.

| Arquivo | Funcionalidade | Mostra o quê | Capturada em |
|---|---|---|---|
| `[PENDENTE: preencher]` | | | |

## O que nunca afirmar sobre {{item.nome}}

Lista explícita, válida para todos os canais e públicos. Herdada por `posicionamento-produto`, `mensagens-por-publico`, `battlecard` e pelo Redator do pack marketing.

- Termos proibidos da marca que assina (`contexto/brandcenter/brandcenter.md`).
- Funcionalidade em roadmap descrita como disponível.
- `[PENDENTE: promessa que o produto não sustenta]`
- `[PENDENTE: comparação sem evidência]`
- `[PENDENTE: resultado que depende de o cliente fazer algo, sem a condição]`

## Como atualizar esta ficha

1. Posicionamento, matriz e battlecard gravam aqui só a parte que lhes cabe, com aprovação.
2. Publicação que vale como prova entra em "Provas" com link do índice.
3. Tela nova substitui a antiga; a antiga sai da tabela.
4. Toda mudança vira linha no `## Histórico`, com o papel.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
