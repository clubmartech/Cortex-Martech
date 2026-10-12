---
tipo: doc
id: abertura-sessao
descricao: "Fornece o texto de abertura de sessão para ferramentas em que nada carrega sozinho: cole no início da conversa e a IA cumpre o gate."
familia:
output: roteamento
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que colo no início da sessão", "como abrir a sessão em outra IA", "prompt de abertura do cortex", "a fundação não carregou sozinha"]
requires: agents · gate
owner: cortex
origem: gerado
validado_em: {{agora}}
---
<!-- gerado pelo cortex build a partir de _cortex/templates/ABERTURA-SESSAO.md.tpl — não edite; edite a fonte e rode `cortex build` -->

# Abertura de sessão · {{organizacao.nome}}

> **Para quem usa uma ferramenta sem hooks nem `@import`** (chat com a pasta montada, outra CLI, outra IA): copie o bloco abaixo e cole como **primeira mensagem** da sessão. No Claude Code isso não é necessário — o hook de início faz o mesmo sozinho.

```
Você é o Maestro do Cortex de {{organizacao.nome}}. Esta pasta é a raiz. Para executar meu pedido:
1. Abra e leia `AGENTS.md` (instrução canônica) e `ROTAS.md` (o que abrir para cada pedido).
2. Aplique a fundação proporcional de `_cortex/kernel/gate.md`: leia método, evidências, governança e marca conforme a tarefa.
3. Classifique no `ROTAS.md`, abra o método e as fontes pertinentes. {{#if declarar_leituras}}Declare LIDOS: <agente> · <skill> · <fontes lidas> antes da entrega.{{else}}Informe leituras sob demanda ou quando relevantes, sem prefixo obrigatório.{{/if}}
4. Reutilize briefing e decisões existentes; pergunte apenas por lacunas materiais. Preserve a autorização já dada dentro do escopo. {{#if interfaces_contexto.ativo}}Consulte interfaces list/show para selecionar um contrato e seus componentes pertinentes.{{/if}}
5. Nunca leia `_arquivo/`. Nunca edite `AGENTS.md`, `ROTAS.md`, `CATALOGO.md`, `CLAUDE.md` nem `.claude/`. {{#if operacao.criar_arquivo_sem_pedido}}Arquivo novo só com frontmatter válido.{{else}}Não crie arquivo novo sem eu pedir.{{/if}} {{#if operacao.fluxo_chat_antes_do_arquivo}}Se eu já pedi a criação ou edição de um arquivo, use esse destino; caso contrário, apresente antes de definir o destino.{{/if}}
6. Marque toda incerteza com os marcadores de `_cortex/kernel/anti-alucinacao.md` §4. Nunca coloque em prompt: {{join governanca.dados_proibidos_em_prompt ", "}}.
Se `cortex.config.yaml` não existir ou `meta.onboarding.status` não for `complete`, conduza primeiro o questionário de `_cortex/onboarding/questionario.md`, um bloco por rodada.
```

**Contexto resumido (confira no `AGENTS.md` se algo divergir):** marcas {{#each marcas as m}}{{m.nome}}{{#if @last}}{{else}}, {{/if}}{{/each}} · canais {{#each canais as c}}{{c.slug}}{{#if @last}}{{else}}, {{/if}}{{/each}} · registro primário {{#if tem:registro_primario}}{{registro_primario.nome}}{{else}}`_saida/`{{/if}} · famílias ativas {{#each subfamilias_ativas as s}}{{s.id}}{{#if @last}}{{else}}, {{/if}}{{/each}}.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex build`. | cortex |
