---
tipo: skill
id: resposta-ticket
descricao: "Escreve a resposta ao cliente em ticket, chat ou mensagem: estrutura, tom da marca, formato do canal, critérios de escalonamento e uso das respostas-modelo."
familia: CRIAR.resposta-cliente
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["estrutura da resposta ao ticket", "tom da resposta ao cliente", "resposta para reclamação", "quando escalar o ticket", "resposta-modelo para esse caso", "cliente irritado no atendimento", "resposta no WhatsApp para o cliente", "primeira resposta do ticket"]
requires: atendente · respostas-modelo
owner: {{papel "atendimento"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Atendente** (`atendente`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter, o doc do produto e as respostas-modelo antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Atendente antes de responder.**

# Resposta ao cliente — ticket, chat e mensagem

Toda resposta tem quatro partes: **reconhecimento** (mostrar que entendeu o problema e o impacto) · **resposta ou próximo passo** (a solução, a instrução, ou o que vamos fazer e quando) · **o que precisamos do cliente** (se algo) · **fechamento** (canal de retorno, prazo). O tom é o de {{marca_mae.nome}} ({{join marca_mae.tom ", "}}), adaptado ao canal. As respostas-padrão vivem em `times/{{time.slug}}/docs/respostas-modelo.md`.

## Contexto de uso

- Primeira resposta a um ticket ou mensagem.
- Resposta de acompanhamento (ainda sem solução).
- Resposta a reclamação, cliente irritado, pedido comercial.
- Resposta pública (comunidade, rede social) — com revisão prévia.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Mensagem original do cliente | sim |
| Canal ({{#each canais as c}}`{{c.slug}}` {{/each}}ou ticket) | sim |
| Produto e o que o doc diz sobre o comportamento em questão | sim |
| Categoria (dúvida · erro · pedido de mudança · reclamação · comercial · incidente) | sim |
| Histórico recente e status do cliente (faixa de saúde, se houver) | não |
| SLA de resposta e política aplicável (reembolso, troca) | sim, quando o caso envolve |

Sem a mensagem original e o canal, não responder.

## Processo

1. **Ler duas vezes**: o que o cliente pediu e o que ele **sente** (urgência, frustração, dúvida). Responder aos dois.
2. **Verificar o fato** no doc do produto ou no material fornecido. Comportamento não confirmado → não afirmar; usar a resposta de espera com prazo.
3. **Decidir** entre resolver, instruir ou escalar (tabela abaixo).
4. **Escolher a resposta-modelo** do canal e do caso, se existir, e **adaptar** — nunca enviar modelo cru.
5. **Escrever** nas quatro partes, no formato do canal.
6. **Revisar** com o checklist; resposta pública passa pelo revisor definido no config.
7. **Registrar** categoria, produto, resolução e se virou artigo ou escalonamento.

### Escalonamento — quando e como

| Situação | Para quem | O que dizer ao cliente |
|---|---|---|
| erro confirmado sem solução conhecida | quem cuida do produto | "registramos como [id]; volto até [prazo] com posição" |
| pedido de cancelamento, reclamação de valor, ameaça de sair | Gestor de Sucesso | "vou envolver quem cuida da sua conta; [nome do papel] fala com você até [prazo]" |
| reembolso, desconto, exceção | quem decide comercialmente | "encaminhei para análise; retorno até [prazo]" — sem antecipar decisão |
| incidente que afeta mais de um cliente | `comunicado-incidente` | status oficial, não resposta individual improvisada |
| segurança, dado pessoal, risco legal | papel definido em `governanca` | reconhecimento + "estamos tratando com prioridade"; nada mais sem orientação |
| cliente agressivo | líder do atendimento | manter o tom; não responder à agressão; registrar |

Escalar **nunca** é "passar o problema": o cliente sabe quem assume e quando volta, e o ticket continua com dono.

### Formato por canal

{{#if canal:whatsapp}}- `whatsapp`: parágrafos de uma a duas linhas; sem blocos longos; uma pergunta por mensagem; horário de atendimento respeitado.
{{/if}}{{#if canal:sms}}- `sms`: uma frase e um caminho (link de ajuda ou canal de retorno).
{{/if}}{{#if canal:email}}- `email`: assunto com o número do ticket e o tema; reconhecimento no primeiro parágrafo; passos numerados; fechamento com prazo.
{{/if}}{{#if canal:comunidade}}- `comunidade`: resposta pública curta, sem dado do cliente; detalhes por canal privado; revisão prévia.
{{/if}}{{#if canal:instagram}}- `instagram`: resposta pública mínima e convite ao privado; nunca discutir em público.
{{/if}}{{#if canal:linkedin}}- `linkedin`: tom institucional; convite ao privado.
{{/if}}- Chat e ticket: resposta em até dois blocos; instrução em passos; capturas quando ajudam.

### Cliente irritado

Reconhecer primeiro, sem "mas": "você tem razão em estar frustrado; [impacto] não deveria ter acontecido". Depois o que vamos fazer e quando. Sem justificativa longa, sem culpa (nem do cliente, nem de "sistema"), sem promessa que não é nossa. Se o problema foi nosso, dizer que foi.

## Regras

- Nunca afirmar comportamento do produto fora do doc ou do material fornecido.
- Nunca prometer prazo de correção, funcionalidade ou compensação sem autorização.
- Reconhecimento antes de solução; nunca argumentar com cliente irritado.
- Modelo sempre adaptado; dado sensível do cliente não repetido na resposta.
- Termos proibidos da marca ({{join marca_mae.termos_proibidos ", "}}) fora; sem jargão interno.
- Resposta pública só com revisão prévia.

## Checklist

- [ ] Respondi ao pedido e ao sentimento?
- [ ] Fato verificado no doc? O não confirmado virou espera com prazo?
- [ ] Quatro partes presentes? Formato do canal?
- [ ] Escalonamento com dono e prazo ditos ao cliente?
- [ ] Nenhuma promessa fora da alçada? Nenhum dado sensível?
- [ ] Tom da marca; modelo adaptado?
- [ ] Registro feito; recorrência anotada para a escuta?

## Output esperado

```
RESPOSTA — ticket [id] — canal [..] — categoria [..] — produto [..]
Decisão: resolver / instruir / escalar para [quem] até [prazo]

[texto da resposta, no formato do canal]

Pendências internas: [...]
Virou: artigo? escalonamento? sinal de risco para o Gestor?
Marcadores: [VALIDADO] · [PENDENTE DE CONFIRMAÇÃO]
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "atendimento"}} |
