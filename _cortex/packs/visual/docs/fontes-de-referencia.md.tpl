---
tipo: doc
id: fontes-de-referencia
descricao: "Registra onde buscar referência visual do nicho — fontes próprias, do nicho e sugeridas — com acesso, uso permitido, como buscar e o que é proibido."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["onde buscar referência", "fontes de inspiração", "sites de referência do nicho", "perfis de referência", "registro de fontes visuais", "posso usar essa fonte"]
requires:
owner: {{papel "curador-visual"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Fontes de referência visual — {{organizacao.nome}}

> Fonte única de **onde** o radar busca. O `radar-de-referencias` lê o bloco YAML abaixo com `_cortex/packs/visual/scripts/radar.py`. Edite aqui; não espalhe listas de sites em skills.

## Como ler

- **origem:** `propria` (a pessoa já usa e confia; prioridade 1) · `nicho` (perfis, marcas e canais do segmento, aprovados pela pessoa; prioridade 2) · `sugerida` (catálogo genérico por tipo; prioridade 3, ainda não validada aqui).
- **acesso:** `livre` · `login` · `pago` (pagas ficam fora do plano, salvo `--incluir-pagas`).
- **uso:** `so-referencia` (estudar, nunca usar a mídia) · `licenca-livre` (CC0, domínio público, licença do banco) · `credito` (CC BY: crédito na peça).
- **como_buscar:** padrão de URL com `{q}` (o termo), `perfil` (visitar a página) ou instrução em texto. Padrões marcados `conferir: true` não foram testados nesta base: confirme na primeira rodada e mude para `false`.
- **proibido:** o que nunca se faz naquela fonte. Valem sempre: raspagem em massa, download de mídia de terceiros para peça, marca d'água ou handle alheio, usar como dado de treino.

## Fontes próprias e do nicho

As fontes da pessoa entram por `visual.fontes_proprias` no `cortex.config.yaml` (o radar as soma ao plano) ou como itens `origem: propria` abaixo. Fontes do nicho descobertas pelo radar entram aqui **só depois de aprovadas**, com `origem: nicho`.

{{#if tem:visual.fontes_proprias}}Declaradas no config: {{#each visual.fontes_proprias as f}}{{f.url}}{{#if @last}}{{else}} · {{/if}}{{/each}}.{{else}}Nenhuma fonte própria declarada ainda. `[PENDENTE: perguntar à pessoa quais perfis, sites e canais ela já usa como referência]`{{/if}}

## Registro

```yaml
fontes:
  - id: unsplash
    nome: "Unsplash"
    url: "https://unsplash.com"
    tipo: banco-livre
    acesso: livre
    uso: licenca-livre
    como_buscar: "https://unsplash.com/s/photos/{q}"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: pexels
    nome: "Pexels"
    url: "https://www.pexels.com"
    tipo: banco-livre
    acesso: livre
    uso: licenca-livre
    como_buscar: "https://www.pexels.com/search/{q}/"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: pixabay
    nome: "Pixabay"
    url: "https://pixabay.com"
    tipo: banco-livre
    acesso: livre
    uso: licenca-livre
    como_buscar: "https://pixabay.com/images/search/{q}/"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: wikimedia-commons
    nome: "Wikimedia Commons"
    url: "https://commons.wikimedia.org"
    tipo: banco-livre
    acesso: livre
    uso: credito
    como_buscar: "https://commons.wikimedia.org/w/index.php?search={q}&title=Special:MediaSearch&type=image"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: pinterest
    nome: "Pinterest"
    url: "https://www.pinterest.com"
    tipo: moodboard
    acesso: login
    uso: so-referencia
    como_buscar: "https://www.pinterest.com/search/pins/?q={q}"
    metodo: navegador
    proibido: [raspagem, download]
    origem: sugerida
    conferir: true
  - id: behance
    nome: "Behance"
    url: "https://www.behance.net"
    tipo: portfolio
    acesso: livre
    uso: so-referencia
    como_buscar: "https://www.behance.net/search/projects?search={q}"
    metodo: navegador
    proibido: [raspagem, download]
    origem: sugerida
    conferir: true
  - id: dribbble
    nome: "Dribbble"
    url: "https://dribbble.com"
    tipo: portfolio
    acesso: livre
    uso: so-referencia
    como_buscar: "https://dribbble.com/search/{q}"
    metodo: navegador
    proibido: [raspagem, download]
    origem: sugerida
    conferir: true
  - id: awwwards
    nome: "Awwwards"
    url: "https://www.awwwards.com"
    tipo: web
    acesso: livre
    uso: so-referencia
    como_buscar: "navegar por categoria e tag do segmento na página de sites"
    metodo: navegador
    origem: sugerida
  - id: godly
    nome: "Godly"
    url: "https://godly.website"
    tipo: web
    acesso: livre
    uso: so-referencia
    como_buscar: "navegar pela galeria e filtrar por tipo de site"
    metodo: navegador
    origem: sugerida
  - id: land-book
    nome: "Land-book"
    url: "https://land-book.com"
    tipo: web
    acesso: livre
    uso: so-referencia
    como_buscar: "filtrar por categoria do segmento"
    metodo: navegador
    origem: sugerida
  - id: are-na
    nome: "Are.na"
    url: "https://www.are.na"
    tipo: moodboard
    acesso: livre
    uso: so-referencia
    como_buscar: "https://www.are.na/search?q={q}"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: youtube
    nome: "YouTube"
    url: "https://www.youtube.com"
    tipo: video
    acesso: livre
    uso: so-referencia
    como_buscar: "https://www.youtube.com/results?search_query={q}"
    metodo: navegador
    proibido: [download]
    origem: sugerida
  - id: lottiefiles
    nome: "LottieFiles"
    url: "https://lottiefiles.com"
    tipo: motion
    acesso: livre
    uso: credito
    como_buscar: "https://lottiefiles.com/search?q={q}"
    metodo: navegador
    origem: sugerida
    conferir: true
  - id: google-fonts
    nome: "Google Fonts"
    url: "https://fonts.google.com"
    tipo: tipografia
    acesso: livre
    uso: licenca-livre
    como_buscar: "filtrar por categoria e testar com o texto real da marca"
    metodo: navegador
    origem: sugerida
  - id: fonts-in-use
    nome: "Fonts In Use"
    url: "https://fontsinuse.com"
    tipo: tipografia
    acesso: livre
    uso: so-referencia
    como_buscar: "buscar por setor ou por fonte candidata"
    metodo: navegador
    origem: sugerida
  - id: coolors
    nome: "Coolors"
    url: "https://coolors.co"
    tipo: cor
    acesso: livre
    uso: so-referencia
    como_buscar: "explorar paletas por palavra-chave do mood"
    metodo: navegador
    origem: sugerida
  - id: mobbin
    nome: "Mobbin"
    url: "https://mobbin.com"
    tipo: ui
    acesso: pago
    uso: so-referencia
    como_buscar: "buscar por fluxo ou tela"
    metodo: navegador
    origem: sugerida
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "curador-visual"}} |
