# CONTRATOS.md — especificação interna do Cortex

> Fonte única das convenções que o CLI, os hooks, os templates, os packs e o kernel compartilham.
> Quem altera um contrato aqui altera o código e os templates que dependem dele.
> Versão do kernel: ver `_cortex/kernel/VERSION`.

## 1. Camadas e quem escreve o quê

| Camada | Onde | Quem escreve | O `build` sobrescreve? |
|---|---|---|---|
| Kernel | `_cortex/kernel/`, `_cortex/templates/`, `_cortex/packs/`, `_cortex/cli/`, `_cortex/onboarding/` | mantenedor do Cortex | nunca |
| Contexto | `cortex.config.yaml`, `contexto/**` | `init` gera; o time edita | só com `--first-run` (ou arquivo ausente) |
| Gerados | `AGENTS.md`, `CLAUDE.md`, `ROTAS.md`, `CATALOGO.md`, `.claude/skills/<id>/SKILL.md` (exceto `cortex-*`), `.claude/agents/<id>.md`, `_cortex/.build/*` | `build` | sempre (só grava se o hash mudou) |
| Times / iniciativas | `times/<time>/**`, `iniciativas/<slug>/**` | pack instancia; o time é dono | nunca (pack `diff` mostra divergência) |
| Fora do escopo | `_arquivo/`, `_saida/`, `_assets/`, `.git/`, `.obsidian/`, `__pycache__/`, `node_modules/` | — | — |

**Marcador de arquivo gerado:** primeira linha do corpo (logo após o frontmatter) é
`<!-- gerado pelo cortex build a partir de _cortex/templates/<nome>.tpl — não edite; edite a fonte e rode `cortex build` -->`
e o frontmatter leva `origem: gerado`. O `build` só sobrescreve arquivo que **não existe** ou que tem `origem: gerado`. O hook PreToolUse nega `Write`/`Edit` em arquivo com `origem: gerado`.

## 2. Frontmatter Cortex — 14 campos, ordem fixa

Vale para **todo** `.md` dentro do escopo (kernel, contexto, times, iniciativas, briefings, raiz).

```yaml
---
tipo: skill                  # agent | skill | sub-skill | doc | pack
id: redator-email            # derivado do nome do arquivo (regra §2.1)
descricao: "Entrega o e-mail pronto para o canal, com assunto e uma variação para teste."  # ≤160, começa por verbo, entre aspas
familia: CRIAR.email         # FAMILIA ou FAMILIA.subfamilia (§4); vazio em doc de contexto
output: texto                # vocabulário fechado do kernel (§2.2); doc usa "nenhum"
canal: email                 # slug de cortex.config.yaml › canais[]; vazio se não se aplica; multivalor com " · "
ferramenta:                  # slug de integracoes[]; vazio se não se aplica
produto: todos               # slug de produtos[] ou "todos"
publico:                     # slug de publicos[] ou vazio
gatilhos: ["frase que a pessoa diria", "outra frase", "terceira frase"]   # ≥3 recomendado; frases, não palavras
requires: redator · redator-comum   # ids separados por " · "; vazio se nenhum
owner: redator               # slug de papeis[] — NUNCA nome de pessoa; `cortex` é reservado para arquivos do kernel
origem: pack:marketing@1.0   # kernel | pack:<id>@<versao> | gerado | gerado-inicial | time
validado_em: 2026-10-03      # AAAA-MM-DD da última linha do ## Histórico
---
```

Regras:
- Campo que não se aplica fica **vazio** (nunca `N/A`, `nenhum`, `-`), exceto `output: nenhum`, que é valor real.
- Multivalor usa ` · ` (espaço, ponto médio, espaço).
- Valor com `:`, `#`, `[`, `{`, `` ` ``, `&`, `*`, `|`, `>` ou que começa com número vai entre aspas duplas.
- `gatilhos` aceita inline `["a", "b"]` ou bloco YAML (`  - a`).
- `tipo: agent` pode ter o campo extra opcional `subagente: true` (gera `.claude/agents/<id>.md`).
- Em `pack.yaml`, `complementar` e `obrigatorio` aceitam um **padrão por item** com chaves, ex.: `criatividade-{produto}` — o check 6 exige só que exista algum id com o prefixo. `abrir` em `condicional` é id de arquivo **ou** texto livre começando por `§`.
- Check 4: `{{`/`}}` residual é ERRO em `contexto/`, raiz e kernel e AVISO em `times/`; `[PENDENTE: …]` é sempre AVISO (é o trabalho humano esperado após o `init`).
- Nenhum gatilho pode se repetir entre dois arquivos do **mesmo** `tipo` (agent×agent, skill×skill…). Repetição entre um agente e a skill que ele roteia é esperada.

### 2.1 Regra determinística do `id`
1. Nome do arquivo sem extensão e sem o sufixo `.agent`.
2. camelCase → kebab (`mapaEditorial` → `mapa-editorial`); underscore, espaço e acento somem; minúsculas.
3. Prefixo `skill-` / `sub-skill-` cai **se sobrar mais de uma palavra**.
4. O `id` é único na base inteira. Nome de arquivo repetido em pastas diferentes ganha sufixo de escopo: `{nome}-{escopo}`.
5. **Exceções fixas** (implementadas em `fm.id_esperado`): arquivos em `contexto/integracoes/` recebem o prefixo `integracao-` (`clickup.md` → `integracao-clickup`); `briefings/_modelo.md` → `modelo-briefing`; `CLAUDE.md` → `claude` (isento de `## Histórico` e de gatilhos por ser atalho ≤ 30 linhas).

### 2.2 Vocabulário fechado de `output` (kernel)
`texto` · `html` · `arte` · `apresentacao` · `roteiro` · `plano` · `analise` · `relatorio` · `dado` · `briefing` · `registro` · `documentacao` · `roteamento` · `nenhum`

### 2.3 Vocabulários derivados do config
`canal:` ← `canais[].slug` · `ferramenta:` ← `integracoes[].slug` · `produto:` ← `produtos[].slug` + `todos` · `publico:` ← `publicos[].slug` · `owner:` ← `papeis[].slug` · `familia:` ← famílias do kernel + sub-famílias dos packs instalados.

### 2.3.1 Valores no kernel
Arquivos de `_cortex/kernel/` são estáticos (não são templates) e usam: `owner: cortex` · `origem: kernel` · `produto: todos` · `canal:`/`ferramenta:`/`publico:` vazios · `familia:` vazio nos docs de fundação e no maestro/entrevistador; `REVISAR`, `REGISTRAR`, `DOCUMENTAR`, `GOVERNAR` nos agentes/skill correspondentes.

### 2.4 Seções obrigatórias por tipo
- **agent**: `## Quem eu sou` · `## Como me ativar` · `## Contexto que eu sempre carrego` · `## Meu processo` · `## Briefing que eu exijo` · `## Regras inegociáveis` · `## Handoffs` · `## O que eu entrego` · `## Histórico`
- **skill / sub-skill**: `## Contexto de uso` · `## Processo` · `## Output esperado` · `## Histórico`
- **doc**: `## Histórico` (demais seções livres). Arquivo > 35 KB exige `## Sumário` com âncoras.
- `## Histórico` é uma tabela `| Data | O que mudou | Papel |`, mais recente primeiro; a primeira data **é** o `validado_em`.

## 3. `cortex.config.yaml`

Schema formal: `_cortex/onboarding/schema/cortex.config.schema.json` (subconjunto: `type`, `required`, `enum`, `properties`, `items`, `minItems`, `pattern`). Exemplos completos: `_cortex/onboarding/exemplos/*.yaml`.

Subconjunto YAML suportado pelo `yamlmini` (PyYAML não é dependência): mapas aninhados por indentação de 2 espaços; listas `- item` e listas de mapas `- chave: valor` (com continuação indentada); mapas inline `{a: 1, b: x}` e listas inline `[a, b]` de **um nível**; escalares `true/false/null`, inteiros, floats, strings com ou sem aspas (aspas duplas com escape `\"`); comentários `#`. **Não** suportado: âncoras, multi-documento, blocos `|`/`>` (usar aspas), chaves com `:` sem aspas.

## 4. Famílias de rota

Kernel (fixas, com orçamento = referência de quantidade de arquivos; leituras necessárias podem excedê-la):

| Família | Orçamento | Sinal |
|---|---|---|
| CRIAR | 5 | peça ou artefato novo |
| PLANEJAR | 7 | campanha, plano, experimento, budget, evento, conta-alvo |
| ANALISAR | 6 | resultado, relatório, funil, atribuição |
| CONSULTAR | 3 | dado já documentado, read-only |
| OPERAR | 4 | base de contatos, automação, integração |
| REVISAR | 2 | humanizar, QA de texto pronto |
| REGISTRAR | 3 | subir no registro, ata, card |
| DOCUMENTAR | 4 | documentar produto/processo, atualizar dado da base |
| GOVERNAR | 4 | criar/corrigir skill, auditar, configurar o Cortex |

Sub-famílias vêm dos packs (`FAMILIA.sub`, ex.: `CRIAR.email`). O `build` só emite no `ROTAS.md` as sub-famílias cuja `condicao` é verdadeira para o config; as demais vão para `ROTAS.md` §5 "Inativas" com o motivo.

Modificadores (kernel; cada um ativo só se o config tiver o insumo): `§3.1 produto` (produtos) · `§3.2 ferramenta/MCP` (integracoes com mcp) · `§3.3 voz` (vozes) · `§3.4 território` (publicos[].territorio) · `§3.5 etapa` (sempre) · `§3.6 ciclo/briefing` (operacao.ciclo_planejamento) · `§3.7 iniciativa` (pasta em `iniciativas/` com `iniciativa.yaml`).

## 5. `pack.yaml`

```yaml
id: marketing
nome: "Marketing"
versao: "1.0"
descricao: "Criação, planejamento e análise de marketing multicanal."
requer_config: [marcas, produtos, canais]      # chaves do config que precisam existir e não estar vazias
sugerir_se: "sempre"                           # condição (§6) usada pelo onboarding B10 para sugerir o pack
time_padrao: marketing                         # slug sugerido para times[].pack
arquivos_base:                                 # instanciados sempre que o pack é instalado
  - agents/redator.agent.md.tpl
  - skills/redator-comum.md.tpl
subfamilias:
  - id: CRIAR.email
    nome: "E-mail"
    condicao: "canal:email"
    sinais: ["e-mail", "fluxo de e-mails", "disparo", "régua"]
    obrigatorio: [redator, redator-comum, redator-email]
    condicional:
      - {se: "produto nomeado", abrir: "§3.1"}
      - {se: "vai usar prova social", abrir: "indice-provas"}
    complementar: [benchmarks-canal]
    orcamento: 6
    arquivos:
      - skills/redator-email.md.tpl
```

Chave opcional `itens:` mapeia um template com `{{item.slug}}` no nome para a lista que ele itera: `"docs/fonte-{{item.slug}}.md.tpl": "integracoes:dados,analytics"` (lista do config, opcionalmente filtrada por `tipo`); padrão `produtos`. Chave `sugerir_se:` (condição §6) é usada por `cortex pack suggest` e pelo bloco B10 do onboarding.

Instanciação: `templates` `*.tpl` do pack são renderizados com o contexto `{config, pack, time, agora}` e gravados em `times/<time>/<mesmo caminho sem .tpl>`. O frontmatter do arquivo instanciado recebe `origem: pack:<id>@<versao>`. Arquivo existente **não** é sobrescrito; `cortex pack diff <id>` compara.

## 6. Mini-linguagem de condição (`condicao`, `sugerir_se`, `{{#if}}`)

Tokens combinados com ` and ` / ` or ` (sem parênteses), negação com `not ` no início do token:

| Token | Verdadeiro quando |
|---|---|
| `sempre` | sempre |
| `canal:<slug>` | `canais[]` contém o slug |
| `integracao:<tipo>` | alguma `integracoes[].tipo` == tipo |
| `ferramenta:<slug>` | `integracoes[]` contém o slug |
| `oferta:<tipo>` | algum `produtos[].tipo` == tipo (`produto`, `servico`, `evento`, `conteudo`) |
| `modelo_comercial:<valor>` | `organizacao.modelo_comercial` == valor |
| `segmento:<valor>` | `organizacao.segmento` == valor |
| `tem:<caminho>` | o caminho (ex.: `vozes`, `publicos.territorio`, `governanca.comite`) existe e é truthy/não vazio |
| `pack:<id>` | pack instalado |
| `ambiente:<valor>` | `sessao.ambiente[]` contém o valor |
| `time:<slug>` | `times[]` contém o slug |
| `papel:<slug>` | `papeis[]` contém o slug |
| `publico:<tipo>` | algum `publicos[].tipo` == tipo (`comprador`, `usuario`, `influenciador`, `parceiro`) |

## 7. Templates — sintaxe do `render`

- Interpolação: `{{caminho.ate.valor}}`; valor ausente vira string vazia e o `doctor` (check 4) acusa `{{` residual.
- Condicional: `{{#if <condição §6 ou caminho>}} … {{else}} … {{/if}}`.
- Repetição: `{{#each produtos as p}} … {{p.nome}} … {{/each}}`; `{{@index}}`, `{{@first}}`, `{{@last}}` disponíveis; `{{#each p.modulos as m}}` aninha.
- Helpers: `{{upper x}}` · `{{lower x}}` · `{{join x ", "}}` · `{{len x}}` · `{{default x "texto"}}` · `{{slug x}}` · `{{hoje}}` · `{{papel "redator"}}` (em instanciação de pack: devolve o slug se existir em `time.papeis`, senão o primeiro papel do time) · `{{marca_mae}}` (objeto da marca com `mae: true`, ou a primeira) · `{{registro_primario}}` (objeto da integração com `registro_primario: true`, ou vazio).
- Comentário: `{{! texto }}` (removido).
- Chaves literais: `\{{` vira `{{`.

- Comparação em `{{#if}}`: `{{#if caminho == "valor"}}` (também `!=`). Um caminho sozinho é truthy se existe e não é vazio/false/0.

### 7.1 Contexto de renderização (nomes exatos usados pelos templates)

| Variável | Tipo | Conteúdo |
|---|---|---|
| raiz do config | mapa | todas as chaves de `cortex.config.yaml` acessíveis sem prefixo (`{{organizacao.nome}}`, `{{meta.onboarding.status}}`, `{{governanca.limites.aviso_kb}}`) |
| `agora` | str | data de hoje `AAAA-MM-DD` |
| `kernel.versao` | str | conteúdo de `_cortex/kernel/VERSION` |
| `registro_primario` | mapa ou vazio | a integração com `registro_primario: true` |
| `marca_mae` | mapa | a marca com `mae: true`, senão a primeira |
| `familias` | lista | kernel: `{id, orcamento, sinal}` |
| `subfamilias_ativas` | lista | `{id, familia, nome, sinais[], obrigatorio[], condicional[{se, abrir}], complementar[], orcamento, pack, condicao}` de todos os packs instalados cuja condição é verdadeira, ordenadas por família (ordem do kernel) e depois por id |
| `subfamilias_inativas` | lista | `{id, nome, pack, condicao, motivo}` |
| `agentes` | lista | `{id, caminho, origem, descricao}` — todo `tipo: agent` do escopo (kernel + times + iniciativas), ordenado: kernel primeiro, depois por caminho |
| `catalogo` | lista | `{id, tipo, caminho, kb, tokens, familia, requires[], consumido_por[], ancora:bool, grupo}` ordenado por caminho |
| `ancoras` | lista | `{id, kb, secoes[]}` dos arquivos > `aviso_kb` (seções = headings `##`/`###` como texto) |
| `total_kb`, `total_tokens` | número | somas do catálogo |
| `vocabularios` | mapa de listas | `familia`, `output`, `canal`, `ferramenta`, `produto`, `publico`, `owner` |
| `pack`, `time` | mapas | só na instanciação de pack: o `pack.yaml` carregado e o item de `times[]` que recebe o pack |
| `item` | mapa | só em templates por item (`marca.md.tpl`, `produto.md.tpl`, `publico.md.tpl`, `integracao.md.tpl`, `criatividade-{{item.slug}}.md.tpl`) |

Nome de arquivo de template pode conter `{{item.slug}}` (ex.: `criatividade-{{item.slug}}.md.tpl`): o build renderiza o nome com o mesmo contexto.

## 8. Saídas do build

| Arquivo | Template | Conteúdo |
|---|---|---|
| `AGENTS.md` | `AGENTS.md.tpl` | canônico multi-IA: §0 onboarding/fallback em chat, §1 gate `LIDOS:`, §2 fluxo de 8 passos, §3 roteamento (aponta `ROTAS.md`), §4 destinos e permissões, §5 manutenção |
| `ABERTURA-SESSAO.md` | `ABERTURA-SESSAO.md.tpl` | texto de abertura para ferramentas sem hook/`@import` (cola-se como 1ª mensagem); contém o gate, a regra da oferta e um resumo do contexto |
| `CLAUDE.md` | `CLAUDE.md.tpl` | ≤30 linhas, `@AGENTS.md`, `@_cortex/kernel/gate.md`, `@contexto/brandcenter/brandcenter.md`, `@_cortex/kernel/anti-alucinacao.md` |
| `ROTAS.md` | `ROTAS.md.tpl` | §0 uso · §1 classificador (ativas) · §2 agentes id→arquivo · §2.x rotas por sub-família · §3 modificadores ativos · §4 desempates · §5 inativas |
| `CATALOGO.md` | `CATALOGO.md.tpl` | §0 vocabulários · tabela `id · caminho · KB · ~tokens · tipo · família · requires · consumido por` · âncoras dos > 35 KB |
| `_cortex/.build/boot.md` | `boot.md.tpl` | ≤3 KB injetado pelo SessionStart |
| `_cortex/.build/manifest.json` | — | `{ids: {id: {caminho, tipo, familia, bytes, hash_fm, hash_headings, hash_conteudo, validado_em, requires, gatilhos}}, wrappers: {id: hash}, gerado_em}` |
| `_cortex/.build/catalogo.json` | — | mesma tabela do CATALOGO em JSON |
| `.claude/skills/<id>/SKILL.md` | `skill-wrapper.tpl` | `name`, `description` (descricao + "Gatilhos: …"), corpo ≤15 linhas |
| `.claude/agents/<id>.md` | `agent-wrapper.tpl` | só para `subagente: true` |
| `_cortex/.build/checkup.json` | — | saída do `cortex checkup` (pré-onboarding): ambiente, ferramentas (só nomes), materiais, sugestões, alertas |

Tokens estimados = `bytes / 3.6` (média pt-BR observada na base de origem).

## 9. Hooks (Claude Code)

- `SessionStart` → `.claude/hooks/session_start.py`: sem `cortex.config.yaml` ou `meta.onboarding.status != complete` → roda o `checkup` pré-onboarding (resumo no chat) e imprime instrução para rodar `/cortex-init` + §1 do gate. Caso contrário roda `doctor --quick` e imprime `_cortex/.build/boot.md` (regera se ausente). Nunca falha a sessão.
- `PreToolUse` (matcher `Read|Grep|Glob|Write|Edit|MultiEdit`) → `.claude/hooks/pre_tool_use.py`:
  1. caminho dentro de `_arquivo/` → **deny** (exit 2, mensagem).
  2. `Write`/`Edit` em arquivo com `origem: gerado` ou em `ROTAS.md`/`CATALOGO.md`/`AGENTS.md`/`CLAUDE.md`/`.claude/skills/*` (exceto `cortex-*`) → **deny** ("edite a fonte e rode build").
  3. `Write`/`Edit` em `.md` do escopo → `cortex lint --file` sobre o conteúdo proposto; erro → **deny** com a lista.
  4. `Write` de arquivo novo no escopo com `operacao.criar_arquivo_sem_pedido: false` → `permissionDecision: ask`.
  Falha interna do hook → **allow** (nunca trava o trabalho).

## 10. Escopo do scanner (`scope.py`)

Inclui todo `.md` sob a raiz. Exclui: `_arquivo`, `_saida`, `_assets`, `.claude`, `.git`, `.obsidian`, `_cortex/.build`, `_cortex/packs`, `_cortex/templates`, `_cortex/onboarding`, `_cortex/cli`, `__pycache__`, `node_modules`, arquivos que começam com `~$`. `_cortex/CONTRATOS.md`, `_cortex/MELHORIAS-APLICADAS.md` e `README.md` são **isentos de frontmatter** (lista fechada `ISENTOS`).

## 11. Checks do `doctor`

| # | Nome | O que valida | Severidade |
|---|---|---|---|
| 1 | estrutura | pastas obrigatórias, `kernel/VERSION`, nada canônico em `.claude/` | ERRO |
| 2 | config | parse, schema, slugs únicos, referências cruzadas, packs existem; ausente = "rode /cortex-init" | ERRO |
| 3 | frontmatter | 14 campos e ordem, `id` derivado, vocabulários do config, gatilhos (≥3 aviso; colisão por tipo), `requires` resolve, `owner` ∈ papéis ∪ {cortex} | ERRO/AVISO |
| 4 | placeholders | `{{`/`}}` residual (ERRO em contexto/raiz/kernel, AVISO em times); `[PENDENTE: …]` (AVISO) | ERRO/AVISO |
| 5 | links | caminhos em crase e links markdown existem (caixa sensível); remissão `§N`; `_arquivo/<x>` como fonte = ERRO | ERRO/AVISO |
| 6 | rotas | sub-família ativa tem obrigatórios; agente em ≥1 rota; skill órfã; padrão `x-{item}` resolve por prefixo | ERRO/AVISO |
| 7 | tamanho | > `aviso_kb` exige `## Sumário`; > `erro_kb` | ERRO/AVISO |
| 8 | drift | hash fm+headings vs manifesto sem `validado_em` novo; wrapper/gerado desatualizado | ERRO/AVISO |
| 9 | segurança | token/secret/bearer/URL de webhook em texto; binário > `binario_mb` no escopo; `.env` fora do `.gitignore` | ERRO/AVISO |
| 10 | histórico | `## Histórico` presente; 1ª data == `validado_em` (`--fix`) | AVISO |
| 11 | nomenclatura | kebab-case sem acento/espaço; sufixos de cópia (`(1)`, `.bak`, conflito; `nome-1.md` só quando `nome.md` existe ao lado) | AVISO |
| 12 | duplicatas | corpo idêntico (AVISO); `id` repetido (ERRO) | ERRO/AVISO |
| 13 | encoding | BOM, CRLF (`--fix`), não-UTF-8 (ERRO), mojibake | ERRO/AVISO |
| 14 | interfaces | manifesto, relações, fontes locais e índice derivado (só com o bloco `interfaces` ativo) | ERRO/AVISO |

`--quick` roda 1, 2, 4 e 9. `lint --file` roda 3, 4, 5, 7, 9, 10, 11, 12 e 13 num arquivo só.


## 12. Interfaces adaptáveis

Extensão opcional desde `0.2.0-local.1`. Configs anteriores continuam válidos. Sem o bloco `interfaces`, o build mantém o roteamento interno; `ativo: false` desliga a extensão.

```yaml
interfaces:
  ativo: true
  raiz: ../..
  manifesto: AI/Skills/interfaces.json
```

`raiz` é relativa ao Cortex, podendo apontar ao projeto que o contém. Manifesto, fontes locais e componentes devem ficar dentro dessa raiz, inclusive após resolver links simbólicos. Não são aceitos caminhos absolutos para esses itens. O núcleo não contém nomes de marca, usuário ou diretórios pessoais fixos.

O manifesto JSON versão 1 contém:

- `componentes`: mapa por id; cada componente tem `nome`, `arquivo` relativo à raiz e `quando`.
- `perfis`: mapa por id com lista `componentes` e critério `verificacao` opcional. Perfis agrupam necessidades, não pessoas.
- `skills`: lista com `id` qualificado e único, `nome`, `escopo`, `perfil`, `fonte`, `quando`, `entrada`, `saida`, `limite` e `relacoes`.
- Cada relação possui `skill` (id de destino), `quando` e `entregar`. Relações são condicionais, não dependências a carregar em massa. A consulta não percorre ciclos.

Escopos `propria`, `externa` e `cortex` apontam a arquivos locais verificáveis. `global` e `plugin` registram referências do ambiente: o núcleo não abre diretórios pessoais nem comprova sua instalação em outro computador. O componente de ambiente orienta a resolução no executor disponível. Métodos e fontes do fornecedor continuam sob seu próprio versionamento; o contrato acrescenta contexto local sem sobrescrever o original.

`interfaces list` pagina metadados (20 por padrão, até 200), com busca e filtros `--profile`, `--scope`, `--offset`, `--limit`. `interfaces show <id>` devolve um contrato e referências dos componentes do perfil; não abre seus conteúdos. Nome ambíguo exige id completo. `interfaces check` verifica manifesto, relações e existência das fontes locais. `--json` fornece saída estruturada, inclusive erros.

`build` valida a extensão antes de escrever e gera `_cortex/.build/interfaces-index.json`. `build --only interfaces` atualiza só esse índice. O índice é descartável e não é uma segunda fonte de verdade. Mudanças em perfis/quantidades também aparecem em rotas/boot após build completo. O check 14 do doctor detecta referência inválida e índice ausente ou divergente. Validação estrutural não comprova a qualidade criativa nem executa as ferramentas citadas.

`sessao.declaracao_leituras` aceita `sempre` (compatibilidade) e `sob-demanda`. Ambos exigem leitura suficiente; apenas a apresentação muda. Os critérios de briefing e continuidade vivem em `_cortex/kernel/gate.md` e `_cortex/kernel/descoberta.md`.

### Adaptação a outro projeto

1. Copie o núcleo e configure a organização, canais e fontes próprias.
2. Crie um manifesto no mesmo formato, com ids e caminhos desse projeto. Não copie memória pessoal ou fatos de outra empresa.
3. Defina componentes que apontem a suas fontes de negócio, linguagem, formatos, imagens, vídeo, narrativa, crenças declaradas e aprendizado. Um componente pode atender vários perfis.
4. Configure a raiz relativa, rode `interfaces check`, `build` e `doctor`.
5. Para adicionar uma skill, declare seu contrato e relações no manifesto; para adicionar um contexto, registre um componente e associe-o aos perfis pertinentes.

Preferências do interlocutor pertencem ao sistema de memória autorizado, fatos da empresa ao contexto, técnica à skill, voz à ficha editorial e pendências ao briefing. Referencie a origem; não replique dados privados. Correções duráveis exigem evidência e substituição explícita de regra anterior; não são inferidas pelo índice.

## 13. Instalação dentro de um projeto existente

Chaves opcionais do `cortex.config.yaml` para quando o Cortex não é a raiz da pasta, e sim uma subpasta de um projeto que já tem camada própria (regras, skills, `CLAUDE.md`):

| Chave | Efeito |
|---|---|
| `projeto.raiz` | raiz do projeto hospedeiro, relativa à raiz do Cortex. Crase em notação do projeto resolve a partir dela (check 5). É opt-in: sem ela (ou a variável `CORTEX_PROJETO`, que tem precedência), só o manifesto de `interfaces` atravessa a raiz do Cortex, e mesmo com ela nada fora da raiz do projeto é aceito |
| `escopo.excluir` | pastas ou arquivos relativos à raiz que ficam fora do scanner, do índice de links, do check de binários e do hook |
| `sessao.python` | interpretador dos comandos gerados (`python3`, `py`…); padrão `python3` |
| `sessao.idiomas_conteudo` | idiomas de entrega ao público final, quando diferem de `sessao.idioma` (documentação num idioma, cliente em outros) |

Comportamento de convivência:

- o `build` só remove wrapper órfão que traga a marca `gerado pelo cortex build`; skills e agentes do projeto em `.claude/` ficam intactos;
- o `init` não sobrescreve `.claude/settings.json`, `.gitignore` e `.env.example` existentes;
- `CLAUDE.md`, `AGENTS.md` e demais gerados de raiz que já existam sem a marca são mantidos: o `build` avisa e o check 8 não acusa drift;
- "gerado" (§8, §9) é decidido pela marca no conteúdo, não pelo nome do arquivo;
- o hook normaliza caminhos em NFC antes de comparar (o macOS devolve NFD em pastas com acento);
- com `operacao.ciclo_planejamento: nenhum`, o `build` cria `briefings/avulso/`;
- com `operacao.destino_material_gerado` diferente de `registro`, o `AGENTS.md` não manda registrar a peça publicada no registro primário.
