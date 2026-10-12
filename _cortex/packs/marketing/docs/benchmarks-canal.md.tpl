---
tipo: doc
id: benchmarks-canal
descricao: "Registra, por canal ativo, as métricas acompanhadas, a faixa de referência própria e como medir — fonte das metas e do diagnóstico de performance."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual a referência de métrica do canal", "faixa de referência de abertura", "benchmark do canal", "como medir o canal", "o que é um bom resultado em", "registrar aprendizado de canal"]
requires:
owner: {{papel "analista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

# Benchmarks por canal — {{organizacao.nome}}

> **Este documento nasce vazio de números, de propósito.** Nenhuma faixa de mercado foi pré-preenchida: benchmark de terceiros desatualiza, varia por segmento e vira "fato" sem fonte. Cada linha `[NECESSITA FONTE]` é preenchida com **dado próprio** (histórico de campanhas, relatórios da plataforma, base integrada) pelo papel `{{papel "analista"}}`, com período e fonte. Benchmark externo só entra com `[BUSCADO: fonte + ano]` e nunca substitui o dado próprio.

**Como usar:** o Estrategista ancora metas aqui; o Analista compara resultado contra a faixa própria; o Redator consulta a seção de aprendizados antes de escrever. **Como atualizar:** no fechamento de cada ciclo ({{operacao.ciclo_planejamento}}), a partir do bloco de aprendizados de `analisar-performance` — com aprovação humana, nunca gravação automática. Mediana e faixa (não média) para séries com outlier.

## Trio diagnóstico (vale para qualquer canal)

| Sintoma | Diagnóstico provável |
|---|---|
| Atenção alta (abertura, impressão, visualização) + ação baixa (clique, conversão) | Problema de **conteúdo ou oferta** — a promessa não se sustenta no corpo ou no CTA |
| Atenção baixa + ação boa | Problema de **gancho ou segmentação** — quem chegou era o público certo, mas poucos chegaram |
| Volume alto + queda de taxa | **Saturação** — frequência alta ou base ampla demais |

## Tabela por canal ativo

{{#each canais as c}}### `{{c.slug}}` (prioridade {{c.prioridade}})

| Métrica | Faixa de referência própria | Como medir |
|---|---|---|
| Alcance ou entregas | `[NECESSITA FONTE]` | Relatório da plataforma; período fixo (semana, mês) |
| Taxa de atenção (abertura, visualização, impressão → clique) | `[NECESSITA FONTE]` | Numerador e denominador da própria plataforma; registrar a definição |
| Taxa de ação (clique, resposta, conversão) | `[NECESSITA FONTE]` | Ação ÷ entregas ou ÷ alcance; declarar qual |
| Custo por lead / por resultado | `[NECESSITA FONTE]` | Verba do canal ÷ leads do canal, pela atribuição oficial |
| Custo por lead qualificado | `[NECESSITA FONTE]` | Verba ÷ leads que avançaram para a etapa seguinte |
| Taxa de passagem para a próxima etapa | `[NECESSITA FONTE]` | Da definição oficial de funil{{#if integracao:crm}} (CRM){{/if}} |
| Sinal negativo (descadastro, bloqueio, denúncia, rejeição) | `[NECESSITA FONTE]` | Relatório da plataforma; limite de alerta definido pelo time |
| Volume mínimo para decidir (impressões, envios) | `[NECESSITA FONTE]` | Abaixo dele, resultado é ruído, não dado |

**Aprendizados do canal** (o que repetir, o que evitar, com evidência e data):
- `[PENDENTE: preencher]`

{{/each}}

## Funil e definições

| Etapa | Definição oficial da organização | Fonte |
|---|---|---|
| Visita / alcance | `[PENDENTE: preencher]` | |
| Lead | `[PENDENTE: preencher]` | |
| Lead qualificado | `[PENDENTE: preencher]` | |
| Oportunidade | `[PENDENTE: preencher]` | |
| Venda | `[PENDENTE: preencher]` | |

Taxa de passagem entre etapas (faixa própria): `[NECESSITA FONTE]`.

## Sazonalidade

| Mês ou período | Comportamento esperado | Evidência |
|---|---|---|
| `[PENDENTE: preencher]` | | |

## Saúde da base de contatos

| Indicador | Saudável | Alerta | Ação |
|---|---|---|---|
| Base engajada (interagiu no período) | `[NECESSITA FONTE]` | | protocolo de reativação (`operar-base`) |
| Rejeição definitiva (hard bounce) | `[NECESSITA FONTE]` | | limpeza |
| Descadastro | `[NECESSITA FONTE]` | | revisar segmentação e frequência |
| Denúncia de spam | `[NECESSITA FONTE]` | | pausar disparos |

## Benchmarks externos (referência, nunca meta)

| Canal | Métrica | Valor | Fonte e ano |
|---|---|---|---|
| `[PENDENTE: canal]` | `[PENDENTE: métrica]` | `[BUSCADO: valor]` | `[BUSCADO: fonte + ano]` |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "analista"}} |
