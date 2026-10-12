---
tipo: doc
id: organizacao
descricao: "Descreve a organização, o modelo comercial, os times e papéis, o ciclo de planejamento e a governança do Cortex."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quem somos", "como a empresa funciona", "quais times existem", "quem ocupa o papel de", "qual o ciclo de planejamento", "quem ratifica mudanças na base"]
requires:
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# {{organizacao.nome}} — organização

> Gerado pelo `cortex init` a partir de `cortex.config.yaml`. **Este arquivo é do time:** o `build` não o sobrescreve (só com `--first-run`). Preencha os `[PENDENTE: …]` e registre no `## Histórico`. Dados estruturais (slugs, canais, papéis) vivem no config — mude lá e rode `build`.

## 1. Organização

- **Nome:** {{organizacao.nome}} (`{{organizacao.slug}}`)
- **Segmento:** {{organizacao.segmento}}
- **Porte:** {{default organizacao.porte "[PENDENTE: preencher]"}}
- **O que faz:** {{default organizacao.descricao "[PENDENTE: preencher em uma frase]"}}
- **Marca-mãe:** {{marca_mae.nome}} · marcas: {{#each marcas as m}}{{m.nome}} (`{{m.slug}}`){{#if @last}}{{else}} · {{/if}}{{/each}} — detalhe em `contexto/brandcenter/brandcenter.md`
- **Ofertas:** {{#each produtos as p}}`{{p.slug}}` {{p.nome}} ({{p.tipo}}){{#if @last}}{{else}} · {{/if}}{{/each}} — doc-raiz em `contexto/produtos/<slug>/<slug>.md`

## 2. Modelo comercial

- **Modelo:** {{organizacao.modelo_comercial}}
- **Como vendemos hoje:** [PENDENTE: preencher — canal de venda, ciclo médio, quem decide a compra]
- **Públicos:** {{#each publicos as p}}`{{p.slug}}` {{p.nome}} ({{p.tipo}}){{#if @last}}{{else}} · {{/if}}{{/each}} — fichas em `contexto/publicos/`
- **Canais ativos (por prioridade):** {{#each canais as c}}{{c.slug}}{{#if @last}}{{else}} · {{/if}}{{/each}}

## 3. Times e papéis

{{#each times as t}}### Time `{{t.slug}}` — {{t.nome}}{{#if t.pack}} (pack `{{t.pack}}`){{/if}}

| Papel | Quem ocupa hoje | Responsabilidades |
|---|---|---|
{{#each t.papeis as p}}| `{{p}}` | [PENDENTE: preencher] | ver `papeis[]` no config |
{{/each}}
{{/each}}
**Papéis sem time:** {{#each papeis as p}}{{#if p.time}}{{else}}`{{p.slug}}` ({{p.nome}}) {{/if}}{{/each}}

> `owner:` no frontmatter é sempre um **slug de papel**, nunca nome de pessoa. Esta tabela é o único lugar onde pessoa e papel se encontram.

## 4. Ciclo e rotina

- **Ciclo de planejamento:** {{operacao.ciclo_planejamento}}{{#if operacao.ciclo_planejamento == "nenhum"}} — sem ciclo formal; briefings avulsos em `briefings/avulso/`{{else}} — briefings em `briefings/<ciclo>/`, modelo em `briefings/_modelo.md`{{/if}}
- **Reuniões e rituais:** [PENDENTE: preencher — quando o time planeja, revisa e registra]

## 5. Destino do material gerado

- **Registro primário:** {{#if tem:registro_primario}}{{registro_primario.nome}} (`contexto/integracoes/{{registro_primario.slug}}.md`){{else}}nenhum sistema externo — `_saida/<AAAA-MM>/`{{/if}}
- **Material gerado vai para:** {{#if operacao.destino_material_gerado == "registro"}}o registro primário{{/if}}{{#if operacao.destino_material_gerado == "saida-local"}}`_saida/<AAAA-MM>/`{{/if}}{{#if operacao.destino_material_gerado == "chat"}}o próprio chat{{/if}}
- **Chat antes do arquivo:** {{#if operacao.fluxo_chat_antes_do_arquivo}}sim — gere no chat, pergunte onde salvar{{else}}não — grave direto quando o destino for claro{{/if}}
- **Arquivo novo sem pedido:** {{#if operacao.criar_arquivo_sem_pedido}}permitido, com frontmatter válido{{else}}proibido{{/if}}

## 6. Governança

- **Comitê de IA:** {{#if governanca.comite}}sim{{else}}não{{/if}} · **ratificador:** `{{governanca.ratificador}}`
- **Git:** {{#if governanca.git}}sim — commit a cada mudança na base{{else}}não{{/if}}
- **Telemetria:** {{#if governanca.telemetria.ativa}}ativa (`{{governanca.telemetria.destino_env}}` no `.env`){{else}}desativada{{/if}}
- **Dados que nunca entram em prompt:** {{join governanca.dados_proibidos_em_prompt " · "}}
- **Limites por `.md`:** aviso em {{governanca.limites.aviso_kb}} KB · erro em {{governanca.limites.erro_kb}} KB · binários acima de {{default governanca.limites.binario_mb "2"}} MB vão para `_assets/`
- **Mudança na base:** só conhecimento operacional reutilizável, com frontmatter válido e linha no `## Histórico`; ratificação do `{{governanca.ratificador}}`.

## 7. Auditoria

- **Periodicidade:** {{default governanca.auditoria.periodicidade "sob demanda"}}{{#if tem:governanca.auditoria.quando}} ({{governanca.auditoria.quando}}){{/if}}
- **Como:** `{{default sessao.python "python3"}} _cortex/cli/cortex.py doctor` — relatório em `_cortex/.build/last-doctor.json`; corrigir ERRO antes de AVISO.
- **Responsável:** [PENDENTE: preencher — papel que roda a auditoria]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
