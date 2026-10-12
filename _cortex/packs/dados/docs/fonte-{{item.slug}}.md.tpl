---
tipo: doc
id: fonte-{{item.slug}}
descricao: "Documenta a fonte {{item.nome}}: entidades, campos, chaves, granularidade, atualização e limitações, para toda consulta partir do mesmo mapa."
familia:
output: nenhum
canal:
ferramenta: {{#if item.tipo == "dados" or item.tipo == "analytics"}}{{item.slug}}{{/if}}
produto: todos
publico:
gatilhos: ["como está documentada a fonte {{item.nome}}", "campos da fonte {{item.nome}}", "limitações de {{item.nome}}", "atualização da fonte {{item.nome}}", "chaves e granularidade de {{item.nome}}"]
requires:
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

{{#if item.tipo == "dados" or item.tipo == "analytics"}}# Ficha de fonte — {{item.nome}}

> **Esta ficha nasce vazia de campos, de propósito.** Nenhuma entidade, campo ou chave foi pré-preenchido: o que está aqui só pode vir de um probe real na fonte, com data. Preenchida por `mapear-fonte-de-dados`, pelo papel `{{papel "analista-dados"}}`, com aprovação do dono técnico. A ficha de integração do kernel (`contexto/integracoes/{{item.slug}}.md`) fala de acesso e uso; esta fala **do dado**.

## Identificação (do config)

| Campo | Valor |
|---|---|
| Nome | **{{item.nome}}** (`{{item.slug}}`) |
| Tipo | {{item.tipo}}{{#if item.tipo == "analytics"}} — eventos de navegação e comportamento, em geral agregados e sem identificação individual{{/if}} |
| Somente leitura | {{#if item.somente_leitura}}sim{{else}}não — **mesmo assim, o agente nunca escreve**{{/if}} |
| Conector (MCP) | {{#if item.mcp}}sim{{else}}não — consulta por export ou painel{{/if}} |
| Dono técnico | `[PENDENTE: papel]` |
| Dono do dado | `[PENDENTE: papel]` |

## Perguntas de negócio que esta fonte responde

- `[PENDENTE: preencher]`

## Perguntas que esta fonte **não** responde

- `[PENDENTE: preencher]` — ex.: não separa por produto; não guarda histórico de etapa; não identifica a pessoa.

## Entidades

| Entidade (nome na fonte) | O que representa | Grão (uma linha = ?) | Volume `[CONECTOR]` | Desde quando |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | `[NECESSITA FONTE]` | |

## Campos por entidade (do probe)

### `[PENDENTE: entidade]`

| Campo | Tipo | Preenchimento (%) | Significado no negócio | Exemplo anonimizado | Observação |
|---|---|---|---|---|---|
| `[PENDENTE: preencher]` | | `[CONECTOR]` | | | |

## Chaves e ligações

| De | Para | Chave | Cobertura | Observação |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | `[NECESSITA FONTE]` | registros antigos podem usar outra chave |

## Datas de negócio e fuso

| Entidade | Campo de data do evento de negócio | O que marca | Campo de gravação (não usar em métrica) | Fuso |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | `[PENDENTE]` |

## Atualização e permissões

| Item | Valor |
|---|---|
| Frequência de atualização | `[PENDENTE: tempo real · diária · manual]` |
| Atraso típico | `[PENDENTE]` |
| Permissão de leitura | `[PENDENTE: quem concede]` |
| Permissão de escrita | não aplicável ao agente |

## Consultas, visões e funções oficiais

Preferir sempre sobre tabela bruta: já aplicam exclusões e definições.

| Nome | Responde o quê | Parâmetros | Observação |
|---|---|---|---|
| `[PENDENTE: preencher]` | | | |

## Exclusões oficiais

| Regra | Onde vive na fonte | Desde quando |
|---|---|---|
| `[PENDENTE: teste · duplicado · interno]` | | |

## Limitações e armadilhas (com data)

| Armadilha | Como aparece | O que fazer | Registrada em |
|---|---|---|---|
| `[PENDENTE: preencher]` | | | `[CONECTOR: {{item.slug}} · AAAA-MM-DD]` |

## Métricas do dicionário que usam esta fonte

Apontar de `times/{{time.slug}}/docs/dicionario-metricas.md`: `[PENDENTE: preencher]`

## Como atualizar

1. Toda consulta que revelar campo vazio, chave alternativa ou comportamento inesperado volta para "Limitações e armadilhas", com data.
2. Probe novo substitui a tabela de campos; registrar a data.
3. Linha no `## Histórico` com o papel.

{{else}}# Ficha de fonte — gerada para `{{item.slug}}` ({{item.tipo}})

> **Aviso.** Este arquivo foi gerado pelo template de ficha de fonte do pack `dados`, que documenta **integrações de tipo `dados` ou `analytics`**. O item recebido foi `{{item.slug}}` (tipo `{{item.tipo}}`), que não é uma dessas integrações — confira a chave `itens` do `pack.yaml`. Este arquivo pode ser removido. Para documentar uma fonte de dados, rodar `mapear-fonte-de-dados` para a integração correspondente e gravar em `times/{{time.slug}}/docs/fonte-<slug-da-integracao>.md`.

{{/if}}## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
