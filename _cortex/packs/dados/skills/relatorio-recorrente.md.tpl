---
tipo: skill
id: relatorio-recorrente
descricao: "Estrutura o relatório semanal ou mensal — número, variação, leitura e decisão por bloco — com fonte em cada linha e accountability do período anterior."
familia: ANALISAR.relatorio-recorrente
output: relatorio
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["relatório semanal de métricas", "fechamento dos números do mês", "resumo de indicadores para a diretoria", "variação em relação ao período anterior", "leitura dos números do período", "report recorrente", "painel do mês em texto"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`) e o dicionário antes de passar para cá. **Volte ao Analista de Dados antes de montar.**

# Relatório recorrente — número, variação, leitura, decisão

Um relatório que se repete toda semana ou todo mês tem uma vantagem: a estrutura não muda, então quem lê compara. Cada bloco segue a mesma célula de quatro partes: **número** (com fonte) · **variação** (vs. período anterior e vs. meta, quando houver) · **leitura** (o que o número sugere, marcada quando é hipótese) · **decisão** (o que fazer ou nada). O relatório de performance de canais de marketing é do Analista do pack marketing; este é o relatório **de métricas da organização**, que o alimenta.

## Contexto de uso

- Fechamento semanal ou mensal ({{operacao.ciclo_planejamento}} é o ciclo de planejamento) de funil, receita, base, uso.
- Reunião de resultado com liderança; número único que todas as áreas usam.
- Primeiro relatório de uma métrica nova (define a estrutura que se repete).

## Briefing mínimo

Periodicidade · período fechado · métricas (todas do dicionário) · metas do período, se houver, e fonte delas · audiência · decisões pendentes que o relatório deve informar.

## Processo

### Passo 1 — Coletar com antecedência e pela mesma régua

Toda métrica via `consultar-metrica`{{#if integracao:dados or integracao:analytics}} (base integrada){{else}} com o dado disponível, marcado `[INFORMADO PELO CLIENTE]`{{/if}} — mesma definição, mesmo período, mesmo fuso. Número de fontes diferentes para a mesma métrica → reconciliar antes, não na reunião.

### Passo 2 — Abrir com accountability

Bloco 0: decisões e ações do período anterior — executada · parcial · não executada — e o que se observou. Relatório que não fecha o ciclo anterior não é recorrente, é avulso.

### Passo 3 — Escrever a narrativa antes da tabela

Três respostas por escrito: o que aconteceu em uma frase · por quê (com evidência) · o que muda. Só depois montar os blocos.

### Passo 4 — Blocos na ordem fixa

| # | Bloco | Conteúdo |
|---|---|---|
| 0 | Accountability | ações do período anterior e resultado |
| 1 | Resumo executivo | 3–5 linhas em linguagem de negócio; o principal ponto de atenção |
| 2 | Resultado de negócio | a métrica que o negócio acompanha (receita, pedidos, contratos): número · variação · leitura · decisão |
| 3 | Funil | volume **e** taxa entre etapas; volume sem taxa esconde qualidade, taxa sem volume esconde escala |
| 4 | Por recorte | produto, origem, segmento — conforme a granularidade do dicionário |
| 5 | Causa e contexto | para cada desvio relevante: métrica · direção · magnitude · causa provável · evidência · `[HIPÓTESE]` quando for |
| 6 | Qualidade do dado | cobertura de rastreamento, exclusões aplicadas, mudanças de definição no período |
| 7 | Decisões e próximas ações | até 5: ação · dono · prazo · métrica que vai mostrar se funcionou |

Sazonalidade e mudanças datadas entram no bloco 5 antes de qualquer conclusão sobre "queda" ou "alta".

### Passo 5 — Variação com cuidado

Vs. período anterior **e** vs. mesmo período do ano anterior quando houver histórico; vs. meta quando a meta tem fonte. Variação percentual sobre base pequena é marcada. Sem histórico comparável, dizer "primeiro período".

### Passo 6 — Distribuir, apresentar, registrar

Enviar antes da reunião com uma linha de contexto e os pontos de decisão · na reunião, abrir pelo resumo e reservar o fim para decisão · registrar decisões com dono e prazo no destino{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} · mudança de definição vai para o dicionário.

## Regras

- Toda linha numérica leva `[CONECTOR: fonte · data]` ou `[INFORMADO PELO CLIENTE]`.
- Estrutura não muda de período para período; se precisar mudar, registrar e manter o bloco antigo por um ciclo.
- Leitura separada do número; causa separada de aprendizado; aprendizado separado de ação.
- Nenhuma meta inventada: sem meta com fonte, o bloco compara só com histórico.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) saem do relatório que circula.

## Checklist

- [ ] Métricas do dicionário, mesma régua, reconciliadas?
- [ ] Accountability aberta? Narrativa escrita antes da tabela?
- [ ] Blocos na ordem fixa com número · variação · leitura · decisão?
- [ ] Sazonalidade considerada? Variações sobre base pequena marcadas?
- [ ] Bloco de qualidade do dado preenchido? Ações com dono, prazo e métrica?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório (blocos 0–7) | documento, mesma estrutura a cada período |
| Tabela de métricas | métrica · número · variação · meta · fonte |
| Registro de decisões | tabela: decisão · dono · prazo · métrica de acompanhamento |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
