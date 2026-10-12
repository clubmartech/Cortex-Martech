---
tipo: doc
id: {{item.slug}}
descricao: "Detalha o tom, os exemplos de linguagem e o universo visual da marca {{item.nome}}."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como a {{item.nome}} fala", "exemplos de texto da {{item.nome}}", "universo visual da {{item.nome}}", "tom de voz da {{item.nome}}"]
requires: brandcenter
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# Marca {{item.nome}} (`{{item.slug}}`)

> Ficha de marca. Regras transversais (arquitetura, termos, grafia, o que nunca fazer): `../brandcenter.md`. Gerado pelo `cortex init`; o time edita.

## 1. Identidade

- **Gênero gramatical:** {{#if item.genero == "m"}}masculino — "o {{item.nome}}"{{/if}}{{#if item.genero == "f"}}feminino — "a {{item.nome}}"{{/if}}{{#if item.genero == "neutro"}}neutro — sem artigo{{/if}}
- **Papel:** {{#if item.mae}}marca-mãe de {{organizacao.nome}}{{else}}marca filha; endossada por {{marca_mae.nome}}{{/if}}
- **Site:** {{default item.site "[PENDENTE: preencher]"}}
- **Ofertas desta marca:** {{#each produtos as p}}{{#if p.marca == item.slug}}`{{p.slug}}` {{p.nome}} · {{/if}}{{/each}}
- **Posicionamento em uma frase:** [PENDENTE: preencher]

## 2. Tom de voz — detalhado

| Dimensão | O que priorizar | O que evitar |
|---|---|---|
{{#each item.tom as t}}| **{{t}}** | [PENDENTE: preencher] | [PENDENTE: preencher] |
{{/each}}
## 3. Exemplos — assim sim / assim não

| Situação | ✅ Assim sim | ❌ Assim não |
|---|---|---|
| Abertura de e-mail | [PENDENTE: preencher] | [PENDENTE: preencher] |
| Post em rede social | [PENDENTE: preencher] | [PENDENTE: preencher] |
| CTA | [PENDENTE: preencher] | [PENDENTE: preencher] |
| Falar de preço / oferta | [PENDENTE: preencher] | [PENDENTE: preencher] |

## 4. Termos

- **Nunca usar:** {{#if tem:item.termos_proibidos}}{{join item.termos_proibidos " · "}}{{else}}[PENDENTE: preencher]{{/if}}
- **Preferir:** {{#if tem:item.termos_preferidos}}{{join item.termos_preferidos " · "}}{{else}}[PENDENTE: preencher]{{/if}}
- **Frases-âncora (posicionamento):** [PENDENTE: preencher — 2 a 3 frases que podem ser repetidas na letra]

## 5. Universo visual

- **Paleta, tipografia, logo:** arquivos em `_assets/{{item.slug}}/` (fora do escopo da IA) — [PENDENTE: preencher o caminho ou link do brandbook]
- **Regras rápidas para a IA descrever uma peça:** [PENDENTE: preencher — cor dominante, tipografia de título, área de proteção do logo]
- **Nunca:** misturar com a paleta de outra marca; usar o logo em versão não oficial.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
