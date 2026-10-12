# Cortex — documentação-para-IA

Versão instalada: consulte `_cortex/kernel/VERSION`.

O **Cortex** é um ecossistema de documentação feito para ser lido por IA. Em vez de uma pilha de arquivos que a pessoa precisa lembrar de abrir, ele organiza o conhecimento do time em arquivos Markdown com um **frontmatter padronizado** (14 campos), uma **camada de roteamento** (`ROTAS.md`) que diz o que abrir para cada tipo de pedido, e um **gate** que confere contexto suficiente, com declaração de leituras configurável. O resultado é uma IA que atende "quero um e-mail sobre o produto X" abrindo exatamente a marca, o produto, o público e a skill do canal — e nada mais.

Ele é **genérico por construção**: tudo que é específico da organização (marcas, ofertas, canais, times, papéis, integrações, governança) vive em um único `cortex.config.yaml`, preenchido por um questionário. A partir dele o `build` gera os arquivos de contexto iniciais, o `AGENTS.md` (instrução canônica, lida por qualquer IA), o `CLAUDE.md` (atalho para o Claude Code), o `ROTAS.md`, o `CATALOGO.md` e os wrappers de skills. Packs (marketing, vendas, cs, produto, eventos, dados) trazem agentes e skills prontos, instanciados só para os canais, integrações, ofertas e times que o contexto realmente tem — `pack suggest` diz quais fazem sentido.

O **kernel** (`_cortex/`) é mantido pelo projeto e nunca é sobrescrito pelo seu time; o **contexto** (`contexto/`) e os **times** (`times/`) são seus; os **gerados** (`ROTAS.md`, `AGENTS.md`, …) são sempre recriados pelo `build`. Um `checkup` analisa a máquina, as ferramentas conectadas e os materiais existentes antes do questionário, para que o onboarding se adapte ao contexto; um `doctor` com 14 checks mantém a base coerente — e, no Claude Code, hooks aplicam essas regras antes de cada leitura ou escrita.

## Memória pessoal × Cortex do projeto

| Sistema | Fonte canônica | Responsabilidade |
|---|---|---|
| Memória pessoal (opcional, da ferramenta de IA ou do usuário) | fora deste repositório, por máquina e por pessoa | Como colaborar com o interlocutor: preferências e decisões explícitas |
| Cortex do projeto | `cortex.config.yaml`, `contexto/`, `times/` e `_cortex/` | Negócio, marca, voz autorizada, métodos, rotas e governança compartilhados |

São sistemas distintos, com dados diferentes. A memória pessoal não substitui este projeto; este projeto não é cópia da memória pessoal. Bibliotecas externas de skills fornecem métodos, não fatos do negócio. Não mover ou fundir essas bases pelo nome ou por trechos parecidos.

Quando o projeto hospedeiro mantém um registro de autoridade das fontes (por exemplo, `AI/FONTE-DE-VERDADE.json`), ele é lido relativo à raiz do projeto. O número instalado do núcleo fica somente em `_cortex/kernel/VERSION`; títulos de release documentam história, não substituem essa fonte.

### Atualização como padrão

Antes de usar informação mutável, consulte sua fonte canônica e confira evidência, data e escopo. Atualize na origem autorizada, registre a mudança e regenere os derivados. Diante de divergência, examine a evidência; não escolha a cópia de maior data nem transforme hipótese em fato.

Depois de alterar o contexto ou método, rode `build` e `doctor`. Se a mudança afetar skills distribuídas no projeto, execute também o instalador e a verificação de interfaces do projeto. A memória pessoal, se houver, se corrige pela própria ferramenta; o `build` do Cortex não a altera.

A manutenção confere consistência e versões; não garante que uma informação externa continua verdadeira sem consultar sua fonte. Memória privada permanece fora da base compartilhada. Detalhes operacionais estão em `_cortex/kernel/governanca.md`, seção 0.1.

## Contratos entre skills (desde 0.2.0-local.1)

O núcleo aceita contratos externos opcionais, selecionados por tarefa. O bloco `interfaces` do config aponta para um manifesto de skills do projeto hospedeiro; o CLI busca e mostra um contrato por vez, com referências aos componentes necessários. O build mantém índices e instruções alinhados e o doctor confere sua integridade.

```bash
python3 _cortex/cli/cortex.py interfaces list --query vídeo
python3 _cortex/cli/cortex.py interfaces show <id-do-contrato>
python3 _cortex/cli/cortex.py interfaces check --json
python3 _cortex/cli/cortex.py build
python3 _cortex/cli/cortex.py doctor
python3 -m unittest discover -s _cortex/cli/tests -v
```

Para adaptar a outro negócio ou interlocutor, troque configuração, manifesto e referências; o núcleo permanece genérico. O formato e o roteiro estão em [_cortex/CONTRATOS.md](./_cortex/CONTRATOS.md), seção 11. Briefings, decisões e autorização acompanham a passagem entre skills. Fatos do negócio e voz pública ficam no projeto; memória pessoal permanece no sistema autorizado.

Bibliotecas públicas de skills de marketing serviram de referência para métodos modulares e distribuição entre ferramentas. Nenhuma é dependência de execução.

## Instalação em 3 passos

1. **Copie o Cortex para a pasta do seu projeto**
   `python3 install.py "/caminho/da/sua/pasta"` (ou clone este repositório na pasta). Requisito: Python 3.10+; nenhuma dependência externa.
2. **Rode o onboarding**
   No Claude Code: abra a pasta e digite `/cortex-init` — a IA roda o `checkup` (máquina, ferramentas, materiais; `_cortex/onboarding/checkup.md`), conduz o questionário bloco a bloco com as respostas detectadas pré-marcadas e grava `cortex.config.yaml`.
   Fora do Claude Code: copie um exemplo de `_cortex/onboarding/exemplos/` para `cortex.config.yaml`, ajuste e rode `python3 _cortex/cli/cortex.py init --answers cortex.config.yaml`.
3. **Preencha o contexto e audite**
   Abra `contexto/organizacao.md`, `contexto/brandcenter/` e `contexto/produtos/` e troque os `[PENDENTE: …]` por conteúdo real. Depois `python3 _cortex/cli/cortex.py doctor` até ficar sem ERRO.

## Comandos

| Comando | O que faz |
|---|---|
| `python3 _cortex/cli/cortex.py checkup [--json]` | Pré-onboarding: sistema, Python, git, pasta sincronizada, ambientes de IA, servidores MCP e variáveis de ambiente (só nomes), inventário de materiais, idioma, packs sugeridos, alertas. Grava `_cortex/.build/checkup.json`. |
| `… doctor [--quick] [--fix] [--json] [arquivo…]` | 14 checks (estrutura, config, frontmatter, placeholders, links, rotas, tamanho, drift, segurança, histórico, nomenclatura, duplicatas, encoding e interfaces). `--quick` roda 1, 2, 4 e 9 em < 1 s. Sai com 1 se houver ERRO. |
| `… build [--first-run] [--only rotas\|catalogo\|wrappers\|contexto\|boot\|interfaces]` | Regera contexto ausente, instala packs pendentes, catálogo, `ROTAS.md`, `AGENTS.md`, `CLAUDE.md`, `CATALOGO.md`, `boot.md` e wrappers. Idempotente. |
| `… init --answers <yaml>` | Valida as respostas, grava o config, `build --first-run`, `doctor`. |
| `… lint --file <a.md> [--stdin]` | Checks de um arquivo só (usado pelo hook). |
| `… new skill\|sub-skill\|agent\|doc --time <t> --id <id> [--familia F] [--canal c] [--owner p]` | Cria o arquivo com frontmatter válido a partir dos templates. |
| `… pack list \| suggest \| install <id> [--time t] \| diff <id>` | Packs: listar, sugerir pelo contexto (`sugerir_se`), instanciar em `times/<time>/`, comparar com o instalado. |
| `… log-use <agent\|skill> <id>` | Telemetria opcional (`.env`). |
| `… config get <caminho>` | Lê um valor do config (ex.: `config get organizacao.nome`). |

O CLI pode ser chamado de qualquer subpasta: ele sobe até encontrar `_cortex/` (ou usa `CORTEX_ROOT`).

## Estrutura de pastas

```
raiz/
├── cortex.config.yaml        # a única fonte dos dados da organização (gerado pelo init; o time edita)
├── AGENTS.md  CLAUDE.md      # gerados: instrução canônica multi-IA + atalho do Claude Code
├── ABERTURA-SESSAO.md        # gerado: texto para colar na 1ª mensagem em ferramentas sem hook
├── ROTAS.md   CATALOGO.md    # gerados: roteamento e inventário
├── _cortex/                  # kernel — nunca sobrescrito pelo build
│   ├── kernel/               # gate, anti-alucinação, governança, roteamento, agentes de base
│   ├── templates/            # *.tpl de tudo que o build gera
│   ├── packs/<id>/           # marketing · vendas · cs · produto · eventos · dados (pack.yaml + *.tpl)
│   ├── cli/                  # cortex.py + lib/
│   ├── onboarding/           # questionário, schema, exemplos
│   └── .build/               # manifest.json, catalogo.json, boot.md, last-doctor.json (ignorado no git)
├── contexto/                 # organização, brandcenter/, produtos/, publicos/, vozes/, integracoes/
├── times/<time>/             # agents/ skills/ docs/ instanciados pelo pack — o time é dono
├── iniciativas/<slug>/       # projetos transversais (iniciativa.yaml + docs)
├── briefings/<ciclo>/        # briefings preenchidos (modelo em briefings/_modelo.md)
├── _saida/  _assets/  _arquivo/   # fora do escopo: material gerado, binários, arquivados (nunca lidos)
└── .claude/                  # settings.json, hooks/, skills/cortex-* (fixas) + wrappers gerados
```

## Como funciona no Claude Code × em outras IAs

- **Claude Code:** `CLAUDE.md` importa `AGENTS.md`, o gate e o brandcenter. O hook `SessionStart` roda `doctor --quick` e injeta `_cortex/.build/boot.md` (resumo do config, famílias ativas, agentes). O hook `PreToolUse` nega leitura de `_arquivo/`, nega edição de arquivos gerados, roda `lint` no conteúdo de todo `.md` antes de gravar e pede confirmação para arquivo novo quando `operacao.criar_arquivo_sem_pedido` é `false`. As skills `/cortex-init`, `/cortex-doctor`, `/cortex-build` e `/cortex-new` guiam a IA; cada skill da base vira um wrapper em `.claude/skills/<id>/`.
- **Outras IAs (Cowork, Codex, chat):** nada carrega sozinho. Cole o conteúdo de `ABERTURA-SESSAO.md` como primeira mensagem; ele manda a IA abrir `AGENTS.md` primeiro; ele diz o que ler (gate → `ROTAS.md` → pacote da família) e aplica a declaração de leituras configurada. O `AGENTS.md` §0 também cobre o onboarding em chat quando não há Python.

## Como criar uma skill ou um pack

- **Skill / agente / doc:** `python3 _cortex/cli/cortex.py new skill --time marketing --id redator-podcast --familia CRIAR.video --canal youtube` cria `times/marketing/skills/redator-podcast.md` com os 14 campos e as seções obrigatórias. Preencha os `[PENDENTE]`, declare `requires` (começando pelo agente que roteia a skill), rode `lint`, depois `build`. Regras completas: `_cortex/CONTRATOS.md` §2.
- **Pack:** crie `_cortex/packs/<id>/pack.yaml` (formato em `_cortex/CONTRATOS.md` §5) com `arquivos_base`, `subfamilias` (cada uma com `condicao`, `sinais`, `obrigatorio`, `orcamento`, `arquivos`) e os `*.tpl` em `agents/`, `skills/`, `docs/`. Templates usam a sintaxe de `_cortex/CONTRATOS.md` §7 e recebem `{config, pack, time, agora, item}`. Instale com `pack install <id> --time <slug>`; `pack diff <id>` mostra o que o time alterou depois.

## Packs disponíveis

| Pack | Quando é sugerido | O que traz |
|---|---|---|
| `marketing` | sempre | redator (sub-skills por canal), designer, estrategista, analista; campanha, ABM, evento online, performance, consulta a dado, operação de base |
| `vendas` | B2B/B2B2C ou time vendas | prospectador, executivo, líder; cadência, qualificação, script, diagnóstico, objeções, proposta, follow-up, forecast, perdas, sinais de compra, canal de parceiros, passagem marketing→vendas |
| `cs` | time cs/suporte/atendimento | gestor de sucesso, atendente; onboarding, plano de sucesso, health score, renovação, expansão, tickets, incidentes, satisfação, central de ajuda, escuta, reativação |
| `produto` | time produto ou oferta do tipo produto | product marketer, documentador de produto; posicionamento, mensagens por público, lançamento, release notes, aviso, funcionalidade, triagem, battlecard, pesquisa, roadmap, registro de publicações |
| `eventos` | oferta evento ou canal eventos | produtor de evento; edição, receita, metas, ciclo, cupons, patrocínio, speakers, calendário, run-of-show, pós-evento, kit de comunicação, deck do dia |
| `dados` | integração de dados/analytics ou time dados | analista de dados; fontes, consulta de métrica, dicionário, funil e origens, cohort, atribuição, relatório recorrente, qualidade, anomalia |

Todo pack é genérico: marca, produto, público, canal e ferramenta entram pelo config. O que não existe no contexto fica em `ROTAS.md` §5 como inativo, com o motivo.

## O que o Cortex corrige em relação a bases anteriores

A rastreabilidade entre os achados da base de origem (segredos em texto claro, índices concorrentes, gate só declarativo, hardcoding, nomes inconsistentes, duplicatas, binários, encoding) e o mecanismo que impede cada um está em `_cortex/MELHORIAS-APLICADAS.md`.

## FAQ

**Posso editar `ROTAS.md` ou `AGENTS.md`?** Não — são gerados. Mude `cortex.config.yaml`, o `pack.yaml`, o `.md` de origem ou o template e rode `build`. O hook recusa a edição direta.

**O `doctor` reclama de `[PENDENTE]` em `contexto/`.** É AVISO, não ERRO: são campos que o time precisa preencher com conhecimento real. A IA não os inventa.

**Mudei os canais no config e uma sub-família sumiu do `ROTAS.md`.** Ela foi para `ROTAS.md` §5 "Inativas" com o motivo. Reative o canal/integração no config e rode `build`.

**Preciso de PyYAML?** Não. O CLI lê o subconjunto de YAML descrito em `_cortex/CONTRATOS.md` §3 com um parser próprio; se PyYAML estiver instalado, é usado só na leitura.

**Onde fica o material gerado (copy, peças)?** Nunca na documentação: vai para o registro primário (`integracoes[].registro_primario`) ou `_saida/<AAAA-MM>/`. Só conhecimento reutilizável entra na base, com ratificação do papel `governanca.ratificador`.

**O que é a linha `LIDOS:`?** É uma declaração configurável: `sessao.declaracao_leituras: sempre` preserva o formato anterior; `sob-demanda` mantém as verificações sem prefixo obrigatório. Detalhe em `_cortex/kernel/gate.md`.
