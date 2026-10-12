---
tipo: doc
id: direcao-de-video
descricao: "Define a estética de vídeo da marca — formatos, ritmo, ganchos, legenda, motion, áudio e cartão final — para todo vídeo nascer com a mesma cara."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["padrão de vídeo", "como os vídeos devem parecer", "ritmo de corte", "legenda do vídeo", "motion da marca", "áudio do vídeo"]
requires:
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Direção de vídeo — {{organizacao.nome}}

> Preenchida pela skill `dirigir-video`. O roteiro é do pack de conteúdo ou marketing; aqui fica **como o vídeo parece e soa**. Executor de vídeo: {{default visual.executores.video "[PENDENTE: quem edita ou renderiza]"}}.

## 1. Formatos

| Formato | Canal | Duração-alvo | Área segura | Situação |
|---|---|---|---|---|
| 9:16 | {{#each canais as c}}{{#if c.slug == "instagram"}}instagram {{/if}}{{#if c.slug == "tiktok"}}tiktok {{/if}}{{/each}} | `[PENDENTE]` | `[PENDENTE: margens para interface do app]` | |
| 16:9 | {{#each canais as c}}{{#if c.slug == "youtube"}}youtube {{/if}}{{#if c.slug == "linkedin"}}linkedin {{/if}}{{/each}} | `[PENDENTE]` | | |

## 2. Ritmo e montagem

Duração média de plano · quando cortar · transições permitidas (preferir corte seco) · pausa antes de informação importante. `[PENDENTE]`

## 3. Abertura e gancho

Os primeiros segundos mostram a tensão ou a pergunta concreta, não o logo. Repertório de ganchos aprovados: `[PENDENTE]`.

## 4. Texto na tela e legenda

Fonte e peso dos tokens · tamanho mínimo legível no celular · posição dentro da área segura · legenda sempre ligada · destaque de palavra com a cor de destaque, uma por vez. `[PENDENTE]`

## 5. Motion

Dialeto de movimento (curvas e durações dos tokens `motion.*`) · o que anima e o que fica parado · `prefers-reduced-motion` no site. `[PENDENTE]`

## 6. Áudio

Volume integrado de referência −14 LUFS para redes · voz acima da trilha · trilha e efeitos só com licença registrada no acervo. `[PENDENTE: confirmar padrão da casa]`

## 7. Cartão final e marca

`[PENDENTE: duração, CTA, elementos]` · logo discreto · sem marca d'água de ferramenta.

## 8. Conferência antes de entregar

Exportação no formato certo · sem quadro preto ou congelado · legenda sincronizada · áudio no volume · checagem visual de quadros-chave.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
