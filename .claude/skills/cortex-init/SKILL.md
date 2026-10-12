---
name: cortex-init
description: "Conduz o onboarding do Cortex: checkup da máquina e dos materiais, questionário bloco a bloco com AskUserQuestion, grava cortex.config.yaml, roda init/build e doctor, instala packs e explica o resultado. Use quando a pessoa disser: configurar o cortex, iniciar o onboarding, rodar o questionário, instalar um pack, revisar um bloco do config, o hook disse que o onboarding está pendente, não existe cortex.config.yaml."
---

# /cortex-init — onboarding do Cortex

Você conduz o questionário; o CLI **não** faz prompt interativo. Trabalhe sempre a partir da raiz do projeto (a pasta que contém `_cortex/`). Tudo em pt-BR, salvo se o checkup detectar outro idioma.

## 0. Checkup antes de perguntar

1. Rode `python3 _cortex/cli/cortex.py checkup`. Leia o resumo e, se precisar de detalhe, `_cortex/.build/checkup.json`. O que ele analisa e por quê: `_cortex/onboarding/checkup.md`.
2. Trate o resultado como **pista, não resposta**: integrações candidatas viram opções pré-marcadas em B6; idioma e ambientes em B0; git em B9; packs sugeridos em B10; "blocos com material" dizem quais arquivos abrir antes de perguntar (ex.: um manual de marca alimenta B2; um playbook alimenta o pack vendas).
3. Se houver alertas (Python fora do PATH, pasta sincronizada, instruções de IA pré-existentes), mostre-os à pessoa antes de seguir — dois deles mudam decisões: sem Claude Code → `sessao.gate: declarativo` e `ABERTURA-SESSAO.md` vira o ponto de entrada; pasta sincronizada → recomende git.
4. Se existir `cortex.config.yaml` com `meta.onboarding.status: complete`, ofereça com AskUserQuestion: *revisar um bloco* (pergunte qual), *instalar pack* (`pack suggest` → `pack install <id> --time <slug>` → `build` → `doctor`) ou *só rodar doctor*. Não refaça o questionário inteiro. Se for `partial`, retome no primeiro bloco fora de `blocos_concluidos`.

## 1. Questionário — um bloco por rodada

Abra `_cortex/onboarding/questionario.md`. Para **cada bloco** (B0 … B10), na ordem:

- Se o bloco tem `condicao` e ela é falsa para as respostas já dadas, **pule** e registre o id em `meta.onboarding.assumidos` com o padrão indicado.
- Antes de perguntar, **abra os materiais que o checkup apontou para o bloco** e proponha respostas extraídas deles, citando o arquivo. A pessoa confirma ou corrige.
- Faça **uma única chamada de AskUserQuestion por bloco**, com todas as perguntas do bloco (cada uma com opções quando o questionário as dá; a sugerida pelo checkup vem marcada como recomendada). Nunca mais de uma rodada por bloco; nunca invente resposta.
- Se a pessoa não souber, use o padrão do questionário e registre em `assumidos`.
- Converta as respostas para os campos do schema (`_cortex/onboarding/schema/cortex.config.schema.json`): slugs em kebab-case, enums exatos, listas inline `[a, b]`. Papéis são **papéis**, nunca nomes de pessoa.
- Em B10, rode `python3 _cortex/cli/cortex.py pack list` e `pack suggest` e mostre só packs que existem; para cada um, pergunte em qual time entra (`time_padrao` é a sugestão). Packs sem o `requer_config` preenchido não entram.

## 2. Gravar e gerar

1. Monte o YAML completo (todas as chaves do schema: `meta, sessao, organizacao, marcas, produtos, canais, integracoes, times, papeis, operacao, governanca, packs, rotas`). Use `_cortex/onboarding/exemplos/*.yaml` como referência de forma. `meta.onboarding.status: complete` só com todos os blocos feitos ou assumidos.
2. Mostre o YAML no chat e confirme. Grave em `cortex.config.yaml` na raiz.
3. Rode `python3 _cortex/cli/cortex.py init --answers cortex.config.yaml` — valida o schema, grava, roda `build --first-run` (gera `contexto/**`, `briefings/_modelo.md`, `.env.example`, `.gitignore`, `.claude/settings.json`), instala os packs de `packs[]`, gera `ROTAS.md`, `AGENTS.md`, `CLAUDE.md`, `ABERTURA-SESSAO.md`, `CATALOGO.md`, `boot.md` e os wrappers, e roda `doctor`.
   - Se o `init` recusar as respostas, corrija o YAML (a mensagem diz o caminho do campo) e rode de novo — não peça tudo outra vez.
   - Alternativa manual: `build --first-run` + `pack install <id> --time <slug>` + `build` + `doctor`.

## 3. Explicar o resultado

- Resuma o `doctor`: ERRO (corrigir antes de produzir) × AVISO (pode seguir; liste os `[PENDENTE: …]` que o time precisa preencher em `contexto/` e `times/`).
- Mostre o que foi gerado e onde o time edita: `contexto/organizacao.md` (quem ocupa cada papel), `contexto/brandcenter/`, `contexto/produtos/<slug>/`, `contexto/integracoes/<slug>.md`, `times/<time>/`.
- Se o ambiente não tiver hooks (sem Claude Code), entregue o texto de `ABERTURA-SESSAO.md` e explique que ele abre toda sessão.
- Encerre com os próximos passos: preencher `[PENDENTE]`, reiniciar a sessão (o hook injeta o `boot.md`), `python3 _cortex/cli/cortex.py doctor` como rotina na periodicidade de `governanca.auditoria`, e `pack suggest` quando o contexto mudar (novo canal, nova integração, novo time).
