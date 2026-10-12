---
tipo: skill
id: registro-de-publicacao
descricao: "Registra o que saiu por produto — data, canal, título, link e fonte — no índice de publicações, fechando a esteira e alimentando as provas de marketing."
familia: DOCUMENTAR.registro-publicacao
output: registro
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["registra a publicação no índice", "o que já publicamos sobre esse produto", "fecha o registro da entrega", "atualiza o índice de publicações", "link do que foi publicado", "o artigo foi ao ar, registra", "histórico de publicações do produto"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`) antes de passar para cá. **Volte ao Documentador de Produto antes de registrar.**

# Registro de publicação — o índice do que saiu

Toda peça de produto que vai ao ar (artigo, release notes, aviso, book, post derivado) vira **uma linha** em `times/{{time.slug}}/docs/indice-publicacoes.md`. O índice responde "o que já publicamos sobre X, quando e onde?" — e é de lá que o Product Marketer e o Redator tiram **provas** (tela publicada, artigo citável, data de disponibilização).

## Contexto de uso

- Fechamento de qualquer etapa da esteira que publicou algo.
- Antes de documentar: conferir se já existe publicação sobre a funcionalidade.
- Auditoria: entradas triadas sem publicação registrada.

## Briefing mínimo

Produto (slug) · funcionalidade ou tema · canal · título como publicado · link · data de publicação · fonte (ficha, release notes, entrada triada) · quem validou.

## Processo

### Passo 1 — Conferir antes de inserir

Buscar no índice por funcionalidade e por título. Publicação já registrada → atualizar a linha (nova versão, link corrigido), não duplicar.

### Passo 2 — Preencher a linha

| Campo | Regra |
|---|---|
| Data | AAAA-MM-DD da publicação, não da aprovação |
| Produto{{#if oferta:produto}} › módulo{{/if}} | slug de `produtos[]`{{#if oferta:produto}}; módulo de `produtos[].modulos` quando houver{{/if}} |
| Funcionalidade ou tema | nome oficial, o mesmo da ficha |
| Tipo | artigo · release notes · aviso · book · post · outro |
| Canal | slug de `canais[]` ou nome do canal de produto (central de ajuda, in-app, parceiros) |
| Título | como publicado |
| Link | URL pública ou caminho no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} |
| Fonte | ficha, release notes ou entrada de origem |
| Validado por | papel |
| Vale como prova? | sim · não · `[PENDENTE DE CONFIRMAÇÃO]` — para o Product Marketer |

Campo sem informação → `[PENDENTE: campo]`, nunca vazio silencioso.

### Passo 3 — Fechar o ciclo

- Entrada triada → marcar como publicada (comentário no card{{#if registro_primario.nome}} em {{registro_primario.nome}}{{/if}} ou no histórico da ficha).
- Ficha de funcionalidade → acrescentar o link na seção de telas ou no histórico.
- Publicação que vale como prova → avisar o Product Marketer para atualizar `ficha-produto-<slug>` e, se o pack marketing estiver instalado, o banco de criatividade do produto.
- Linha no `## Histórico` do índice.

### Passo 4 — Auditoria periódica (por ciclo: {{operacao.ciclo_planejamento}})

Cruzar entradas triadas como P1/P2 com o índice: triada sem publicação → pendência; publicada sem triagem → registrar a origem. Links quebrados → corrigir ou marcar.

## Regras

- Só entra o que **foi ao ar**. Rascunho, aprovado-mas-não-publicado e peça interna não entram.
- Uma linha por peça publicada; a mesma funcionalidade em três canais são três linhas.
- O índice é conhecimento, não entregável: fica na base (`governanca.md` §8).
- Dados sensíveis não entram em título nem em link.

## Checklist

- [ ] Conferido antes de inserir? Linha atualizada em vez de duplicada?
- [ ] Todos os campos preenchidos ou marcados?
- [ ] Entrada e ficha de origem fechadas? Prova sinalizada ao Product Marketer?
- [ ] Histórico do índice atualizado?

## Output esperado

| Saída | Formato |
|---|---|
| Linha(s) no índice | tabela de `indice-publicacoes` |
| Fechamento da esteira | comentário no card ou histórico da ficha |
| Relatório de auditoria (por ciclo) | tabela: entrada · status · pendência |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
