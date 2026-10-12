---
tipo: skill
id: follow-up
descricao: "Monta a régua de follow-up pós-reunião e pós-proposta: resumo validado, toques com valor, intervalo, canal e critério de encerramento — sem cobrança vazia."
familia: CRIAR.follow-up
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["follow-up depois da reunião", "régua de follow-up da proposta", "o cliente sumiu depois da proposta", "mensagem de retomada", "quantos follow-ups fazer", "e-mail de resumo da reunião", "cobrar resposta sem ser chato", "encerrar negociação parada"]
requires: executivo-vendas · estagios-pipeline
owner: {{papel "executivo"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Executivo de Vendas** (`executivo-vendas`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e o estágio do negócio antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Executivo antes de escrever.**

# Follow-up — régua pós-reunião e pós-proposta

Follow-up bom entrega algo: o resumo que o cliente não escreveu, a resposta à dúvida que ficou, a prova que faltava, a decisão que precisa de data. "Só passando para saber se viu" não é follow-up — é ruído. Duas réguas: **pós-reunião** (até a proposta) e **pós-proposta** (até a decisão ou o encerramento). O limite de dias parado por estágio vem de `times/{{time.slug}}/docs/estagios-pipeline.md`.

## Contexto de uso

- Depois de qualquer reunião com o cliente (resumo em até um dia útil).
- Depois do envio da proposta.
- Negócio em silêncio dentro ou além do limite do estágio.
- Encerramento de negociação parada, com porta aberta.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Estágio do negócio e data do último contato | sim |
| O que aconteceu na última interação (decisões, dúvidas, pendências) | sim |
| Próximo passo combinado (e com quem) | sim |
| Canais em que o cliente respondeu até aqui | sim |
| Objeção aberta (se houver) | não |
| Prova ou material novo disponível | não |

Sem o que aconteceu na última interação, não há o que resumir nem o que entregar — perguntar.

## Processo

### A. Pós-reunião

1. **Resumo em até um dia útil**, no canal da reunião ou e-mail: o que ouvimos (dor e impacto nas palavras dele) · o que ficou decidido · pendências de cada lado com data · próximo passo. Fechar pedindo correção: "ajusto o que estiver diferente do que você disse".
2. **Entrega intermediária** quando houver pendência nossa (prova, demonstração, resposta técnica): enviar o que foi prometido, na data, com uma pergunta.
3. **Confirmação do próximo passo** um dia antes (reunião, apresentação da proposta), com objetivo e participantes.

### B. Pós-proposta

| Toque | Quando | Canal | Conteúdo |
|---|---|---|---|
| 1 | no envio | o da apresentação | proposta + resumo da âncora de valor + data da decisão combinada |
| 2 | meio do prazo de validade | canal de maior resposta do cliente | pergunta específica sobre uma seção ("a etapa de implantação faz sentido para o time?") |
| 3 | próximo da validade | ligação | conversa sobre o que falta para decidir; incluir o decisor ausente |
| 4 | validade vencida | escrito | reabrir validade com nova data **ou** encerrar com porta aberta |

Intervalos exatos seguem o prazo de validade e o limite do estágio — não há número universal. Cada toque traz algo novo: resposta a objeção da matriz, prova autorizada, ajuste de escopo pedido, resumo para o decisor que não estava.

### C. Encerramento com porta aberta

Quando o negócio passa do limite do estágio sem resposta: mensagem curta, sem culpa, que **nomeia** o silêncio ("imagino que a prioridade mudou"), oferece saída limpa ("se não for o momento, tudo bem — me diga e paro por aqui") e deixa o caminho de volta. Registrar o motivo de perda da taxonomia (`analise-motivos-de-perda`), nunca "sem retorno" como motivo final.

### Mensagens-base (adaptar — nunca copiar)

```
RESUMO PÓS-REUNIÃO
[Nome], obrigado pela conversa de hoje.
O que entendi: [dor nas palavras dele] — e o impacto disso em [impacto declarado].
Ficou decidido: [...]. Pendências: nós → [o quê, até quando]; vocês → [o quê, até quando].
Próximo passo: [o quê, data, quem participa].
Se eu entendi algo diferente do que você disse, me corrige por aqui.
```

```
RETOMADA COM VALOR
[Nome], ao revisar a proposta lembrei de [dúvida/critério dele]. [Resposta curta ou prova com fonte].
Isso muda algo na leitura de vocês? Se ajudar, mostro em [duração] para [decisor].
```

```
ENCERRAMENTO
[Nome], não tive retorno desde [data] e imagino que a prioridade mudou — acontece.
Se não for o momento, pode me dizer que encerro por aqui sem problema.
Se voltar a fazer sentido, [caminho de volta].
```

{{#if canal:whatsapp}}Por `whatsapp`: só se o cliente já respondeu por lá; até quatro linhas; uma pergunta. {{/if}}{{#if canal:email}}Por `email`: assunto com o próximo passo, não "follow-up". {{/if}}

## Regras

- Todo toque entrega algo (resumo, resposta, prova, decisão com data). Sem conteúdo novo, não enviar.
- Resumo pós-reunião em até um dia útil, sempre pedindo correção.
- Nenhum número ou prova sem fonte; nenhuma promessa fora do doc do produto.
- Não criar urgência artificial; validade da proposta é a urgência real.
- Negócio além do limite do estágio é sinalizado ao Líder de Vendas, não escondido em "mais um follow-up".
- Tom de {{marca_mae.nome}}; termos proibidos ({{join marca_mae.termos_proibidos ", "}}) fora.

## Checklist

- [ ] Resumo enviado no prazo, nas palavras do cliente, pedindo correção?
- [ ] Cada toque com conteúdo novo e uma pergunta?
- [ ] Canal escolhido pelo histórico de resposta do cliente?
- [ ] Decisor ausente incluído em algum toque?
- [ ] Limite do estágio respeitado; encerramento com porta aberta e motivo registrado?
- [ ] Estágio e data do próximo passo atualizados no registro?

## Output esperado

```
RÉGUA DE FOLLOW-UP — [conta] — estágio [n] — último contato [data]
| Toque | Data | Canal | Conteúdo novo | Pergunta | Se não responder |
|---|---|---|---|---|---|

MENSAGENS: [uma por toque, prontas]
ENCERRAMENTO (se chegar lá): [mensagem] · motivo de perda provável: [taxonomia]
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO]
```

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}{{#if integracao:crm}} e tarefas na integração de CRM definida em `cortex.config.yaml`{{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "executivo"}} |
