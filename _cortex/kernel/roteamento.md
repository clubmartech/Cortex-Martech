---
tipo: doc
id: roteamento
descricao: "Explica como classificar um pedido em família, montar o pacote base, somar modificadores e declarar o que foi aberto, dentro do orçamento."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como classifico o pedido", "o que é família de rota", "quantos arquivos posso abrir", "o que é fecho transitivo", "quais modificadores somar ao pacote", "como desempatar entre duas famílias", "o ROTAS.md é gerado"]
requires: gate
owner: cortex
origem: kernel
validado_em: 2026-10-04
---

# roteamento.md — Como um pedido vira uma lista de arquivos abertos

> **O que é:** a regra de roteamento do Cortex — o método que o Maestro aplica para transformar um pedido em **família + pacote base + modificadores**, com declaração conforme `sessao.declaracao_leituras`. **O que não é:** a tabela de rotas. A tabela vive em **`ROTAS.md`** (raiz), que é **gerado pelo `cortex build`** a partir do `cortex.config.yaml` e dos packs instalados, e lista **só o que está ativo** para esta organização. Este arquivo explica o método; o `ROTAS.md` dá os endereços.

---

## Sumário

- [0. Os quatro passos](#0-os-quatro-passos)
- [1. Fecho transitivo](#1-fecho-transitivo)
- [2. Regra de ouro e orçamento](#2-regra-de-ouro-e-orçamento)
- [3. As nove famílias do kernel](#3-as-nove-famílias-do-kernel)
- [4. Modificadores — o que somar ao pacote base](#4-modificadores--o-que-somar-ao-pacote-base)
- [5. Desempates](#5-desempates)
- [6. O que o `ROTAS.md` gerado contém](#6-o-que-o-rotasmd-gerado-contém)

---

## 0. Os quatro passos

```
1. CLASSIFIQUE   → ROTAS.md §1: sinal do pedido → família (ou sub-família do pack)
2. PACOTE BASE   → ROTAS.md §2: a linha OBRIGATÓRIO daquela família — abra cada arquivo
3. MODIFICADORES → ROTAS.md §3: some produto · ferramenta · voz · território · etapa · ciclo · iniciativa
4. VERIFIQUE     → suficiência das fontes; declaração conforme `_cortex/kernel/gate.md` §1
```

**Fundação:** aplique `_cortex/kernel/gate.md` §2; marque como lido apenas o conteúdo efetivamente disponível. Marca e voz entram quando pertinentes à tarefa.

**Não achou a família?** Não invente rota. Faça 1–2 perguntas para classificar (*"é para criar a peça ou para entender o resultado?"*). Pedido que não cabe em família nenhuma é sinal de lacuna no pack — declare e siga pela família mais próxima, com orçamento mínimo.

**Pedido composto é comum.** "Campanha completa" = PLANEJAR → CRIAR → REVISAR → REGISTRAR. Rode as famílias **em sequência**, não em paralelo — cada uma entrega insumo para a próxima; o briefing e as decisões acompanham cada troca de família.

---

## 1. Fecho transitivo

**Se abriu X e o `requires` aplicável de X cita Y, abra Y também, uma vez por id/caminho.** Não reabra dependências visitadas nem percorra ciclos indefinidamente. O `requires` de cada arquivo está no `CATALOGO.md` (coluna `requires`) e no próprio frontmatter. Vale em cadeia: Y pode citar Z. Numa skill, o `requires` começa pelo agente que a roteia — quem chega pela skill encontra o caminho de volta ao agente e, por ele, à fundação.

O fecho é o que faz um briefing persistido puxar a ficha do produto sem que ninguém precise lembrar (§4.6): o briefing cita o produto no `requires`; abrir o briefing obriga a abrir a ficha.

---

## 2. Regra de ouro e orçamento

**Abra o necessário para a decisão atual.** Método, fonte dos fatos e regra de formato precisam estar disponíveis. Use o contrato para separar componentes obrigatórios de relações condicionais; não carregue catálogos inteiros.

**Mas o orçamento existe.** Cada família tem uma referência de quantidade de arquivos abertos (tabela §3; `rotas.orcamento_padrao` no config vale para sub-família sem orçamento próprio). Ele cabe o pacote base + os modificadores típicos. Ultrapassá-lo pede uma revisão da seleção, sem bloquear uma leitura necessária:

| Sintoma | Causa provável | O que fazer |
|---|---|---|
| passou do orçamento com modificadores | abriu produto inteiro (raiz + filhos) em vez de só a raiz; abriu duas vozes; abriu iniciativa e produto quando a iniciativa já resolve | abra só o doc-raiz; escolha **uma** subpasta; cite a seção, não o arquivo |
| passou com o pacote base | rota mal desenhada no pack | execute e registre como achado de GOVERNAR |
| precisou de arquivo de outra família | pedido composto | troque de família preservando o briefing e as decisões |

Arquivo grande (> 35 KB) tem `## Sumário` com âncoras: **abra 2 ou 3 seções, nunca o arquivo inteiro**, e cite a seção pelo título.

---

## 3. As nove famílias do kernel

Fixas; os packs acrescentam **sub-famílias** (`FAMILIA.sub`, ex.: `CRIAR.email`) com pacote e orçamento próprios, emitidas no `ROTAS.md` só quando a `condicao` do pack é verdadeira para o config.

| Família | Orçamento | Sinal genérico — o pedido é sobre… | Agente de entrada |
|---|---|---|---|
| **CRIAR** | 5 | peça ou artefato novo: texto, arte, roteiro, página, anúncio, apresentação | o agente criador do pack (ex.: redator, designer) |
| **PLANEJAR** | 7 | campanha, plano, experimento, verba, meta a definir, evento ponta a ponta, conta-alvo | o estrategista do pack |
| **ANALISAR** | 6 | resultado, relatório, funil, atribuição, "por que caiu", escuta de comunidade | o analista do pack |
| **CONSULTAR** | 3 | dado já documentado, read-only: "qual é", "o que significa", "quanto está cadastrado" | nenhum agente próprio (ver `gate.md` §1.2) ou o analista, se houver sub-skill de extração |
| **OPERAR** | 4 | base de contatos, higienização, importação, automação, integração, fluxo | o operador do pack |
| **REVISAR** | 2 | humanizar, tirar cara de IA, QA de texto pronto | `_cortex/kernel/revisor.agent.md` |
| **REGISTRAR** | 3 | subir no registro primário, abrir card, preencher campos, ata, documentar reunião | `_cortex/kernel/registrador.agent.md` |
| **DOCUMENTAR** | 4 | documentar produto ou processo, registrar o que foi publicado, atualizar dado dentro de um doc da base | `_cortex/kernel/documentador.agent.md` |
| **GOVERNAR** | 4 | criar ou corrigir skill, agente ou doc; auditar entrega; configurar o Cortex; "a skill errou" | `_cortex/kernel/skill-creator.md` (via Maestro) |

Pedido de descoberta (briefing antes de produzir) não é família: é a **etapa** (§4.5) que antecede CRIAR, PLANEJAR e ANALISAR, conduzida por `_cortex/kernel/entrevistador.agent.md`.

---

## 4. Modificadores — o que somar ao pacote base

Cada modificador só existe no `ROTAS.md` §3 se o config tiver o insumo; os inativos vão para `ROTAS.md` §5 com o motivo.

### 4.1 Produto — quando o pedido nomeia uma oferta (`produtos[]`)
`+ contexto/produtos/<slug>/<slug>.md` — o doc-raiz: posicionamento, persona, dores, provas, o que não fazer.
`+` **uma** subpasta ou arquivo filho, só quando o pedido descer do posicionamento (funcionalidade, concorrente, lançamento, outro público). Nunca o produto inteiro.
`+` o banco de criatividade do produto, se o pack o tiver — calibração de tom, nunca template para copiar.

| O pedido é sobre… | Seções do doc-raiz |
|---|---|
| posicionamento, mensagem-chave, como falar | *Posicionamento* + *O que não fazer* |
| persona, cargo, dor | *Personas* — e o arquivo dedicado de públicos, quando existir |
| prova, número, resultado de cliente | *Dados e provas* — e os claims que exigem validação antes de uso externo |
| objeção, concorrente, comparação | *Concorrência* + *Objeções* |
| o que o produto é, funcionalidade | *O que é* + *Funcionalidades* (ou o filho de módulo) |
| cor, logo, naming | *Identidade visual* — e confira `contexto/brandcenter/brandcenter.md` |

Produto citado **sem ficha** em `contexto/produtos/`: declare a lacuna; a descrição depende 100 % de insumo do solicitante (`anti-alucinacao.md` §3). Produto ainda ambíguo e necessário: pergunte. Oferta já informada dispensa nova pergunta; tarefa sem oferta é não aplicável (`descoberta.md` §4).

### 4.2 Ferramenta — gate de MCP (`integracoes[]` com `mcp: true`)
`+ contexto/integracoes/<slug>.md` — **antes da primeira chamada** ao conector: schema, filtros, limites, o que é somente leitura (`somente_leitura`), campos que disparam automação. Chamar o conector sem a ficha é produzir sem trava. Se o pack tiver sub-skill de extração para aquela integração, ela entra junto (`gate.md` §1.2).

### 4.3 Voz — quem assina o texto (`vozes[]`)
`+` o doc apontado em `vozes[].doc` quando a peça sai na voz de uma pessoa (perfil pessoal, assinatura de artigo, fala em evento). Perfil institucional: só o brandcenter e a skill de canal. Voz não cadastrada no config: pergunte quem assina e marque o tom como `[INFORMADO PELO CLIENTE]`.

### 4.4 Território — quando o leitor muda (`publicos[].territorio`)
`+` a ficha do público daquele território, antes da skill de canal, quando o leitor não é o padrão da marca (ex.: parceiro ou fornecedor em vez do comprador). O `ROTAS.md` §3.4 lista os territórios ativos e seus arquivos. Território padrão: nada a somar.

### 4.5 Etapa — onde o pedido está no fluxo (sempre ativo)

| Etapa | O que entra |
|---|---|
| Descoberta | `entrevistador` + `descoberta` — preencher lacunas materiais; reutilizar briefing suficiente |
| Produção | a família da §3 |
| Revisão | REVISAR — **obrigatória** nos canais com `revisao_anti_ia: obrigatoria`; **oferecida** nos demais (`operacao.revisao_anti_ia_padrao`) |
| Registro | REGISTRAR — oferecido ao fim de todo fluxo |

### 4.6 Ciclo e briefing — quando o pedido cita uma campanha nomeada (`operacao.ciclo_planejamento`)
`+ briefings/<ciclo>/<campanha>.md` — o direcional já aprovado: dor, persona, mensagem-chave, canal, período e meta. O briefing puxa a ficha do produto pelo próprio `requires` (§1). Não sabe se existe briefing? `CATALOGO.md`, seção Briefings — não invente direcional. **Briefing é insumo, não template:** a peça continua saindo pela skill do canal; campanha encerrada não vira fonte de peça nova. Briefing nunca ganha família própria — é alcançado só por este modificador.

### 4.7 Iniciativa — quando a peça é de uma iniciativa (`iniciativas/<slug>/iniciativa.yaml`)
`+` as regras de comunicação da iniciativa (o doc marcado como trava em `iniciativa.yaml`) — abrir inteiro antes de escrever.
`+` a seção do doc-hub da iniciativa com a informação usada (dados, janelas, preços, público) — nunca o arquivo inteiro.
A iniciativa **soma 2 a 3 arquivos** ao orçamento da família. A peça continua saindo pela família do canal; o agente da iniciativa planeja e analisa, não escreve a peça (§5, regra 10).

---

## 5. Desempates

1. **Ler meta ≠ definir meta.** *"Qual a meta de agosto"* → CONSULTAR (lê o cadastrado). *"Quanto preciso para fechar 30 vendas"* → PLANEJAR. O sinal é o verbo. Rotear leitura para o estrategista produz número **estimado** no lugar do **cadastrado**.
2. **Consultar o dado ≠ diagnosticar.** *"Quais foram os motivos de perda"* → CONSULTAR. *"Por que a conversão caiu"* → ANALISAR. Só escale quando alguém perguntar o porquê.
3. **Criar ≠ revisar.** Texto novo → CRIAR. Texto pronto que precisa melhorar → REVISAR. O criador oferece o Revisor ao final; o contrário não existe — o Revisor devolve ao criador quando falta trecho novo.
4. **Revisar ≠ auditar.** *"Tá com cara de IA"* → REVISAR. *"Prova que a entrega falhou"*, com dano concreto → GOVERNAR. Crítica estética sem padrão violado não é auditoria.
5. **Evento tem quatro camadas.** Planejar → PLANEJAR. Texto (página, e-mail, roteiro) → CRIAR. Arte → CRIAR. Reaproveitar a gravação → CRIAR com o doc de reaproveitamento do pack. Medir → ANALISAR.
6. **Produto citado não manda para "Produto".** Quase todo pedido cita uma oferta. Pergunte: quer *posicionamento/persona/objeção* (CONSULTAR a ficha, §4.1) ou *uma peça sobre a oferta* (CRIAR, com a ficha como modificador)?
7. **Molde ≠ peça.** *"Faz o e-mail"* → CRIAR. *"Cria o modelo de e-mail que eu uso toda vez"* → GOVERNAR (é um doc ou skill da base, com frontmatter e rota).
8. **Registrar é o último passo.** Todo fluxo de produção termina com a oferta de REGISTRAR. Registrar não é documentar: REGISTRAR sobe a entrega pronta no registro primário; DOCUMENTAR grava conhecimento na base.
9. **Atualizar o dado ≠ escrever com o dado.** *"Chegou o indicador do mês"* → DOCUMENTAR, grava o número novo dentro do doc com fonte e `validado_em`. *"Usa o indicador na newsletter"* → CRIAR. Rodar CRIAR sobre dado velho publica número desatualizado; rodar DOCUMENTAR quando o pedido era a peça reescreve arquivo à toa.
10. **Peça da iniciativa ≠ planejamento da iniciativa.** *"Escreve o e-mail de abertura"*, *"faz o post de virada"* → CRIAR + §4.7; o criador escreve. *"Desenha o ciclo"*, *"qual a meta da fase 2"*, *"por que a venda caiu"* → o agente da iniciativa (PLANEJAR/ANALISAR). Mandar peça para o estrategista devolve plano no lugar de copy.
11. **Fala de cliente ≠ fala de especialista.** Depoimento de **cliente**, em case → o índice de provas do pack (prova social). Trecho de **podcast, live ou entrevista** com especialista da casa → voz (§4.3), a partir do material fornecido. O desempate é **quem fala**, não o formato — não trate fala de especialista como prova social, nem o contrário.
12. **Processo que vira skill ≠ processo descrito.** *"Documenta esse processo como skill, com passo a passo acionável"* → GOVERNAR (`skill-creator`). *"Documenta como esse processo funciona para quem consulta"* → DOCUMENTAR (doc).
13. **Na dúvida entre duas famílias, pergunte 1 coisa.** *"É para criar a peça ou para analisar o resultado?"* resolve a maioria.

---

## 5.1 Contratos entre skills

Quando `interfaces.ativo` estiver configurado, use `python3 _cortex/cli/cortex.py interfaces list --query <termo>` e `interfaces show <id>`. A busca pagina metadados; o detalhe traz só um contrato e referências aos seus componentes. Não abre métodos nem memória pessoal. Nomes ambíguos exigem id qualificado, sem escolha silenciosa.

Abra a fonte da skill selecionada e os componentes aplicáveis. Siga uma relação somente se a condição ocorrer. Passe objetivo, fontes, saída atual, decisões, pendências e autorização. Os detalhes do formato e da configuração estão em `_cortex/CONTRATOS.md`, seção Interfaces adaptáveis.

## 6. O que o `ROTAS.md` gerado contém

| Seção | Conteúdo | De onde vem |
|---|---|---|
| §0 | os quatro passos, resumidos; link para este arquivo | kernel |
| §1 | classificador: sinal → família ou sub-família, **só as ativas** | famílias do kernel + `subfamilias[].sinais` dos packs cuja `condicao` é verdadeira |
| §2 | agentes `id → arquivo` e, por família/sub-família, as linhas OBRIGATÓRIO · CONDICIONAL · COMPLEMENTAR e o orçamento | `pack.yaml` + frontmatter dos arquivos |
| §3 | modificadores **ativos** (§4 deste arquivo), com os caminhos reais | config: `produtos`, `integracoes.mcp`, `vozes`, `publicos.territorio`, `operacao.ciclo_planejamento`, `iniciativas/` |
| §4 | desempates genéricos (§5 deste arquivo) + os que o pack acrescenta | kernel + packs |
| §5 | sub-famílias e modificadores **inativos**, com o motivo (ex.: `canal:whatsapp` ausente no config) | `build` |

O `ROTAS.md` **não se edita à mão**: tem `origem: gerado` e o hook nega a gravação. Mudou o config, instalou um pack, criou uma skill? `cortex build`. Rota que falta ou sobra é achado de GOVERNAR, corrigido na fonte (pack, config ou frontmatter) — nunca no arquivo gerado.

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-04 | Leitura seletiva por contrato e continuidade entre skills. | cortex |
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
