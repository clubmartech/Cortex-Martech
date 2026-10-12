---
tipo: doc
id: matriz-risco-churn
descricao: "Registra os sinais de risco de churn, os níveis, a ação e o dono por nível, os gatilhos que sobrepõem o score e a taxonomia de motivos de cancelamento do time."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quais sinais indicam risco de churn", "o que fazer com cliente em risco", "níveis de risco da carteira", "quem age quando o risco sobe", "motivos de cancelamento registrados", "ação por nível de risco"]
requires:
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

# Matriz de risco de churn — {{organizacao.nome}}

> **Convenção do time, não benchmark.** Sinais, pesos, faixas e prazos nascem `[PENDENTE: preencher]` e são definidos pelo papel `{{papel "cs"}}` com o histórico próprio: a cada ciclo, quem cancelou estava em que faixa um ciclo antes? Se o modelo não previu, muda-se o modelo. Alteração passa por `governanca.ratificador`.

**Quem usa:** `health-score` (dimensões, pesos, faixas, gatilhos) · `playbook-renovacao` (classe de renovação) · `resposta-ticket` e Atendente (reconhecer sinal em ticket) · `escuta-de-cliente` (risco em conta) · `reativacao-cliente` (motivo de inatividade).

## Sinais de risco por dimensão

| Dimensão | Sinal | Fonte | Tem dado? | Peso |
|---|---|---|---|---|
| Uso | queda de frequência · usuários ativos abaixo do contratado · módulo-chave sem uso | {{#if integracao:dados}}integração de dados{{else}}dado fornecido{{/if}} | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Resultado | marco do plano de sucesso atrasado · primeiro valor não confirmado | plano de sucesso | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Relacionamento | patrocinador saiu ou trocou · ausência nos ritos · sem resposta ao Gestor | registro | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Suporte | ticket reincidente · ticket grave aberto · tom hostil · ticket sem resposta no SLA | atendimento | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Satisfação | detrator · nota caindo · comentário negativo sobre valor | `pesquisa-satisfacao` | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Comercial | inadimplência · pedido de redução · pedido de cancelamento · vencimento próximo sem contato | {{#if integracao:crm}}integração de CRM{{else}}registro{{/if}} | `[PENDENTE: confirmar]` | `[PENDENTE]` |
| Externo | mudança no cliente (fusão, corte, troca de liderança) · concorrente ativo na conta | escuta, sinal público | `[PENDENTE: confirmar]` | `[PENDENTE]` |

## Gatilhos (sobrepõem o score)

| Gatilho | Nível imediato | Ação no mesmo dia | Dono |
|---|---|---|---|
| Pedido de cancelamento ou redução | risco | contato humano; conversa de causa; decisor envolvido | {{papel "cs"}} |
| Patrocinador saiu | risco | mapear novo patrocinador; reapresentar o plano de sucesso | {{papel "cs"}} |
| Inadimplência | risco | contato; entender causa; alinhar com quem cobra | {{papel "cs"}} |
| Incidente grave na conta | atenção | contato individual além do comunicado (`comunicado-incidente`) | {{papel "atendimento"}} → {{papel "cs"}} |
| Detrator em conta relevante | atenção | fechamento de loop em até `[PENDENTE: prazo]` | {{papel "cs"}} |
| `[PENDENTE: outros gatilhos]` | | | |

## Níveis e ação

| Nível | Critério (faixa do score ou gatilho) | Ação | Prazo | Dono | Registro |
|---|---|---|---|---|---|
| **Saudável** | `[PENDENTE: faixa]` | rito normal; avaliar expansão | ciclo | {{papel "cs"}} | leitura do score |
| **Atenção** | `[PENDENTE: faixa]` ou gatilho de atenção | contato em até `[PENDENTE]`; identificar causa; ação com data; nova leitura | `[PENDENTE]` | {{papel "cs"}} | causa + ação + data |
| **Risco** | `[PENDENTE: faixa]` ou gatilho de risco | contato humano no mesmo dia; decisor envolvido; plano de recuperação; renovação reclassificada | mesmo dia | {{papel "cs"}}{{#if pack:vendas}} (+ {{papel "executivo"}} se contrato){{/if}} | plano com dono e prazo |
| **Crítico** | risco + vencimento próximo ou pedido formal de saída | escalonamento à liderança; proposta de recuperação só após tratar causa; preparar transição digna | mesmo dia | liderança do time | decisão registrada |

Prazo e faixa são do time. Cliente em qualquer nível acima de saudável tem **dono nomeado** e **data da próxima leitura**.

## Causas e tratamento

| Causa provável | Como reconhecer | Tratamento | Quem mais entra |
|---|---|---|---|
| Valor não percebido | marcos não atingidos; "não vejo resultado" | reunião de resultados; replanejar marcos; reonboarding | — |
| Uso baixo | dimensão uso em queda | treinamento; usuário-chave; artigo | Atendente |
| Problema não resolvido | ticket reincidente ou grave | priorizar com quem cuida do produto; retorno ao cliente com data | produto |
| Mudança no cliente | patrocinador, fusão, corte | mapear novo decisor; reapresentar valor | — |
| Preço | "está caro" após valor entregue | voltar ao valor com dado; condição só autorizada | {{#if pack:vendas}}{{papel "executivo"}}{{else}}quem decide comercialmente{{/if}} |
| Expectativa errada na venda | promessa fora do doc do produto | honestidade; ajustar escopo; sinalizar à venda | {{#if pack:vendas}}{{papel "lider-vendas"}}{{else}}quem vende{{/if}} |
| Atendimento | tom hostil; SLA estourado | resposta com dono; revisão do fluxo | {{papel "atendimento"}} |

## Taxonomia de motivos de cancelamento

| Família | Motivos aceitos |
|---|---|
| Valor | não percebeu resultado · objetivo mudou |
| Uso | não adotou · perdeu usuário-chave |
| Produto | lacuna de funcionalidade · integração · instabilidade |
| Atendimento | demora · problema não resolvido |
| Comercial | preço · condição · orçamento cortado |
| Cliente | fechou · fusão · mudou de modelo · troca de liderança |
| Concorrência | migrou para alternativa |

"Sem retorno" não é motivo. Motivo com frase exata do cliente e data; alimenta `escuta-de-cliente`{{#if pack:vendas}} e, quando aponta expectativa errada, `analise-motivos-de-perda` do pack de vendas{{/if}}.

## Validação do modelo (por ciclo)

| Ciclo | Cancelamentos | Em que faixa estavam um ciclo antes | Modelo previu? | Ajuste feito |
|---|---|---|---|---|
| `[PENDENTE]` | | | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
