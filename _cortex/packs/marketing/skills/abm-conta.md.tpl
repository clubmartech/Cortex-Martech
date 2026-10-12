---
tipo: skill
id: abm-conta
descricao: "Monta o plano de conta-alvo: resumo estratégico, hipóteses de dor, aderência da solução, abordagem por stakeholder e plano de execução."
familia: PLANEJAR.abm
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["plano de ABM para essa conta", "como abordar a conta", "estratégia para a conta-alvo", "plano de ativação da conta", "mapa de stakeholders da conta", "expansão na conta", "preparar reunião com a conta"]
requires: estrategista
owner: {{papel "estrategista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Estrategista** (`estrategista`), que carrega o gate (`_cortex/kernel/gate.md`) e o brandcenter antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Estrategista antes de produzir.**

# Plano de conta-alvo (ABM)

Consolida contexto da conta, sinais estratégicos, stakeholders, hipóteses de dor e aderência da solução num plano de ação — para orientar marketing, prospecção, pré-vendas e sucesso do cliente de forma coordenada. É a **consolidadora**: não repete a coleta de sinais nem o mapeamento de pessoas; integra o que já existe e direciona.

Modelo comercial da organização: **{{organizacao.modelo_comercial}}**.

## Contexto de uso

- Plano de conta para contas prioritárias (tier 1 e 2).
- Preparação de reunião estratégica com stakeholders de alto nível.
- Alinhamento entre prospecção, marketing, pré-vendas e sucesso do cliente antes de abordar.
- Expansão em conta que já é cliente.

## Briefing mínimo

| Entrada | Obrigatório | Descrição |
|---|---|---|
| **Conta** (nome) | sim | Empresa ou grupo |
| **Objetivo** | sim | Abrir, expandir, reativar, preparar reunião |
| **Momento da conta** | sim | Fria · aquecida · oportunidade ativa · cliente · expansão · renovação · reativação |
| **Tier** | sim | Prioridade da conta |
| **Estrutura operacional** | sim | Centralizada ou distribuída; múltiplas unidades; maturidade estimada |
| Produto(s) de interesse | recomendado | Slug de `produtos[]` |
| Sinais públicos coletados | recomendado | Expansão, transformação, mudança organizacional, investimento |
| Stakeholders conhecidos | recomendado | Nome, cargo, papel no comitê de compra |
| Contexto comercial | sim | Histórico no CRM ou briefing manual |

Banco completo em `times/{{time.slug}}/docs/descoberta-bancos.md` (Conta-alvo). Sem conta, objetivo e tier, não produzir.

{{#if integracao:crm}}**Fonte do contexto comercial:** a integração de CRM definida em `cortex.config.yaml` — histórico de interações, estágio do negócio, contatos. Consulta read-only; dado ausente vira `[PENDENTE DE CONFIRMAÇÃO]`.{{else}}**Fonte do contexto comercial:** não há CRM integrado no config — o histórico vem do briefing e entra marcado `[INFORMADO PELO CLIENTE]`.{{/if}}

## Processo

### Bloco 1 — Resumo estratégico da conta

Quem é (tipo de operação, segmento, porte, região) · como opera (centralizada ou distribuída, unidades, volume) · momento (crescimento, reestruturação, estabilidade) · complexidade operacional estimada · contexto comercial (nova conta, cliente, estágio do negócio). **Foco em operação, execução e maturidade** — sem descrição institucional genérica ou excesso de histórico.

### Bloco 2 — Sinais estratégicos

Consolidar (não recoletar):

| Tipo de sinal | O que foi identificado | Implicação operacional |
|---|---|---|
| Expansão | [sinal] | [o que muda no processo] |
| Transformação digital | [sinal] | [onde há pressão] |
| Estrutura organizacional | [sinal] | [quem é afetado] |
| Investimento e estratégia | [sinal] | [onde há aderência] |

Interpretar: o que os sinais indicam operacionalmente, onde há mais pressão, quais áreas sentem mais impacto, onde a solução adere mais.

### Bloco 3 — Hipóteses de dor

| Hipótese | Área afetada | Evidência | Probabilidade |
|---|---|---|---|
| [hipótese] | [área] | [sinal ou dado] | alta / média / baixa |

Nem toda dor vira narrativa comercial: selecionar as 2–3 de maior probabilidade e aderência para a abordagem inicial. Cruzar com `publicos[].dor` e `publicos[].objecao` do config e com o doc do produto.

### Bloco 4 — Aderência da solução

| Produto / módulo | Aderência | Justificativa para esta conta |
|---|---|---|
| [de `produtos[]` e `modulos[]`] | alta / média / baixa | [por quê, no contexto dela] |

Traduzir em impacto operacional, na linguagem da dor do cliente — nunca em linguagem técnica de produto. Não fixar nome de produto na estratégia: usar o produto ativo do contexto.

### Bloco 5 — Abordagem por stakeholder

| Stakeholder | Papel | Dor a abordar | Canal inicial | Mensagem central | Próximo passo |
|---|---|---|---|---|---|
| [nome/cargo] | champion | | | | |
| [nome/cargo] | decisor econômico | | | | |
| [nome/cargo] | avaliador técnico | | | | |
| [nome/cargo] | bloqueador | | | | |

Sequência: ativar o champion (validar a hipótese de dor antes de escalar) → envolver o avaliador técnico se houver demonstração → escalar ao decisor só com o champion engajado → neutralizar bloqueadores via aliados, não confronto. Canais possíveis: {{#each canais as c}}`{{c.slug}}` {{/each}}e abordagem direta de vendas.

### Bloco 6 — Plano de execução

| # | Ação | Responsável | Canal | Prazo | Critério de sucesso |
|---|---|---|---|---|---|

### Bloco 7 — Potencial de expansão (contas cliente)

Produtos ou módulos adicionais com aderência · unidades que ainda não usam · novo centro de decisão a ativar · receita potencial estimada (só com base em dado; senão `[NECESSITA FONTE]`).

## Regras

- Consolidar e direcionar — não repetir análise já feita.
- Abordagem consultiva: **não mencionar o produto na primeira interação**.
- Plano revisado a cada interação relevante com a conta.
- Dados sensíveis da conta ({{join governanca.dados_proibidos_em_prompt ", "}}) não vão para prompt externo.
- Toda afirmação sobre a conta tem fonte (sinal público com link, CRM, briefing) ou marcador.

## Checklist

- [ ] Conta, objetivo, momento, tier e estrutura confirmados?
- [ ] Sinais consolidados com implicação, não só listados?
- [ ] 2–3 hipóteses priorizadas com evidência e probabilidade?
- [ ] Aderência em linguagem de dor do cliente? Produto do contexto, não fixado?
- [ ] Cada stakeholder com dor, canal, mensagem e próximo passo? Sequência champion → técnico → decisor respeitada?
- [ ] Plano de execução com responsável, prazo e critério? Nenhum dado sem fonte?

## Output esperado

| Saída | Formato |
|---|---|
| Resumo estratégico | 3–5 parágrafos |
| Hipóteses de dor | tabela classificada |
| Mapa de aderência | tabela |
| Abordagem por stakeholder | tabela |
| Plano de execução | tabela com dono, prazo e critério |
| Potencial de expansão | lista (contas cliente) |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou pasta da conta — nunca a documentação. Marcadores de incerteza em toda inferência.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "estrategista"}} |
