---
tipo: skill
id: verbete
descricao: "Escreve o verbete de glossário: definição correta em um parágrafo, uso, exemplo e termos relacionados, com o termo-alvo no título."
familia: CRIAR.verbete
output: texto
canal: seo
ferramenta:
produto: todos
publico:
gatilhos: ["cria o verbete de", "define o termo", "página de glossário para", "o que é X para o glossário", "revisa esse verbete", "termos relacionados a"]
requires: editor · linha-editorial · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Verbete — definição que resolve em um parágrafo

## Contexto de uso

- **Família:** `CRIAR.verbete` · **canal:** `seo` · **oferta:** `todos` (cite a oferta só se o termo for dela, e pelo que está na ficha).
- **Entra com:** `BRIEFING VALIDADO ✅` (termo exato, público, fontes) + decisão de formato do Editor.
- **Não serve para:** explicar um processo (`artigo`), noticiar (`noticia`), página de ferramenta (`ferramenta-web`).

## Processo

1. Confirme o **termo exato** e suas grafias (sigla, tradução, variação). Confira duplicidade no inventário do glossário.
2. Escreva a **definição em um parágrafo**, correta e sem adjetivo: o que é, para que serve, em que contexto aparece.
3. Acrescente **como se usa** (1–3 frases) e **um exemplo** concreto.
4. Liste **termos relacionados** que já existem no glossário (link) e os que faltam (marque como lacuna para o Editor).
5. Fonte: definição de referência com link profundo quando houver padrão (norma, documentação oficial, autor); sem fonte → marcador de `_cortex/kernel/anti-alucinacao.md` §4.
6. Checklist: termo no título · definição no topo · nada sobre a oferta fora de `contexto/produtos/` · tom de `contexto/brandcenter/brandcenter.md`.
7. Entregue no chat. Revisão humana antes de publicar.

## Output esperado

- **Formato:** título (o termo) · definição (1 parágrafo) · como se usa · exemplo · termos relacionados · fonte(s) · meta description.
- **Tamanho / limites:** o da tabela de formatos; definição ≤ 60 palavras.
- **Exemplo curto:** "**CDP** — plataforma que unifica dados de cliente de várias fontes num perfil único e persistente, usado para segmentar e ativar em outros sistemas."

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
