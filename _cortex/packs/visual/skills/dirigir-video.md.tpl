---
tipo: skill
id: dirigir-video
descricao: "Define como os vídeos da marca parecem e soam — formatos, ritmo, gancho, texto na tela, motion, áudio e cartão final — e confere a exportação antes de entregar."
familia: DOCUMENTAR.direcao-de-video
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["estética dos vídeos", "padrão de vídeo da marca", "ritmo e cortes", "legenda e texto na tela", "motion da marca", "como os reels devem parecer"]
requires: diretor-de-arte · direcao-de-video
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# Direção de vídeo — a mesma cara em todo vídeo

O roteiro é do pack de marketing ou conteúdo. Aqui fica **como o vídeo parece e soa**, para qualquer editor ou motor de render seguir.

## Contexto de uso

- Etapa 3 do `kit-visual`, quando há canal de vídeo.
- Antes do primeiro vídeo de um formato novo; revisão de vídeo pronto.

## Processo

1. Ler referências de vídeo aprovadas (DNA: ritmo, gancho, texto na tela, motion) e os tokens de `motion.*`.
2. Preencher `direcao-de-video.md`: formatos e áreas seguras, ritmo e montagem, abertura e gancho, texto na tela e legenda (fonte e peso dos tokens, tamanho mínimo no celular), dialeto de motion, áudio (padrão de volume da casa), cartão final.
3. Produzir **um vídeo-piloto** com o executor da instância ({{default visual.executores.video "[PENDENTE: editor ou motor de render]"}}).
4. Conferência antes de entregar: formato e duração, quadros-chave sem defeito (preto, congelado, texto fora da área segura), legenda sincronizada, volume. Se houver script de conferência de exportação na instância, rodar.

## Regras

- Os primeiros segundos mostram a tensão, não o logo.
- Trilha e efeito só com licença registrada no acervo.
- Legenda sempre; uma palavra destacada por vez, com a cor de destaque.

## Output esperado

| Saída | Formato |
|---|---|
| Direção de vídeo | `direcao-de-video.md` |
| Vídeo-piloto conferido | destino de material gerado |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
