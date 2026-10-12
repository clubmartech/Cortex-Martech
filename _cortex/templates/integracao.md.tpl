---
tipo: doc
id: integracao-{{item.slug}}
descricao: "Documenta a integração {{default item.nome item.slug}}: o que é, permissões, gate antes da primeira chamada e como citar o que volta."
familia:
output: nenhum
canal:
ferramenta: {{item.slug}}
produto: todos
publico:
gatilhos: ["como usar o {{default item.nome item.slug}}", "o que posso fazer no {{default item.nome item.slug}}", "posso escrever no {{default item.nome item.slug}}", "ficha da integração {{item.slug}}"]
requires:
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# Integração: {{default item.nome item.slug}} (`{{item.slug}}`)

> Abra esta ficha **antes da primeira chamada** ao conector nesta sessão (`ROTAS.md` §3.2). Gerado pelo `cortex init`; o time edita.

## 1. O que é

- **Tipo:** `{{item.tipo}}`{{#if item.registro_primario}} · **registro primário da operação**{{/if}}
- **Somente leitura:** {{#if item.somente_leitura}}**sim** — nunca cria, altera ou apaga nada por este conector{{else}}não — escrita permitida dentro das regras de §4{{/if}}
- **É MCP / conector direto na IA:** {{#if item.mcp}}sim{{else}}não — acesso manual ou por automação externa{{/if}}
- **Para que o time usa:** [PENDENTE: preencher]

## 2. Antes da primeira chamada (gate)

1. A linha `LIDOS:` já foi declarada (nada de conector antes do gate — `_cortex/kernel/gate.md`).
2. Esta ficha foi aberta e o pedido cabe no que §1 permite.
3. Dados proibidos em prompt não entram na chamada: {{join governanca.dados_proibidos_em_prompt " · "}}.
4. Se a chamada escreve algo, a pessoa confirmou o destino **nesta sessão**.

## 3. Como citar o que volta

Todo dado vindo deste conector recebe o marcador `[CONECTOR: {{default item.nome item.slug}} · AAAA-MM-DD]` ao lado do número ou lista. Sem marcador, o dado é tratado como não verificado (`_cortex/kernel/anti-alucinacao.md`).

## 4. O que nunca escrever

{{#if item.somente_leitura}}- Nada: integração somente leitura.
{{else}}- Nunca apagar registros; nunca alterar o que outra pessoa criou sem pedido explícito.
- [PENDENTE: preencher — campos, listas ou status que só humano muda]
{{/if}}
## 5. Campos a preencher

- **Estrutura (schema / listas / pastas / espaços):** [PENDENTE: preencher]
- **Onde o material gerado entra:** [PENDENTE: preencher{{#if item.registro_primario}} — texto publicado, arte publicada, resultado com análise{{/if}}]
- **Convenções de nome:** [PENDENTE: preencher]
- **Dono do acesso:** [PENDENTE: preencher — papel, nunca pessoa]

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
