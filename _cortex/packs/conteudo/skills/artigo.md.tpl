---
tipo: skill
id: artigo
descricao: "Escreve o artigo evergreen pronto para publicar: título, promessa, seções, exemplo real, fontes linkadas e próximo passo coerente com o leitor."
familia: CRIAR.artigo
output: texto
canal: blog
ferramenta:
produto: todos
publico:
gatilhos: ["escreve o artigo sobre", "artigo para o blog", "texto evergreen sobre", "guia completo de", "atualiza esse artigo", "transforma essa pauta em artigo"]
requires: editor · linha-editorial · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Artigo — texto evergreen que ensina

## Contexto de uso

- **Família:** `CRIAR.artigo` · **canal:** `blog` · **oferta:** `todos` (pergunte qual, se o texto citar a oferta; nunca deduza).
- **Entra com:** `BRIEFING VALIDADO ✅` (tema e ângulo, público, fontes, termo-alvo) + decisão de formato do Editor.
- **Não serve para:** fato com prazo de validade (`noticia`), definição curta (`verbete`), material para aluno (`aula`), adaptação para rede social (pack marketing).

## Processo

1. Releia a linha em `times/{{time.slug}}/docs/formatos-editoriais.md` para **Artigo** e fixe tamanho e estrutura.
2. Confira duplicidade com o inventário que o Editor indicou; tema coberto → proponha atualização e pare.
3. Defina **a promessa em duas linhas**: para quem e o que a pessoa leva. Se não couber em duas linhas, o ângulo está largo.
4. Estruture com H2 que respondem perguntas reais do leitor, na ordem em que ele as faria.
5. Escreva no tom de `contexto/brandcenter/brandcenter.md`; cada afirmação externa com link profundo; dado sem fonte recebe marcador (`_cortex/kernel/anti-alucinacao.md` §4).
6. Inclua **um exemplo concreto** (caso, número com fonte, cena de uso). Sem exemplo, o artigo é opinião.
7. Feche com o próximo passo coerente com o nível de consciência (educar → outro conteúdo; comparar → a ficha da oferta; converter → a ação).
8. Checklist: título sem ano · promessa cumprida · fontes abertas · termos proibidos ausentes · nenhuma afirmação sobre a oferta fora de `contexto/produtos/`.
9. Entregue no chat com a lista do que falta confirmar. Revisão humana antes de publicar.

## Output esperado

- **Formato:** título · promessa (2 linhas) · corpo com H2/H3 · fontes (lista com links) · próximo passo · meta description (≤ 155 caracteres) · sugestão de imagem de destaque (metáfora concreta).
- **Tamanho / limites:** o da tabela de formatos; sem ano no título; sem emoji.
- **Exemplo curto:** "**Título:** o que um pipeline de dados faz pelo marketing · **Promessa:** para quem opera campanha e recebe relatório pronto: o que acontece entre o clique e o número, e onde o erro costuma nascer."

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
