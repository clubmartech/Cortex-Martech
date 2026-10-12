---
tipo: doc
id: linha-editorial
descricao: "Define o que a casa publica, para quem, o que nunca publica e como cita fonte — a referência que o Editor abre antes de qualquer pauta."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que a gente publica", "qual a linha editorial", "isso cabe no blog", "como citar fonte no artigo", "o que nunca publicamos", "qual público do conteúdo"]
requires:
owner: {{papel "editor"}}
origem: pack:conteudo@1.0
validado_em: {{hoje}}
---

# Linha editorial — {{organizacao.nome}}

> Gerado pelo pack `conteudo`; **o time é dono** (o build não sobrescreve). Preencha os `[PENDENTE: …]` com a prática real e registre no `## Histórico`. Tom e termos vivem em `contexto/brandcenter/brandcenter.md`; aqui fica o que é **editorial**: tema, público, promessa, fonte.

## 1. O que publicamos e por quê

| Tipo | Para quê serve no negócio | Público principal |
|---|---|---|
{{#if canal:blog}}| Artigo | [PENDENTE: preencher — autoridade? aquisição? educação da base?] | [PENDENTE: slug de `publicos[]`] |
| Notícia | [PENDENTE: preencher — recorrência? atualidade?] | [PENDENTE: preencher] |
{{/if}}{{#if canal:seo}}| Verbete | [PENDENTE: preencher — captura de intenção de aprendizado?] | [PENDENTE: preencher] |
| Ferramenta web | [PENDENTE: preencher — ímã de busca? prova de utilidade?] | [PENDENTE: preencher] |
{{/if}}{{#if oferta:produto}}| Material de aula | [PENDENTE: preencher — retenção? complemento da oferta?] | aluno |
{{/if}}
## 2. Públicos e nível de consciência

Públicos cadastrados: {{#each publicos as p}}`{{p.slug}}` ({{p.tipo}}){{#if @last}}{{else}} · {{/if}}{{/each}} — fichas em `contexto/publicos/`.
- **Quem já sabe o básico:** [PENDENTE: preencher — o que esse leitor quer que o conteúdo nomeie]
- **Quem chega por tarefa pontual:** [PENDENTE: preencher — o que oferecer sem forçar a oferta]

## 3. Promessa e ângulo

- **A tese que todo conteúdo sustenta:** [PENDENTE: preencher — a frase que posiciona a casa]
- **Ângulos que funcionam:** [PENDENTE: preencher]
- **Ângulos que afastam o leitor certo:** [PENDENTE: preencher]

## 4. Fonte e citação

- Toda afirmação externa tem **link profundo** para a origem (a página do dado, não a home).
- Dado de terceiro traz **data**; dado próprio traz **período e sistema de origem**.
- Sem fonte → marcador de `_cortex/kernel/anti-alucinacao.md` §4; nunca "estudos mostram".
- Citação de pessoa real só com aspas exatas e origem verificável.
- [PENDENTE: preencher — fontes de referência da casa (relatórios, bases, estudos) e onde estão]

## 5. O que nunca publicamos

- Afirmação sobre a oferta que não esteja em `contexto/produtos/`.
- Texto gerado por IA sem revisão humana.
- Imagem que retrate pessoa real sem autorização.
- [PENDENTE: preencher — temas, formatos ou práticas vetadas]

## 6. Duplicidade e atualização

- Antes de criar, conferir se o tema já existe: [PENDENTE: preencher — onde está o inventário do publicado]
- Tema coberto → **atualizar** o existente (data, dado, exemplo), não criar outro.
- Título é evergreen: [PENDENTE: confirmar a regra da casa sobre ano no título]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado pelo pack `conteudo@1.0`. | cortex |
