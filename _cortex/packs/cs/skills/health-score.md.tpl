---
tipo: skill
id: health-score
descricao: "Define e calcula o health score da carteira com as dimensões que têm dado: sinais, pesos, faixas e ação por faixa — e lista quem está em risco e por quê."
familia: ANALISAR.saude-carteira
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["score de saúde do cliente", "dimensões do health score", "pesos do health score", "quais clientes estão em risco", "sinal de churn", "carteira por faixa de saúde", "cliente verde amarelo vermelho", "calcular a saúde da conta"]
requires: gestor-sucesso · matriz-risco-churn
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a matriz de risco e o dado disponível antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de calcular.**

# Health score — dimensões, pesos, sinais e faixas

O health score é uma **convenção do time** para ordenar a atenção: combina dimensões com dado real (uso, resultado, relacionamento, suporte, comercial) em uma leitura por cliente. Regra de ouro: **dimensão sem dado não entra**. Score bonito com dado inventado é pior do que nenhum score. O que fazer por faixa está em `times/{{time.slug}}/docs/matriz-risco-churn.md`.

## Contexto de uso

- Definir o modelo de score pela primeira vez (ou revisar pesos).
- Leitura periódica da carteira (semanal ou no ciclo {{operacao.ciclo_planejamento}}).
- Priorizar ação de renovação, expansão ou reativação.
- Investigar um cliente específico.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Recorte (carteira inteira, produto, segmento, cliente) | sim |
| Dado disponível por dimensão, com fonte e data | sim |
| Modelo vigente (dimensões, pesos, faixas) ou "ainda não existe" | sim |
| Vencimentos de contrato no período | não |

**Fonte:** {{#if integracao:dados}}integração de dados definida em `cortex.config.yaml` para uso e atividade{{else}}sem integração de dados no config — uso vem do que o usuário fornece, `[INFORMADO PELO CLIENTE]`{{/if}}{{#if integracao:crm}}; integração de CRM para contrato, valor e contatos{{/if}}{{#if integracao:automacao-mkt}}; integração de automação de marketing para engajamento com comunicação{{/if}}. Dimensão sem fonte: fora do modelo até ter dado.

## Processo

### 1. Dimensões e sinais (só as que têm dado)

| Dimensão | Sinais possíveis | Tem dado? | Fonte |
|---|---|---|---|
| **Uso** | frequência de acesso · usuários ativos ÷ contratados · uso dos módulos-chave · tendência | `[PENDENTE: confirmar]` | |
| **Resultado** | marcos do `plano-de-sucesso` atingidos · primeiro valor confirmado | `[PENDENTE: confirmar]` | |
| **Relacionamento** | patrocinador ativo · participação nos ritos · resposta a contatos · tempo desde o último contato | `[PENDENTE: confirmar]` | |
| **Suporte** | tickets abertos · reincidência · tempo de resolução · gravidade · tom das mensagens | `[PENDENTE: confirmar]` | |
| **Satisfação** | NPS/CSAT individual · comentário · tendência (`pesquisa-satisfacao`) | `[PENDENTE: confirmar]` | |
| **Comercial** | inadimplência · pedido de cancelamento · redução de escopo · tempo até o vencimento | `[PENDENTE: confirmar]` | |

Produtos no config ({{#each produtos as p}}`{{p.slug}}` {{/each}}): sinal de uso é definido por produto — o módulo-chave de um não é o do outro.

### 2. Pesos e faixas (convenção do time)

Pesos somam cem por cento entre as dimensões com dado; dimensão sem dado é redistribuída, não zerada em silêncio. Faixas (por exemplo saudável · atenção · risco) com cortes definidos pelo time e registrados na matriz de risco. Regra de **gatilho**: alguns sinais sobrepõem o score — pedido de cancelamento, patrocinador saiu, inadimplência — e colocam o cliente na faixa de risco independentemente da soma.

### 3. Calcular e ler

| Cliente | Produto | Uso | Resultado | Relacionamento | Suporte | Satisfação | Comercial | Score | Faixa | Gatilho | Tendência | Vencimento |
|---|---|---|---|---|---|---|---|---|---|---|---|---|

Ler a **tendência** (subiu, caiu, estável) junto da faixa: cliente em "atenção" caindo pede mais do que cliente em "risco" subindo.

### 4. Ação por faixa

Da matriz de risco: dono, prazo, ação. Cliente em risco com vencimento próximo vai para `playbook-renovacao` hoje; cliente saudável com uso crescente é candidato a `playbook-expansao`; cliente sem uso vai para `reativacao-cliente`.

### 5. Validar o modelo

A cada ciclo: clientes que cancelaram estavam em que faixa um ciclo antes? Se a maioria estava "saudável", o modelo não prevê — revisar dimensões e pesos, com aprovação humana, e registrar na matriz.

## Regras

- Dimensão sem dado não entra; o relatório diz quais ficaram de fora.
- Pesos e faixas são convenção registrada, não benchmark; alteração passa por aprovação.
- Gatilhos sobrepõem o score.
- Tendência sempre junto da faixa.
- Contas anonimizadas em prompt externo; dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem.
- Score nunca substitui conversa: cliente em risco recebe contato humano.

## Checklist

- [ ] Dimensões usadas são só as com dado e fonte declarada?
- [ ] Pesos, faixas e gatilhos registrados na matriz de risco?
- [ ] Tabela com faixa, gatilho, tendência e vencimento?
- [ ] Clientes em risco com dono, ação e prazo?
- [ ] Dimensões ausentes listadas no relatório?
- [ ] Validação do modelo prevista para o próximo ciclo?

## Output esperado

| Saída | Formato |
|---|---|
| Modelo de score (quando definido ou revisado) | tabela de dimensões, pesos, faixas, gatilhos — para a matriz de risco |
| Leitura da carteira | tabela por cliente + distribuição por faixa + tendência |
| Lista de ação | clientes por faixa com dono, ação e prazo |
| Lacunas de dado | dimensões sem fonte e o que seria preciso |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}; modelo ratificado vai para `matriz-risco-churn` com aprovação humana.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
