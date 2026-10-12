---
tipo: skill
id: cadencia-prospeccao
descricao: "Monta a sequência multicanal de prospecção: passos, intervalos, canal de cada toque, mensagem-base e critério de encerramento — só com canais do config."
familia: CRIAR.cadencia
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["sequência de prospecção", "cadência de outbound", "quantos toques por lead", "régua de prospecção multicanal", "mensagens da cadência", "intervalo entre os contatos", "cadência para lead inbound", "quando encerrar a cadência"]
requires: prospectador · dicionario-qualificacao
owner: {{papel "sdr"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Prospectador** (`prospectador`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e o dicionário de qualificação antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Prospectador antes de montar a cadência.**

# Cadência de prospecção — sequência multicanal

Uma cadência é uma **sequência finita** de toques, com canal, intervalo, mensagem e objetivo definidos por passo, que termina em reunião agendada, lead nutrido ou encerramento explícito. O que a cadência não é: uma lista de lembretes para "tentar de novo".

Canais disponíveis nesta organização: {{#each canais as c}}`{{c.slug}}` {{/each}}+ ligação telefônica. Canal fora dessa lista **não entra** na cadência.

## Contexto de uso

- **Outbound** — lista fria classificada pelo dicionário de qualificação.
- **Inbound** — lead que pediu contato ou converteu em material; a cadência é mais curta e começa pelo canal em que ele chegou.
- **Reativação de lead** — quem esfriou dentro do ciclo comercial (não confundir com reativação de cliente, do pack de CS).
- **Revisão** de cadência existente com taxa de resposta baixa.

## Briefing mínimo

| Campo | Obrigatório | Nota |
|---|---|---|
| Tipo (outbound · inbound · reativação) | sim | define duração e primeiro canal |
| Público (`publicos[]`) | sim | dor e objeção vêm do config |
| Produto ou oferta | sim | ângulo único por cadência |
| Canais liberados para este lote | sim | subconjunto dos canais do config |
| Consentimento por canal de mensageria | sim | sem consentimento registrado, o canal sai |
| Volume e campos disponíveis na lista | sim | campo vazio não vira variável |
| Objetivo do passo final | sim | reunião · diagnóstico · demonstração · reativar |
| Sinal da conta (se houver) | não | de `sinais-de-compra` |

Sem público, produto e canais, não montar — perguntar.

## Processo

1. **Classificar a lista** com `dicionario-qualificacao`: só perfil ideal e fit parcial recebem cadência. Fora do perfil é registrado e sai.
2. **Definir o ângulo** em uma frase: "[dor do público] custa [impacto]; [oferta] resolve em [contexto]". Uma cadência, um ângulo.
3. **Desenhar a sequência** (tabela abaixo): número de toques, canal por toque, intervalo, objetivo do toque. Regras de desenho:
   - Alternar canais; nunca dois toques no mesmo dia no mesmo lead.
   - Cada toque traz **informação nova** (pergunta, dado com fonte, cenário da rotina, prova) — nunca "só passando para saber se viu".
   - O primeiro toque nunca apresenta o produto; apresenta a dor em forma de pergunta.
   - Ligação entra depois de ao menos um toque escrito, salvo lead inbound com telefone pedido.
   - Toque de encerramento é obrigatório: fecha a porta com respeito e deixa um caminho de volta.
4. **Escrever a mensagem-base** de cada toque com `script-abordagem` (por público e canal). Esta skill define a estrutura; o texto final vem de lá.
5. **Definir critérios de saída** por resultado: respondeu positivo → agendar; respondeu negativo → registrar motivo e encerrar; pediu depois → nutrir com data; silêncio ao fim → encerrar e marcar para reativação futura.
6. **Registrar** a cadência {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}{{#if integracao:crm}} e configurar as tarefas na integração de CRM definida em `cortex.config.yaml`, com o campo de resultado por toque{{/if}}.
7. **Medir** por toque: entregas, respostas, reuniões, recusas. Toque com resposta zero após volume mínimo é reescrito, não repetido.

### Estrutura de referência (adaptar à organização)

| Passo | Dia | Canal | Objetivo | Conteúdo |
|---|---|---|---|---|
| 1 | D+0 | canal escrito de maior prioridade no config | abrir com a dor | pergunta consultiva sobre a rotina do público |
| 2 | D+2 | mesmo canal (resposta no fio) | dar contexto | dado com fonte ou cenário da rotina |
| 3 | D+4 | ligação | conversa | abertura de `script-abordagem`; se não atender, mensagem curta de voz ou texto |
| 4 | D+7 | segundo canal escrito | prova | caso ou resultado com fonte válida; sem prova, outra dor |
| 5 | D+10 | ligação | conversa | segunda tentativa, novo horário |
| 6 | D+14 | canal do passo 1 | encerramento | fechar com respeito; caminho de volta |

Intervalos e número de toques são **ponto de partida** `[PENDENTE DE CONFIRMAÇÃO]`: calibrar com a taxa de resposta própria após o primeiro lote. Lead inbound: metade dos toques, começando pelo canal em que chegou, no mesmo dia. Reativação: três toques no máximo, com uma pergunta direta no segundo ("ainda faz sentido conversarmos?").

{{#if canal:whatsapp}}**Mensageria:** mensagem por `whatsapp` só com consentimento registrado para o canal; texto curto, uma pergunta, sem link no primeiro toque.{{/if}}{{#if canal:linkedin}} **Rede profissional:** pedido de conexão com nota curta e motivo genuíno; a mensagem de dor vem depois de aceita, nunca junto.{{/if}}{{#if canal:email}} **E-mail:** assunto como pergunta sobre o processo, sem nome do produto; corpo com até três parágrafos curtos.{{/if}}

## Regras

- Só canais do config, só com consentimento onde a lei ou a plataforma exigem.
- Sinal público da conta vira pergunta consultiva, nunca citação da fonte.
- Nenhum dado, caso ou número sem fonte válida (doc do produto, briefing). O resto é `[NECESSITA FONTE]`.
- Tom e termos proibidos de {{marca_mae.nome}} ({{join marca_mae.termos_proibidos ", "}}) valem em toda mensagem.
- Cadência termina. Lead que não respondeu a toda a sequência não recebe "mais uma".
- Lead que pediu para não ser contatado sai de todas as cadências imediatamente e fica registrado.

## Checklist

- [ ] Lista classificada? Fora do perfil removido?
- [ ] Um ângulo só? Primeiro toque sem produto?
- [ ] Canais alternados, todos do config, consentimento confirmado onde necessário?
- [ ] Cada toque com informação nova? Toque de encerramento presente?
- [ ] Critério de saída definido para cada resultado?
- [ ] Variáveis da mensagem existem na lista? Fallback definido?
- [ ] Nenhum número ou caso sem fonte? Termos proibidos ausentes?

## Output esperado

```
CADÊNCIA — [público] · [produto/oferta] · [tipo]
Ângulo: [uma frase]
Canais: [subconjunto do config]

| Passo | Dia | Canal | Objetivo | Mensagem-base (ref. script-abordagem) | Critério de saída |
|---|---|---|---|---|---|

Variáveis: campo → fonte → fallback
Métricas por toque: entregas · respostas · reuniões · recusas
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou a ferramenta de cadência da organização — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "sdr"}} |
