---
tipo: skill
id: noticia
descricao: "Escreve a notícia com lide, contexto, o que muda para o leitor e fonte primária linkada — sem opinião não atribuída e com data no corpo."
familia: CRIAR.noticia
output: texto
canal: blog
ferramenta:
produto: todos
publico:
gatilhos: ["cobre a notícia de", "escreve a nota sobre o anúncio", "notícia sobre o lançamento", "transforma essa fonte em notícia", "pauta do dia para o site", "o que mudou com essa novidade"]
requires: editor · linha-editorial · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Notícia — fato novo, fonte primária, o que muda

## Contexto de uso

- **Família:** `CRIAR.noticia` · **canal:** `blog` · **oferta:** `todos` (a notícia não vende; se citar a oferta, só pelo que está na ficha).
- **Entra com:** `BRIEFING VALIDADO ✅` (fonte primária, data do fato, público) + decisão de formato do Editor.
- **Não serve para:** conteúdo que vale daqui a um ano (`artigo`), análise ou opinião da casa (artigo assinado por voz, pack marketing).

## Processo

1. Localize a **fonte primária** (anúncio oficial, documento, release) — não o veículo que repercutiu. Sem fonte primária, pare e avise.
2. Confira duplicidade: a casa já cobriu esse fato? Cobriu → atualize, não duplique.
3. **Lide:** quem, o quê, quando, onde — em até 3 linhas, com a data do fato no corpo.
4. **Contexto:** o que existia antes, em 1 parágrafo, com fonte.
5. **O que muda para o leitor:** a parte que justifica publicar; para o público cadastrado, não "para o mercado".
6. Opinião só **atribuída** (aspas + nome + origem). Nada de "especialistas apontam".
7. Checklist: data no corpo · fonte primária linkada · sem termos proibidos · sem promessa sobre a oferta.
8. Entregue no chat. Revisão humana antes de publicar.

## Output esperado

- **Formato:** título factual · lide · contexto · o que muda · fonte(s) primária(s) · meta description.
- **Tamanho / limites:** o da tabela de formatos; título sem ano; sem adjetivo de impacto.
- **Exemplo curto:** "**Título:** plataforma X encerra a versão gratuita em 1º de março · **Lide:** a X anunciou em 10/02 que…"

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
