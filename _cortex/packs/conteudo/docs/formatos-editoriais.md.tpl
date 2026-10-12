---
tipo: doc
id: formatos-editoriais
descricao: "Tabela dos formatos editoriais ativos — tamanho, estrutura, promessa e critério de pronto de cada um — para decidir o formato antes do texto."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual o tamanho de um artigo", "estrutura do verbete", "diferença entre artigo e notícia", "qual formato usar", "critério de pronto do conteúdo", "estrutura de uma aula"]
requires:
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

# Formatos editoriais — {{organizacao.nome}}

> Gerado pelo pack `conteudo`; **o time é dono**. Os números abaixo são **ponto de partida**: substitua pelos da casa e registre a fonte da mudança no `## Histórico`. O Editor abre esta tabela **antes** de escrever.

## 1. A tabela

| Formato | Responde a | Tamanho de partida | Estrutura | Pronto quando |
|---|---|---|---|---|
{{#if canal:blog}}| **Artigo** | "como funciona / como fazer / por que" | [PENDENTE: faixa de palavras] | título → promessa em 2 linhas → seções com H2 → exemplo concreto → fechamento com próximo passo | fonte em toda afirmação externa; um exemplo real; revisão humana |
| **Notícia** | "o que aconteceu, quando, e o que muda" | [PENDENTE: faixa de palavras] | lide (quem/o quê/quando) → contexto → o que muda para o leitor → fonte original | fonte primária linkada; data no corpo; sem opinião não atribuída |
{{/if}}{{#if canal:seo}}| **Verbete** | "o que é X" | [PENDENTE: faixa de palavras] | definição em 1 parágrafo → como se usa → exemplo → termos relacionados | definição correta e curta no topo; termo-alvo no título |
| **Ferramenta web** | "faz isso por mim" | uma tela | o que faz em 1 frase → entrada → resultado → como funciona → limites | funciona sem instrução; sem coleta de dado não declarada; medida de uso ligada |
{{/if}}{{#if oferta:produto}}| **Material de aula** | "o que o aluno sai sabendo" | [PENDENTE: duração ou páginas] | objetivo → conceito → exemplo → exercício → resumo | objetivo verificável; coerente com o módulo da oferta |
{{/if}}
## 2. Desempates

- **Explicar × definir:** se o leitor precisa de contexto para agir, é artigo; se precisa só saber o que a palavra significa, é verbete.
- **Explicar × noticiar:** se perde validade em semanas, é notícia; se vale daqui a um ano, é artigo.
- **Artigo × aula:** aula pressupõe a oferta e um objetivo de aprendizagem; artigo é para quem ainda não comprou.
- **Página × ferramenta:** se o visitante **faz** algo e sai com um resultado, é ferramenta; se **lê**, é página.

## 3. Elementos comuns a todo formato

- Título sem ano e sem clickbait; promete o que o corpo entrega.
- Primeiro parágrafo diz para quem é e o que a pessoa leva.
- Imagem de destaque é metáfora concreta do tema, não ilustração genérica.
- Chamada final aponta um próximo passo coerente com o nível de consciência do leitor.
- [PENDENTE: preencher — regras de SEO on-page da casa, se houver]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
