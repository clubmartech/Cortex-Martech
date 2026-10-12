---
tipo: doc
id: respostas-modelo
descricao: "Reúne, por canal ativo, saudação, encerramento e respostas-padrão para os casos recorrentes do atendimento — adaptadas antes do envio, nunca enviadas cruas."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual a resposta-modelo para esse caso", "modelo de resposta por canal", "resposta padrão de atraso", "resposta padrão de erro", "saudação e encerramento por canal", "modelo de resposta para reembolso"]
requires:
owner: {{papel "atendimento"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

# Respostas-modelo — {{organizacao.nome}}

> **Modelos são ponto de partida, não resposta.** Cada um é adaptado ao caso, ao cliente e ao canal por `resposta-ticket` antes de sair. Os textos abaixo nascem como **estrutura**; o papel `{{papel "atendimento"}}` substitui pelas versões validadas da organização, no tom de {{marca_mae.nome}} ({{join marca_mae.tom ", "}}), sem os termos proibidos ({{join marca_mae.termos_proibidos ", "}}). Comportamento do produto só do doc `contexto/produtos/<slug>/<slug>.md`.

**Marcadores nos modelos:** `[NOME]` primeiro nome · `[PRODUTO]` · `[ID]` número do ticket · `[PRAZO]` prazo real · `[LINK]` artigo da central de ajuda · `[PAPEL]` quem assume.

## Regras gerais de canal

| Canal | Formato | SLA de primeira resposta | Horário | Revisão prévia |
|---|---|---|---|---|
{{#each canais as c}}| `{{c.slug}}` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | {{c.revisao_anti_ia}} |
{{/each}}| ticket / chat | reconhecimento + resposta ou próximo passo + o que precisamos + fechamento | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | — |

## Bloco de mensageria

{{#if canal:whatsapp}}### `whatsapp`

Parágrafos de uma a duas linhas · uma pergunta por mensagem · sem bloco longo · só com consentimento · dentro do horário de atendimento.

- **Saudação:** "Oi, [NOME]! Aqui é [PAPEL] de {{marca_mae.nome}}. Recebi sua mensagem sobre [tema]."
- **Espera com prazo:** "Estou verificando [tema] com quem cuida disso. Volto até [PRAZO] com uma posição."
- **Instrução curta:** "Para [ação]: [passo 1] → [passo 2]. Se preferir, o passo a passo completo está aqui: [LINK]."
- **Encerramento:** "Resolvido? Se precisar de mais alguma coisa, é só chamar por aqui."

{{/if}}{{#if canal:sms}}### `sms`

Uma frase e um caminho. "[NOME], sobre [tema]: [resposta ou próximo passo]. Detalhes: [LINK]."

{{/if}}{{#if canal:whatsapp or canal:sms}}{{else}}Nenhum canal de mensageria ativo no config. Se um for ativado, acrescentar aqui saudação, espera, instrução e encerramento no formato curto.

{{/if}}## Bloco de e-mail

{{#if canal:email}}### `email`

Assunto com `[ID]` e tema · reconhecimento no primeiro parágrafo · passos numerados · fechamento com prazo e canal de retorno.

- **Primeira resposta:** "Olá, [NOME]. Recebemos seu contato sobre [tema] ([ID]). Entendo que [impacto para o cliente]. [Resposta ou: estamos verificando e retornamos até [PRAZO]]. Qualquer novidade, respondo por este e-mail."
- **Resolução com instrução:** "[Reconhecimento]. Para resolver: 1. [...] 2. [...] 3. [...]. O passo a passo com imagens está em [LINK]. Se não funcionar, me diga o que apareceu na tela."
- **Encerramento:** "Considero [ID] resolvido. Se o problema voltar, responda este e-mail e reabrimos com o histórico."

{{else}}Canal `email` não está ativo no config. Se for ativado, acrescentar primeira resposta, resolução com instrução e encerramento.

{{/if}}## Bloco de chat e comunidade

- **Chat (abertura):** "Oi, [NOME]. Sou [PAPEL]. Me conta o que aconteceu com [PRODUTO] que eu te ajudo por aqui."
- **Chat (transferência):** "Vou passar você para [PAPEL], que cuida de [tema]. Já repassei o que conversamos — não precisa repetir."
{{#if canal:comunidade}}- **`comunidade` (resposta pública):** curta, sem dado do cliente: "Obrigado por trazer isso, [NOME]. [Resposta geral ou: estamos olhando]. Te chamo no privado para os detalhes." Revisão prévia obrigatória.
{{/if}}{{#if canal:instagram}}- **`instagram` (público):** "Oi, [NOME]! Vamos resolver isso. Me chama no privado com [informação mínima] que eu te acompanho." Nunca discutir em público.
{{/if}}{{#if canal:linkedin}}- **`linkedin` (público):** tom institucional; convite ao privado.
{{/if}}
## Respostas por caso (adaptar sempre)

| Caso | Estrutura | Trava |
|---|---|---|
| **Dúvida de uso com artigo** | reconhecimento · resposta curta · link · "se não funcionar, me diga o que apareceu" | só comportamento confirmado no doc |
| **Dúvida sem artigo** | reconhecimento · instrução passo a passo · registrar para `artigo-central-ajuda` | idem |
| **Erro confirmado, sem solução** | reconhecimento · "registramos como [ID]" · o que fazemos · próxima atualização em [PRAZO] · contorno se houver | sem prazo de correção não garantido |
| **Erro não reproduzido** | reconhecimento · pedir: o que fez, o que esperava, o que apareceu, captura · prazo | sem "funciona para mim" |
| **Atraso nosso** | pedido de desculpas direto · situação atual · nova data · compensação só se autorizada | sem justificativa longa |
| **Reclamação / cliente irritado** | reconhecimento sem "mas" · o que vamos fazer e quando · quem assume | nunca argumentar; nunca culpar |
| **Pedido de funcionalidade** | agradecer · dizer com honestidade se existe, não existe ou está em avaliação · registrar na escuta | sem promessa de roadmap |
| **Reembolso, troca, desconto** | reconhecimento · "encaminhei para análise; retorno até [PRAZO]" · o que precisamos (dados do pedido) | decisão é de quem decide; sem antecipar |
| **Cancelamento** | reconhecimento · "quem cuida da sua conta fala com você até [PRAZO]" · nada de retenção na primeira resposta | handoff ao Gestor de Sucesso no mesmo dia |
| **Dado pessoal / segurança** | reconhecimento · "estamos tratando com prioridade" · papel responsável | nada além sem orientação de `governanca` |
| **Elogio** | agradecer com nome de quem ajudou · perguntar se aceita contar a experiência (opcional) | sem pressão |

## Incidente (versões por canal)

Página de status: estrutura completa de `comunicado-incidente`. Mensageria: "[PRODUTO]: [funcionalidade] instável desde [hora]. Estamos atuando. Próxima atualização às [hora]. Status: [LINK]." E-mail: só abertura, encerramento e pós-incidente. Contas em risco: contato individual do Gestor.

## Central de ajuda — fecho padrão

"Esperamos que este artigo tenha ajudado. Se ficou alguma dúvida, fale com a gente por [canal]." `[PENDENTE: validar texto]`

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "atendimento"}} |
