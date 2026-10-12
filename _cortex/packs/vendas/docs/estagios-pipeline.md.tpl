---
tipo: doc
id: estagios-pipeline
descricao: "Define os estágios do pipeline, o critério de saída de cada um, os campos obrigatórios no registro, o limite de dias parado e os limiares de forecast do time."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quais são os estágios do pipeline", "critério de saída do estágio", "campos obrigatórios no CRM por estágio", "quando o negócio avança de estágio", "definição de oportunidade", "o que é um negócio parado"]
requires:
owner: {{papel "lider-vendas"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

# Estágios do pipeline — {{organizacao.nome}}

> **Régua oficial do time de vendas.** Estágio é definido pelo **critério de saída** (o que precisa ter acontecido para avançar), não pela sensação de quem conduz. Os valores de limite, probabilidade e limiar nascem `[PENDENTE: preencher]` e são preenchidos pelo papel `{{papel "lider-vendas"}}` com histórico próprio; alteração passa por `governanca.ratificador`.

**Onde o estágio vive:** {{#if integracao:crm}}na integração de CRM definida em `cortex.config.yaml` — o nome do estágio aqui deve ser idêntico ao do CRM{{else}}{{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}} — sem CRM integrado, os campos abaixo são preenchidos manualmente no registro{{/if}}. **Quem usa:** `forecast-pipeline` (probabilidade, limite de dias, limiares) · `follow-up` (limite de dias) · `analise-motivos-de-perda` (motivo lido por estágio) · `passagem-marketing-vendas` (definição de MQL, SQL e oportunidade) · Executivo e Prospectador (critério de saída).

## Estágios

| # | Estágio | Entra quando | Critério de saída (para avançar) | Dono | Limite de dias parado | Probabilidade (histórico próprio) |
|---|---|---|---|---|---|---|
| 1 | Lead qualificado por marketing / origem (MQL) | cumpre perfil + sinal do `dicionario-qualificacao` | primeiro contato feito dentro do SLA | {{papel "sdr"}} | `[PENDENTE: preencher]` | — |
| 2 | Em cadência | primeiro contato feito | resposta obtida ou cadência encerrada | {{papel "sdr"}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| 3 | Qualificado por vendas (SQL) | ficha de `qualificacao-lead` com decisão "avançar" | reunião de diagnóstico realizada | {{papel "sdr"}} → {{papel "executivo"}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| 4 | Diagnóstico | reunião realizada | diagnóstico validado pelo cliente; decisor econômico e campeão mapeados | {{papel "executivo"}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| 5 | Proposta | proposta enviada ou apresentada | cliente deu retorno sobre a proposta | {{papel "executivo"}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| 6 | Negociação | retorno com pedido de ajuste ou condição | condições aceitas por quem assina | {{papel "executivo"}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| 7 | Fechamento | condições aceitas | contrato assinado e registrado | {{papel "executivo"}} | `[PENDENTE: preencher]` | — |
| — | Ganho | contrato assinado | handoff{{#if pack:cs}} ao Gestor de Sucesso (pack de CS){{else}} a quem cuida do cliente{{/if}} com diagnóstico e expectativas | {{papel "executivo"}} | — | — |
| — | Perdido | encerramento explícito ou limite ultrapassado sem retorno | motivo da taxonomia registrado (nunca "sem retorno") | quem conduzia | — | — |
| — | Nutrição | fit sem urgência | data de retorno definida | {{papel "sdr"}} | `[PENDENTE: preencher]` | — |

Adaptar nomes e quantidade de estágios ao processo real — mas cada estágio precisa de critério de saída, dono e limite.

## Campos obrigatórios por estágio

| Estágio | Campos obrigatórios no registro |
|---|---|
| 1 — MQL | origem · campanha ou lista · público provável · produto de interesse · consentimento por canal · data de entrada |
| 2 — Em cadência | cadência aplicada · data e canal de cada toque · resultado por toque |
| 3 — SQL | ficha de qualificação (perfil, fit, urgência, decisão) · data da reunião agendada |
| 4 — Diagnóstico | dor nas palavras do cliente · impacto declarado · critérios de decisão · decisores com papel e postura · prazo · orçamento declarado |
| 5 — Proposta | versão · validade · valor `[INFORMADO PELO CLIENTE]` · escopo · data da decisão combinada |
| 6 — Negociação | pedidos de ajuste · condições oferecidas (dentro do limite autorizado) · quem assina |
| 7 — Fechamento / Ganho | contrato · data · valor final · produto(s) · responsável pelo handoff |
| Perdido | motivo (taxonomia) · estágio em que perdeu · concorrente ou alternativa (se houver) · frase do cliente |

Negócio sem os campos do estágio **não avança** — o critério de saída inclui o registro.

## Motivos de perda (taxonomia)

Famílias e motivos aceitos, conforme `analise-motivos-de-perda` § Taxonomia. O time pode renomear, nunca aceitar motivo fora da lista.

| Família | Motivos aceitos |
|---|---|
| Contato | tentativas esgotadas · dado inválido · não pediu contato |
| Perfil | fora do perfil ideal · sem maturidade · porte inadequado |
| Necessidade | sem dor · já resolveu de outro jeito |
| Timing | sem gatilho agora · orçamento em outro ciclo · projeto adiado |
| Decisão | decisor não mapeado · comitê travou · campeão saiu |
| Valor / preço | caro para o valor percebido · sem verba |
| Concorrência | escolheu alternativa · ficou com o atual |
| Produto | funcionalidade ausente · integração inexistente · implantação pesada |
| Processo nosso | follow-up abandonado · proposta à pessoa errada · demonstração genérica |

## Limiares do time (convenção, não benchmark)

| Limiar | Valor | Definido em | Fonte |
|---|---|---|---|
| Janela de histórico para calibrar probabilidade | `[PENDENTE: preencher]` | | |
| Cobertura mínima de pipeline para a meta | `[PENDENTE: preencher]` | | |
| Faixas de gap (pequeno · médio · grande) | `[PENDENTE: preencher]` | | |
| Volume mínimo para taxa (abaixo é ruído) | `[PENDENTE: preencher]` | | |
| Negócio em risco = dias parados acima de | `[PENDENTE: preencher]` × limite do estágio | | |

## Produtos e ciclos

| Produto | Ciclo médio (histórico) | Observação |
|---|---|---|
{{#each produtos as p}}| {{p.nome}} (`{{p.slug}}`, {{p.tipo}}) | `[NECESSITA FONTE]` | |
{{/each}}

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "lider-vendas"}} |
