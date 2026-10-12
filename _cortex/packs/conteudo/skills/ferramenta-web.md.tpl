---
tipo: skill
id: ferramenta-web
descricao: "Especifica e entrega a ferramenta web do site: o que faz em uma frase, entrada, resultado, como funciona, limites, medição de uso e dado coletado declarado."
familia: CRIAR.ferramenta-web
output: html
canal: seo
ferramenta:
produto: todos
publico:
gatilhos: ["cria uma ferramenta para o site", "calculadora de", "gerador de", "validador online de", "página utilitária para", "especifica a ferramenta HTML"]
requires: editor · formatos-editoriais
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Editor** (`editor`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a linha editorial antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Editor antes de escrever.**

# Ferramenta web — a página que faz algo pelo visitante

## Contexto de uso

- **Família:** `CRIAR.ferramenta-web` · **canal:** `seo` · **oferta:** `todos` (a ferramenta não vende; a ponte para a oferta é uma chamada medida, nunca o conteúdo).
- **Entra com:** `BRIEFING VALIDADO ✅` (tarefa que o visitante quer resolver, entrada, resultado, termo de busca, dado coletado) + decisão de formato do Editor.
- **Não serve para:** página que só explica (`artigo`/`verbete`), ferramenta interna do time (fora do escopo editorial).

## Processo

1. Escreva **o que a ferramenta faz em uma frase** — se não couber, são duas ferramentas.
2. Defina **entrada** (campos, limites, validação) e **resultado** (formato, precisão, o que o visitante leva).
3. Seção **como funciona**: a regra ou fórmula, com fonte quando for norma ou padrão.
4. **Limites** declarados: o que ela não calcula, onde o resultado é aproximado.
5. **Dado coletado:** se a ferramenta guarda ou envia qualquer dado do visitante, declare e confira `_cortex/kernel/governanca.md` §3; sem base para coletar, não coleta.
6. **Medição de uso:** defina o evento que conta uso e clique na chamada para a oferta{{#if integracao:analytics}}; registre pela integração de analytics (`ROTAS.md` §3.2){{/if}}.
7. Entregue a **especificação** e, se houver padrão de construção da casa, o código no padrão; sem padrão, só a especificação.
8. Checklist: uma frase · entrada/resultado · como funciona · limites · dado declarado · evento de uso · termo de busca no título.
9. Revisão humana antes de publicar.

## Output esperado

- **Formato:** título com o termo de busca · frase do que faz · tabela entrada/resultado · como funciona · limites · dado coletado · evento de medição · (código, se houver padrão).
- **Tamanho / limites:** uma tela; sem dependência não declarada.
- **Exemplo curto:** "**Calculadora de ROAS** — informe gasto e receita e veja o retorno sobre o investimento em mídia, com a fórmula aberta."

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
