---
tipo: skill
id: analise-de-cohort
descricao: "Estrutura a análise de cohort — safra, tamanho, períodos, métrica por célula — lê os quatro padrões e deriva retenção, churn e tempo até o evento."
familia: ANALISAR.cohort
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta a análise de cohort", "retenção por mês de entrada", "cohort por canal", "quanto tempo até converter", "safra de clientes", "curva de retenção", "cohort de conversão"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`), o dicionário e a ficha da fonte antes de passar para cá. **Volte ao Analista de Dados antes de analisar.**

# Análise de cohort

Uma cohort é um grupo que compartilha um ponto de partida (mês de entrada, canal, segmento, versão). A análise acompanha o grupo ao longo do tempo e responde o que a média esconde: **as safras recentes estão melhores ou piores?** · **em que ponto da jornada perdemos?** · **quanto tempo leva até o evento?** Serve para retenção, conversão e receita.

## Contexto de uso

- Retenção ou cancelamento ao longo do tempo; conversão entre etapas com atraso; receita por safra.
- Comparar canais, segmentos ou produtos pela qualidade do que trazem, não pelo volume.
- Avaliar se uma mudança (produto, processo, preço) alterou o comportamento das safras seguintes.

## Briefing mínimo

Pergunta de negócio e decisão · **evento de entrada** (T0) e **evento acompanhado** (métrica do dicionário) · agrupamento (mês, canal, segmento, produto) · janela (quantos períodos após T0) · fonte com ficha.

## Processo

### Passo 1 — Definir antes de montar

T0 (data de negócio, não de gravação) · evento acompanhado e sua definição no dicionário · granularidade do período (semana, mês) · agrupamento · recorte. Tudo escrito antes de qualquer consulta.

### Passo 2 — Montar a tabela

| Cohort (T0) | Tamanho | P1 | P2 | P3 | … |
|---|---|---|---|---|---|

Linhas: cohorts · colunas: períodos após T0 · célula: % do tamanho inicial que ainda está ativo (retenção) ou que já converteu (conversão acumulada). Diagonal vazia é normal: cohorts recentes têm menos períodos. Montar via `consultar-metrica` (probe → consulta → citação); tamanho mínimo por cohort declarado — abaixo dele, a célula é ruído e recebe marcação.

### Passo 3 — Ler os quatro padrões

| Padrão | Como aparece | O que sugere |
|---|---|---|
| Melhora ao longo das safras | cohorts recentes com % maior no mesmo período | algo melhorou: produto, processo, qualificação |
| Piora ao longo das safras | cohorts recentes com % menor | algo piorou: qualidade de entrada, processo, produto |
| Queda no mesmo período em todas | coluna inteira cai | problema naquele ponto da jornada |
| Cohort discrepante | uma linha fora das demais | evento daquele período: sazonalidade, canal, campanha, mudança externa |

Cada leitura é `[HIPÓTESE]` até ter evidência (mudança datada, registro de campanha, relato).

### Passo 4 — Derivar métricas

- Retenção no período N = ativos em N ÷ tamanho inicial.
- Churn do período N = retenção(N−1) − retenção(N).
- Tempo até o evento = mediana de dias entre T0 e o evento, por cohort (mediana, não média).
- Receita por cohort (quando houver receita no dicionário) = receita acumulada ÷ tamanho inicial.
- Comparação entre agrupamentos (canal A vs. B) no **mesmo período** após T0 — nunca em períodos diferentes.

### Passo 5 — Hipóteses e recomendação

Para cada padrão lido: hipótese · evidência disponível · o que verificar · decisão que depende disso · quem age (Estrategista, produto, vendas). Separar o que muda o futuro (aprendizado) do que explica o passado (causa).

### Passo 6 — Entregar

Tabela com `[CONECTOR: fonte · data]`, definições usadas, tamanho mínimo, leitura por padrão e recomendações. Inteiro no chat; destino conforme pedido.

## Regras

- T0 e evento acompanhado vêm do dicionário; sem definição, não há cohort.
- Cohort pequena é marcada, não interpretada.
- Nunca comparar células de períodos diferentes após T0.
- Sazonalidade e mudanças datadas entram na leitura antes de qualquer conclusão sobre "melhora" ou "piora".
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem; cohort por cliente nomeado é anonimizada.

## Checklist

- [ ] T0, evento, período, agrupamento e recorte escritos antes da consulta?
- [ ] Tabela montada via `consultar-metrica` com conector e data?
- [ ] Tamanho mínimo declarado e células pequenas marcadas?
- [ ] Quatro padrões lidos com `[HIPÓTESE]` e evidência?
- [ ] Métricas derivadas corretas (mediana para tempo)? Recomendação com dono?

## Output esperado

| Saída | Formato |
|---|---|
| Tabela de cohort | tabela, com nota de método e `[CONECTOR: fonte · data]` |
| Leitura | lista: padrão · hipótese · evidência · o que verificar |
| Recomendações | tabela: ação · decisão que depende · dono |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
