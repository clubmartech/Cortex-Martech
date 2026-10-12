# MELHORIAS-APLICADAS.md — o que o Cortex corrige por desenho

> Rastreabilidade entre o diagnóstico da base de origem (2026-10-03, 21 itens) e o mecanismo do Cortex que impede a recorrência de cada achado. Serve para auditar a cobertura e para explicar a quem vier de outra base por que as regras existem.

| Achado de origem | Problema | Mecanismo no Cortex | Onde |
|---|---|---|---|
| **S1** token de webhook em texto claro | credencial em `.md` que viaja por webhook/git | `doctor` check 9 (ERRO bloqueante por regex de token/secret/bearer/URL de webhook); telemetria só por `.env` (`CORTEX_TELEMETRY_URL/TOKEN`); `.env` ignorado pelo git; o hook `PreToolUse` recusa gravar `.md` com segredo | `lib/checks.py::check_seguranca`, `lib/telemetry.py`, `templates/env.example.tpl`, `templates/gitignore.tpl` |
| **S2** credenciais em script e CSV de leads na pasta sincronizada | segredo em código; dado pessoal no escopo | check 9 varre também `.py`, `.json`, `.yaml` no escopo; `governanca.dados_proibidos_em_prompt` entra no `AGENTS.md` §4 e no `boot.md`; `_saida/` e `_assets/` ficam fora do escopo e do git | `lib/checks.py`, `templates/AGENTS.md.tpl` |
| **S3** permissões amplas em `settings.local.json`; MCP declarado sem arquivo | ferramenta de IA com poder de apagar processos/arquivos | `settings.json` gerado só com os hooks e `Bash(python3 _cortex/cli/cortex.py *)`; nenhum `settings.local.json` é criado; MCP é descrito em `contexto/integracoes/<slug>.md` e detectado pelo `checkup` (só nomes) | `templates/settings.json.tpl`, `lib/checkup.py` |
| **R1** seis índices concorrentes | roteamento diverge | um `ROTAS.md` e um `CATALOGO.md`, ambos gerados do mesmo manifesto; matriz e inventário não existem; o hook recusa editar gerados; check 8 acusa drift | `lib/build.py`, `lib/catalog.py`, `lib/routes.py`, `hooks/pre_tool_use.py` |
| **R2** índices de domínio de 300 KB | arquivo que não cabe no orçamento | limites `aviso_kb`/`erro_kb` (check 7); arquivo grande exige `## Sumário` e o catálogo lista âncoras; docs por item (`criatividade-<produto>`, `ficha-produto-<produto>`, `fonte-<integração>`) nascem fatiados | `lib/checks.py::check_tamanho`, `packs/*/pack.yaml › itens` |
| **R3** tabela de agentes em dois lugares; governança espelhada | fonte única violada | tabela de agentes só no `ROTAS.md` §2 (gerada); um único `governanca.md` no kernel; `AGENTS.md` aponta, não repete | `templates/ROTAS.md.tpl`, `kernel/governanca.md` |
| **A1** gate só declarativo; nada carrega no Cowork | qualidade depende de o modelo lembrar | `SessionStart` injeta `boot.md` e roda `doctor --quick`; `PreToolUse` bloqueia `_arquivo/`, gerados e `.md` inválido; para ambientes sem hook, `ABERTURA-SESSAO.md` (gerado) é o texto de abertura e `AGENTS.md` §0 instrui a abrir a fundação | `hooks/session_start.py`, `hooks/pre_tool_use.py`, `templates/ABERTURA-SESSAO.md.tpl` |
| **A2** `.claude/` sem recursos nativos | sem acionamento por descrição nem subagentes | wrappers gerados em `.claude/skills/<id>/SKILL.md` para toda skill; `.claude/agents/<id>.md` para agentes `subagente: true`; 4 skills de sistema (`cortex-init/doctor/build/new`) | `lib/wrappers.py` |
| **H1** vocabulário, integrações e pessoas fixos no texto | base não portável | tudo deriva de `cortex.config.yaml`: vocabulários (`canal`, `ferramenta`, `produto`, `publico`, `owner`), marcas, registro primário, famílias ativas; kernel e packs não citam marca/produto/ferramenta literal; `checkup` + questionário adaptam ao contexto | `lib/config.py`, `lib/ctx.py`, `onboarding/questionario.md` |
| **H2** nome de pessoa como owner | arquivo órfão quando a pessoa sai | `owner` só aceita slug de `papeis[]` ou `cortex` (check 3); nomes vivem apenas em `contexto/organizacao.md` | `lib/checks.py::check_frontmatter`, `templates/organizacao.md.tpl` |
| **N1** regra de nomes híbrida e prática divergente | busca e `id` quebram | regra única (kebab-case, sem acento, `.agent.md` para agente) + check 11 (nomenclatura) + `id` determinístico derivado do nome (check 3) | `CONTRATOS.md` §2.1, `lib/checks.py::check_nomenclatura` |
| **N2** pastas vazias, esqueletos, restos de git | ruído no escopo | check 1 valida a estrutura; `_cortex/.build/` e `__pycache__/` ignorados; o build cria só as pastas que o config pede | `lib/checks.py::check_estrutura`, `templates/gitignore.tpl` |
| **D1** duplicatas de conteúdo e mídia; conflitos de sincronização | versão errada citada; peso | check 12 (corpo idêntico = aviso; `id` repetido = erro); check 11 acusa `(1)`, `.bak`, `-1.md`, cópias de conflito; `.gitignore` cobre padrões de conflito; `checkup` alerta pasta sincronizada; `build` grava só se o hash mudou | `lib/checks.py::check_duplicatas`, `lib/fs.py` |
| **D2** binários na pasta sincronizada; `.md` gigantes | contexto estoura; git pesado | `_assets/` fora do escopo; check 9 avisa binário > `binario_mb` no escopo; `.gitignore` exclui mídia; limites de KB (check 7) | `lib/scope.py`, `templates/gitignore.tpl` |
| **G1** referências mortas na fundação | IA tenta abrir o que não existe | check 5 (links e caminhos em crase devem existir; `_arquivo/` como fonte = erro); `requires` deve resolver (check 3) | `lib/checks.py::check_links` |
| **G2** encoding corrompido em artefato gerado | acentos quebrados | tudo é gravado UTF-8 sem BOM e LF; check 13 acusa BOM, CRLF, não-UTF-8 e mojibake, com `--fix` para BOM/CRLF | `lib/fs.py`, `lib/checks.py::check_encoding` |
| **G3** histórico de auditorias de 132 KB | arquivo único cresce sem fim | `doctor` grava apenas `_cortex/.build/last-doctor.json` (sobrescrito); histórico por arquivo na tabela `## Histórico`, completo no git quando `governanca.git` | `lib/checks.py::check_historico`, `kernel/governanca.md` |
| **I1** role da chave de dados não confirmado | IA pode escrever no banco | `integracoes[].somente_leitura` é campo do config; a ficha `contexto/integracoes/<slug>.md` exige declarar e o `checkup` sugere `somente_leitura: true` para dados/analytics | `templates/integracao.md.tpl`, `lib/checkup.py` |
| **I2** webhook envia tudo ao repositório | segredo e binário vazam | sem webhook no kernel; git como trilha; telemetria opt-in e separada do versionamento | `kernel/governanca.md` §histórico |
| **Z2–Z4** (pasta irmã) corpus duplicado, scripts com caminho fixo, índices redundantes | análise enviesada; scripts quebram ao mover | checks 11–13 cobrem duplicata e nomes; o CLI descobre a raiz subindo até `_cortex/` (nenhum caminho fixo); um índice só (`CATALOGO.md`) | `lib/scope.py::descobrir_raiz`, `lib/catalog.py` |
| **Backlog 4/13** prompt de abertura para Cowork; hooks | ambiente sem autoload | `ABERTURA-SESSAO.md` gerado; hooks (acima) | — |
| **Backlog 19** `cortex.config.yaml` + de-para pessoa→papel | portabilidade | é a base do Cortex; `contexto/organizacao.md` guarda o de-para | — |

## O que continua sendo responsabilidade humana
- Rotacionar os segredos já expostos na base de origem (o Cortex impede os novos, não revoga os antigos).
- Preencher os `[PENDENTE: preencher]` de `contexto/` e `times/` — o esqueleto é gerado, o conhecimento não.
- Decidir git vs. pasta sincronizada; o `checkup` só alerta.
- Ratificar skills novas (`governanca.ratificador`) e manter o `## Histórico` ao editar.

| **Portabilidade macOS/Linux** (primeira instância, 2026-10-03) | `python` não existe por padrão no macOS (só `python3`): hooks, settings e instruções falhavam em silêncio | todo comando do kernel, templates, skills e hooks chama `python3`; o hook de sessão da instância usa `python3` explícito | `.claude/settings.json`, `_cortex/templates/settings.json.tpl`, templates e kernel |

## 2026-10-04 — 0.2.0-local.1, atualização solicitada pelo mantenedor

| Problema | Alteração | Verificação |
|---|---|---|
| Roteamento interno desconhecia contratos das demais skills | Integração opcional por raiz relativa e manifesto, busca paginada e detalhe seletivo | CLI + testes de configuração, portabilidade, ambiguidade e volume |
| Referências e índice podiam divergir | Validação antes do build; check 14 no doctor; índice derivado com hash | Testes de referências ausentes, caminhos fora da raiz, relações inválidas e drift |
| Briefing e autorização se perdiam nas passagens | Gate, descoberta, roteamento, agentes e templates reaproveitam decisões | Verificação dos gerados e cenários de sessão |
| Cerimônia fixa independente da tarefa | Declaração de leituras configurável e fundação proporcional | Compatibilidade com config antigo e modo sob demanda |
| Contexto pessoal confundido com negócio/voz | Destinos e referências separados no contrato | Consulta seletiva não lê métodos ou memória pessoal |
| Interrupção durante gravação podia deixar arquivo parcial | Gravação por substituição atômica, preservando permissões existentes | Testes de falha antes da substituição e idempotência |

Fontes externas foram usadas como referência, sem instalar serviços nem alterar originais. Testes estruturais não substituem execução real de cada fluxo criativo. Memória pessoal não foi migrada ou reescrita nesta atualização.

## 2026-10-04 — 0.2.0-local.2, fontes e atualização padrão

Comparação confirmou que o Cortex pessoal e o Cortex do projeto têm finalidades, armazenamento e programas diferentes. Permanecem em suas fontes próprias; não são duplicatas a fundir. O registro de fontes do projeto passa a consultar a versão no arquivo VERSION, evitando manter um número manual concorrente. Governança e componente de aprendizado definem atualização na origem com evidência, histórico, regeneração e verificação dos consumidores.

## 2026-10-12 — 0.3.0, distribuição agnóstica e convivência com projeto existente

Primeira versão publicada fora de uma instância. Junta o núcleo 0.2.0-local.2 às correções que uma segunda instância (Cortex instalado em subpasta de um projeto com camada própria, caminho com acento e entrega multilíngue) precisou fazer por patch local, e a duas práticas de uma terceira base (marca pessoal, um interlocutor).

| Problema | Alteração | Onde |
|---|---|---|
| Ponteiro para a fonte canônica fora da raiz do Cortex virava ERRO no check 5 | `projeto.raiz` (opt-in; ou `CORTEX_PROJETO`) resolve crase em notação do projeto, só dentro da raiz declarada | `cli/lib/checks.py::_raiz_projeto` |
| Hook liberava tudo em silêncio em caminho com acento (NFD × NFC no macOS) | normalização NFC dos dois lados | `.claude/hooks/pre_tool_use.py` |
| `build` apagava skills e agentes do projeto em `.claude/` como "órfãos" | só remove wrapper com a marca `gerado pelo cortex build` | `cli/lib/wrappers.py` |
| `init` sobrescrevia `settings.json`, `.gitignore` e `.env.example` do projeto | arquivos protegidos | `cli/lib/build.py` |
| `CLAUDE.md`/`AGENTS.md` escritos à mão eram sobrescritos e o hook negava editá-los | "gerado" decidido pela marca no conteúdo; build avisa e mantém; check 8 ignora | `cli/lib/scope.py::eh_gerado`, `build.py`, `checks.py::check_drift` |
| Sem como tirar acervo do projeto do scanner | `escopo.excluir` (scanner, índice, binários, hook) | `cli/lib/scope.py`, `checks.py`, hook |
| `nome-30-45.md` acusado como cópia | `nome-N.md` só é cópia quando `nome.md` existe ao lado | `checks.py::check_nomenclatura` + teste |
| Interpretador fixo nos gerados | `sessao.python` (padrão `python3`) | templates |
| Documentação num idioma, cliente em outros | `sessao.idiomas_conteudo` no `AGENTS.md` e no boot | templates, schema |
| `CLAUDE.md` afirmava hook mesmo com gate declarativo; `AGENTS.md` mandava registrar a peça com destino `chat` | condicionais por `sessao.gate` e `operacao.destino_material_gerado` | templates |
| `briefings/avulso/` citado mas não criado com ciclo `nenhum` | `build` cria a pasta | `build.py` |
| `descricao` do banco de criatividade passava de 160 caracteres | texto curto fixo | `packs/marketing/docs/criatividade-*.tpl` |
| Entrega gravada tratada como aprovada ou publicada | três estados com evidência própria | `kernel/governanca.md` §8 |
| Escolha pontual promovida a regra permanente | classificação do feedback | `kernel/gate.md` §4 |
| `CONTRATOS.md` com dois §11 e tabela sem o check 14; governança citava `saida` e o schema aceita `saida-local` | renumeração, linha 14, valor alinhado | `CONTRATOS.md`, `kernel/governanca.md` |
| Testes dependiam do config da instância | caem no exemplo de onboarding quando não há config | `cli/tests/test_interfaces.py` |

Verificação: 25 testes; instalação limpa + `init` com os três exemplos de onboarding + `build` idempotente + `doctor` sem erro; hooks testados por stdin.
