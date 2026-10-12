---
tipo: doc
id: governanca
descricao: "Reúne a política de uso de IA, os dados proibidos em prompt, a ratificação, os owners por papel, a estrutura de pastas, a nomenclatura e os gates da base."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual a política de uso de IA", "o que não pode entrar no prompt", "preciso de ratificação para isso", "quem é o dono desse arquivo", "onde salvo o material gerado", "como nomeio o arquivo", "como registro a mudança no histórico", "quais são os gates do doctor"]
requires:
owner: cortex
origem: kernel
validado_em: 2026-10-12
---

# governanca.md — Política de uso, dados, papéis, estrutura e versionamento

> **O que é:** a governança do Cortex num arquivo só — o que vale em **todo** pedido (§1–§3) e o que importa ao criar, nomear, editar ou arquivar um arquivo (§4–§11). Um dos três pilares da fundação (`_cortex/kernel/gate.md` §2). Os valores que mudam por organização (quem ratifica, quais dados são proibidos, para onde vai o material) **vêm do `cortex.config.yaml`** — este arquivo explica a regra; o config diz o valor.

---

## Sumário

- [0. Princípio](#0-princípio)
- [1. Política de uso](#1-política-de-uso)
- [2. Chat antes do arquivo](#2-chat-antes-do-arquivo)
- [3. Dados proibidos em prompt](#3-dados-proibidos-em-prompt)
- [4. Ratificação](#4-ratificação)
- [5. Owners por papel — nunca pessoa](#5-owners-por-papel--nunca-pessoa)
- [6. Estrutura de pastas do Cortex](#6-estrutura-de-pastas-do-cortex)
- [7. Nomenclatura única](#7-nomenclatura-única)
- [8. Destino do material gerado](#8-destino-do-material-gerado)
- [9. Histórico por arquivo e git](#9-histórico-por-arquivo-e-git)
- [10. Os três gates — `cortex doctor`](#10-os-três-gates--cortex-doctor)
- [11. Sinalizar problemas](#11-sinalizar-problemas)

---

## 0. Princípio

O Cortex é uma **camada operacional**: padroniza como o time usa IA, oferecendo a base de conhecimento e as regras para produzir com autonomia, velocidade e consistência. Não é ferramenta isolada, não substitui o julgamento humano em decisão estratégica e não é experimento — é infraestrutura. **Qualquer pessoa do time deve conseguir executar qualquer processo coberto pela base com o mesmo nível de qualidade, independente de experiência prévia.** A estrutura é **independente de ferramenta**: o conhecimento documentado vale seja qual for o assistente de IA em uso.

---

### 0.1 Atualização e autoridade da informação

A atualização da informação faz parte da execução. Antes de usar um dado mutável, consulte a fonte canônica pertinente, sua data, evidência e escopo. Uma cópia recente ou uma lembrança não vence automaticamente a fonte do assunto.

| Informação | Fonte responsável |
|---|---|
| Preferência pessoal ou decisão explícita do interlocutor | Sistema de memória pessoal autorizado, com evidência e escopo |
| Fato de negócio, posicionamento e voz editorial autorizada | Contexto canônico do projeto |
| Método de trabalho | Fonte da skill ou do agente; adaptações de fornecedor ficam separadas |
| Configuração e versão instalada | Configuração e arquivo de versão do sistema correspondente |
| Andamento e pendências de uma tarefa | Briefing ou handoff |

Ao corrigir informação, verifique mudanças concorrentes, edite a origem autorizada, preserve a evidência no histórico, regenere os consumidores afetados e confira a paridade. Não acrescente uma segunda regra que deixe a anterior contraditória em circulação. Quando faltar evidência, registre a lacuna e continue o trabalho independente.

Memória pessoal e documentação compartilhada são sistemas complementares: mantenha uma fonte por tipo de informação e referências entre elas. Não copie dados privados para contexto público nem una projetos apenas porque se chamam igual. A unificação de duplicatas exige confirmar função, origem, consumidores e possibilidade de reconstrução, preservando a fonte canônica.

O pedido atual prevalece sobre uma preferência antiga no mesmo escopo. Mudança persistente exige evidência ou pedido explícito; atualização não autoriza publicação, envio ou mudança de outros sistemas fora do escopo. As autorizações já dadas continuam válidas e não precisam ser solicitadas novamente.

## 1. Política de uso

### O que pode ser feito com IA

- Produção e revisão de texto e conteúdo (posts, e-mails, páginas, roteiros, legendas).
- Briefings de campanha e de conteúdo.
- Análise de dados e performance de canais.
- Estruturação de relatórios e apresentações.
- Planejamento de ações, eventos e experimentos.
- Pesquisa e curadoria de conteúdo.
- Geração de parâmetros de rastreio, checklists e templates operacionais.
- Documentação de produto e processo, registro de entregas.

### O que exige validação humana antes de publicar

- Qualquer conteúdo externo com menção a produto, funcionalidade ou posicionamento.
- Texto com dados numéricos (métricas, resultados, benchmarks).
- Comunicações institucionais ou de crise.
- Conteúdo que envolva parceiros, clientes ou pessoas nomeadas.
- Qualquer `.md` novo de conhecimento operacional na base (§4).

### O que não deve ser feito com IA

- Tomar decisão estratégica sem revisão do responsável pelo papel.
- Publicar conteúdo externo sem validação humana.
- Usar a IA como fonte de dados — a IA usa os dados que você fornece ou que a base e os conectores devolvem com fonte.

### Anti-alucinação, fontes e marcadores — fonte única

> **`_cortex/kernel/anti-alucinacao.md`** (abra o arquivo — não assuma que está no contexto) é a fonte única: princípios e regra de segurança máxima (§2), o que nunca inventar (§3), fontes válidas e os seis marcadores (§4), ações na incerteza (§5), perguntas de verificação (§6). Não repetido aqui de propósito. Princípio de bolso: **sem fonte válida, interrompe e pergunta** — nunca assume, infere ou completa lacuna.

---

## 2. Chat antes do arquivo

Regra ativa quando `operacao.fluxo_chat_antes_do_arquivo: true` (padrão):

- Qualquer conteúdo que vá se tornar um arquivo (briefing, documento, planilha, apresentação, `.md` da base) é **gerado e apresentado primeiro no chat**, em texto, para quem pediu revisar e ajustar.
- Só depois de **aprovação explícita** dessa pessoa a IA gera o arquivo completo e final — no destino correto (§8).
- Vale para **qualquer** tipo de conteúdo. A regra específica de briefing ("rascunho fica no chat até validar", em `briefings/_modelo.md`) é a mesma.
- **Exceção:** pedido explícito de "já pode gravar o arquivo direto" ou equivalente.

Complemento: com `operacao.criar_arquivo_sem_pedido: false`, a IA **não cria arquivo novo** na base sem pedido explícito — o hook `PreToolUse` pede confirmação antes de gravar (`_cortex/CONTRATOS.md` §9).

---

## 3. Dados proibidos em prompt

A lista vem de `governanca.dados_proibidos_em_prompt` no `cortex.config.yaml`. Valores típicos e o motivo:

| Dado restrito | Motivo |
|---|---|
| `preco-de-produto` — preço, tabela, desconto não público | Informação comercial sensível |
| `dados-de-cliente` — nome, documento, contrato, contato | Privacidade e confidencialidade |
| `metricas-internas` — resultado interno não público | Dado estratégico |
| `financeiro-da-empresa` — faturamento, margem, orçamento | Confidencialidade corporativa |
| `credenciais` — senha, token, chave de API | Segurança de acesso |

Vale para prompt, card, comentário no registro, arquivo da base e material gerado.

**Boas práticas:** nunca colar planilha interna no prompt sem anonimizar; em exemplos reais, substituir nomes por "Cliente A", "Empresa X"; não usar IA em rede não segura para dado sensível; em dúvida sobre o que pode ser compartilhado, perguntar ao papel `sessao.papel_configurador` antes de prosseguir. Dado que chega via conector é lido, não copiado para arquivo da base: o que entra na base é o conhecimento derivado, com fonte, não o dado bruto restrito.

---

## 4. Ratificação

**Todo arquivo novo de conhecimento operacional** — agent, skill, sub-skill, doc, inclusive doc de produto e de referência — precisa de ratificação antes de ser usado oficialmente. A ratificação é registrada **na linha do `## Histórico`** do arquivo (não existe campo próprio no frontmatter).

Quem ratifica vem do config:

| Config | Quem ratifica |
|---|---|
| `governanca.comite: true` | o papel em `governanca.ratificador` (um comitê, ex.: `comite-ia`) — a deliberação é coletiva |
| `governanca.comite: false` | o papel em `governanca.ratificador` (uma função, ex.: `lider-marca`) |
| `governanca.ratificador` vazio | o papel `sessao.papel_configurador` |

- Quem publica **ocupa** o papel ratificador → **autoconcede** no ato e registra na linha do Histórico: `Criação do arquivo. Ratificada por <papel> no ato da publicação.`
- Quem publica **não ocupa** → a ratificação fica **PENDENTE** até deliberação; registra-se `Criação do arquivo. Ratificação por <papel> PENDENTE desde AAAA-MM-DD.` e o arquivo não é usado oficialmente até lá.
- Ratificação pode entrar numa edição posterior — a linha descreve a edição e acrescenta o fato.
- **Categoria pré-autorizada:** quando um tipo de arquivo nasce em série (ex.: um registro de conteúdo publicado por lançamento), o ratificador pode autorizar a **categoria**, e cada arquivo registra `categoria pré-autorizada` na linha. Nunca por dedução — a autorização da categoria é um fato registrado no doc que a define.

Arquivos de `_cortex/kernel/` são do projeto (`owner: cortex`) e não passam por ratificação local — mudança de kernel é atualização de versão (`_cortex/kernel/VERSION`).

---

## 5. Owners por papel — nunca pessoa

- O campo `owner` do frontmatter é **sempre um slug de `papeis[]`** do `cortex.config.yaml` — nunca nome de pessoa. Vários donos separados por ` · `. `cortex` é reservado ao kernel.
- **Quem ocupa cada papel** fica em `contexto/organizacao.md` — fonte única de pessoa → papel. Se a pessoa muda, muda-se lá; nenhum arquivo da base precisa ser tocado.
- **Autonomia com responsabilidade:** o dono (papel) pode fazer alteração estrutural no próprio arquivo sem aprovação prévia. Aprovação do ratificador (§4) continua obrigatória para (a) arquivos de fundação do contexto (`contexto/brandcenter/`, `contexto/organizacao.md`) e (b) alteração que cruze times ou afete arquivo de outro dono.
- **Quem revisa o quê** sai das `responsabilidades` de `papeis[]`: `revisa-externo` (texto que sai para o mercado), `revisa-dados` (número, análise, relatório), `ratifica-skills` / `ratifica-kernel` (conhecimento operacional), `opera-registro` (registro primário), `mantem-base` (estrutura e rotas). Quem publica é responsável por revisar o output e acionar o papel certo — não há etapa de aprovação obrigatória além das de §1 e §4.
- **Todo o time:** usar os documentos de base (nunca pedir criação sem o contexto certo) · registrar outputs no registro primário · acionar revisão quando o conteúdo é sensível · sinalizar problemas (§11) · não compartilhar dados restritos (§3).

---

## 6. Estrutura de pastas do Cortex

```
<raiz>/
├── cortex.config.yaml          ← contexto: o init gera; o time edita
├── AGENTS.md · CLAUDE.md · ROTAS.md · CATALOGO.md   ← gerados pelo build; nunca editar à mão
├── _cortex/
│   ├── CONTRATOS.md            ← especificação interna (frontmatter, famílias, condições)
│   ├── kernel/                 ← este arquivo e os demais da fundação; VERSION
│   ├── templates/ · packs/ · cli/ · onboarding/      ← mantidos pelo projeto
│   └── .build/                 ← boot.md, manifest.json, catalogo.json (gerados)
├── contexto/                   ← organização, brandcenter/, produtos/<slug>/, publicos, integracoes/<slug>.md, vozes
├── times/<time>/               ← agents/ · skills/ · docs/ instanciados do pack; o time é dono
├── iniciativas/<slug>/         ← iniciativa.yaml + docs/ · skills/ · agents/
├── briefings/                  ← _modelo.md na raiz; preenchidos em <ciclo>/
├── _saida/<AAAA-MM>/           ← material gerado quando o destino é "saida"; fora do escopo do scanner
├── _assets/                    ← binários (imagem, fonte); fora do escopo
├── _arquivo/                   ← o que saiu de uso; NUNCA lido como fonte
└── .claude/                    ← skills/ e agents/ gerados (wrappers), hooks/
```

| Camada | Onde | Quem escreve | O `build` sobrescreve? |
|---|---|---|---|
| Kernel | `_cortex/kernel/`, `_cortex/templates/`, `_cortex/packs/`, `_cortex/cli/`, `_cortex/onboarding/` | mantenedor do Cortex | nunca |
| Contexto | `cortex.config.yaml`, `contexto/**` | `init` gera; o time edita | só com `--first-run` (ou arquivo ausente) |
| Gerados | `AGENTS.md`, `CLAUDE.md`, `ROTAS.md`, `CATALOGO.md`, `.claude/skills/<id>/SKILL.md` (exceto `cortex-*`), `.claude/agents/<id>.md`, `_cortex/.build/*` | `build` | sempre (só grava se o hash mudou) |
| Times / iniciativas | `times/<time>/**`, `iniciativas/<slug>/**` | pack instancia; o time é dono | nunca (`cortex pack diff` mostra divergência) |
| Fora do escopo | `_arquivo/`, `_saida/`, `_assets/`, `.git/`, `.obsidian/`, `__pycache__/`, `node_modules/` | — | — |

**Arquivo gerado** tem `origem: gerado` e, na primeira linha do corpo, o marcador `<!-- gerado pelo cortex build … -->`. Nunca se edita: edita-se a fonte (config, kernel, pack, time) e roda-se `cortex build`. O hook `PreToolUse` nega a gravação.

**Pasta não tem índice próprio.** O `CATALOGO.md` (gerado) lista todos os arquivos com `id`, caminho, peso, família, `requires` e "consumido por". Se a navegação de uma pasta ficar difícil, melhora-se a `descricao` dos arquivos ou abre-se uma sub-família no pack — não se cria índice à mão.

---

## 7. Nomenclatura única

| Regra | Como |
|---|---|
| Caixa e separador | **kebab-case**, minúsculas, sem acento, sem espaço, sem underscore; pt-BR |
| Prefixo = tipo | agente: `<nome>.agent.md` · skill, sub-skill e doc: **sem prefixo** (`redator-email.md`, `benchmarks-canal.md`) |
| `id` | deriva do nome do arquivo (`_cortex/CONTRATOS.md` §2.1) — único na base inteira; nome repetido em pasta diferente ganha sufixo de escopo |
| Slug de produto, canal, público, integração, papel | o slug do `cortex.config.yaml` — **nunca inventar grafia nova**; o nome por extenso vai na prosa |
| Ficha de produto | `contexto/produtos/<slug>/<slug>.md` (doc-raiz) + filhos na mesma pasta |
| Ficha de integração | `contexto/integracoes/<slug>.md` |
| Briefing preenchido | `briefings/<ciclo>/<time>-<tipo>-<tema>.md` (ciclo conforme `operacao.ciclo_planejamento`, ex.: `2026-q4`) |
| Iniciativa | `iniciativas/<slug>/` com `iniciativa.yaml`, `docs/`, `skills/`, `agents/` — só quando há 3+ skills próprias, mecânica que não se confunde com a de um time, e recorrência |
| Material em `_saida/` | `_saida/<AAAA-MM>/<nome-original>` — mantém o nome, nunca ganha `id` nem frontmatter de base |
| Arquivado | `_arquivo/<caminho-original>` — move, não apaga |

Todo `.md` dentro do escopo nasce com o **frontmatter de 14 campos** (`_cortex/CONTRATOS.md` §2) — briefing, doc de produto, skill, agente, arquivo de contexto. Arquivo sem frontmatter é invisível para o `ROTAS.md` e para o `CATALOGO.md`. Se não souber o `owner`, pergunte antes de salvar — não invente dono.

---

## 8. Destino do material gerado

**Material gerado nunca vai para a base** — copy, peça, campanha, post, análise, plano, apresentação, qualquer entrega criada durante uma demanda. A base guarda **conhecimento operacional reutilizável** (skills, docs, aprendizados validados, fichas). O destino vem de `operacao.destino_material_gerado`:

| Valor | Para onde vai | Como |
|---|---|---|
| `registro` | o **registro primário** (`integracoes[]` com `registro_primario: true`) — card, tarefa ou página indicada pelo solicitante | o Registrador (`_cortex/kernel/registrador.agent.md`) registra; texto no comentário, nunca HTML; o arquivo final vai para a pasta de rede que o solicitante indicar |
| `saida-local` | `_saida/<AAAA-MM>/`, com o nome original | fora do escopo do scanner; a pessoa move para o destino definitivo |
| `chat` | só no chat | nada é gravado; a pessoa copia |

Fluxo obrigatório, em qualquer valor: (1) gere e **apresente integralmente no chat** (§2); (2) **pergunte** o destino quando houver mais de um possível (qual card, qual pasta); (3) grave **só após indicação explícita**; (4) sem indicação, grave em `_saida/<AAAA-MM>/` mantendo o nome original e **avise no chat** que ficou ali, pendente de mover.

**Estados de uma entrega — não confunda:** *entregue no chat ou em `_saida/`* (rascunho local) → *aprovada* (o papel revisor ou o solicitante disse que serve) → *publicada* (está no ar, no canal). Cada estado exige evidência própria: arquivo gravado não é aprovação, aprovação não é publicação. Ao reportar, diga em qual estado a peça está; nunca declare "publicado" sem conferir o canal.

**Exceções — o que *pode* entrar na base:**
- **Briefing preenchido** a partir de `briefings/_modelo.md` → `briefings/<ciclo>/`, com frontmatter (`output: briefing`), além do registro no registro primário. A raiz de `briefings/` guarda só os modelos.
- **Registro de conteúdo publicado** (conhecimento de produto + índice do que saiu, não as peças) → `contexto/produtos/<slug>/` ou `times/<time>/docs/`, pelo Documentador, como categoria pré-autorizada (§4).
- **Conhecimento reutilizável** nascido de uma entrega (um case novo, um aprendizado de canal) migra para o doc que já é fonte única daquele assunto — não vira arquivo avulso.

**Nunca use como destino de entregável** a raiz, `_cortex/`, `contexto/`, `times/` ou `iniciativas/` — inclusive quando a ferramenta de IA sugerir a pasta conectada como padrão. Entregável com `id` e `gatilhos` vira fonte roteável de peça nova: um post de setembro catalogado reaparece em outubro como se fosse direcional aprovado.

**`_arquivo/` nunca é lido como fonte** — nem para "ver como era". O hook `PreToolUse` nega a leitura. Arquivo que voltou de `_arquivo/` religa a rota de quem o citava. No corpo de um `.md`, descreva o arquivamento sem o caminho literal ("arquivado em AAAA-MM-DD").

---

## 9. Histórico por arquivo e git

Nenhuma edição, criação ou arquivamento de `.md` desta base está concluída sem, para **cada** arquivo tocado:

1. **Nova linha no topo do `## Histórico`** do arquivo — tabela `| Data | O que mudou | Papel |`, mais recente primeiro; **uma frase objetiva de até 150 caracteres** que resuma o conjunto da edição (não a lista de mudanças); mais de uma edição no mesmo dia → `AAAA-MM-DD (2ª edição do dia)`; a coluna Papel leva o slug do papel, nunca nome de pessoa.
2. **`validado_em`** do frontmatter = a data dessa linha.
3. **`cortex lint --file <arquivo>`** sem erro (o hook `PreToolUse` já roda isso em `Write`/`Edit`).
4. **`cortex build`** quando a edição muda `id`, `gatilhos`, `requires`, `familia`, `tipo` ou cria/arquiva arquivo — para o `ROTAS.md`, o `CATALOGO.md` e os wrappers refletirem o estado real.
5. **Git, quando `governanca.git: true`:** um commit por edição lógica, mensagem = a frase da linha do Histórico, prefixada pelo caminho (`contexto/produtos/x/x.md: Atualiza a persona compradora.`). O histórico completo vive no git; o `.md` guarda a tabela inteira enquanto couber no limite de tamanho (`governanca.limites`) — ao passar, as linhas mais antigas saem para o git e o arquivo mantém um ponteiro `> Histórico anterior a AAAA-MM-DD: ver git.`
6. **Arquivamento:** "deletar" é sempre **mover para `_arquivo/`**, nunca excluir. Registra-se a linha no Histórico do arquivo movido e nos arquivos que o citavam (religar ou remover a rota).

Arquivos desatualizados há mais de 90 dias (pelo `validado_em`) aparecem no `cortex doctor` para revisão ou arquivamento; a auditoria periódica segue `governanca.auditoria`.

---

## 10. Os três gates — `cortex doctor`

Passar nos três é critério de aceite para qualquer `.md` entrar ou mudar na base. Rodam juntos em `cortex doctor` (completo) e, no recorte do arquivo, em `cortex lint --file`.

| Gate | O que confere | Bloqueia | Avisa |
|---|---|---|---|
| **1. Frontmatter válido** | parseia como YAML; os 14 campos na ordem; valor com caractere especial entre aspas; `descricao` ≤ 160 caracteres e começa por verbo; vocabulários fechados (`output` do kernel; `canal`, `ferramenta`, `produto`, `publico`, `owner`, `familia` do config e dos packs); campo que não se aplica vazio (nunca `N/A`); `validado_em` = data da primeira linha do Histórico | qualquer item anterior | gatilhos fora da faixa recomendada (`skill-creator.md` §4); gatilho repetido entre arquivos do mesmo `tipo` |
| **2. Rota resolve** | todo `requires` aponta para `id` existente; todo caminho em crase existe dentro da base; nenhum destino de leitura em `_arquivo/`, em drive externo ou em arquivo que só existe com uma pessoa; roteamento registrado nas duas pontas (agente → skill no corpo; skill → agente no `requires`); `{{` residual em arquivo gerado | caminho ou id inexistente; `_arquivo/` como fonte | remissão a seção inexistente |
| **3. Estrutura** | frontmatter presente; exatamente um H1; seções obrigatórias do tipo (`_cortex/CONTRATOS.md` §2.4); `## Histórico` em tabela de 3 colunas, mais recente no topo; `## Sumário` quando o arquivo passa de 35 KB; tamanho dentro de `governanca.limites` (`aviso_kb` avisa, `erro_kb` bloqueia); arquivo presente no `CATALOGO.md` após o `build` | H1, seções ou Histórico ausentes; acima de `erro_kb` | acima de `aviso_kb`; sem sumário no limiar; `id` que não deriva do nome |

Rota que aponta para fora da base não quebra — resolve para o nada e o agente responde **sem a fonte, sem avisar**. Por isso o gate 2 bloqueia: se a fonte real está num arquivo externo, o passo é trazer o conteúdo como `.md` canônico.

---

## 11. Sinalizar problemas

Quando a IA gerar algo incorreto, inconsistente, desatualizado ou fora do padrão, ou quando faltar conteúdo na base:

- **Arquivo da sua responsabilidade (seu papel é o `owner`)?** Corrija direto, com linha no Histórico — não abra chamado.
- **Arquivo de outro dono?** Registre o problema no registro primário (card para o papel dono, ou o fluxo que o pack definir em `times/<time>/docs/`) com: arquivo, trecho, o que está errado, a fonte correta se houver.
- **Dado desatualizado detectado por conector** (`anti-alucinacao.md` §4.2)? Entregue com `[CONECTOR: …]`, aponte a divergência e acione o Documentador (`_cortex/kernel/documentador.agent.md`) para gravar o dado novo com fonte e `validado_em`.
- **Falta de conteúdo** (produto sem ficha, integração sem ficha, pergunta sem doc)? Declare a lacuna na entrega — marcador `[NECESSITA FONTE]` — e registre como demanda de DOCUMENTAR.

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-12 | §8: estados de uma entrega (local, aprovada, publicada) e valor `saida-local` alinhado ao schema. | cortex |
| 2026-10-04 | Define fontes por tipo de informação e atualização com evidência e regeneração dos derivados. | cortex |
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
