---
tipo: skill
id: forecast-pipeline
descricao: "Lê o pipeline por estágio, calcula o forecast ponderado com probabilidade do histórico próprio, mede cobertura contra a meta e aponta negócios parados e ações."
familia: PLANEJAR.pipeline
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["forecast do mês", "previsão de fechamento", "pipeline ponderado", "quanto do pipeline vai fechar", "cobertura de pipeline para a meta", "negócios parados no estágio", "taxa de passagem entre estágios", "revisão de forecast"]
requires: lider-vendas · estagios-pipeline
owner: {{papel "lider-vendas"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Líder de Vendas** (`lider-vendas`), que carrega o gate (`_cortex/kernel/gate.md`) e a definição oficial de estágios antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Líder antes de analisar.**

# Forecast e pipeline — estágios, taxas, previsão e cobertura

Responde "vamos bater a meta?" com dado: negócios por estágio × probabilidade calibrada no histórico próprio × chance de fechar dentro do período. Entrega o **gap** contra a meta e o que fazer com ele. A régua é `times/{{time.slug}}/docs/estagios-pipeline.md`: estágio, critério de saída e limite de dias parado.

## Contexto de uso

- Revisão semanal de pipeline; abertura da reunião tática do ciclo ({{operacao.ciclo_planejamento}}).
- Meta do período em risco.
- Decisão sobre ação de aceleração ou de geração de demanda.
- Comunicação de perspectiva à liderança antes do fechamento.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Período e data de corte | sim |
| Meta do período (quantidade, valor ou ambos) | sim |
| Recorte (produto, time, origem) | sim |
| Fonte do dado | sim |
| Histórico de taxa de passagem por estágio (ou aviso de que não existe) | sim |

**Fonte do dado:** {{#if integracao:crm}}a integração de CRM definida em `cortex.config.yaml` (consulta read-only; registrar data e filtro da extração){{else}}não há CRM integrado no config — o pipeline vem do export ou planilha que o usuário fornece, e todo número entra `[INFORMADO PELO CLIENTE]`{{/if}}{{#if integracao:dados}}; a integração de dados é fonte complementar para histórico por safra{{/if}}. Sem meta, não há gap; sem gap, não há forecast — só contagem.

## Processo

### 0. Calibrar as probabilidades (obrigatório)

Para cada estágio, probabilidade = negócios que passaram pelo estágio e fecharam ganhos ÷ negócios que passaram pelo estágio, no histórico próprio (janela definida pelo time, `[PENDENTE: definir janela]`). Sem histórico suficiente: usar pesos declarados pelo time como `[PENDENTE DE CONFIRMAÇÃO]` e dizer no relatório que o forecast usa pesos não calibrados. Nunca usar faixa de mercado como peso.

### 1. Snapshot por estágio

| Estágio (do doc) | Negócios | Valor | Probabilidade | Ponderado | Dias médios no estágio | Acima do limite |
|---|---|---|---|---|---|---|

Separar por produto quando a organização vende mais de um ({{#each produtos as p}}`{{p.slug}}` {{/each}}): média entre produtos esconde o padrão.

### 2. Ajuste por tempo

Negócio só conta para o período se o tempo restante ≥ tempo médio do estágio atual até o fechamento (histórico próprio). O que não cabe no período é **pipeline futuro**, não forecast.

### 3. Gap e cobertura

```
Forecast = Σ (valor ou quantidade por estágio × probabilidade), só dos que cabem no período
Gap = Meta − Forecast
Cobertura = Pipeline aberto que cabe no período ÷ Meta
```

Faixas de alerta de cobertura e de gap são **convenção do time** registradas em `estagios-pipeline` § Limiares — sem elas, o relatório apresenta o número e marca `[PENDENTE: definir limiar]`.

### 4. Negócios parados

Lista dos que passaram o limite de dias do estágio: conta, estágio, dias, último contato, dono, próxima ação. Parado além do dobro do limite é tratado como **risco de perda**, não como pipeline confiável.

### 5. Ações por tipo de gap

| Situação | Ação | Dono |
|---|---|---|
| Gap pequeno | acelerar os que estão em proposta/negociação (`follow-up` com valor; incluir decisor ausente) | Executivo de Vendas |
| Gap médio | aceleração + reativar negócios perdidos recentes por timing + revisar critério de passagem | Executivo + Líder |
| Gap grande | comunicar à liderança antes do fechamento; plano de recuperação{{#if pack:marketing}}; demanda via estrategista do pack de marketing{{/if}} | Líder de Vendas |
| Cobertura baixa para o próximo período | geração de demanda agora — o efeito chega no ciclo seguinte | Líder{{#if pack:marketing}} + marketing{{/if}} |

### 6. Relatório (uma página)

```
FORECAST — [período] — gerado em [data] — fonte: [integração/arquivo, data da extração]
Realizado até agora: [x] · Meta: [y] · Diferença: [z]
| Estágio | Negócios | Prob. (calibrada/declarada) | Contribuição |
Forecast: [...] · Gap: [...] · Cobertura: [...] · Avaliação: no caminho / em risco / meta em risco
Negócios parados: [n] — top [lista]
Ações: [ação — dono — prazo — impacto esperado]
Premissas e marcadores: [...]
```

## Regras

- Forecast nunca sem gap explícito.
- Probabilidade do histórico próprio; peso não calibrado é declarado.
- Leitura por safra e por produto; volume mínimo para taxa (abaixo dele, é ruído).
- Negócio sem valor registrado entra na contagem, não no valor; o relatório diz quantos são.
- Benchmark externo só com `[BUSCADO: fonte + ano]`, nunca como meta.
- Contas anonimizadas em prompt externo; dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem.

## Checklist

- [ ] Meta, período, recorte e fonte confirmados?
- [ ] Probabilidades calibradas ou declaradas como não calibradas?
- [ ] Ajuste por tempo aplicado? Pipeline futuro separado?
- [ ] Gap e cobertura calculados; limiares do time ou `[PENDENTE]`?
- [ ] Negócios parados listados com dono e ação?
- [ ] Toda ação com dono, prazo e impacto esperado?
- [ ] Nenhum número sem origem?

## Output esperado

| Saída | Formato |
|---|---|
| Snapshot por estágio | tabela |
| Forecast, gap e cobertura | números + avaliação |
| Negócios parados | lista com dono e ação |
| Relatório de uma página | modelo acima |
| Proposta de ajuste de limiar ou probabilidade | para `estagios-pipeline`, com aprovação humana |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "lider-vendas"}} |
