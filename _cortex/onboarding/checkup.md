# Checkup pré-onboarding — o que o Cortex analisa antes de perguntar

> Rode `python3 _cortex/cli/cortex.py checkup` (o hook de início de sessão roda sozinho quando não há config). O resultado vai para `_cortex/.build/checkup.json` e um resumo aparece no chat. O `/cortex-init` lê o JSON para **pré-preencher** o questionário; nada detectado vira resposta sem confirmação da pessoa.

## 1. Por que analisar antes de perguntar
O questionário tem ~45 perguntas. Boa parte das respostas já está na máquina ou na pasta: idioma dos arquivos, ferramentas conectadas, se há git, se a pasta é sincronizada, que materiais (marca, personas, playbooks) já existem. Analisar primeiro reduz o questionário ao que só a pessoa sabe e evita instalar o Cortex num ambiente onde os hooks não vão funcionar.

## 2. O que é analisado e o que alimenta

| Dimensão | O que o checkup olha | Alimenta | Como |
|---|---|---|---|
| **Máquina** | sistema operacional, versão do Python, `python`/`py` no PATH, PyYAML, git instalado e se a pasta é repositório, permissão de escrita | B0 ambiente, B9 git, alertas | sem Python no PATH → alerta (hooks chamam `python`); sem git e pasta sincronizada → `governanca.git: false` |
| **Pasta sincronizada** | caminho contém OneDrive, SharePoint, Dropbox, Google Drive, iCloud | alerta | risco de cópias de conflito nos arquivos gerados; sugere git ou excluir `_cortex/.build/` da sincronização |
| **Ambientes de IA** | pasta `.claude/`, CLI `claude`, CLI `codex`, `AGENTS.md`, `.cursorrules`, `.cursor/` | B0.2 `sessao.ambiente[]`, `sessao.gate` | com Claude Code → `declarativo+hook`; sem → `declarativo` e `ABERTURA-SESSAO.md` ganha destaque |
| **Ferramentas conectadas** | **nomes** de servidores MCP em `.mcp.json`, `.claude/settings*.json` e `~/.claude.json`; **nomes** de variáveis de ambiente (nunca valores) | B6 `integracoes[]` (slug, tipo, nome, `mcp`, `somente_leitura` para dados/analytics) | tabela de padrões em `lib/checkup.py` (`FERRAMENTAS`); 1 registro detectado → `registro_primario: true` sugerido |
| **Materiais existentes** | inventário por extensão; palavras no nome dos arquivos (marca, persona, produto, playbook, evento, métricas, ajuda, campanha); binários > 2 MB; instruções de IA pré-existentes (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `copilot-instructions`) | B2, B3, B4, B10 packs; alertas | cada pista aponta os arquivos que a pessoa pode usar para responder o bloco; o onboarding pede para abrir esses arquivos antes de perguntar |
| **Idioma** | amostra de até 40 arquivos `.md`/`.txt`, contagem de palavras funcionais pt-BR/en/es | B0.1 `sessao.idioma` | pt-BR como padrão quando não há texto |
| **Config anterior** | existe `cortex.config.yaml`? | fluxo do `/cortex-init` | oferece revisar bloco/adicionar pack em vez de recomeçar |
| **Packs** | combinação de ferramentas + materiais | B10 `packs_sugeridos` | marketing sempre; dados se há integração de dados/analytics; vendas se há CRM ou playbooks; eventos, cs e produto pelas pistas de material |

## 3. O que o checkup **não** faz
- Não lê valores de variáveis de ambiente, chaves, tokens ou conteúdo de arquivos de credencial.
- Não abre PDFs, apresentações ou planilhas: só usa o nome. Quem lê o conteúdo para preencher o bloco é a IA durante o `/cortex-init`, com a pessoa.
- Não decide nada sozinho: tudo que ele sugere aparece como opção pré-marcada no questionário, para confirmar ou corrigir.

## 4. O que ainda precisa ser perguntado (não é detectável)
Nome e segmento da organização, modelo comercial, marcas e gênero gramatical, tom, ofertas e dores, públicos e objeções, canais prioritários, quem ratifica, dados proibidos em prompt, ciclo de planejamento. É o núcleo do questionário e continua obrigatório.

## 5. Checkup × doctor
- **`checkup`** roda **antes** do config existir: analisa máquina, ferramentas e materiais para adaptar o onboarding.
- **`doctor`** roda **depois**: audita a base gerada (13 checks: estrutura, config, frontmatter, placeholders, links, rotas, tamanho, drift, segurança, histórico, nomenclatura, duplicatas, encoding).
