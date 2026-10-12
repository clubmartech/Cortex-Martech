---
tipo: doc
id: taxonomia-origens
descricao: "Fixa a taxonomia origem de negócio → canal → campanha, o padrão de nome, o de-para de valores crus e a precedência, para que toda análise use a mesma régua."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["taxonomia de origens", "lista de canais e origens", "de-para de origem", "nomenclatura de campanha", "qual origem usar", "origem oficial do canal"]
requires:
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

# Taxonomia de origens — {{organizacao.nome}}

> **Três níveis, nunca misturados.** *Origem de negócio* diz qual área gerou; *canal* diz por qual meio chegou; *campanha* diz qual ação específica. Um registro tem os três. Esta taxonomia é escolha de negócio escrita por `definir-funil-e-origens`, pelo papel `{{papel "analista-dados"}}`, com aprovação das áreas — não é o que a ferramenta trouxe por padrão. "Desconhecido" é categoria legítima e **aparece** nos relatórios.

## Etapas do funil (resumo; definição completa no dicionário)

| Etapa | Entra quando (evento observável) | Campo ou evento na fonte | Responsável | Por produto? |
|---|---|---|---|---|
| `[PENDENTE: etapa]` | `[PENDENTE: preencher]` | `[PENDENTE]` | `[PENDENTE: papel]` | `[PENDENTE]` |

Exclusões em todas as etapas (teste, duplicado, interno, descarte administrativo) e onde a regra vive: `[PENDENTE: preencher]`.

## Nível 1 — Origem de negócio

| Origem | Área responsável (papel) | Descrição | Entra nas análises de marketing? |
|---|---|---|---|
| inbound | `[PENDENTE: papel]` | chegou por conteúdo, busca, site ou mídia | sim |
| outbound | `[PENDENTE: papel]` | abordagem ativa a partir da base ou de lista | `[PENDENTE]` |
| evento | `[PENDENTE: papel]` | inscrição ou contato em evento próprio ou de terceiros | sim |
| indicação | `[PENDENTE: papel]` | indicado por cliente, parceiro ou colaborador | `[PENDENTE]` |
| venda ativa | `[PENDENTE: papel]` | prospecção do time comercial | não |
{{#if publico:parceiro}}| parceiro | `[PENDENTE: papel]` | gerado por parceiro ou canal de revenda | `[PENDENTE]` |
{{/if}}| base de clientes | `[PENDENTE: papel]` | expansão ou recompra de quem já é cliente | `[PENDENTE]` |
| desconhecido | — | sem origem identificável | aparece, não some |

## Nível 2 — Canal de mídia

Canais ativos no config, mais os que toda organização recebe:

| Canal | Slug oficial | Regra de classificação (fonte + meio → canal) | Origem de negócio habitual |
|---|---|---|---|
{{#each canais as c}}| `{{c.slug}}` (prioridade {{c.prioridade}}) | `{{c.slug}}` | `[PENDENTE: regra]` | `[PENDENTE]` |
{{/each}}| busca orgânica | `organico` | `[PENDENTE: regra]` | inbound |
| tráfego direto | `direto` | sem fonte e sem meio | inbound |
| referência | `referencia` | outro site, sem campanha | inbound |
| desconhecido | `desconhecido` | não casou nenhuma regra | — |

Regra escrita uma vez, aplicada na entrada; valor que não casa cai em `desconhecido` e aparece no relatório.

## Nível 3 — Campanha

**Padrão de nome:** `[PENDENTE: produto-objetivo-canal-periodo-variacao]` · separador fixo · minúsculas · sem acento · sem espaço.

| Parte | Valores permitidos | Exemplo |
|---|---|---|
| produto | {{#each produtos as p}}`{{p.slug}}`{{#if @last}}{{else}} · {{/if}}{{/each}} | |
| objetivo | `[PENDENTE: captacao · nutricao · conversao · evento · reativacao]` | |
| canal | slug do nível 2 | |
| período | `AAAA-MM` ou `AAAA-tN` | |
| variação | letra ou número curto | |

Parâmetros de URL: `[PENDENTE: quais parâmetros e qual mapeia para fonte, meio, campanha, conteúdo]`.

## De-para de valores crus

Grafias antigas não são apagadas: entram aqui com a vigência.

| Valor cru (como aparece na fonte) | Origem oficial | Canal oficial | Desde quando | Observação |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | |

## Precedência

Quando um registro tem mais de uma origem possível:

| Situação | O que vale | Por quê |
|---|---|---|
| Primeira conversão vs. mais recente | `[PENDENTE: escolher]` | |
| Campo manual vs. parâmetro de URL | `[PENDENTE: escolher]` | |
| Registro de origem comercial com parâmetro de marketing | `[PENDENTE: escolher]` | |

## Vigência e mudanças

| Data | O que mudou | Impacto no histórico |
|---|---|---|
| `[PENDENTE: preencher]` | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
