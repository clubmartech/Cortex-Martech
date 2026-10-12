---
tipo: doc
id: jornada-cliente
descricao: "Mapeia as etapas da jornada do cliente, da pré-venda à expansão, com dono por papel, critério de passagem, marcos e sinais de alerta."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quais são as etapas da jornada do cliente", "quem é dono de cada etapa da jornada", "onde o cliente está na jornada", "o que acontece depois da venda", "quando a conta passa de vendas para o sucesso do cliente", "marcos da jornada"]
requires:
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

# Jornada do cliente — {{organizacao.nome}}

> **Mapa único da relação com o cliente**, da pré-venda à expansão. Cada etapa tem um **dono por papel**, um **critério de passagem** (o que precisa ter acontecido para a próxima começar), **marcos** e **sinais de alerta**. Os campos `[PENDENTE: preencher]` são do papel `{{papel "cs"}}`, com os times envolvidos; alteração passa por `governanca.ratificador`.

**Quem usa:** `onboarding-cliente` e `plano-de-sucesso` (etapa e marcos) · `health-score` e `matriz-risco-churn` (sinais) · `pesquisa-satisfacao` (momentos de pesquisa) · `playbook-renovacao` e `playbook-expansao` (critérios){{#if pack:vendas}} · Executivo de Vendas (handoff){{/if}}. Modelo comercial: **{{organizacao.modelo_comercial}}**.

## Etapas

| # | Etapa | Começa quando | Dono | Objetivo do cliente | Critério de passagem | Marcos | Sinais de alerta |
|---|---|---|---|---|---|---|---|
| 0 | **Pré-venda** | contato comercial iniciado | {{#if pack:vendas}}{{papel "executivo"}} (pack de vendas){{else}}quem vende{{/if}} | entender se resolvemos a dor dele | contrato assinado **e** ficha de handoff entregue (dor, impacto esperado, decisores, promessas) | diagnóstico validado · proposta aceita | expectativa fora do doc do produto · decisor ausente |
| 1 | **Onboarding** | ficha de handoff recebida | {{papel "cs"}} | começar a usar e ver o primeiro valor | primeiro valor confirmado pelo cliente (`onboarding-cliente`) | kickoff · ativação · uso recorrente · primeiro valor | sem acesso ao fim da primeira janela · patrocinador ausente · expectativa diferente da venda |
| 2 | **Adoção** | onboarding encerrado | {{papel "cs"}} | usar no fluxo real, com o time dele | uso no ritmo combinado por `[PENDENTE: definir métrica]`; plano de sucesso validado | plano de sucesso v1 · usuários-chave ativos · módulos-chave em uso | uso caindo · ticket repetido no mesmo fluxo · usuário-chave saiu |
| 3 | **Valor** | plano de sucesso em execução | {{papel "cs"}} | atingir os objetivos que declarou | marcos do plano atingidos e reconhecidos em reunião de resultados | reunião de resultados · marcos com dado · NPS de relacionamento | marco atrasado sem causa · detrator · patrocinador trocou |
| 4 | **Renovação** | vencimento no horizonte da régua (`playbook-renovacao`) | {{papel "cs"}}{{#if pack:vendas}} (+ {{papel "executivo"}} se reestruturar){{/if}} | continuar porque vale | contrato renovado; plano do novo ciclo iniciado | classificação da renovação · proposta · assinatura | classe risco · pedido de redução · silêncio do decisor |
| 5 | **Expansão** | cliente saudável com dor nova (`playbook-expansao`) | {{papel "cs"}}{{#if pack:vendas}} (+ {{papel "executivo"}} na negociação){{/if}} | resolver mais com quem já confia | contrato ampliado; onboarding do incremento iniciado | sinal com fonte · aderência confirmada · proposta | oferta sem dor declarada · faixa de saúde abaixo de saudável |
| — | **Risco** (transversal) | qualquer gatilho da `matriz-risco-churn` | {{papel "cs"}} | ser ouvido e ver ação | risco tratado na causa; faixa recuperada | contato humano · ação com dono · nova leitura | risco sem dono · ação sem prazo |
| — | **Saída** | cancelamento confirmado | {{papel "cs"}} | sair com dignidade | transição concluída; motivo registrado; porta aberta | conversa de aprendizado · transição | motivo "sem retorno" · dados sem transição |
| — | **Reativação** | inativo além do intervalo (`reativacao-cliente`) | {{papel "cs"}} | voltar por um motivo | reativado → etapa 1 (curta) ou 2 | toque de valor · pergunta direta | pedido de saída · rejeição de canal |

Nomes e quantidade de etapas podem ser adaptados ao processo real — mas cada etapa precisa de dono, critério de passagem e sinais.

## Handoff vendas → sucesso do cliente

Campos obrigatórios da ficha: dor nas palavras do cliente · impacto esperado · decisores e patrocinador · produtos, módulos e escopo · promessas feitas (prazo, funcionalidade, resultado) · objeções que surgiram · contexto comercial (valor `[INFORMADO PELO CLIENTE]`, vencimento, modelo de renovação). Ficha incompleta: o Gestor pergunta antes do kickoff; promessa fora do doc do produto é sinalizada{{#if pack:vendas}} ao Executivo e ao Líder de Vendas{{/if}} no dia.

## Momentos de contato e de pesquisa

| Etapa | Contato previsto | Pesquisa |
|---|---|---|
| Onboarding | ponto semanal; kickoff; encerramento | CSAT do onboarding |
| Adoção | rito definido no plano de sucesso | — |
| Valor | reunião de resultados por ciclo ({{operacao.ciclo_planejamento}}) | NPS de relacionamento |
| Renovação | régua por antecedência | NPS antes da janela |
| Atendimento (qualquer etapa) | resposta no SLA do canal | CSAT por ticket (com limite por cliente) |

Canais de relacionamento ativos: {{#each canais as c}}`{{c.slug}}` {{/each}}— regras por canal em `respostas-modelo`.

## Por produto

| Produto | Primeiro valor típico | Métrica de adoção | Intervalo de inatividade | Observações |
|---|---|---|---|---|
{{#each produtos as p}}| {{p.nome}} (`{{p.slug}}`, {{p.tipo}}) | `[PENDENTE: preencher]` — promessa: {{p.promessa}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | {{#if p.modulos}}módulos: {{join p.modulos ", "}}{{/if}} |
{{/each}}

## Públicos na jornada

| Público | Tipo | Papel típico na conta | Dor registrada |
|---|---|---|---|
{{#each publicos as pu}}| {{pu.nome}} (`{{pu.slug}}`) | {{pu.tipo}} | `[PENDENTE: patrocinador · usuário-chave · decisor da renovação]` | {{pu.dor}} |
{{/each}}

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
