---
tipo: doc
id: mapa-de-conteudo
descricao: "Mapeia pilares × públicos × etapa × formato × canal, com lacunas, frequência e o estilo visual de cada formato, para o calendário partir de um território claro."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["mapa de conteúdo", "pilares de conteúdo", "lacunas de conteúdo", "que formato usar para cada público", "território de conteúdo", "matriz de formatos"]
requires:
owner: {{papel "arquiteto-de-conteudo"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Mapa de conteúdo — {{organizacao.nome}}

> Preenchido pela skill `mapear-conteudo`. É o **território**: o que a marca fala, para quem, em que momento e em que formato. O calendário (o quando) sai daqui; as peças (o texto) saem dos packs de marketing e conteúdo.

## 1. Pilares

| Pilar | Tese em uma frase | Por que a marca pode falar disso | Prova disponível |
|---|---|---|---|
| `[PENDENTE]` | | | |

Três a cinco pilares. Pilar sem prova disponível vira pauta de construção de prova, não de promessa.

## 2. Públicos

{{#each publicos as p}}- **{{p.nome}}** (`{{p.slug}}`)
{{/each}}{{#if tem:publicos}}{{else}}`[PENDENTE: públicos do config]`
{{/if}}
## 3. Matriz pilar × etapa

| Pilar | Descoberta | Consideração | Decisão | Relacionamento |
|---|---|---|---|---|
| `[PENDENTE]` | | | | |

Cada célula: tipo de conteúdo + formato + canal. Célula vazia é **lacuna** e vai para a seção 5.

## 4. Formato → estilo e direção

| Formato | Canais | Estilo (`estilos-visuais`) | Direção | Frequência-alvo |
|---|---|---|---|---|
{{#each canais as c}}| `[PENDENTE: formato]` | {{c.slug}} | `[PENDENTE]` | `[PENDENTE: foto, vídeo ou imagem IA]` | `[PENDENTE]` |
{{/each}}
## 5. Lacunas priorizadas

| Lacuna | Público | Etapa | Por que importa | Prioridade |
|---|---|---|---|---|
| `[PENDENTE]` | | | | |

## 6. O que a marca não publica

`[PENDENTE: temas fora do território, formatos que não combinam com a marca]`

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "arquiteto-de-conteudo"}} |
