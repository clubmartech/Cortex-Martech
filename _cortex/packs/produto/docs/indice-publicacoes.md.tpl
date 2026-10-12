---
tipo: doc
id: indice-publicacoes
descricao: "Lista, por produto, tudo o que foi publicado — data, canal, título, link, fonte e se vale como prova — e é o fechamento da esteira de documentação."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["índice de publicações", "o que já saiu sobre o produto", "link do artigo que publicamos", "quando publicamos o aviso", "publicações que valem como prova", "histórico do que foi ao ar"]
requires:
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

# Índice de publicações — {{organizacao.nome}}

> **Só entra o que foi ao ar.** Rascunho, peça aprovada mas não publicada e material interno não entram. Uma linha por peça publicada: a mesma funcionalidade em três canais são três linhas. Preenchido por `registro-de-publicacao`, pelo papel `{{papel "pm"}}`. É daqui que o Product Marketer tira provas (coluna "Vale como prova?") e que a triagem confere se já existe publicação antes de documentar de novo.

**Como usar:** buscar pelo nome da funcionalidade ou pelo título antes de documentar; atualizar a linha quando a peça ganhar versão nova; auditar por ciclo ({{operacao.ciclo_planejamento}}) cruzando com as entradas triadas. Link quebrado é corrigido ou marcado, nunca apagado.

## Produtos cobertos

{{#each produtos as p}}- **{{p.nome}}** (`{{p.slug}}`{{#if p.modulos}}; módulos: {{join p.modulos ", "}}{{/if}})
{{/each}}
## Publicações

| Data | Produto{{#if oferta:produto}} › módulo{{/if}} | Funcionalidade ou tema | Tipo | Canal | Título | Link | Fonte | Validado por | Vale como prova? |
|---|---|---|---|---|---|---|---|---|---|
| `[PENDENTE: AAAA-MM-DD]` | `[PENDENTE: slug]` | `[PENDENTE: nome oficial]` | artigo · release notes · aviso · book · post | `[PENDENTE: canal]` | | | | | `[PENDENTE DE CONFIRMAÇÃO]` |

Tipos: **artigo** (central de ajuda) · **release notes** · **aviso** (in-app, parceiros, base) · **book** (roadmap, interno) · **post** (comunidade, social, derivado da ficha) · **outro**.

Canais: os de `cortex.config.yaml › canais[]` ({{#each canais as c}}`{{c.slug}}`{{#if @last}}{{else}}, {{/if}}{{/each}}) mais os canais próprios de produto (central de ajuda, in-app, portal de parceiros).

## Pendências de publicação

Entradas triadas como P1 ou P2 sem linha acima. Alimentada pela auditoria de `registro-de-publicacao`.

| Entrada | Produto | P | Triada em | O que falta |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
