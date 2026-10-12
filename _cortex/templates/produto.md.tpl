---
tipo: doc
id: {{item.slug}}
descricao: "Documenta {{item.nome}}: posicionamento, públicos, dor, promessa, módulos, objeções, concorrência, provas e o que nunca afirmar."
familia:
output: nenhum
canal:
ferramenta:
produto: {{item.slug}}
publico:
gatilhos: ["o que é {{item.nome}}", "para quem é {{item.nome}}", "qual a promessa de {{item.nome}}", "quais módulos tem {{item.nome}}", "objeções de {{item.nome}}", "concorrentes de {{item.nome}}"]
requires: brandcenter
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# {{item.nome}} (`{{item.slug}}`) — doc-raiz da oferta

> **Abra este arquivo primeiro** sempre que a demanda citar {{item.nome}} (`ROTAS.md` §3.1). Filhos (um `.md` por módulo, objeções, concorrência) só se a resposta não estiver aqui. Gerado pelo `cortex init`; o time é dono. Número, preço e métrica **não** entram aqui sem fonte (`_cortex/kernel/anti-alucinacao.md`).

## 1. Posicionamento

- **Tipo de oferta:** {{item.tipo}} · **marca:** `{{item.marca}}` (ficha: `../../brandcenter/marcas/{{item.marca}}.md`)
- **Em uma frase:** [PENDENTE: preencher — para quem, resolve o quê, diferente de quê]
- **Categoria em que compete:** [PENDENTE: preencher]

## 2. Públicos

{{#if tem:item.publicos}}{{#each item.publicos as p}}- [`{{p}}`](../../publicos/{{p}}.md)
{{/each}}{{else}}- [PENDENTE: preencher — slugs de `publicos[]` no config]
{{/if}}
## 3. Dor e promessa

- **Dor principal:** {{default item.dor_principal "[PENDENTE: preencher]"}}
- **Promessa:** {{default item.promessa "[PENDENTE: preencher]"}}
- **Como a promessa se prova:** [PENDENTE: preencher — funcionalidade, dado com fonte ou case]

## 4. Módulos e funcionalidades

{{#if tem:item.modulos}}{{#each item.modulos as m}}### 4.{{@index}} Módulo `{{m}}`
- **O que faz:** [PENDENTE: preencher]
- **Dor que resolve:** [PENDENTE: preencher]
- **Para qual público:** [PENDENTE: preencher]

{{/each}}{{else}}Sem módulos declarados no config. [PENDENTE: preencher — funcionalidades principais, uma por linha]
{{/if}}
## 5. Objeções e respostas

| Objeção | Resposta aprovada | Prova |
|---|---|---|
| [PENDENTE: preencher] | [PENDENTE: preencher] | [PENDENTE: preencher] |

## 6. Concorrência

| Concorrente | Onde ganha | Onde perdemos | Como posicionar |
|---|---|---|---|
| [PENDENTE: preencher] | [PENDENTE: preencher] | [PENDENTE: preencher] | [PENDENTE: preencher] |

## 7. Provas e cases

- [PENDENTE: preencher — case, depoimento aprovado, dado com fonte e data]
- Sem prova documentada aqui, a peça usa o marcador de incerteza — nunca inventa.

## 8. O que nunca afirmar

- Nunca prometer resultado numérico sem fonte nesta seção.
- Nunca citar cliente sem autorização registrada.
- [PENDENTE: preencher — afirmações juridicamente ou comercialmente proibidas]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
