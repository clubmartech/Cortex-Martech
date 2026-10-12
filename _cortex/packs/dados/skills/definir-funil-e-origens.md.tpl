---
tipo: skill
id: definir-funil-e-origens
descricao: "Define as etapas do funil com critério de passagem e a taxonomia origem → canal → campanha com de-para, para que toda análise use a mesma régua."
familia: PLANEJAR.funil-e-origens
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["define as etapas do funil", "critério de passagem de etapa", "taxonomia de origem", "de-para de canal e origem", "o que é origem e o que é canal", "padronizar campanha e origem", "etapas do funil por produto"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`) e o dicionário antes de passar para cá. **Volte ao Analista de Dados antes de definir.**

# Definir funil e origens

Duas definições que toda análise pressupõe e quase ninguém escreve: **as etapas do funil** (o que precisa acontecer para um registro passar de uma para a outra, e quem é responsável) e **a taxonomia de origens** (de onde o registro veio: origem de negócio, canal de mídia, campanha). O resultado vai para `times/{{time.slug}}/docs/taxonomia-origens.md` e alimenta o dicionário.

## Contexto de uso

- Organização sem funil escrito, ou com áreas discordando sobre o que é "qualificado".
- Rastreamento inconsistente: a mesma campanha com três nomes; canal e origem usados como sinônimos.
- Antes de atribuição, cohort e relatório recorrente.

## Briefing mínimo

Produtos cobertos (slugs){{#if integracao:crm}} · etapas como estão no CRM{{/if}} · áreas envolvidas (marketing, vendas, atendimento) e seus papéis · canais ativos ({{#each canais as c}}`{{c.slug}}`{{#if @last}}{{else}}, {{/if}}{{/each}}) · como o rastreamento é feito hoje (parâmetros de URL, campo de origem, formulário).

## Processo

### A. Funil

**Passo 1 — Listar as etapas como o negócio fala.** Do primeiro contato ao resultado (venda, pedido, ativação). Nome oficial · apelidos · o que a etapa representa.

**Passo 2 — Escrever o critério de passagem.**

| Etapa | Entra quando (evento observável) | Campo ou evento na fonte | Sai quando | Responsável (papel) | Granularidade |
|---|---|---|---|---|---|

Critério é **evento observável** ("negócio aberto no CRM com campo X preenchido"), não julgamento ("lead bom"). Etapa sem evento na fonte → `[PENDENTE: instrumentar]`.

**Passo 3 — Declarar as exclusões.** O que sai da contagem em todas as etapas (teste, duplicado, interno, descarte administrativo) e **onde a regra vive**. Sem isso, ninguém reproduz o painel.

**Passo 4 — Granularidade por etapa.** Quais etapas separam por produto e quais são agregadas. Regra de comparação: nunca comparar etapa agregada com etapa por produto sem dizer.

### B. Origens

**Passo 5 — Três níveis, nunca misturados.**

| Nível | Pergunta que responde | Exemplos de valores | Quem define |
|---|---|---|---|
| **Origem de negócio** | qual área gerou | inbound · outbound · evento · indicação · venda ativa · parceiro · base de clientes | liderança das áreas |
| **Canal de mídia** | por qual meio chegou | os de `canais[]` + orgânico · direto · referência · desconhecido | dados + marketing |
| **Campanha** | qual ação específica | padrão de nome (Passo 6) | quem cria a campanha |

Origem é de responsabilidade; canal é de mídia; campanha é de ação. Um registro tem os três.

**Passo 6 — Padrão de nome de campanha e parâmetros.** Convenção única (produto · objetivo · canal · período · variação), separador fixo, minúsculas, sem acento. Parâmetros de URL mapeados para canal com regra escrita (fonte + meio → canal). Valores fora da regra caem em "desconhecido" **e aparecem no relatório** — nunca somem.

**Passo 7 — De-para.** Tabela: valor cru como aparece na fonte → origem · canal oficiais · desde quando. Grafias antigas não são apagadas: entram no de-para.

**Passo 8 — Precedência.** Quando um registro tem mais de uma origem possível (primeira conversão vs. mais recente; campo manual vs. parâmetro), qual vale — e isso é escrito uma vez.

### Passo 9 — Validar e gravar

Inteiro no chat → aprovação das áreas envolvidas → gravar em `taxonomia-origens` e as etapas no dicionário → linha no `## Histórico`.

## Regras

- Etapa sem critério observável não entra no funil.
- Taxonomia é escolha de negócio escrita, não o que a ferramenta trouxe por padrão.
- "Desconhecido" é categoria legítima e visível; esconder é pior que mostrar.
- Mudança de etapa ou de taxonomia tem data de vigência; histórico anterior é marcado, não reescrito.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não entram em exemplos.

## Checklist

- [ ] Etapas com evento observável, campo na fonte e responsável?
- [ ] Exclusões declaradas com onde vivem? Granularidade por etapa?
- [ ] Três níveis separados? Padrão de nome e regra de parâmetros?
- [ ] De-para com grafias antigas? Precedência escrita?
- [ ] Aprovado pelas áreas e gravado com vigência?

## Output esperado

| Saída | Formato |
|---|---|
| Definição do funil | tabela de etapas, exclusões e granularidade |
| Taxonomia de origens | três tabelas (origem · canal · campanha) + de-para + precedência |
| Pendências de instrumentação | lista: etapa ou campo · o que falta · dono |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
