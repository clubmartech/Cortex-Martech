---
tipo: skill
id: playbook-expansao
descricao: "Identifica e conduz upsell e cross-sell na base: sinais por produto, aderência à dor do cliente, momento certo, abordagem consultiva e handoff comercial."
familia: PLANEJAR.expansao
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["upsell para o cliente", "cross-sell na base", "qual produto oferecer para o cliente", "expansão da conta cliente", "sinais de expansão", "oferta para quem já é cliente", "aumentar o contrato", "módulo adicional para o cliente"]
requires: gestor-sucesso · jornada-cliente
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a jornada e o plano de sucesso antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de propor expansão.**

# Playbook de expansão — upsell e cross-sell

Expansão é consequência de valor percebido: um cliente que atingiu os marcos do `plano-de-sucesso` e tem uma dor nova (ou maior) que outro produto ou módulo resolve. Dois tipos: **upsell** (mais do mesmo: usuários, módulos, capacidade) e **cross-sell** (outro produto do config). Cliente que não está saudável não recebe oferta — recebe atenção.

## Contexto de uso

- Cliente saudável com uso crescente ou limite contratado próximo.
- Dor nova declarada em rito, ticket ou pesquisa.
- Renovação segura em preparação (`playbook-renovacao`).
- Revisão da carteira em busca de oportunidades de expansão.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Cliente, produto(s) atuais, contrato e vencimento | sim |
| Health score e faixa | sim — faixa de risco ou atenção encerra o pedido |
| Plano de sucesso: marcos atingidos; dor nova declarada | sim |
| Produtos e módulos elegíveis (do config) | sim |
| Condições comerciais autorizadas | sim — do usuário, `[INFORMADO PELO CLIENTE]` |
| Decisor da expansão | sim |

## Processo

### 1. Mapa de expansão por produto

| Produto atual | Upsell possível (módulos, capacidade) | Cross-sell possível | Sinal que indica aderência |
|---|---|---|---|
{{#each produtos as p}}| **{{p.nome}}** (`{{p.slug}}`) | {{#if p.modulos}}módulos: {{join p.modulos ", "}} · `[PENDENTE: limites de capacidade]`{{else}}`[PENDENTE: preencher]`{{/if}} | `[PENDENTE: produtos complementares]` | dor: {{default p.dor_principal "[PENDENTE: preencher]"}} |
{{/each}}

Produtos do config que o cliente ainda não usa são candidatos a cross-sell **só** quando a dor principal deles aparece no plano de sucesso, na escuta ou nos tickets do cliente.

### 2. Sinais de expansão (do que existe)

| Sinal | Fonte | Indica |
|---|---|---|
| uso próximo do limite contratado (usuários, volume, módulos) | {{#if integracao:dados}}integração de dados{{else}}dado fornecido{{/if}} | upsell de capacidade |
| pedido de funcionalidade que existe em outro módulo ou produto | tickets, escuta | cross-sell ou módulo |
| dor nova declarada em rito ou pesquisa | `plano-de-sucesso`, `pesquisa-satisfacao` | aderência a produto complementar |
| nova área ou unidade do cliente adotando o produto | relacionamento | expansão por território interno |
| marco de valor atingido e reconhecido | plano de sucesso | momento certo |

Sinal sem fonte não entra. Sinal de risco ativo (matriz) anula qualquer sinal de expansão.

### 3. Qualificar a oportunidade

Perguntas: a dor nova está nas palavras do cliente? · o produto ou módulo resolve essa dor conforme o doc `contexto/produtos/<slug>/<slug>.md`? · quem decide essa compra é o mesmo decisor atual? · o momento é bom (saúde, renovação, orçamento declarado)? Qualquer "não" → nutrir e registrar, não propor.

### 4. Abordagem consultiva

Na reunião de resultados ou em contato próprio: retomar a dor nas palavras do cliente → mostrar, no contexto dele, como o módulo ou produto resolve (demonstração focada, não catálogo) → pedir permissão para levar uma proposta → combinar decisor e data. Nunca ofertar por e-mail genérico para a base inteira — isso é campanha{{#if pack:marketing}} (pack de marketing){{/if}}, não expansão de conta.

### 5. Proposta e handoff

{{#if pack:vendas}}Expansão com negociação comercial segue `proposta-comercial` do pack de vendas, conduzida pelo Executivo com o Gestor na sala; o Gestor leva o diagnóstico (plano de sucesso) e as expectativas.{{else}}Estrutura da proposta: o que combinamos → o que foi entregue → a dor nova → o que propomos e como resolve → condições `[INFORMADO PELO CLIENTE]` → próximos passos com data. Quem negocia é quem o config define para a função comercial.{{/if}} Após o sim: onboarding do incremento (`onboarding-cliente`) e plano de sucesso atualizado.

### 6. Registrar

Oportunidade, sinal de origem, decisão e resultado {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}{{#if integracao:crm}} e na integração de CRM definida em `cortex.config.yaml`{{/if}}. Expansão recusada leva motivo (taxonomia da matriz de risco ou{{#if pack:vendas}} de `analise-motivos-de-perda`{{else}} do time{{/if}}).

## Regras

- Cliente em atenção ou risco não recebe oferta.
- Oferta só com dor declarada e aderência confirmada no doc do produto.
- Preço e condição vêm do usuário; a skill não sugere valor.
- Expansão é conversa de conta, não disparo para a base.
- Nenhuma promessa fora do doc do produto.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Faixa de saúde permite oferta? Sem gatilho de risco?
- [ ] Sinal com fonte? Dor nas palavras do cliente?
- [ ] Aderência confirmada no doc do produto?
- [ ] Decisor e momento confirmados?
- [ ] Abordagem consultiva, com permissão para propor?
- [ ] Proposta com condições do usuário; handoff definido?
- [ ] Resultado e motivo registrados; onboarding do incremento previsto?

## Output esperado

```
EXPANSÃO — [cliente] — de [produto atual] para [módulo/produto] — tipo: upsell / cross-sell
Saúde: faixa [..] · gatilhos: nenhum
Sinal de origem: [..] (fonte, data)
Dor nas palavras do cliente: "[...]"
Aderência (doc do produto): [...]
Decisor: [...] · Momento: [...]

ABORDAGEM: [roteiro da conversa]
PRÓXIMOS PASSOS: [proposta — dono — data]
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
