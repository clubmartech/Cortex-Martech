---
tipo: skill
id: planejar-editorial
descricao: "Monta o calendário editorial do período a partir da cobertura atual, das lacunas por público e do dado disponível, com formato e ordem por pauta."
familia: PLANEJAR.editorial
output: plano
canal: blog
ferramenta:
produto: todos
publico:
gatilhos: ["monta o calendário editorial", "o que publicar este mês", "quais pautas do trimestre", "onde está a lacuna de conteúdo", "cluster de conteúdo sobre", "cobertura de tema do blog"]
requires: editor · linha-editorial · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Calendário e cobertura editorial

## Contexto de uso

- **Família:** `PLANEJAR.editorial` · **canal:** `blog` (e `seo`) · **oferta:** `todos` (pergunte se o plano serve a uma oferta).
- **Entra com:** `BRIEFING VALIDADO ✅` (período, público prioritário, dado disponível, capacidade de produção) + inventário do publicado.
- **Não serve para:** escrever a peça (`artigo`, `verbete`, `noticia`), plano de campanha com mídia (pack marketing, `PLANEJAR.campanha`).

## Processo

1. Levante a **cobertura atual** por tema e formato a partir do inventário; sem inventário, peça-o — não estime de memória.
2. Cruze com os públicos de `contexto/publicos/`: que pergunta de cada público ainda não tem resposta publicada? Essa é a **lacuna**.
3. Se houver dado{{#if integracao:analytics}} (integração de analytics, `ROTAS.md` §3.2){{/if}}: o que já traz leitor e não converte; o que tem impressão e não tem clique. Dado recebe marcador `[CONECTOR: sistema · data]`.
4. Para cada pauta: **formato** (tabela de `times/{{time.slug}}/docs/formatos-editoriais.md`), público, ângulo em uma linha, fonte prevista, dependência (dado, entrevista, oferta).
5. Ordene pela regra: primeiro o que **liga o que já traz gente ao que já está pronto**; depois lacuna de público prioritário; por último cobertura nova.
6. Respeite a capacidade declarada; pauta que não cabe vai para "próximo período" com o motivo.
7. Entregue o plano e **ofereça** abrir a skill do formato para a primeira pauta.

## Output esperado

- **Formato:** tabela período × pauta × formato × público × ângulo × fonte × dependência · lista de lacunas não atendidas · critério de sucesso do período.
- **Tamanho / limites:** o período pedido; sem pauta sem público; sem meta inventada (sem meta declarada, o critério é cobertura, não número).
- **Exemplo curto:** "Semana 1 — artigo — `persona-x` — 'o que acontece com o dado entre o clique e o relatório' — fonte: doc de dados da casa — depende de: ninguém."

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
