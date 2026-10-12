---
tipo: skill
id: consultar-metrica
descricao: "Leva uma pergunta de negócio até o número citado — métrica do dicionário, fonte, probe de cinco linhas, consulta read-only e resultado com conector e data."
familia: CONSULTAR.metrica
output: dado
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual foi o número de", "quanto foi a métrica no período", "consulta a métrica", "me dá o valor de", "quantos no mês passado", "resultado da métrica por canal", "número para a reunião"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`), o dicionário e a ficha da fonte antes de passar para cá. Consulta read-only **não dispensa** abrir esta skill. **Volte ao Analista de Dados antes de consultar.**

# Consultar métrica — pergunta → métrica → fonte → probe → consulta → citação

Responde "quanto foi X no período Y, com recorte Z?" com um número que qualquer pessoa consegue reproduzir. O que diferencia esta skill de "rodar uma query": a métrica vem do dicionário, a fonte vem da ficha, o probe acontece **antes** da consulta final e a entrega leva `[CONECTOR: <fonte> · <data>]`. Lista registro a registro (quem converteu) segue o mesmo caminho.

## Contexto de uso

- Número pontual para reunião, relatório ou decisão.
- Insumo para `relatorio-recorrente`, `analise-de-cohort`, `atribuicao-multicanal` e para o Analista do pack marketing.
- Verificação de um número que alguém trouxe de outra fonte.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Pergunta de negócio | sim | "quantos leads" não basta: leads de quê, para decidir o quê |
| Métrica | sim | nome do dicionário; fora dele → `dicionario-de-metricas` antes |
| Período | sim | datas e fuso; "mês passado" é confirmado em datas |
| Recorte | não | produto, origem, canal, segmento |
| Formato | sim — perguntar | número no chat · tabela · lista · arquivo |

## Processo

### Passo 1 — Traduzir a pergunta para a definição

Abrir `times/{{time.slug}}/docs/dicionario-metricas.md`; copiar a definição (fórmula, exclusões, data de negócio, granularidade). Pergunta que a definição não cobre (ex.: métrica agregada pedida por produto) → dizer o limite, não adaptar em silêncio.

### Passo 2 — Escolher a fonte pela ficha

Fontes disponíveis:
{{#each integracoes as i}}{{#if i.tipo == "dados"}}- **{{i.nome}}** (`{{i.slug}}`) → `times/{{time.slug}}/docs/fonte-{{i.slug}}.md`
{{/if}}{{#if i.tipo == "analytics"}}- **{{i.nome}}** (`{{i.slug}}`, analytics) → `times/{{time.slug}}/docs/fonte-{{i.slug}}.md`
{{/if}}{{/each}}
Preferir consulta, visão ou função pronta que a ficha indique como oficial sobre tabela bruta. Fonte sem ficha → `mapear-fonte-de-dados` primeiro (pelo menos o probe da entidade usada).

### Passo 3 — Probe (5 linhas)

Antes da consulta final: amostra de 5 registros do recorte, listando campos existentes e preenchidos. Confirma: o campo da data de negócio · o campo do recorte (produto, origem) e seus valores reais (não os imaginados) · identificador exato quando a pergunta cita campanha, página ou formulário (buscar por aproximação e **confirmar com quem pediu**).

### Passo 4 — Consulta final

Read-only · definição do dicionário aplicada literalmente · data do evento de negócio, com fuso · exclusões oficiais · recorte pelos valores vistos no probe · volume grande → paginar.

### Passo 5 — Verificar

- Fechamento: soma das partes = total (por produto, por origem).
- Amostra: 3–5 registros contra o registro bruto.
- Sanidade: comparar com o período anterior; variação grande sem explicação vira pergunta, não entrega.

### Passo 6 — Entregar com citação

Formato combinado. Toda entrega leva: **`[CONECTOR: <fonte> · <data da extração>]`** · período e fuso · definição usada (nome no dicionário) · filtros · limitações da fonte que afetam o número · o que foi excluído. Leitura (o que o número sugere) **separada** do número e marcada `[HIPÓTESE]` quando for.

## Regras

- **Read-only.** Nunca escrita, mesmo com permissão no conector.
- **Nunca inventar coluna, tabela, função ou valor de recorte.** Só o que o probe mostrou.
- Nunca fixar colunas sem probe; nunca decidir o formato sem perguntar.
- Métrica sem definição no dicionário não é calculada "do jeito óbvio".
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem para prompt externo; lista compartilhada é anonimizada.
- Fonte indisponível → pedir o dado; sem resposta → `[NECESSITA FONTE]`.

## Tratamento de exceções

| Situação | Ação |
|---|---|
| Métrica fora do dicionário | abrir `dicionario-de-metricas`; não calcular antes |
| Identificador não encontrado exato | buscar por aproximação, listar variações com contagem, confirmar |
| Recorte com valores fora da taxonomia | entregar com os valores reais e apontar `taxonomia-origens` |
| Fechamento não bate | não entregar; investigar exclusão ou chave; registrar na ficha da fonte |
| Fonte não separa pelo recorte pedido | dizer o limite; oferecer o agregado |

## Checklist

- [ ] Pergunta de negócio e decisão claras? Métrica do dicionário?
- [ ] Fonte pela ficha? Probe rodado e campos confirmados?
- [ ] Data de negócio e exclusões oficiais aplicadas?
- [ ] Fechamento e amostra verificados?
- [ ] Entrega com conector, data, definição, filtros e limitações? Leitura separada?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório do probe | tabela no chat, antes da consulta final |
| Número, tabela ou lista | conforme combinado, com `[CONECTOR: fonte · data]` |
| Nota de método | definição · período · filtros · exclusões · limitações |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
