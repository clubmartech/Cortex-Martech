---
tipo: skill
id: triagem-entrada-produto
descricao: "Classifica o que o PM entregou — prioridade por critério, o que vira ficha, release, aviso, lançamento ou nada — antes de qualquer produção."
familia: OPERAR.triagem-produto
output: registro
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["faz a triagem dessa entrada", "chegou material de produto", "qual a prioridade dessa entrega", "isso vira doc ou aviso", "o que fazer com o que o PM mandou", "classifica a entrada de produto", "essa entrega precisa de comunicação"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`) antes de passar para cá. A triagem lê o material do PM **depois** desta skill, nunca antes. **Volte ao Documentador de Produto.**

# Triagem da entrada de produto

Toda entrega do PM passa por aqui antes de virar qualquer coisa. A triagem responde: **qual a prioridade** (por critério, não por urgência) · **o que a entrada vira** (ficha, release notes, aviso, lançamento, nada) · **quem comunica** · **o que falta** no material. O resultado é um registro, não uma peça.

## Contexto de uso

- Material novo do PM: formulário, card, anexo, mensagem{{#if registro_primario.nome}} — a entrada chega pelo registro ({{registro_primario.nome}}){{/if}}.
- Reclassificação: entrega que já saiu sem comunicação (recuperação).
- Dúvida sobre se algo merece comunicação.

## Briefing mínimo

O material do PM (link ou anexo) · produto (slug){{#if oferta:produto}} e módulo, se houver{{/if}} · quem enviou (papel) · estágio de liberação · data prevista, se o PM tiver (`[PENDENTE DE CONFIRMAÇÃO]` se não).

## Processo

### Passo 1 — Ordem de leitura

Esta skill → `LIDOS:` declarado → a ficha do produto (`times/{{time.slug}}/docs/ficha-produto-<slug>.md`) → **só então** o material. Lendo o material primeiro, a classificação encaixa a regra no que já foi lido.

### Passo 2 — Pontuar o impacto (cinco perguntas, 0 a 3 cada)

| Pergunta | Expectativa de negócio | 0 = não · 1 = talvez · 2 = provavelmente · 3 = sim |
|---|---|---|
| Atrai novos clientes? | crescimento | |
| Aumenta receita dos clientes atuais? | expansão | |
| Evita cancelamento? | retenção | |
| Aumenta uso ou engajamento? | adoção | |
| É diferencial frente à alternativa? | marca | |

A pontuação vem do que o material **diz**, não do que a pessoa supõe. Pergunta sem base no material → 0 e uma dúvida ao PM.

### Passo 3 — Aplicar as faixas

| Soma | Prioridade | O que vira | Quem comunica |
|---|---|---|---|
| 11–15 | **P1** | lançamento (`plano-de-lancamento`) + ficha + release + aviso | Product Marketer e Documentador de Produto |
| 8–10 | **P2** | ficha + release + aviso à base | Documentador de Produto |
| 1–7 | **P3** | ficha e release notes; sem peça de canal | Produto, com a ficha desta esteira |
| **0** | nenhuma | volta ao PM com as dúvidas | — |

Recuperação (já foi ao ar sem comunicação) **não é um P**: entra como P2 com a etiqueta "recuperação" e prazo curto.

### Passo 4 — Rodar as checagens da fila

- [ ] As cinco perguntas têm base no material?
- [ ] Produto{{#if oferta:produto}} e módulo{{/if}} identificados e coerentes com o material?
- [ ] Já existe entrada aberta para a mesma funcionalidade (mesmo nome, mesmo módulo, outro PM)?
- [ ] Impacta a operação do cliente? Se sim, precisa de aviso — sem ele a entrada não fecha.
- [ ] Prioridade coerente com os canais pedidos? P1 com um canal só ou P3 com oito canais é sinal de preenchimento sem critério: perguntar, não corrigir sozinho.
- [ ] Data: não cobrar nem inferir. Sem data, o plano usa semanas relativas.

### Passo 5 — Avisar o responsável e registrar

Comentário de três linhas no card ou na mensagem de retorno: **o P e a soma** · **o que isso significa** (quem comunica, o que vira) · **o que ficou pendente**. Vale para P1, P2 e P3 — P3 sem aviso vira entrega que todos supõem comunicada e não está. {{#if registro_primario.nome}}Com registro integrado, o comentário vai no card; o campo de responsável do card não é alterado.{{else}}Sem registro integrado, o comentário vai na resposta a quem enviou e fica no `## Histórico` da ficha.{{/if}}

### Passo 6 — Entrada que não vira comunicação

Registrar o motivo em uma linha (correção interna, não afeta cliente, duplicada) e fechar. Entrada fechada sem motivo é entrada perdida.

## Regras

- Prioridade sai da soma, nunca da urgência de quem pede. Discordância vai para o papel `{{papel "pm"}}`, não para a triagem.
- A triagem não produz peça; produz classificação e pendências.
- Material sem produto identificável volta ao PM.

## Checklist

- [ ] Skill lida antes do material? Soma com base no material?
- [ ] Faixa aplicada; recuperação etiquetada?
- [ ] Checagens da fila rodadas? Duplicidade conferida?
- [ ] Responsável avisado em três linhas? Motivo registrado quando não vira comunicação?

## Output esperado

| Saída | Formato |
|---|---|
| Registro da triagem | tabela: produto · funcionalidade · soma · P · o que vira · quem · pendências |
| Comentário ao responsável | três linhas |
| Próxima skill a abrir | `documentar-funcionalidade`, `plano-de-lancamento`, `aviso-de-produto` ou nada |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
