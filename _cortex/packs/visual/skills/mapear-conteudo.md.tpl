---
tipo: skill
id: mapear-conteudo
descricao: "Monta o mapa de conteúdo — pilares com tese e prova, matriz pilar × etapa, formato → estilo e lacunas priorizadas — como território para o calendário."
familia: PLANEJAR.mapa-de-conteudo
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o mapa de conteúdo", "define os pilares", "onde estão as lacunas de conteúdo", "que formato para cada público", "matriz de conteúdo por etapa", "território de conteúdo da marca"]
requires: arquiteto-de-conteudo · mapa-de-conteudo
owner: {{papel "arquiteto-de-conteudo"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Arquiteto de Conteúdo** (`arquiteto-de-conteudo`).

# Mapa de conteúdo — o território antes do calendário

## Contexto de uso

- Etapa 6 do `kit-visual`.
- Começo de ciclo, reposicionamento, canal novo, ou "a gente não sabe sobre o que falar".

## Briefing mínimo

Objetivo do período · públicos prioritários · oferta e provas disponíveis · canais ativos · o que já foi publicado · frequência que a equipe sustenta.

## Processo

1. **Inventário:** o que a marca já publicou (por tema, formato e canal) e o que funcionou, com fonte e data quando houver número.
2. **Pilares:** propor 3–5, cada um com tese em uma frase, por que a marca pode falar disso e qual prova existe. A pessoa escolhe.
3. **Matriz pilar × etapa** (descoberta, consideração, decisão, relacionamento): tipo de conteúdo + formato + canal por célula.
4. **Formato → estilo e direção:** cada formato aponta um estilo de `estilos-visuais.md` e a direção (foto, vídeo, imagem IA). Formato sem estilo vai ao Diretor de Arte.
5. **Lacunas:** células vazias e formatos sem estilo, priorizados por impacto no público e esforço.
6. Gravar em `mapa-de-conteudo.md` e pedir aprovação.

## Regras

- Pilar sem prova vira pauta de construção de prova, não promessa.
- Frequência só a que a equipe sustenta.
- Número de desempenho só com fonte e data; sem dado, a prioridade é declarada como julgamento.

## Output esperado

| Saída | Formato |
|---|---|
| Mapa aprovado | `mapa-de-conteudo.md` |
| Lista de pendências visuais | formatos sem estilo ou referência |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "arquiteto-de-conteudo"}} |
