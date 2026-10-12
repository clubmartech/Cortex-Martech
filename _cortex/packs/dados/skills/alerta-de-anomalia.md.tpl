---
tipo: skill
id: alerta-de-anomalia
descricao: "Define regras simples de queda e pico por métrica, classifica o tipo de desvio e lista o que verificar antes de concluir — rastreamento primeiro, causa depois."
familia: ANALISAR.anomalia
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["caiu de repente", "pico estranho na métrica", "regra de alerta de queda", "o número está fora do normal", "o que verificar quando cai", "alerta de anomalia", "detectar queda ou pico"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`), o dicionário e a ficha da fonte antes de passar para cá. **Volte ao Analista de Dados antes de alertar.**

# Alerta de anomalia — regras simples e o que verificar

Anomalia é desvio fora do que a métrica costuma fazer. A skill faz duas coisas: **(A) define regras** de queda e pico por métrica, simples o bastante para serem conferidas à mão; **(B) quando dispara**, classifica o tipo de desvio e percorre a lista de verificação **antes** de qualquer hipótese de causa. A maioria das "quedas" é rastreamento, definição ou sazonalidade — não negócio.

## Contexto de uso

- Métrica caiu ou subiu de forma inesperada; alguém quer saber "o que houve".
- Definir monitoramento recorrente das métricas do dicionário.
- Validar um número antes de publicá-lo no relatório.

## Briefing mínimo

Métrica (do dicionário) · período e comparação (semana vs. semana, mês vs. mês, vs. mesmo período anterior) · fonte com ficha · mudanças conhecidas no período (campanha, lançamento, feriado, alteração de rastreamento).

## Processo

### A. Regras

**Passo 1 — Escolher a comparação.** Período igual anterior (semana vs. semana anterior) e mesmo período de ciclos anteriores (para sazonalidade). Janela curta para operação; janela longa para tendência.

**Passo 2 — Definir o limiar por métrica.**

| Métrica | Comparação | Limiar de queda | Limiar de pico | Volume mínimo | Dono |
|---|---|---|---|---|---|
| `[PENDENTE: métrica]` | `[PENDENTE]` | `[PENDENTE: definido pelo time a partir do histórico]` | `[PENDENTE]` | `[PENDENTE]` | `[PENDENTE: papel]` |

Limiar vem do histórico próprio (faixa habitual de variação), nunca de número de mercado. Volume mínimo: abaixo dele, variação é ruído e não dispara.

**Passo 3 — Gravar** no dicionário (campo "armadilhas e alertas" da métrica) com aprovação.

### B. Quando dispara

**Passo 4 — Confirmar que é real (antes de qualquer causa).**

- [ ] Definição da métrica mudou no período? (dicionário, histórico)
- [ ] Rastreamento ou integração mudou? (parâmetros, formulário, campo, fluxo) — `qualidade-de-dados`
- [ ] A fonte atualizou? Há atraso de carga? (ficha da fonte)
- [ ] Exclusões oficiais foram aplicadas igual nos dois períodos?
- [ ] Fuso e data de negócio iguais nos dois períodos?
- [ ] Período comparável? (dias úteis, feriado, sazonalidade registrada)
- [ ] Volume acima do mínimo?

Qualquer "sim" nas quatro primeiras → o alerta é de dado, não de negócio. Entregar como tal.

**Passo 5 — Classificar o tipo de desvio.**

| Tipo | Sinal primário | Sinal secundário |
|---|---|---|
| Queda de volume | entrada menor na primeira etapa | investimento, alcance ou tráfego menores |
| Queda de qualidade | taxa de passagem entre etapas menor | motivos de perda concentrados em perfil fora do público |
| Piora de eficiência | custo por resultado maior sem queda de volume | custo unitário maior; taxa de ação menor |
| Desvio localizado | só um produto, canal, origem ou segmento | os demais estáveis |
| Desvio geral | tudo caiu junto | sazonalidade, feriado, incidente, mudança de fonte |

**Passo 6 — Descer o recorte.** Produto → origem → canal → campanha, até isolar onde o desvio começa. Via `consultar-metrica`, com `[CONECTOR: fonte · data]`.

**Passo 7 — Hipóteses com confiança.** Hipótese principal · alternativas · o que foi descartado e por quê · confiança (alta: evidência direta; média: correlação datada; baixa: sem evidência). Canal ou campanha de marketing → handoff ao Analista do pack marketing para o diagnóstico de causa.

**Passo 8 — Alerta curto.** Métrica · comparação · magnitude · tipo · verificações feitas · hipótese principal com confiança · próxima ação e dono. Uma tela.

## Regras

- Verificar dado antes de causa, sempre, na ordem do Passo 4.
- Limiar e volume mínimo vêm do histórico próprio; benchmark externo só com `[BUSCADO: fonte + ano]` e nunca como regra.
- Hipótese sem evidência é `[HIPÓTESE]`; alerta não afirma causa.
- Alerta sobre base pequena não dispara; é anotado.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem no alerta que circula.

## Checklist

- [ ] Regra com comparação, limiar, volume mínimo e dono, gravada no dicionário?
- [ ] Checklist de dado percorrido antes de qualquer causa?
- [ ] Tipo de desvio classificado? Recorte descido até isolar?
- [ ] Hipóteses com confiança e descartes explicados?
- [ ] Alerta em uma tela, com próxima ação e dono?

## Output esperado

| Saída | Formato |
|---|---|
| Tabela de regras | métrica · comparação · limiares · volume mínimo · dono |
| Alerta | texto curto na estrutura do Passo 8 |
| Nota de verificação | checklist do Passo 4 preenchido |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
