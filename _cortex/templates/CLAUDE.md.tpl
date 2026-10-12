---
tipo: doc
id: claude
descricao: "Injeta a fundação no início da sessão do Claude Code e aponta o AGENTS.md como fonte canônica."
familia:
output: roteamento
canal:
ferramenta:
produto: todos
publico:
gatilhos: []
requires: agents · gate · anti-alucinacao · governanca · rotas
owner: cortex
origem: gerado
validado_em: {{agora}}
---
<!-- gerado pelo cortex build a partir de _cortex/templates/CLAUDE.md.tpl — não edite; edite a fonte e rode `cortex build` -->

# CLAUDE.md — atalho

> Este projeto usa **`AGENTS.md`** como instrução canônica (padrão aberto, multi-IA). **Leia e siga `./AGENTS.md`.**
> O hook de início de sessão roda `cortex doctor --quick` e injeta `_cortex/.build/boot.md` (resumo do config, famílias ativas e agentes). Os `@import` abaixo carregam a fundação. A declaração de leituras segue `sessao.declaracao_leituras`; nunca trate o resumo como prova de leitura integral.
> 🚫 Nunca leia `_arquivo/`. 🚫 Nunca edite arquivo com `origem: gerado` — edite a fonte e rode `python3 _cortex/cli/cortex.py build`.
> {{#if operacao.criar_arquivo_sem_pedido}}Arquivo novo na base só com frontmatter válido.{{else}}**Nunca crie arquivo novo nesta pasta sem pedido explícito.**{{/if}}

@AGENTS.md
@_cortex/kernel/gate.md
@contexto/brandcenter/brandcenter.md
@_cortex/kernel/anti-alucinacao.md
