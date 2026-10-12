# Geração da camada de contexto — espelho legível do `cortex build`

> Use este guia quando **não há Python** na sessão (ferramenta só com a pasta montada) e o questionário já produziu o `cortex.config.yaml`. Ele descreve, campo a campo, o que o `cortex build --first-run` geraria, para que a IA gere os mesmos arquivos à mão. Quando houver Python, rode o build: ele é a fonte de verdade e o `doctor` concilia depois.

## 1. Regras gerais
- Todo arquivo gerado nasce com o frontmatter de 14 campos (`_cortex/CONTRATOS.md` §2), `origem: gerado-inicial` (contexto, editável pelo time) ou `origem: gerado` (raiz e wrappers, regenerados).
- Arquivo de contexto que já existe **não** é sobrescrito.
- Tudo que o config não informou fica como `[PENDENTE: preencher]` — nunca invente.
- Templates em `_cortex/templates/`: leia o `.tpl` correspondente e substitua `{{…}}` pelos valores do config, resolvendo `{{#if}}`/`{{#each}}` conforme `_cortex/CONTRATOS.md` §7.

## 2. Campo → template → arquivo

| Campo do config | Template | Arquivo gerado | Observações |
|---|---|---|---|
| `organizacao`, `times`, `papeis`, `operacao`, `governanca` | `organizacao.md.tpl` | `contexto/organizacao.md` | tabela papel → quem ocupa hoje (nomes só aqui) |
| `marcas[]` (todas) | `brandcenter.md.tpl` | `contexto/brandcenter/brandcenter.md` | arquitetura mãe × filhas quando há mais de uma |
| cada `marcas[i]` | `marca.md.tpl` (`item` = marca) | `contexto/brandcenter/marcas/<slug>.md` | |
| cada `produtos[i]` | `produto.md.tpl` (`item` = produto) | `contexto/produtos/<slug>/<slug>.md` | uma seção por módulo |
| cada `publicos[i]` | `publico.md.tpl` | `contexto/publicos/<slug>.md` | |
| cada `vozes[i]` | `voz.md.tpl` (se existir; senão `doc.md.tpl`) | `contexto/vozes/<slug>.md` | |
| cada `integracoes[i]` | `integracao.md.tpl` | `contexto/integracoes/<slug>.md` | `id: integracao-<slug>`; gate antes da 1ª chamada |
| `operacao.ciclo_planejamento` | `briefing.md.tpl` | `briefings/_modelo.md` + pasta `briefings/<ciclo-atual>/` | ciclo: `AA-MM` (mensal), `AA-QN` (trimestral), `sprint-NN` |
| `governanca.telemetria`, `governanca.git` | `env.example.tpl`, `gitignore.tpl` | `.env.example`, `.gitignore` | |
| `sessao.ambiente` contém `claude-code` | `settings.json.tpl` | `.claude/settings.json` | hooks + permissão do CLI |
| `packs[]` | `_cortex/packs/<id>/**/*.tpl` | `times/<time>/{agents,skills,docs}/…` | só arquivos das sub-famílias com `condicao` verdadeira (+ `arquivos_base`); `origem: pack:<id>@<versao>` |
| tudo acima + frontmatters | `ROTAS.md.tpl` | `ROTAS.md` | §1 só sub-famílias ativas; §5 inativas com motivo |
| tudo acima | `AGENTS.md.tpl`, `CLAUDE.md.tpl`, `ABERTURA-SESSAO.md.tpl` | `AGENTS.md`, `CLAUDE.md`, `ABERTURA-SESSAO.md` | o último é o texto que se cola na 1ª mensagem em ferramentas sem hook |
| varredura dos `.md` | `CATALOGO.md.tpl` | `CATALOGO.md` | id, caminho, KB, tokens (bytes ÷ 3,6), requires, consumido por |
| tudo acima | `boot.md.tpl` | `_cortex/.build/boot.md` | ≤ 3 KB |
| cada skill/sub-skill | `skill-wrapper.tpl` | `.claude/skills/<id>/SKILL.md` | só se `claude-code` no ambiente |
| cada agente com `subagente: true` | `agent-wrapper.tpl` | `.claude/agents/<id>.md` | idem |

## 3. Avaliação das condições dos packs (sem Python)
Para cada sub-família do `pack.yaml`, avalie `condicao` com a tabela de `_cortex/CONTRATOS.md` §6 contra o config. Exemplo: `canal:email` é verdadeiro se existe `{slug: email}` em `canais[]`; `modelo_comercial:B2B or modelo_comercial:B2B2C` é verdadeiro para B2B. Sub-família falsa → não instancie os arquivos dela e liste-a em `ROTAS.md` §5 com o motivo ("nenhum canal `email` configurado").

## 4. Checklist manual (substitui o `doctor` até haver Python)
- [ ] Todo `.md` novo tem os 14 campos na ordem, `id` igual ao nome do arquivo em kebab-case, `owner` é um slug de `papeis[]` (ou `cortex`).
- [ ] Nenhum `{{` ou `}}` sobrou em arquivo gerado.
- [ ] Todo caminho citado em crase existe.
- [ ] `ROTAS.md` §1 só tem famílias cujo canal/integração/oferta existe no config.
- [ ] `AGENTS.md` §4 cita o registro primário certo.
- [ ] Nenhum token, senha ou URL de webhook em `.md` (só no `.env`).
- [ ] `meta.onboarding.status` reflete o que foi respondido.
- [ ] Liste para a pessoa tudo que ficou `[PENDENTE: preencher]`.
