---
tipo: doc
id: modelo-briefing
descricao: "Modela o briefing: direcional (01–07), leitura cruzada com a base, decisão do estrategista (08–10), checagem de suficiência e registro de decisões."
familia:
output: briefing
canal:
ferramenta: {{registro_primario.slug}}
produto: todos
publico:
gatilhos: ["qual o modelo de briefing", "como preencher o briefing", "template de briefing", "o que precisa ter num briefing", "como nomear o briefing", "ata de reunião", "registro de decisões"]
requires:
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# Modelo de briefing · {{organizacao.nome}}

> Ponto de partida único para briefing: **quem pede entrega o direcional** (campos 01–07) → a **IA cruza o direcional com a base** (Leitura cruzada) → o **estrategista decide e complementa** (08–10). **Não edite este arquivo** — copie o template, nomeie pela taxonomia e preencha. Diferente do cartão `BRIEFING VALIDADO ✅` (gate efêmero de chat, `_cortex/kernel/descoberta.md`): este é o documento persistido.
> Destino: {{#if tem:registro_primario}}{{registro_primario.nome}} (ficha `contexto/integracoes/{{registro_primario.slug}}.md`), com cópia local opcional em `briefings/<ciclo>/`{{else}}`briefings/<ciclo>/`{{/if}}.

## Como usar

1. **Copie** o template abaixo (do título "Briefing — …" até a Checagem). Nunca edite o modelo.
2. **Nomeie** pela taxonomia: `briefings/<ciclo>/{time}-{tipo}-{tema}.md` — kebab-case, sem acento. Ciclo {{operacao.ciclo_planejamento}}{{#if operacao.ciclo_planejamento == "mensal"}} → `AAAA-MM`{{/if}}{{#if operacao.ciclo_planejamento == "trimestral"}} → `AA-QN`{{/if}}{{#if operacao.ciclo_planejamento == "sprint"}} → `sprint-NN`{{/if}}{{#if operacao.ciclo_planejamento == "nenhum"}} → `avulso`{{/if}}. Ex.: `{{#each times as t}}{{#if @first}}{{t.slug}}{{/if}}{{/each}}-campanha-{{#each produtos as p}}{{#if @first}}{{p.slug}}{{/if}}{{/each}}.md`.
3. **Cole o direcional** nos campos 01–07 como recebido — nunca edite o texto original. Em cada campo, acrescente `➡️ Em uma frase:` com o resumo acionável.
4. **Preencha a Leitura cruzada** antes de acionar o estrategista: cadeia dor → público → oferta → prova a partir de `contexto/produtos/<slug>/<slug>.md` e `contexto/publicos/<slug>.md`; aponte sustentação, lacuna e divergência. É leitura e sugestão — nunca decisão.
5. **Pergunte antes de complementar** — 08–10 são do estrategista. Sem resposta, `[PENDENTE — aguardando definição do estrategista]`; nunca inferido.
6. **Marque a incerteza** com os marcadores de `_cortex/kernel/anti-alucinacao.md` §4.
7. **Declare no `requires`** o id do doc-raiz da oferta (ex.: `requires: modelo-briefing · {{#each produtos as p}}{{#if @first}}{{p.slug}}{{/if}}{{/each}}`).
8. **Rode a Checagem de suficiência** antes de liberar; sinalize lacuna no chat, sem travar.
9. **Registre** no destino acima; cópia local opcional.
10. **Apague estas instruções** no briefing final — o documento começa no título.

---

# Briefing — {Nome da ação}

**Oferta:** {slug de `produtos[]`} · **Ciclo:** {ciclo} · **Time:** {slug de `times[]`}

## Direcional (01–07)
> Cole o texto de quem pede, campo a campo — sem editar. Em cada campo, o resumo acionável.

## 01. Contexto da demanda
*O que aconteceu para que esta comunicação seja necessária agora?*
{...}
➡️ **Em uma frase:** {o quê fazer, para quem, com qual prova}

## 02. Objetivo
*O que esta demanda precisa gerar ou tornar claro para o público?*
{...}
➡️ **Em uma frase:** {...}

## 03. Público prioritário
*Para quem estamos falando? (slug de `publicos[]`)*
{...}
➡️ **Em uma frase:** {...}

## 04. Direcionamento estratégico
*O que deve ganhar protagonismo nesta demanda?*
{...}
➡️ **Em uma frase:** {...}

## 05. Mensagem que queremos sustentar
*Qual é a ideia principal que o público precisa compreender?*
{...}
➡️ **Em uma frase:** {...}

## 06. Fontes obrigatórias e complementares
*Quais docs da base são obrigatórios e quais são complemento?*
{...}
➡️ **Em uma frase:** {...}

## 07. Materiais complementares
*Apresentações, dados, demos, telas, pesquisas que precisam ser consideradas?*
{...}
➡️ **Em uma frase:** {...}

## Leitura cruzada — direcional × base (antes do estrategista)
> Preenchida pela IA. É leitura e sugestão, nunca decisão.

**A. Cadeia dor → público → oferta → prova**
{Dor} → {Público} → {Oferta/módulo} → {Prova com fonte}

**B. Match com o direcional**
- Sustentado por: {...}
- Lacuna ou divergência a resolver com o estrategista: {...}

**C. Correlações encontradas na base**
- Oferta / módulos: {caminho}
- Conteúdo já publicado: {caminho ou "nada encontrado"}
- Prova de cliente: {prova aprovada com fonte e data — ou "não há prova documentada para esta dor"}

> Não achar é resposta válida — declare explicitamente; não deixe item vazio.

## Complemento do estrategista (08–10)
> **A IA nunca preenche por conta própria.** Antes do 08, confirme **período de veiculação** e **meta numérica**.

**Período:** {...} · **Meta numérica:** {...}

## 08. Estratégia
{...}

## 09. Canais
{slugs de `canais[]` — confirmados, não inferidos}

## 10. Observações complementares
{...}

## Checagem de suficiência (antes de liberar)
- A dor (item A) está específica, não genérica? {sim/não + comentário}
- O público está amarrado à dor e à oferta? {sim/não + comentário}
- A mensagem (05) tem prova concreta? **Nomeie qual.** Sem prova: "sem prova documentada — lacuna" e siga.
- Ficou algum `[PENDENTE — aguardando definição do estrategista]`? Liste.
- **Conclusão:** {suficiente para produzir / lacuna em {X} — recomendo completar antes de liberar}

---

## Registro de decisões (atas)

Use esta seção quando o briefing nasce de reunião ou quando uma decisão muda o briefing. Uma linha por decisão; a IA transcreve, **não decide**.

| Data | Decisão | Quem decidiu (papel) | O que muda no briefing |
|---|---|---|---|
| {AAAA-MM-DD} | {...} | {slug de `papeis[]`} | {campo afetado} |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
