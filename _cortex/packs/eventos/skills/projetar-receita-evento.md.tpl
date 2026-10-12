---
tipo: skill
id: projetar-receita-evento
descricao: "Projeta a receita da edição em faixa — ingressos por lote, cortesias, patrocínio e cupons — com cenários, sensibilidade de volume e ponto de quebra da meta."
familia: PLANEJAR.receita-evento
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quanto a edição vai faturar", "projetar a receita de ingressos", "qual o ponto de quebra da meta de receita", "simular cenário de bilheteria", "quanto muda a receita se vender menos ingresso", "receita de patrocínio no modelo", "cenário otimista e pessimista do evento"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de projetar.**

# Projetar a receita do evento

Aplica um modelo registrado e devolve receita **em faixa**, com sensibilidade às variáveis que realmente a movem. Existe porque projeção refeita do zero a cada rodada, com parâmetros não registrados, produz versões do mesmo cenário que divergem sem ninguém saber por quê.

**Modelo:** receita = Σ janelas [ingressos pagos × ticket líquido da janela] + patrocínio fechado − custo de cupons e recompensas. Cortesias entram como **custo de oportunidade e de produção**, nunca como receita.

## Contexto de uso

- Dentro do desenho da edição (`planejar-edicao-evento` §7).
- Recalibração de meio de ciclo, depois de um checkpoint.
- Responder "e se vendermos menos?", "quanto o patrocínio cobre?", "a meta fecha com esse mix?".

**Não acionar para:** ler o realizado (`acompanhar-metas-evento`) · explicar por que a venda caiu (`analisar-ciclo-evento`) · definir cotas de patrocínio (`captar-patrocinio`).

## Briefing mínimo

| Entrada | Obrigatório | Fonte |
|---|---|---|
| Preço de tabela por janela e tipo | sim | Ficha §5 — `[INFORMADO PELO CLIENTE]`; sem preço, não há projeção |
| Curva de volume por janela | sim | `planejar-edicao-evento` §7 |
| Mix entre tipos de ingresso e entre cliente / mercado | sim | Histórico próprio ou premissa declarada |
| Descontos e cumulatividade | sim | Ficha §6 |
| Penetração esperada de cupom por janela | sim | `apurar-cupons-evento` ou premissa declarada |
| Patrocínio: cotas fechadas e em negociação | recomendado | `captar-patrocinio`, com probabilidade por estágio |
| Fator de calibração contra a edição anterior | opcional | Declarar que é ajuste contra um ano só |

> Parâmetro ausente: **parar e perguntar.** Não estimar, não herdar o do ano passado sem dizer, não inferir de outro evento. Divergência de qualquer parâmetro registrado é declarada no output.

## Processo

### 1. Ticket líquido por janela
Preço de tabela ponderado pelo mix de tipos × (1 − desconto efetivo esperado da janela), onde o desconto efetivo combina cliente, cupom e grupo pela matriz de cumulatividade. **Desconto efetivo, nunca desconto de cupom** — o de cupom ignora o desconto embutido em ingresso de cliente e subestima o real.

### 2. Receita de ingressos
Para cada janela: volume × ticket líquido. Somar. Aplicar o fator de calibração, se existir, declarando que um ponto de calibração não é validação.

### 3. Patrocínio
Cotas **fechadas** entram pelo valor contratado; cotas em negociação entram ponderadas pela probabilidade do estágio do pipeline, em linha separada. Nunca somar pipeline bruto à receita.

### 4. Custo de cupons e cortesias
Recompensa devida por ingresso vendido com cupom (incremental ou não) e custo variável de cada cortesia (credencial, alimentação, material). Não ratear custo fixo por pessoa: palco, local e speaker não variam com um participante a mais.

### 5. Sensibilizar — obrigatório
1. **Sensibilidade de volume:** receita em pelo menos quatro níveis de ingressos, incluindo o realizado da edição anterior.
2. **Ponto de quebra:** quantos ingressos, ao ticket projetado, entregam exatamente a meta institucional.
3. **Matriz volume × ticket:** quatro níveis de cada, mostrando em que diagonal a meta cai.
4. **Cenários nomeados** (pessimista · base · otimista) com a premissa que muda em cada um — nunca só "±X%".

### 6. Separar as duas metas na leitura
Dizer qual tem folga e qual não tem. Folga agregada esconde que o número que será cobrado não tem folga nenhuma.

### 7. Anexar as ressalvas do modelo
Calibração de um ano só · mixes como premissa de continuidade · elasticidade de preço assumida e não testada · no-show não medido · pipeline de patrocínio ponderado por estimativa.

## Regras

- Saída em **faixa**; ponto único só como centro da faixa, nunca sozinho.
- Nenhum número de preço, mix ou conversão inventado: `[NECESSITA FONTE]` trava o cenário.
- Benchmark externo só com `[BUSCADO: fonte + ano]`, como referência, nunca como parâmetro.
- Se virar arquivo, entra na ficha ou no acompanhamento da iniciativa — nunca arquivo próprio de "projeção", que dessincroniza no dia seguinte.

## Checklist

- [ ] Todos os parâmetros com fonte declarada? Nenhum improvisado?
- [ ] Ticket líquido com desconto efetivo?
- [ ] Patrocínio fechado separado do ponderado?
- [ ] Quatro níveis de volume, ponto de quebra e matriz volume × ticket?
- [ ] Leitura explícita das duas metas?
- [ ] Bloco de ressalvas e lista de divergências?

## Output esperado

1. **Receita projetada em faixa**, por componente (ingressos · patrocínio · custos de cupom e cortesia).
2. **Tabela de sensibilidade de volume** com o ponto de quebra destacado.
3. **Matriz volume × ticket.**
4. **Cenários nomeados** com a premissa de cada um.
5. **Leitura das duas metas** — qual tem margem.
6. **Ressalvas do modelo** e **divergências de parâmetro**.

Formato: tabelas no chat; registro no acompanhamento da iniciativa.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
