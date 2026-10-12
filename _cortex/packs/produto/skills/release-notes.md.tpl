---
tipo: skill
id: release-notes
descricao: "Transforma a lista de entregas do PM em release notes por público, mensal ou por versão, preservando item a item a estrutura e o significado da origem."
familia: CRIAR.release-notes
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o release notes", "notas da versão", "o que mudou nesta versão", "release notes para o cliente", "reescreve as entregas do mês", "changelog em linguagem de cliente", "novidades da versão"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha do produto antes de passar para cá. **Volte ao Documentador de Produto antes de escrever.**

# Release notes — mensal ou por versão

**Entrada:** a lista de entregas que o PM mantém (planilha, card, changelog técnico). **Saída:** o mesmo conteúdo, reescrito para cada público, sem mudar o que foi entregue. Release notes é conferido **item a item contra a origem** — por isso a estrutura é sagrada e o texto é o que muda.

## Contexto de uso

- Fechamento mensal ou de versão de um produto{{#if oferta:produto}} ou módulo{{/if}}.
- Insumo para book de roadmap, boletim, aviso in-app e post de comunidade.
- Relançamento: entregas que saíram sem comunicação.

## Briefing mínimo

Produto (slug) · período ou versão · **a lista de entregas do PM** (única fonte) · públicos de saída (cliente, parceiro, equipe interna) · onde será publicado (central de ajuda, e-mail, comunidade, in-app).

## Processo

### Passo 1 — Reescrever cada item, no lugar dele

- Remover repetição e palavras desnecessárias; frases curtas; voz ativa.
- Trocar nome técnico por **o que muda para quem usa**: começar pelo cenário, não pelo parâmetro.
- Manter a informação que ajuda o cliente a entender **o que mudou** e **o que precisa fazer** (pré-requisito, configuração), quando a origem traz.
- Evitar linguagem comercial: release notes informa, não vende.

### Passo 2 — Regra dura: o que não pode ser tocado

- Preservar o **significado** original · não alterar regra de negócio · não inventar informação.
- Manter a **sequência** dos itens · não agrupar por tema · não reorganizar · não criar seção nova · não fundir vários itens em um.
- Manter a formatação da origem (numeração, campos).

Essas travas existem porque a conferência é item a item. Item movido ou fundido quebra a conferência mesmo que o texto tenha ficado melhor.

### Passo 3 — Derivar por público

| Público | O que muda na versão |
|---|---|
| **Cliente** | Linguagem do uso; caminho de menu em itálico quando a origem traz; "Saiba mais" apontando para o artigo quando existir |
| **Parceiro** | Mesma lista; acrescenta o que o parceiro precisa configurar, suportar ou vender; sai antes do cliente quando há público parceiro{{#if publico:parceiro}} (há parceiro no config){{/if}} |
| **Equipe interna** (vendas, atendimento) | Mesma lista; acrescenta a objeção ou pergunta esperada e a resposta curta |

A derivação muda tom e acréscimo — nunca a lista.

### Passo 4 — Marcar o que não está claro

Item incompreensível na origem **não é reescrito por dedução**: fica com `[PENDENTE DE CONFIRMAÇÃO: <pergunta ao PM>]` e entra na lista de dúvidas. Release notes com funcionalidade descrita errada vira ticket.

### Passo 5 — Entregar, validar, publicar, registrar

Inteiro no chat → validação do papel `{{papel "pm"}}` → publicação pelo canal escolhido (texto para o Redator do pack marketing quando vira e-mail ou post) → linha em `times/{{time.slug}}/docs/indice-publicacoes.md` com data, canal e link.

## Regras

- A lista do PM é a única fonte. Nada entra que não esteja nela.
- Termos proibidos da marca não entram — `contexto/brandcenter/brandcenter.md`{{#each marcas as m}}{{#if m.termos_proibidos}}; `{{m.slug}}`: {{join m.termos_proibidos ", "}}{{/if}}{{/each}}.
- Nenhuma data de disponibilização futura; release notes fala do que **já está** disponível. O que vem por aí é `book-de-roadmap`.
- Funcionalidade em liberação gradual leva a frase "disponível para [critério]" só se a origem informar o critério.

## Checklist

- [ ] Mesma quantidade de itens, mesma ordem da origem?
- [ ] Cada item: o que mudou + o que o cliente precisa fazer (quando a origem traz)?
- [ ] Nenhum item deduzido? Dúvidas listadas com marcador?
- [ ] Versões por público diferem só em tom e acréscimo?
- [ ] Validação humana registrada? Índice de publicações atualizado?

## Output esperado

| Saída | Formato |
|---|---|
| Release notes por público | texto, na estrutura da origem; uma versão por público pedido |
| Lista de dúvidas ao PM | tabela: item · dúvida · status |
| Linha para `indice-publicacoes` | data · produto · canal · título · link |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
