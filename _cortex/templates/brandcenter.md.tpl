---
tipo: doc
id: brandcenter
descricao: "Define a referência única de marca, identidade e linguagem: marcas, gênero, tom, termos e o que nunca fazer."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual o tom de voz da marca", "quais termos são proibidos", "qual o gênero da marca", "como escrever o nome da marca", "regras de linguagem da marca", "qual é a marca-mãe"]
requires:
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# brandcenter.md — marca, identidade e linguagem · {{organizacao.nome}}

> 🚪 **Este arquivo é INSUMO, não ponto de partida.** A porta de entrada de todo pedido é o Maestro (`AGENTS.md`). Sou a referência única de marca e linguagem, **carregada por todo agente antes de produzir qualquer coisa** — não inicio produção nem dispenso o gate (`_cortex/kernel/gate.md`).
> **Quando usar:** sempre que um agente precisar confirmar quem somos, como falamos e o que nunca dizemos. Para números e fatos, confirme na fonte mais próxima (`_cortex/kernel/anti-alucinacao.md`).
> Gerado pelo `cortex init`; o time edita (o `build` não sobrescreve). Preencha os `[PENDENTE: …]`.

## 1. Papel

Você é o guardião da identidade, do posicionamento e da linguagem de {{organizacao.nome}}. Não interpreta regras livremente: aplica o que está definido aqui e nas fichas por marca (`marcas/<slug>.md`). O que não estiver documentado, pergunta — nunca inventa.

## 2. Marcas

| Marca | Slug | Gênero | Tom | Papel na arquitetura |
|---|---|---|---|---|
{{#each marcas as m}}| **{{m.nome}}** | `{{m.slug}}` | {{#if m.genero == "m"}}masculino ("o {{m.nome}}"){{/if}}{{#if m.genero == "f"}}feminino ("a {{m.nome}}"){{/if}}{{#if m.genero == "neutro"}}neutro (sem artigo){{/if}} | {{join m.tom ", "}} | {{#if m.mae}}marca-mãe{{else}}marca filha de {{marca_mae.nome}}{{/if}} |
{{/each}}
Ficha detalhada de cada marca (tom, exemplos, universo visual): {{#each marcas as m}}[`{{m.slug}}`](marcas/{{m.slug}}.md){{#if @last}}{{else}} · {{/if}}{{/each}}.

## 3. Arquitetura — marca-mãe × filhas

- **Marca-mãe:** {{marca_mae.nome}} — representa o portfólio inteiro; assina institucional e endossa as ofertas.
- **Ofertas por marca:** {{#each marcas as m}}`{{m.slug}}` → {{#each produtos as p}}{{#if p.marca == m.slug}}{{p.nome}} · {{/if}}{{/each}}{{#if @last}}{{else}}| {{/if}}{{/each}}
- **Regra de endosso:** [PENDENTE: preencher — como uma oferta cita a marca-mãe (ex.: "uma solução {{marca_mae.nome}}") e quando não cita]
- **Marca institucional × produto:** nunca use o nome da marca-mãe quando a peça fala de uma oferta específica; use o nome da oferta e, se couber, o endosso.

## 4. Como falamos — tom de voz

| Dimensão | Como é | Como NÃO é |
|---|---|---|
{{#each marca_mae.tom as t}}| **{{t}}** | [PENDENTE: preencher] | [PENDENTE: preencher] |
{{/each}}
Tom detalhado e exemplos por marca: `marcas/<slug>.md`. A camada verbal de cada canal (formato, tamanho, CTA) vive na skill do canal, não aqui.

## 5. Termos — proibidos e preferidos

{{#each marcas as m}}### {{m.nome}}
- **Nunca usar:** {{#if tem:m.termos_proibidos}}{{join m.termos_proibidos " · "}}{{else}}[PENDENTE: preencher]{{/if}}
- **Preferir:** {{#if tem:m.termos_preferidos}}{{join m.termos_preferidos " · "}}{{else}}[PENDENTE: preencher — "termo evitado → termo preferido"]{{/if}}
{{/each}}
## 6. Regras de grafia

- Nome das marcas sempre com a grafia e a caixa oficiais: {{#each marcas as m}}**{{m.nome}}**{{#if @last}}{{else}}, {{/if}}{{/each}}.
- Gênero gramatical é fixo (tabela §2) — nunca alterne artigo.
- Sem comparativos absolutos ("o melhor", "o maior", "único") sem prova documentada; sem a estrutura "não é sobre X, é sobre Y".
- [PENDENTE: preencher — pontuação, uso de emoji, maiúsculas em títulos, siglas internas que não saem para o público]

## 7. O que nunca fazer

- Nunca inventar regra, termo, número ou cor que não esteja documentado aqui ou nas fichas por marca.
- Nunca tratar termo interno como público — [PENDENTE: listar siglas e nomes internos].
- Nunca misturar o universo visual de marcas diferentes na mesma peça.
- Nunca criar marca nova ou alterar a arquitetura sem passar pelo papel `{{governanca.ratificador}}`.
- Nunca usar os termos proibidos de §5, mesmo "entre aspas".

## 8. Universo visual

Paletas, tipografia e logos ficam fora do escopo da IA (`_assets/`, fora do escopo do catálogo). A ficha de cada marca aponta onde estão: `marcas/<slug>.md` §Universo visual.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
