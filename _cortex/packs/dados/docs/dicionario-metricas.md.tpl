---
tipo: doc
id: dicionario-metricas
descricao: "Guarda a definição única de cada métrica — fórmula, fonte, granularidade, dono e armadilhas — partindo das métricas de funil e receita, sem números."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["definição oficial da métrica", "tabela de métricas", "qual a fórmula de", "métricas de funil e receita", "quem é dono da métrica", "armadilhas da métrica"]
requires:
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

# Dicionário de métricas — {{organizacao.nome}}

> **Este dicionário nasce sem números e sem fonte preenchida, de propósito.** As linhas abaixo são as métricas universais de funil e receita com a **estrutura** da definição; fórmula, fonte, dono e armadilhas são preenchidos por `dicionario-de-metricas`, pelo papel `{{papel "analista-dados"}}`, com aprovação do dono de cada métrica. Métrica que não está aqui não é calculada "do jeito óbvio" — é definida antes. Toda consulta (`consultar-metrica`) parte desta tabela.

**Como ler:** uma linha por métrica. *Data de negócio* é o evento que marca o período (nunca a data de gravação). *Granularidade* diz o que dá e o que não dá para quebrar. *Dono* é um papel de `papeis[]`. *Armadilhas* guardam o que já deu errado, com data.

**Fontes disponíveis:** {{#each integracoes as i}}{{#if i.tipo == "dados"}}`{{i.slug}}` (dados) {{/if}}{{#if i.tipo == "analytics"}}`{{i.slug}}` (analytics) {{/if}}{{#if i.tipo == "crm"}}`{{i.slug}}` (CRM) {{/if}}{{#if i.tipo == "automacao-mkt"}}`{{i.slug}}` (automação de marketing) {{/if}}{{/each}}{{#if integracao:dados}}{{else}}{{#if integracao:analytics}}{{else}}— sem integração de dados ou analytics: fonte é export ou dado informado, marcado `[INFORMADO PELO CLIENTE]`{{/if}}{{/if}}. Fichas em `times/{{time.slug}}/docs/fonte-<slug>.md`.

## Funil

| Métrica | Definição | Fórmula (numerador ÷ denominador) | Data de negócio | Exclusões | Granularidade | Fonte | Dono | Armadilhas |
|---|---|---|---|---|---|---|---|---|
| Visita / sessão | pessoa ou sessão que chegou a uma propriedade digital | contagem de sessões no período | início da sessão | interno, robô | `[PENDENTE: agregada?]` | `[PENDENTE]` | `[PENDENTE: papel]` | |
| Lead / contato novo | pessoa identificada pela primeira vez no período | contagem distinta por chave natural | data da primeira conversão | teste, interno | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` | mesma pessoa em dois formulários conta uma vez |
| Lead qualificado | contato que atende o critério de passagem da etapa | contagem de registros que entraram na etapa no período | data de entrada na etapa | teste, duplicado, descarte administrativo | `[PENDENTE: por produto?]` | `[PENDENTE]` | `[PENDENTE: papel]` | critério muda → série quebra; registrar vigência |
| Oportunidade | negócio aberto e aceito pela área seguinte | contagem de negócios aceitos no período | data de aceite | idem | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` | |
| Venda / pedido | resultado fechado | contagem de fechamentos no período | data de fechamento | cancelado, teste | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` | fechamento vs. pagamento: escolher um |
| Taxa de passagem (etapa A → B) | proporção que avança | entradas em B no período ÷ entradas em A no período **ou** por cohort — escolher e escrever | conforme as etapas | idem | a menor entre A e B | — | `[PENDENTE: papel]` | taxa de período ≠ taxa de cohort |
| Tempo entre etapas | quanto demora para avançar | mediana de dias entre entrada em A e em B | ambas | idem | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` | usar mediana; média é puxada por outliers |

## Receita

{{#if modelo_comercial:B2C}}| Métrica | Definição | Fórmula | Data de negócio | Exclusões | Granularidade | Fonte | Dono | Armadilhas |
|---|---|---|---|---|---|---|---|---|
| Receita do período | valor vendido | soma do valor dos pedidos fechados | data do pedido | cancelado, devolvido (declarar se bruto ou líquido) | `[PENDENTE: por produto?]` | `[PENDENTE]` | `[PENDENTE: papel]` | bruto vs. líquido de devolução |
| Ticket médio | valor por pedido | receita do período ÷ pedidos do período | data do pedido | idem | idem | `[PENDENTE]` | `[PENDENTE: papel]` | |
| Taxa de recompra | clientes que voltaram | clientes com 2+ pedidos na janela ÷ clientes com 1+ pedido | data do pedido | idem | `[PENDENTE: janela]` | `[PENDENTE]` | `[PENDENTE: papel]` | janela define tudo; escrever |
| Clientes ativos | compraram na janela | contagem distinta de clientes com pedido na janela | data do pedido | idem | `[PENDENTE: janela]` | `[PENDENTE]` | `[PENDENTE: papel]` | |
{{else}}| Métrica | Definição | Fórmula | Data de negócio | Exclusões | Granularidade | Fonte | Dono | Armadilhas |
|---|---|---|---|---|---|---|---|---|
| Receita nova | valor dos contratos fechados no período | soma do valor dos fechamentos | data de fechamento | cancelado, teste | `[PENDENTE: por produto?]` | `[PENDENTE]` | `[PENDENTE: papel]` | valor total vs. valor recorrente: escolher e nomear |
| Receita recorrente nova | parcela recorrente dos fechamentos | soma do valor recorrente mensal dos fechamentos | data de fechamento | idem; expansão e redução separadas | idem | `[PENDENTE]` | `[PENDENTE: papel]` | não misturar novo, expansão e retração |
| Ticket médio | valor por fechamento | receita nova ÷ fechamentos | data de fechamento | idem | idem | `[PENDENTE]` | `[PENDENTE: papel]` | |
| Clientes ativos | contratos vigentes | contagem distinta de clientes com contrato ativo na data | data de referência | cancelado | `[PENDENTE: por produto?]` | `[PENDENTE]` | `[PENDENTE: papel]` | foto (data) vs. período |
| Cancelamento (churn) | clientes ou receita que saíram | saídas no período ÷ base no início do período | data de cancelamento | idem | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` | por cliente ≠ por receita |
{{/if}}
## Custo e eficiência

| Métrica | Definição | Fórmula | Data de negócio | Exclusões | Granularidade | Fonte | Dono | Armadilhas |
|---|---|---|---|---|---|---|---|---|
| Custo por lead | investimento por contato novo | investimento do canal no período ÷ leads do canal no período | data de conversão do lead | leads sem canal | por canal | `[PENDENTE]` | `[PENDENTE: papel]` | lead sem canal some do denominador: declarar |
| Custo por lead qualificado | investimento por lead que avançou | investimento ÷ leads que passaram da etapa | data de entrada na etapa | idem | por canal | `[PENDENTE]` | `[PENDENTE: papel]` | a métrica mais honesta de qualidade do canal |
| Cobertura de rastreamento | % de registros com origem identificada | registros com canal ≠ desconhecido ÷ total | data do registro | — | por fonte | `[PENDENTE]` | `[PENDENTE: papel]` | abaixo do piso, atribuição é inválida |

## Produtos e granularidade

Produtos do config: {{#each produtos as p}}`{{p.slug}}`{{#if @last}}{{else}}, {{/if}}{{/each}}. Para cada métrica, a coluna *Granularidade* diz se há quebra por produto. **Nunca comparar métrica agregada com métrica por produto sem dizer.**

## Métricas próprias desta organização

| Métrica | Definição | Fórmula | Data de negócio | Exclusões | Granularidade | Fonte | Dono | Armadilhas |
|---|---|---|---|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | | | | | |

## Regras de alerta (de `alerta-de-anomalia`)

| Métrica | Comparação | Limiar de queda | Limiar de pico | Volume mínimo | Dono |
|---|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | | |

## Conflitos resolvidos

| Data | Métrica | Definições concorrentes | Decisão | Quem |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
