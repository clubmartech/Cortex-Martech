---
tipo: skill
id: book-de-roadmap
descricao: "Monta a comunicação de roadmap por horizonte — o que foi entregue, o que está em andamento, o que vem depois — sem prometer data e com fonte por item."
familia: CRIAR.book-roadmap
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o book de roadmap", "o que vem por aí para o cliente", "entregas do trimestre em um documento", "apresentar o roadmap", "roadmap por horizonte", "resumo das entregas do período", "book para o time de sucesso"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`), a ficha do produto e as release notes do período antes de passar para cá. **Volte ao Documentador de Produto antes de montar.**

# Book de roadmap — comunicação por horizonte

Um documento periódico que conta ao cliente (ou à equipe interna) **o que foi entregue** no período e **o que vem depois**, por horizonte, sem data. A fonte das entregas são as release notes e as fichas; a fonte do futuro é o material de roadmap do PM. O book não cria informação: organiza e traduz.

## Contexto de uso

| Variante | Público | Periodicidade | Tem "o que vem por aí"? |
|---|---|---|---|
| Book do cliente | clientes | por ciclo ({{operacao.ciclo_planejamento}}) | sim, por horizonte |
| Book interno | sucesso do cliente, vendas, atendimento | mensal | opcional; com mais detalhe de pré-requisito |
| Apresentação de roadmap | reunião com cliente ou parceiro | sob demanda | sim, verbal, com as mesmas regras |

## Briefing mínimo

Produto (slug){{#if oferta:produto}} e módulos cobertos{{/if}} · período · variante · **release notes do período** · **material de roadmap do PM** (lista do que está em andamento e planejado, com horizonte) · quem valida.

## Processo

### Passo 1 — Reunir as entregas do período

Fonte: `release-notes` do período e fichas de funcionalidade. Agrupar por produto{{#if oferta:produto}} › módulo{{/if}}; dentro do grupo, pela ordem das release notes. Entrega sem release notes ou ficha → `[PENDENTE DE CONFIRMAÇÃO]`; não descrever de memória.

### Passo 2 — Escrever cada entrega

Título com o benefício · duas ou três frases: cenário, o que muda, o que fazer para usar · "Saiba mais" com link para o artigo (ou `[PENDENTE: artigo]`). Linguagem de uso, sem venda.

### Passo 3 — Escrever "o que vem por aí" por horizonte

| Horizonte | O que dizer | O que nunca dizer |
|---|---|---|
| **Em andamento** | o problema que será resolvido e para quem; "em desenvolvimento" | data, versão, mês |
| **Próximo** | o tema e a direção; "nos próximos ciclos" | escopo detalhado, funcionalidade como certa |
| **Explorando** | a área de interesse; "estamos estudando" | qualquer compromisso |

Só entra o que o material do PM traz, com o horizonte que ele traz. Data aparece **somente** com `[VALIDADO]` explícito do PM para publicação externa — e mesmo assim como "previsto para", nunca "disponível em".

### Passo 4 — Montar a estrutura

| Parte | Conteúdo |
|---|---|
| Capa | produto, período, variante |
| Introdução | o que o documento traz, período coberto, como ler |
| Índice | produto{{#if oferta:produto}} › módulo{{/if}} → entregas · o que vem por aí |
| Capítulos | um por grupo; dentro, entregas e depois horizontes |
| Release notes | links das release notes do período |
| Fecho | para onde ir (central de ajuda, canal de feedback) e quem assina |

### Passo 5 — Conferências antes de fechar

- [ ] Toda entrega tem release notes ou ficha de origem?
- [ ] Nenhuma data sem `[VALIDADO]`? Nenhum "em breve" com escopo detalhado?
- [ ] "O que vem por aí" bate com o material do PM, nem mais nem menos?
- [ ] Book interno: pré-requisitos e objeções esperadas incluídos?

### Passo 6 — Diagramar, validar, publicar, registrar

Diagramação → **Designer** do pack marketing, com o texto fechado. Validação do papel `{{papel "pm"}}` → publicação → linha em `times/{{time.slug}}/docs/indice-publicacoes.md`.

## Regras

- Roadmap é direção, não promessa. O cliente lê o book como compromisso: cada item futuro leva a linguagem do horizonte.
- Nada entra sem fonte (release notes, ficha, material do PM).
- Termos proibidos da marca não entram — `contexto/brandcenter/brandcenter.md`{{#each marcas as m}}{{#if m.termos_proibidos}}; `{{m.slug}}`: {{join m.termos_proibidos ", "}}{{/if}}{{/each}}.
- Book interno não vai para o cliente sem passar pela variante do cliente.

## Checklist

- [ ] Entregas do período com origem? Agrupadas e na ordem das release notes?
- [ ] Horizontes com a linguagem certa? Sem data?
- [ ] Estrutura completa? Conferências rodadas?
- [ ] Validação humana? Índice atualizado?

## Output esperado

| Saída | Formato |
|---|---|
| Book (texto fechado) | documento na estrutura acima, para diagramação |
| Lista de pendências ao PM | tabela: item · pergunta · status |
| Linha para `indice-publicacoes` | data · produto · canal · título · link |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
