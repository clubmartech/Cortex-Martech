---
tipo: doc
id: criatividade-{{item.slug}}
descricao: "Reúne ângulos, provas, objeções, termos e copies de {{item.nome}} que já foram ao ar e performaram — referência de padrão, não template para copiar."
familia:
output: nenhum
canal:
ferramenta:
produto: {{item.slug}}
publico:
gatilhos: ["copies que já rodaram de {{item.nome}}", "referência de campanha de {{item.nome}}", "banco de criatividade de {{item.nome}}", "ângulos de {{item.nome}}", "objeções do público de {{item.nome}}", "exemplo de copy de {{item.nome}}"]
requires:
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

# Banco de criatividade — {{item.nome}}

> **Critério de inclusão:** só entra copy que **foi ao ar e performou** — não rascunho, não aprovado-mas-não-veiculado. Atualização no fechamento de cada ciclo pelo papel `{{papel "redator"}}`. Use como **referência de padrão**, nunca como template literal. Doc do produto: `contexto/produtos/{{item.slug}}/{{item.slug}}.md`.

## Ficha do produto (do config)

| Campo | Valor |
|---|---|
| Nome | **{{item.nome}}** (`{{item.slug}}`) |
| Tipo | {{item.tipo}} |
| Marca que assina | `{{item.marca}}` |
| Públicos | {{join item.publicos ", "}} |
| Dor principal | {{#if item.dor_principal}}{{item.dor_principal}}{{else}}`[PENDENTE: preencher]`{{/if}} |
| Promessa | {{item.promessa}} |
{{#if item.modulos}}| Módulos | {{join item.modulos ", "}} |
{{/if}}

## Ângulos

Um ângulo é a razão específica pela qual alguém clicaria, lida, não o tema. Cada campanha usa um ângulo diferente; ângulo já usado numa peça da mesma campanha não se repete.

| Ângulo | Em uma frase | Funciona para (público, estágio) | Já usado em (campanha, data) |
|---|---|---|---|
| Dor | `[PENDENTE: preencher]` — ponto de partida: "{{item.dor_principal}}" | | |
| Resultado | `[PENDENTE: preencher]` — ponto de partida: "{{item.promessa}}" | | |
| Mecanismo (como funciona) | `[PENDENTE: preencher]` | | |
| Contrariano (crença a derrubar) | `[PENDENTE: preencher]` | | |
| Custo de não agir | `[PENDENTE: preencher]` | | |
| Identidade (para quem é) | `[PENDENTE: preencher]` | | |

## Provas

Nenhum número, case ou depoimento entra sem fonte e status. Fala de cliente só com aprovação registrada.

| Prova | Tipo (dado · case · depoimento · tela) | Fonte | Status | Onde cabe |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | | `[NECESSITA FONTE]` | |

## Objeções por público

Objeções de `cortex.config.yaml › publicos[]`. Os públicos deste produto são **{{join item.publicos ", "}}** — manter só as linhas deles e completar a resposta que o copy dá.

| Público | Dor | Objeção | Como o copy responde |
|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` — {{pu.nome}} | {{pu.dor}} | {{pu.objecao}} | `[PENDENTE: preencher]` |
{{/each}}

## Termos

| Usar | Evitar | Por quê |
|---|---|---|
| nome oficial: **{{item.nome}}** | apelido, abreviação, nome antigo | grafia do config |
{{#if item.modulos}}{{#each item.modulos as m}}| `{{m}}` (nome do módulo em minúscula, como prática) | nome do módulo como rótulo de produto em peça que não pode nomear produto | quem não é cliente lê como prática; quem é reconhece |
{{/each}}{{/if}}| `[PENDENTE: preencher]` | | |

Termos proibidos e preferidos da marca: `contexto/brandcenter/brandcenter.md` e `redator-comum`.

## O dia do público — matéria-prima de copy

Rotina concreta de quem usa ou compra {{item.nome}}: a semana, o fechamento, o campo e o escritório, a reunião, o que dói e não se fala, a carreira. Frases marcadas com fonte (entrevista, call, pesquisa); sem fonte, `[INFORMADO PELO CLIENTE]`.

- `[PENDENTE: preencher]`

## Copies que foram ao ar

Uma seção por campanha. Cada peça: canal · hook ou headline · copy · CTA · resultado observado (com fonte) · por que funcionou.

### Campanha: `[PENDENTE: nome]`

**Conceito:** `[PENDENTE: preencher]`

{{#each canais as c}}#### `{{c.slug}}`
- **Headline / gancho:** `[PENDENTE: preencher]`
- **Copy:** `[PENDENTE: preencher]`
- **CTA:** `[PENDENTE: preencher]`
- **Resultado:** `[NECESSITA FONTE]`

{{/each}}

## Por que estes copies funcionaram

- **Headlines:** `[PENDENTE: preencher]`
- **Aberturas:** `[PENDENTE: preencher]`
- **CTAs que funcionam:** `[PENDENTE: preencher]`
- **CTAs que não funcionam:** `[PENDENTE: preencher]`
- **Mercado × clientes:** `[PENDENTE: preencher]`

## Como atualizar este arquivo

1. No fechamento do ciclo, listar as peças de {{item.nome}} com melhor resultado (fonte: `analisar-performance`).
2. Para cada uma: canal, texto como foi ao ar, CTA, resultado com fonte, por que funcionou.
3. Copy que foi ao ar antes de uma regra atual de `redator-comum` entra já corrigido, com nota do que mudou.
4. Registrar a atualização no `## Histórico` abaixo.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
