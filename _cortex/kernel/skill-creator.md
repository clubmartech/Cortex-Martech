---
tipo: skill
id: skill-creator
descricao: "Entrega uma skill, um agente ou um doc novo ou corrigido, no padrão do Cortex, com rota resolvida, gatilhos sem colisão e histórico registrado."
familia: GOVERNAR
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quero criar uma skill no Cortex", "documenta esse processo como skill do Cortex", "como atualizo uma skill do Cortex", "como classifico esse arquivo do Cortex", "como escrevo os gatilhos do Cortex", "cria um agente num time do Cortex", "a skill do Cortex errou, corrige"]
requires: gate · governanca · anti-alucinacao
owner: cortex
origem: kernel
validado_em: 2026-10-09
---

> 🔒 **Chegou aqui direto?** Esta skill é transversal e normalmente é acionada pelo Maestro (família GOVERNAR), que carrega a fundação antes de passar para cá. Abrir só este arquivo pula a trava de ativação (`_cortex/kernel/gate.md`). **Volte ao agente antes de produzir.**

# Skill Creator — como nasce, muda e se cataloga um arquivo da base

> Skill mestra que define o padrão de criação, documentação e catalogação de skills, agentes e docs do Cortex. Use quando alguém quiser criar uma skill nova, documentar um workflow como skill, padronizar um processo recorrente, atualizar ou corrigir uma skill existente, criar um agente, ou verificar se algo já existe antes de criar.
>
> ⚠️ Antes de criar qualquer arquivo, verificar se ele já existe no `CATALOGO.md`. Se existir, avaliar se é caso de atualização, não de criação.
>
> **O frontmatter não é especificado aqui.** A fonte única é **`_cortex/CONTRATOS.md` §2** (14 campos, ordem fixa, regra do `id`, vocabulário de `output`, seções obrigatórias por tipo). Os vocabulários derivados do config (`canal`, `ferramenta`, `produto`, `publico`, `owner`, `familia`) **vêm do `cortex.config.yaml`; a lista ativa está em `CATALOGO.md` §0**. Se o valor não está lá, **pare e pergunte** — criar valor novo é decisão de quem mantém o config, não de quem escreve a skill.

---

## Sumário

- [Contexto de uso](#contexto-de-uso)
- [Processo](#processo)
- [1. Anatomia de uma skill e de um doc](#1-anatomia-de-uma-skill-e-de-um-doc)
- [2. Anatomia de um agente](#2-anatomia-de-um-agente)
- [3. Regra do `requires` — as duas pontas](#3-regra-do-requires--as-duas-pontas)
- [4. Regra de gatilhos](#4-regra-de-gatilhos)
- [5. Boas práticas anti-alucinação dentro de uma skill](#5-boas-práticas-anti-alucinação-dentro-de-uma-skill)
- [6. Checklist de entrega](#6-checklist-de-entrega)
- [Output esperado](#output-esperado)

---

## Contexto de uso

Acionar quando o pedido é de **GOVERNAR**: criar skill, sub-skill, agente ou doc; corrigir uma skill que errou; padronizar um processo recorrente em passo a passo acionável; classificar um arquivo que chegou sem tipo; revisar gatilhos que colidem; auditar se uma entrega seguiu a skill. **Não** acionar para documentar conhecimento de produto ou processo que será *consultado* (isso é DOCUMENTAR, `_cortex/kernel/documentador.agent.md`) nem para registrar uma entrega (REGISTRAR). Desempate em `_cortex/kernel/roteamento.md` §5, regra 12.

Vale a crítica leve de `gate.md` §1.1: antes de criar, confirme que a skill resolve um problema recorrente e que não existe outra que já o cobre.

---

## Processo

### 1. Verificação prévia

1. Buscar no `CATALOGO.md` por `id`, por gatilho parecido e por família. Existe? → atualização, não criação.
2. Perguntar, numa rodada só (formato de `descoberta.md`):
   - Qual processo ou workflow o arquivo cobre? Qual problema recorrente resolve?
   - Quando deve ser acionado — quais frases a pessoa diria?
   - Qual é o output que a pessoa recebe de volta?
   - Qual **papel** responde por ele (`owner` — slug de `papeis[]`)? Em qual time ou iniciativa mora?
   - Existe skill ou agente relacionado? Qual agente o roteia?
3. Decidir o **tipo** (`_cortex/CONTRATOS.md` §2): `agent` roteia e tem persona; `skill` é acionada por gatilho e produz output; `sub-skill` só existe dentro de uma skill-mãe; `doc` é consultado e não produz nada. A definição manda sobre a pasta. Jurisprudência: índice, modelo e briefing preenchido são `doc`; `descoberta` e `skill-creator` são `skill` mesmo vivendo no kernel.

### 2. Estrutura

1. `cortex new skill|agent|doc <nome> --time <time>` (ou `--iniciativa <slug>`) gera o arquivo com o frontmatter de 14 campos preenchido com o que o config permite, `id` derivado do nome e as seções obrigatórias do tipo vazias. Para o kernel não se usa `new`: arquivos de `_cortex/kernel/` são do projeto.
2. Preencher o frontmatter: `descricao` ≤ 160 caracteres, começando por verbo, dizendo **o que a pessoa recebe** (não o que a skill faz); `familia` (kernel ou sub-família do pack ativa); `output` do vocabulário do kernel; `canal`/`ferramenta`/`produto`/`publico` com slugs do config ou vazios; `gatilhos` (§4); `requires` (§3); `owner` por papel; `origem: time` (ou a que o `new` gravar); `validado_em` = hoje.
3. Escrever o corpo na anatomia do tipo (§1 ou §2).
4. `cortex lint --file <arquivo>` — o hook `PreToolUse` já roda isso na gravação; rode de novo depois de qualquer edição à mão.

### 3. Registro em rota

1. **Skill:** o `requires` começa pelo agente que a roteia; o agente ganha a linha correspondente na seção *Roteador de missão* (§3). Se o pack define a sub-família, confira que a skill aparece na lista `obrigatorio`, `condicional` ou `complementar` dela — senão, é achado para o mantenedor do pack.
2. **Agente:** entra no `ROTAS.md` §2 pelo frontmatter (`tipo: agent` + `familia`). Com `subagente: true`, o `build` gera `.claude/agents/<id>.md`.
3. **Doc:** entra pelo `requires` de quem o consome e pelo `CATALOGO.md`. Doc que ninguém cita no `requires` é doc que ninguém abre — o `doctor` avisa.
4. `cortex build` — regera `ROTAS.md`, `CATALOGO.md` e os wrappers. **Nunca edite o `ROTAS.md` à mão:** é gerado, o hook nega.

### 4. Histórico e ratificação

1. Linha no `## Histórico`: `| AAAA-MM-DD | Criação do arquivo. Ratificada por <papel> no ato da publicação. | <papel> |` — ou `Ratificação por <papel> PENDENTE desde AAAA-MM-DD.` quando quem publica não ocupa o papel ratificador (`governanca.md` §4).
2. `validado_em` = a data dessa linha.
3. Com `governanca.git: true`: commit com a frase da linha, prefixada pelo caminho.
4. Apresentar o arquivo **inteiro no chat** antes de gravar (`governanca.md` §2) — criar skill também é produção.

### 5. Corrigir uma skill que errou

1. Reproduzir: qual pedido, qual saída, qual regra da skill não foi aplicada ou está errada.
2. Diagnosticar a causa: (a) a skill não foi aberta (problema de rota ou gatilho → §3, §4); (b) foi aberta e a regra é ambígua (reescrever a regra, com exemplo bom e ruim); (c) foi aberta, a regra é clara e o modelo não seguiu (reforçar com checklist no *Output esperado*; aplicar §5).
3. Editar a fonte — nunca a saída. Linha no Histórico com a causa em uma frase. `lint`, `build`.

---

## 1. Anatomia de uma skill e de um doc

**Skill / sub-skill** (`_cortex/CONTRATOS.md` §2.4): bloco 🔒 "Chegou aqui direto?" logo após o frontmatter · `# Título legível` · parágrafo de contexto (o que faz, por que existe) · `## Contexto de uso` (quando exatamente acionar — situações concretas; quando **não** acionar) · `## Processo` (passo a passo numerado, acionável: diz **o que fazer**, inclusive onde parar e perguntar, e onde abrir a ficha de integração antes do conector) · `## Output esperado` (formato, nível de detalhe, a quem se destina; checklist final) · `## Histórico`.

Sub-skill: igual, com `requires: <agente> · <skill-mãe>` e sem repetir o que a mãe já resolve — descreve só a mecânica própria do canal ou do caso.

**Doc:** `# Título` · blockquote de abertura ("O que é / Quando usar / O que não é") · seções livres · `## Histórico`. Doc > 35 KB exige `## Sumário` com âncoras; aspire a ficar abaixo de 25 KB — doc grande é aberto por seção. Doc com **dado embutido** que muda com o tempo (série mensal, ranking, lista) guarda o contexto do indicador e o dado; o **processo de atualização** vive numa skill de DOCUMENTAR, não no doc — doc que descreve passo a passo diverge da skill, é questão de tempo.

**Tamanho:** `governanca.limites.aviso_kb` avisa, `erro_kb` bloqueia. Arquivo que passa do aviso é candidato a split por responsabilidade, não por tamanho.

---

## 2. Anatomia de um agente

Todo `*.agent.md` tem:

1. **Frontmatter** de 14 campos com `tipo: agent` (opcional `subagente: true` quando o agente pode rodar isolado, com contexto próprio — caso do Revisor).
2. **Trava de ativação no topo** — bloco 🔒 antes de qualquer seção, declarando a primeira linha `LIDOS:` do agente (formato de `gate.md` §1), se opera com fundação completa ou leve, e o que ele não faz sem o cartão `BRIEFING VALIDADO ✅`.
3. **Seções do corpo, nesta ordem** (`_cortex/CONTRATOS.md` §2.4):

| Seção | O que traz |
|---|---|
| `## Quem eu sou` | persona em 1ª pessoa — o que faz, o que não faz, o que valoriza |
| `## Como me ativar` | via Maestro, ativação direta, por handoff |
| `## Contexto que eu sempre carrego` | o que abre antes de qualquer coisa — deve bater com o `requires` |
| `## Roteador de missão` *(opcional)* | demanda → skill. É a **saída** do roteamento; a **entrada** é o `requires` da skill apontando de volta (§3). Agente de etapa única (Entrevistador) ou que organiza por modos não tem |
| `## Meu processo` | passo a passo, incluindo onde ele **para** para abrir a sub-skill ou perguntar |
| `## Briefing que eu exijo` | o mínimo obrigatório antes de produzir (cartão, ou contexto mínimo se não cria do zero) |
| `## Regras inegociáveis` | o que ele nunca faz |
| `## Handoffs` | para quem passa e em que condição; de quem recebe |
| `## O que eu entrego` | formato do output |
| `## Histórico` | tabela de 3 colunas |

4. **Registro no `ROTAS.md`** sai do frontmatter pelo `build`: `id → arquivo → família`. Não existe arquivo de configuração por agente — o handoff mora na seção *Handoffs* e o que ele abre, no `requires`.

---

## 3. Regra do `requires` — as duas pontas

O `requires` de toda skill **começa pelo `id` do agente que a roteia**, seguido da skill-mãe quando for sub-skill: `requires: redator · redator-comum`. Duas razões:

1. **A skill não repete a fundação.** `gate`, `brandcenter`, `anti-alucinacao` e `governanca` chegam pelo agente. Repetir a lista em dezenas de arquivos mantidos à mão é dessincronia garantida.
2. **Quem abrir a skill direto encontra o caminho de volta.** O `requires` resolve isso com um item, sem editar o corpo.

O roteamento fica registrado nas **duas pontas**: o agente aponta para a skill (*Roteador de missão*) e a skill aponta para o agente (`requires`). O `cortex doctor` compara as duas e acusa divergência. **Sub-skill que vira destino de pedido avulso precisa de rota própria no agente**; sub-skill que só existe dentro de uma análise maior, não.

Em `requires` usam-se **ids**, nunca caminhos. O fecho transitivo (`roteamento.md` §1) faz o resto.

---

## 4. Regra de gatilhos

O acionamento é por **`id` + `gatilhos`**. A `descricao` não aciona nada — é para leitura humana e para o wrapper gerado.

- **Gatilho é frase, não palavra solta** — em `skill`, `sub-skill` e `doc`. O jargão do time entra **dentro** da frase: `manda uma mensagem pra base` (não `mensagem`), `e-mail de repique` (não `repique`). Em `doc`, são **perguntas** que a pessoa faria, não comandos.
- **`agent` está liberado** para palavra solta: o agente é o funil amplo; palavra solta ali é cobertura, não imprecisão.
- **Faixa recomendada:** 5 a 12 numa skill · 8 a 16 num agente · 5 a 10 num doc. Mínimo de 3 em qualquer arquivo — **recomendação**, não bloqueio. Não altere um arquivo só para atingir número: arquivo de escopo estreito com 3 ou 4 gatilhos reais é melhor que 5 frases inventadas que ninguém diz.
- **Agente roteador não tem teto.** Um agente que roteia várias sub-skills de canal precisa reconhecer toda demanda que encaminha — cobertura é a função dele. O `lint` trata como roteador o agente que cita 5 ou mais skills no corpo; o teto de 16 só avisa para agente que executa direto.
- **Nenhum gatilho se repete entre dois arquivos do mesmo `tipo`** (agent × agent, skill × skill, doc × doc). Se repetir, um dos dois está mal definido: dois arquivos disputam o mesmo pedido sem sinal que desempate. O `lint` bloqueia.
- **O que NÃO é colisão** (jurisprudência — auditoria não deve apontar):

| Padrão | Exemplo | Por quê |
|---|---|---|
| Agente × skill que ele roteia | `escreve um e-mail` no agente criador e na skill de e-mail | o agente reconhece para rotear; a skill aplica a regra. Comportamento esperado da arquitetura |
| Paralelismo por produto, pessoa, índice ou campanha | `banco de criatividade do <produto>` em arquivos irmãos, um por produto | o nome do produto (pessoa, índice, campanha) **é** o desempate |
| Nome de oferta compartilhado | `banco de criatividade do X` × `o que é o X` | assuntos distintos; só compartilham o nome |
| Maestro | poucos gatilhos genéricos (`qualquer pedido inicial`) | genérico por função; a cobertura está no `ROTAS.md`, não no número de frases |

**Exemplo ruim:** `gatilhos: ["social", "post", "conteúdo"]` — três termos soltos que colidem com meia dúzia de skills e não descrevem pedido nenhum.
**Exemplo bom:** `gatilhos: ["preciso de post para o desafio", "briefing semanal do programa", "o colaborador quer publicar sobre a empresa", "revisão de post de participante"]` — frases reais, específicas de um programa, que não servem para outra skill.

---

## 5. Boas práticas anti-alucinação dentro de uma skill

Ao escrever ou revisar as instruções de uma skill, aplique:

- **Permita o "não sei".** Inclua a permissão explícita: *"Se não tiver informação suficiente para esta etapa, diga 'Não tenho contexto suficiente para responder com confiança' e peça o dado que falta, em vez de gerar resposta aproximada."*
- **Use citação literal como âncora** em workflows sobre documentos longos: *"1. Extraia trechos literais relevantes para [objetivo]; se não encontrar, escreva 'Nenhuma citação relevante encontrada'. 2. Use só esses trechos como base."*
- **Exija verificação com fonte** em skills que geram output factual: *"Após gerar, revise cada afirmação factual; sem citação de suporte no material, remova e marque `[NECESSITA FONTE]`."*
- **Ficha antes do conector:** toda skill que chama integração abre `contexto/integracoes/<slug>.md` antes da primeira chamada e cita só tabela, campo ou filtro que está lá.
- **Restrinja o conhecimento externo** quando a skill opera sobre briefing ou dado proprietário: *"Use apenas as informações fornecidas neste contexto."*
- **Raciocínio antes da resposta** em skill analítica ou de decisão; **refinamento iterativo** em skill de revisão por etapas (output de uma etapa vira input verificado da próxima).
- **Marcadores oficiais** (`anti-alucinacao.md` §4.1) no *Output esperado* — a skill diz onde eles aparecem.

⚠️ Nenhuma técnica elimina alucinação. Em output de alto impacto (apresentação para liderança, dado publicado, comunicado), a skill instrui validação humana antes do uso.

---

## 6. Checklist de entrega

- [ ] `CATALOGO.md` consultado — não existe arquivo que já cubra isto.
- [ ] Frontmatter completo: 14 campos na ordem de `_cortex/CONTRATOS.md` §2; `descricao` ≤ 160, por verbo; vocabulários do `CATALOGO.md` §0; campos vazios onde não se aplica.
- [ ] `owner` é slug de `papeis[]`, nunca pessoa.
- [ ] `gatilhos` com frases reais na faixa do tipo, nenhuma repetindo gatilho de outro arquivo do mesmo tipo (§4).
- [ ] `requires` começa pelo agente que roteia (skill) e o agente aponta de volta (§3).
- [ ] Seções obrigatórias do tipo presentes (§1, §2).
- [ ] Técnicas anti-alucinação aplicadas nas instruções (§5), ficha de integração antes de conector.
- [ ] Arquivo apresentado no chat e aprovado antes de gravar.
- [ ] `cortex lint --file` sem erro · `cortex build` rodado · arquivo aparece no `ROTAS.md` e no `CATALOGO.md`.
- [ ] Linha no `## Histórico` com ratificação (concedida ou PENDENTE) · `validado_em` = data da linha · commit, se `governanca.git`.

---

## Output esperado

O arquivo novo ou corrigido, **inteiro no chat** antes da gravação, seguido do bloco:

```
ARQUIVO: <caminho>  (tipo · família · owner)
ROTA: <agente que roteia> → <id>  |  requires: <ids>
GATILHOS: <n> frases — colisões verificadas no CATALOGO.md: nenhuma
LINT: ok  |  BUILD: rodado — ROTAS.md §<n> e CATALOGO.md atualizados
HISTÓRICO: <linha gravada>  |  RATIFICAÇÃO: concedida por <papel> / PENDENTE
```

Para correção de skill: o diagnóstico (a, b ou c do Processo §5) em uma frase, o trecho antes e depois, e a linha de Histórico.

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-09 | Gatilhos restritos a skills e agentes do Cortex; skill própria do drive é da skill `skills-e-agentes`. Pedido do fundador. | fundador |
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
