# Questionário de onboarding do Cortex

> **Para a IA que conduz:** faça **um bloco por rodada**, sempre com **opções** (2–4 por pergunta, mais "outro"), marcando o que é **obrigatório** (negrito). Não despeje tudo de uma vez. Antes de cada bloco, verifique a `condicao`: se for falsa, pule o bloco, aplique os padrões indicados e registre o id do bloco em `meta.onboarding.assumidos`. Ao final de cada bloco, mostre em 3–5 linhas o que vai gravar e confirme. Depois do último bloco, monte o `cortex.config.yaml` completo (schema: `schema/cortex.config.schema.json`; exemplos: `exemplos/`), grave-o e siga `geracao.md` (ou rode `python3 _cortex/cli/cortex.py init --answers <arquivo>`).
> No Claude Code, use `AskUserQuestion` com `multiSelect` onde indicado. Em outras ferramentas, pergunte em texto, numerando as opções.
> **Modo rápido** (`--rapido` ou "só o essencial"): blocos B0, B1, B2, B3, B5, B6; o resto assume padrão.

Legenda: 🔸 obrigatório · ◽ opcional · ⇒ o que a resposta gera/altera.

---

## B0 — Sessão e ambiente
`condicao: sempre` · **Antes deste bloco, rode `python3 _cortex/cli/cortex.py checkup`** (`checkup.md` explica): idioma, ambientes, integrações, git e packs vêm pré-marcados dali.

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B0.1 | Em que idioma a base deve ser escrita? | pt-BR · en · es | `sessao.idioma` |
| 🔸 B0.2 | Onde a IA vai rodar com esta pasta? (múltipla) | Claude Code · sessão "só pasta montada" (Cowork, chat com arquivos) · Codex/outra CLI · outra | `sessao.ambiente[]`; se não houver Claude Code: `sessao.gate: declarativo` e o `AGENTS.md` reforça a abertura manual da fundação |
| ◽ B0.3 | Qual o seu papel? (quem está configurando) | líder da área · operações/ops · redator/criador · dados · outro | `sessao.papel_configurador` (vira um papel em B7 se não existir) |

Padrões: `pt-BR`, `[claude-code]`, `declarativo+hook`.

---

## B1 — Organização e modelo comercial
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B1.1 | Nome da organização ou unidade | texto | `organizacao.nome`, `organizacao.slug` (kebab) |
| 🔸 B1.2 | Segmento principal | SaaS/tecnologia · varejo · serviços profissionais · indústria · educação · saúde · eventos/mídia · financeiro · outro (+ especialize: "saas-b2b-construcao") | `organizacao.segmento` (slug) |
| 🔸 B1.3 | Para quem você vende? | B2B (empresas) · B2C (pessoas) · B2B2C (via parceiro/canal) · misto | `organizacao.modelo_comercial`; **B2C** desativa ABM; **B2B/B2B2C** habilita `PLANEJAR.abm` |
| ◽ B1.4 | Porte | pequeno (até 20 pessoas) · médio · grande | `organizacao.porte` |
| ◽ B1.5 | Em uma frase, o que a organização faz? | texto | `organizacao.descricao` (vai para o `AGENTS.md`) |

---

## B2 — Marcas, gênero e tom
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B2.1 | Quais marcas assinam comunicação? Liste (1 ou mais). | texto; se mais de uma: qual é a marca-mãe? | `marcas[]` com `slug`, `nome`, `mae` |
| 🔸 B2.2 | Para cada marca: como ela é referida no texto? | "a Marca" (feminino) · "o Marca" (masculino) · neutro/sem artigo | `marcas[].genero` — evita "a Marca" × "o Marca" no mesmo texto |
| 🔸 B2.3 | Para cada marca: 3 adjetivos de tom | ex.: direta, técnica, próxima · leve, afetiva, confiante · institucional, sóbria, precisa · bem-humorada, jovem, ágil | `marcas[].tom[]` |
| ◽ B2.4 | Termos que **nunca** podem aparecer | ex.: "solução completa", "imperdível", "revolucionário" | `marcas[].termos_proibidos[]` |
| ◽ B2.5 | Trocas de termo obrigatórias ("diga X, não Y") | ex.: software → plataforma; cliente → você | `marcas[].termos_preferidos{}` |
| ◽ B2.6 | Site oficial (fonte válida para fato institucional) | URL | `marcas[].site` |

⇒ gera `contexto/brandcenter/brandcenter.md` e um `contexto/brandcenter/marcas/<slug>.md` por marca. Uma marca → brandcenter simples; várias → seção de arquitetura (mãe × filhas, quando cada uma assina).

---

## B3 — Oferta (produtos, serviços, eventos, conteúdo)
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B3.1 | O que você oferece? (múltipla) | produtos · serviços · eventos · conteúdo/mídia · misto | define os `tipo` aceitos em B3.2; **evento** sugere `PLANEJAR.evento` |
| 🔸 B3.2 | Liste cada oferta: nome, tipo, marca que assina, dor principal que resolve (1 frase), promessa (1 frase) | texto, 1 por linha | `produtos[]` → vocabulário `produto:`; `contexto/produtos/<slug>/<slug>.md` por item |
| ◽ B3.3 | Alguma oferta tem módulos/linhas/coleções internas que o time cita separadamente? | sim (liste por oferta) · não | `produtos[].modulos[]` → seção por módulo no doc-raiz |
| ◽ B3.4 | Qual é a oferta "default" quando a pessoa não diz? | **nenhuma — a IA sempre pergunta** (recomendado) · uma específica | se específica, grava em `rotas.oferta_padrao` (o kernel ainda recomenda perguntar) |

---

## B4 — Públicos e personas
`condicao: sempre` (modo rápido: assume 1 público genérico por oferta, marcado `[PENDENTE: preencher]`)

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B4.1 | Quem compra e quem usa? Liste até 5 públicos: nome curto, tipo (comprador · usuário · influenciador · parceiro), dor principal, objeção típica | texto | `publicos[]` → vocabulário `publico:`; `contexto/publicos/<slug>.md` |
| ◽ B4.2 | Existem públicos que vivem em "mundos" diferentes (ex.: cliente final × fornecedor × canal), onde muda a linguagem inteira? | sim (nomeie os territórios) · não | `publicos[].territorio` → ativa modificador §3.4 |
| ◽ B4.3 | Ligue cada oferta aos seus públicos | matriz oferta × público | `produtos[].publicos[]` |

---

## B5 — Canais
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B5.1 | Em quais canais a comunicação sai? (múltipla) | e-mail · landing page · blog/SEO · LinkedIn · Instagram · TikTok · YouTube · WhatsApp/SMS · mídia paga · eventos · comunidade · newsletter · PR/imprensa · marketplace · push/app · loja física | `canais[]` → vocabulário `canal:`; **só** as sub-skills desses canais são instanciadas; `ROTAS.md` só lista famílias com canal ativo |
| 🔸 B5.2 | Ordene os 3 mais importantes | lista | `canais[].prioridade` |
| ◽ B5.3 | Em quais canais o texto **sempre** passa por revisão anti-IA antes de publicar? | redes sociais e newsletter (recomendado) · todos · nenhum · escolher | `canais[].revisao_anti_ia` e `operacao.revisao_anti_ia_padrao` |
| ◽ B5.4 | Alguma pessoa assina conteúdo com voz própria (CEO, especialista, influenciador interno)? | sim (nome do papel, não da pessoa) · não | `vozes[]` → `contexto/vozes/<slug>.md`; ativa modificador §3.3 |

---

## B6 — Ferramentas e integrações
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B6.1 | Onde a entrega é **registrada** (card, página, ticket)? | ClickUp · Notion · Jira · Asana · Trello · só git · nenhum | `integracoes[]` com `tipo: registro`, `registro_primario: true`; "nenhum" → `operacao.destino_material_gerado: saida-local` |
| 🔸 B6.2 | Onde está o **dado** de resultado (funil, conversões, vendas)? | banco/warehouse (Supabase, BigQuery, Postgres) · planilhas · GA4/analytics · CRM · "não temos dado estruturado" | `tipo: dados` ou `analytics`; **sem dado** → `CONSULTAR.dado` inativa e o Analista trabalha com dado fornecido |
| ◽ B6.3 | CRM e automação de marketing | RD Station · HubSpot · Salesforce · Pipedrive · Mailchimp · ActiveCampaign · Meta Business · nenhum | `tipo: crm` / `automacao-mkt`; habilita `OPERAR.base` |
| ◽ B6.4 | Ferramenta de design | Canva · Figma · Adobe · nenhuma | `tipo: design` (o Designer cita a ferramenta) |
| ◽ B6.5 | Automação e chat do time | n8n · Make · Zapier · Power Automate · nenhum / Teams · Slack · Google Chat | `tipo: automacao` / `chat` |
| ◽ B6.6 | Para cada integração: a IA acessa por conector (MCP)? É **somente leitura**? | sim/não · sim/não | `integracoes[].mcp`, `integracoes[].somente_leitura` → ficha `contexto/integracoes/<slug>.md` com gate antes da 1ª chamada |

---

## B7 — Times e papéis
`condicao: sempre`

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B7.1 | Quais times vão usar o Cortex? (múltipla) | marketing · vendas · customer success · produto · conteúdo · design · operações · dados · outro | `times[]` → pasta `times/<slug>/`; sugere packs em B10 |
| 🔸 B7.2 | Por time: quais papéis existem? (papéis, não pessoas) | ex.: líder · ops · redator · designer · estrategista · analista · social · atendimento · PM | `papeis[]` → vocabulário `owner:`; `times[].papeis[]` |
| 🔸 B7.3 | Quem **ratifica** conhecimento novo na base (skill, doc)? | um comitê · um papel específico | `governanca.comite`, `governanca.ratificador` |
| ◽ B7.4 | Quem revisa conteúdo externo antes de publicar? Quem revisa número/dado? | papéis | `papeis[].responsabilidades` (`revisa-externo`, `revisa-dados`) |

⇒ gera `contexto/organizacao.md` com a tabela "papel → quem ocupa hoje" para o time preencher (nomes ficam **só** lá).

---

## B8 — Operação do dia a dia
`condicao: sempre` (modo rápido: assume os padrões)

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| ◽ B8.1 | Ciclo de planejamento | mensal · trimestral · sprint · nenhum | `operacao.ciclo_planejamento` → `briefings/<ciclo>/` e modificador §3.6 |
| ◽ B8.2 | Onde vai o material gerado (copy, peça, análise)? | no registro primário (recomendado) · pasta `_saida/` · só no chat | `operacao.destino_material_gerado` |
| ◽ B8.3 | A IA mostra no chat antes de gravar arquivo? | sim (recomendado) · não, pode gravar direto quando o destino for claro | `operacao.fluxo_chat_antes_do_arquivo` |
| ◽ B8.4 | A IA pode criar arquivo novo na base sem pedido explícito? | não (recomendado) · sim | `operacao.criar_arquivo_sem_pedido` (o hook pergunta antes de criar) |

Padrões: trimestral · registro · sim · não.

---

## B9 — Governança, segurança e telemetria
`condicao: sempre` (modo rápido: assume os padrões)

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| ◽ B9.1 | Com que frequência a base é auditada (`cortex doctor`)? | semanal (recomendado) · quinzenal · mensal · nenhuma | `governanca.auditoria` |
| ◽ B9.2 | A pasta é versionada com git? | sim · não | `governanca.git` → `.gitignore`; histórico por arquivo + commit |
| ◽ B9.3 | Registrar uso de skills/agentes em um painel (telemetria)? | não · sim (URL e token ficam só no `.env`) | `governanca.telemetria` → `.env.example` |
| ◽ B9.4 | O que **nunca** pode entrar num prompt? (múltipla) | preço de produto · dados de cliente · métricas internas · financeiro da empresa · credenciais · contratos · dados pessoais | `governanca.dados_proibidos_em_prompt[]` (vai para o `AGENTS.md` §4) |
| ◽ B9.5 | Limite de tamanho por arquivo `.md` | 35 KB aviso / 60 KB erro (recomendado) · outro | `governanca.limites` |

Padrões: semanal · git conforme B6.1 · telemetria desligada · [dados-de-cliente, credenciais, financeiro-da-empresa] · 35/60.

---

## B10 — Packs
`condicao: sempre`

Rode `python3 _cortex/cli/cortex.py pack suggest`: ele avalia a condição `sugerir_se` de cada pack existente contra as respostas já gravadas. Regras hoje: `marketing` sempre · `vendas` se B2B/B2B2C ou time vendas · `cs` se time cs/suporte/atendimento · `produto` se time produto ou oferta do tipo produto · `eventos` se oferta evento ou canal eventos · `dados` se integração de dados/analytics ou time dados · `visual` se canal de rede social, vídeo ou landing page, time design ou bloco `visual`. Some as pistas do `checkup` (materiais na pasta). Mostre só packs que existem em `_cortex/packs/`.

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B10.1 | Confirma a instalação destes packs? Em qual time cada um entra? | lista sugerida | `packs[]` com `instalado_em: times/<slug>`; `times[].pack` |

---

## B11 — Visual (pack `visual`)
`condicao: pack:visual or tem:visual` — só quando o pack visual for instalado ou a pessoa pedir sistema visual.

Pergunte o que alimenta o radar e as direções. Não peça valores de cor ou fonte aqui: eles nascem no `kit-visual`, a partir de referências aprovadas, ou são transcritos do que a marca já tem.

| # | Pergunta | Opções | ⇒ |
|---|---|---|---|
| 🔸 B11.1 | Em uma frase, qual é o nicho visual? (o que a marca faz, onde, para quem) | texto livre | `visual.nicho` |
| ◽ B11.2 | Que termos alguém do nicho usaria para buscar referência? (pt e en) | texto livre · "a IA sugere" | `visual.termos_nicho` |
| 🔸 B11.3 | Quem precisa se reconhecer nas imagens? | públicos do B4 · outro | `visual.publico_visual` |
| 🔸 B11.4 | A comunicação mostra pessoas reais (fundador, equipe, clientes)? | sim · não · às vezes | `visual.pessoas_reais` (muda retrato e autorização) |
| 🔸 B11.5 | Quais formatos o sistema precisa cobrir? (múltipla) | feed · carrossel · stories/reels · vídeo horizontal · site/landing · e-mail · apresentação | `visual.formatos` |
| ◽ B11.6 | Quem gera imagem, vídeo e peça de design? | ferramenta de IA específica · editor ou motor de vídeo · Figma · HTML · pessoa da equipe | `visual.executores` (sem resposta: a skill entrega especificação para humano) |
| ◽ B11.7 | Que perfis, sites ou canais você já usa como referência? | lista de URLs | `visual.fontes_proprias` (prioridade 1 no radar) |
| ◽ B11.8 | Alguma fonte que não quer usar (paga, concorrente direto, estética contrária)? | lista | `visual.fontes_vetadas` |

Padrões: termos sugeridos pela IA a partir do nicho e aprovados · executores vazios · nenhuma fonte vetada além das pagas.

---

## Fechamento

1. Monte o `cortex.config.yaml` completo (todas as chaves do schema; listas vazias onde não houver dado; `meta.onboarding.status: complete` se todos os blocos obrigatórios foram respondidos, senão `partial` com `blocos_concluidos`).
2. Mostre o YAML no chat e peça confirmação.
3. Grave em `cortex.config.yaml` na raiz.
4. Com Python: `python3 _cortex/cli/cortex.py init --answers cortex.config.yaml` (gera contexto, instala packs, gera rotas/catálogo/wrappers, roda o doctor). Sem Python: siga `geracao.md`.
5. Diga à pessoa o que ficou `[PENDENTE: preencher]` em `contexto/` — é o trabalho humano que transforma o esqueleto em base viva.
