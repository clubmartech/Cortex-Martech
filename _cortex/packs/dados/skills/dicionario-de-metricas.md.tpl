---
tipo: skill
id: dicionario-de-metricas
descricao: "Define cada métrica uma única vez — fórmula, fonte, granularidade, dono e armadilhas — e grava no dicionário para que o mesmo nome dê o mesmo número."
familia: DOCUMENTAR.dicionario-metricas
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["define a métrica", "como calculamos essa métrica", "fórmula da métrica", "dono da métrica", "duas pessoas com números diferentes", "o que conta como", "padroniza a definição da métrica"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`) e as fichas de fonte antes de passar para cá. **Volte ao Analista de Dados antes de definir.**

# Dicionário de métricas — uma definição por métrica

Dois números diferentes para "a mesma métrica" quase nunca são erro de cálculo: são duas definições. Esta skill escreve a definição **uma vez**, com tudo que faz o número ser reproduzível, e grava em `times/{{time.slug}}/docs/dicionario-metricas.md`. Toda consulta parte de lá.

## Contexto de uso

- Métrica pedida que não está no dicionário.
- Conflito: áreas ou relatórios com números diferentes para o mesmo nome.
- Mudança de fonte, de etapa do funil ou de regra de exclusão.

## Briefing mínimo

Nome da métrica como as pessoas falam · pergunta de negócio que ela responde · quem usa e para decidir o quê · fonte candidata (ficha em `times/{{time.slug}}/docs/fonte-<slug>.md`) · definições concorrentes, se houver.

## Processo

### Passo 1 — Nomear e desambiguar

Nome oficial · apelidos que as pessoas usam · o que **não** é (a métrica vizinha com que se confunde). Se duas áreas usam o mesmo nome para coisas diferentes, nascem duas métricas com nomes diferentes — nunca uma definição "média".

### Passo 2 — Escrever a definição reproduzível

| Campo | Regra |
|---|---|
| **Definição** | uma frase, em linguagem de negócio |
| **Fórmula** | numerador e denominador explícitos; o que conta e o que não conta |
| **Unidade e contagem** | contagem distinta de quê (contato, negócio, pedido); valor em moeda ou percentual |
| **Data de negócio** | qual evento marca o período (abertura, conversão, fechamento) — nunca data de gravação; fuso |
| **Exclusões** | teste, duplicado, interno, cancelado — e onde a regra vive na fonte |
| **Granularidade** | por produto? por origem? por período mínimo? o que **não** dá para quebrar |
| **Fonte** | ficha da fonte e a consulta, visão ou função oficial, quando existe |
| **Dono** | papel que responde pela definição (slug de `papeis[]`) |
| **Armadilhas** | o que já deu errado: campo parecido, taxonomia dupla, chave que não liga |
| **Relações** | de qual etapa vem, para qual vai; métricas derivadas (taxas) |

### Passo 3 — Testar a definição

Calcular uma vez com a definição escrita (via `consultar-metrica`{{#if integracao:dados or integracao:analytics}}{{else}} ou com o export disponível{{/if}}) e comparar com o número que as pessoas usam. Diferença → explicar linha a linha (exclusão, data, granularidade). Só grava definição que **reproduz** ou que explica por que o número antigo estava diferente.

### Passo 4 — Resolver conflito, se houver

Reunir as definições concorrentes em uma tabela: quem usa · fórmula · fonte · número que dá. Escolher com o dono; as outras viram apelido ou métrica nova com outro nome. Registrar a decisão e a data.

### Passo 5 — Gravar e propagar

Inteiro no chat → aprovação do dono → linha no dicionário → avisar quem usa relatórios com a métrica (`relatorio-recorrente`) e, se o pack marketing estiver instalado, apontar de `benchmarks-canal`. Linha no `## Histórico`.

## Regras

- Uma métrica, uma definição, um dono. Sem dono, não entra.
- Nada de fórmula "aproximada": o que não dá para reproduzir na fonte vira `[PENDENTE DE CONFIRMAÇÃO]`.
- Métrica agregada (sem quebra por produto, por exemplo) leva o limite escrito; comparar com métrica por produto é erro documentado.
- Taxa só existe se numerador e denominador estão no dicionário.
- Alterar definição exige linha no histórico e recálculo do histórico comparável.

## Checklist

- [ ] Nome, apelidos e "o que não é"? Fórmula com numerador e denominador?
- [ ] Data de negócio e fuso? Exclusões com onde vivem?
- [ ] Granularidade e limites? Fonte com ficha? Dono por papel?
- [ ] Testada e reproduzida? Conflito resolvido e registrado?
- [ ] Gravada com aprovação e quem usa avisado?

## Output esperado

| Saída | Formato |
|---|---|
| Linha(s) no dicionário | tabela de `dicionario-metricas` |
| Nota de teste | número obtido · número anterior · explicação da diferença |
| Registro de conflito (quando houver) | tabela: definição · quem usava · decisão · data |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
