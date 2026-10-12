---
tipo: doc
id: catalogo
descricao: "Lista todos os arquivos da base com id, caminho, peso, família, requires e quem os consome, mais os vocabulários vigentes."
familia:
output: roteamento
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual o caminho desse arquivo", "quanto pesa esse arquivo", "quem consome essa skill", "quais valores posso usar no frontmatter", "qual o vocabulário de canal"]
requires: rotas
owner: cortex
origem: gerado
validado_em: {{agora}}
---
<!-- gerado pelo cortex build a partir de _cortex/templates/CATALOGO.md.tpl — não edite; é consulta sob demanda, fora do force-load -->

# CATALOGO.md — inventário da base · {{organizacao.nome}}

> Consulta sob demanda: abra quando a rota não resolveu o caminho ou quando precisa saber o custo de um arquivo antes de abrir. Tokens ≈ bytes ÷ 3,6. Arquivos com ⚓ passam de {{governanca.limites.aviso_kb}} KB: abra **por seção**, pelas âncoras listadas no fim.

## 0. Vocabulários vigentes (derivados de `cortex.config.yaml`)

| Campo | Valores |
|---|---|
| `tipo` | agent · skill · sub-skill · doc · pack |
| `familia` | {{join vocabularios.familia " · "}} |
| `output` | {{join vocabularios.output " · "}} |
| `canal` | {{join vocabularios.canal " · "}} |
| `ferramenta` | {{join vocabularios.ferramenta " · "}} |
| `produto` | {{join vocabularios.produto " · "}} |
| `publico` | {{join vocabularios.publico " · "}} |
| `owner` | {{join vocabularios.owner " · "}} |

## 1. Arquivos

| id | tipo | arquivo | KB | ~tokens | família | requires | consumido por |
|---|---|---|---|---|---|---|---|
{{#each catalogo as r}}| {{#if r.ancora}}⚓ {{/if}}`{{r.id}}` | {{r.tipo}} | `{{r.caminho}}` | {{r.kb}} | {{r.tokens}} | {{r.familia}} | {{join r.requires " · "}} | {{join r.consumido_por " · "}} |
{{/each}}

Total: {{len catalogo}} arquivos · {{total_kb}} KB · ≈{{total_tokens}} tokens.

## 2. Âncoras dos arquivos pesados

{{#if tem:ancoras}}{{#each ancoras as a}}### `{{a.id}}` ({{a.kb}} KB)
{{#each a.secoes as s}}- {{s}}
{{/each}}
{{/each}}{{else}}Nenhum arquivo acima de {{governanca.limites.aviso_kb}} KB.{{/if}}

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex build`. | cortex |
