---
tipo: skill
id: redator-email
descricao: "Entrega a copy de e-mail pronta para a plataforma de disparo, no tipo certo (conversão, material rico ou evento), com assunto, preheader e CTA."
familia: CRIAR.email
output: texto
canal: email
ferramenta:
produto: todos
publico:
gatilhos: ["escreve um e-mail", "e-mail de convite", "e-mail de lembrete", "fluxo de nutrição", "assunto e preheader", "e-mail de repique", "régua de e-mails", "e-mail de material rico", "copy de e-mail"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — E-mail (conversão · material rico · evento)

Aplica `redator-comum` às especificações de copy dos três tipos de e-mail: **conversão** (pedido de contato, demonstração, compra), **material rico** (download, nutrição) e **evento** (convite, confirmação, lembrete, gravação). Os três compartilham briefing, diagnóstico de base, anatomia e regras técnicas; diferem nas etapas do fluxo e no objetivo do CTA.

## Contexto de uso

- **E-mail único** — envio avulso.
- **Fluxo completo** — sequência de e-mails do mesmo tipo, do primeiro contato à conversão.
- **Revisão** de e-mail existente com baixa performance.
- **Adaptação** de copy para novo produto, material ou evento do mesmo tipo.

### Como identificar o `tipo_email`

| Se o pedido menciona… | `tipo_email` |
|---|---|
| pedido de contato, demonstração, orçamento, compra, repique, novo argumento, última chamada | **conversao** |
| material rico, guia, planilha, kit, checklist, fluxo de nutrição, download | **material-rico** |
| webinar, live, evento, convite, lembrete, "estamos ao vivo", gravação | **evento** |

Regra rápida: CTA leva a download → `material-rico`; CTA leva a "agendar", "falar com especialista" ou "comprar" → `conversao`. Um fluxo pode mudar de tipo no meio (os primeiros e-mails entregam o material e o último convida para conversa): tratar cada e-mail com as regras do seu tipo.

## Briefing mínimo

Além do briefing de `redator-comum`:

| Campo | conversao | material-rico | evento |
|---|---|---|---|
| **Produto** ou **material** / **tema do evento** | sim | sim (nome e tipo) | sim (título e tema) |
| **Base** (mercado × clientes) | sim | sim | sim |
| **Etapa do fluxo** | primeiro envio / repique / novo argumento / conversão | único / lançamento / repique / nova abordagem / prova social / conexão com produto | convite #1/#2/#3 / confirmação / lembrete do dia / ao vivo / gravação |
| **Benefício ou dor em destaque** | sim | sim (dor que o material resolve) | sim (o que se aprende) |
| **Dado, número ou resultado** disponível | se houver | se houver | se houver |
| **Nome do remetente** (fixo na campanha) | sim | — | sim |
| **Link do CTA** | sim | sim (página de download) | sim (inscrição ou transmissão) |
| **Data, horário, palestrante** | — | — | sim |

Se algum campo obrigatório estiver em branco, **não escreva**. Pergunte.

## Processo

1. **Identificar o `tipo_email`** (tabela acima). Se ambíguo, perguntar.
2. **Verificar contexto de marca** (`contexto/brandcenter/brandcenter.md`) e, se houver produto, `contexto/produtos/<slug>/<slug>.md` + `times/{{time.slug}}/docs/criatividade-<slug>.md`.
3. **Confirmar o briefing** do tipo.
4. **Diagnosticar a base e calibrar o tom:**

| Base | Perfil | Regra |
|---|---|---|
| **Mercado** | Não usa nenhum produto da marca | Educativo e consultivo, foco em ganho prático; nunca posicionar o produto como pré-requisito nem apontar a ausência dele como falha; nunca tom de "terra arrasada" |
| **Clientes** | Já usa outro produto da marca | Consultivo, orientado à evolução; o novo produto ou material **complementa** o que já usa — nunca "produto adicional" |

   Nuances: em `material-rico` para clientes, conexão com produto só a partir do terceiro e-mail do fluxo; em `evento` para mercado, o conteúdo é o valor — nunca o produto como gancho.
5. **Identificar a etapa do fluxo** e aplicar a estrutura correspondente (§ Estrutura por etapa).
6. **Nomear a ideia central em uma frase**, antes de escrever: "[dor ou dado específico] custa [prejuízo concreto]. [O produto / este material / o evento] resolve isso em [contexto]." Um e-mail com duas ideias é um e-mail fraco.
7. **Escrever** seguindo as regras técnicas (§ abaixo).
8. **Revisar** com o checklist de `redator-comum` + o checklist desta skill.
9. **Oferecer o HTML** depois da copy aprovada — sempre perguntar, nunca gerar antes do "sim". A diagramação (modelo, cores, header, banner) segue os modelos de HTML que a organização já tem; esta skill entrega **texto e estrutura**, nunca decide layout.

## Princípio central e anatomia

O e-mail não vende o produto, o material ou o evento: vende **o ganho da ação** (agendar, baixar, participar).

| `tipo_email` | Frase-âncora | O leitor precisa entender em segundos |
|---|---|---|
| conversao | Clareza é mais persuasiva que criatividade | por que é relevante para a rotina dele; o que ganha ao clicar; que do outro lado há um especialista, não um catálogo |
| material-rico | Entender por que baixar em até três segundos | qual problema o material resolve; o que ganha ao baixar; que é gratuito, útil e aplicável agora |
| evento | O que se aprende importa mais do que o que se apresenta | o que vai aprender; quando é (data e hora no primeiro bloco); por que vale o tempo — e quem apresenta |

| Elemento | Função | Regra |
|---|---|---|
| **Remetente** | Fator primário de abertura | Fixo e consistente na campanha — trocar destrói o reconhecimento acumulado |
| **Assunto** | Desempate da abertura | Até 50 caracteres; direto; sem click-bait, exclamação ou emoji; em evento, benefício do conteúdo > nome do evento |
| **Preheader** | Segundo gancho | Sempre preenchido; complementa o assunto, nunca repete; nunca texto padrão de sistema ("visualizar no navegador") |
| **1ª frase** | Ancora a leitura (visível no resumo automático do cliente de e-mail) | Proposta de valor completa, dado ou dor específica |
| **Corpo** | Dor → ganho → CTA | Máximo 2 parágrafos antes do 1º CTA; parágrafos de até 4 linhas; voz ativa |
| **CTA** | Converte leitura em ação | Linguagem de ganho + link; nunca "saiba mais", "clique aqui", "bate-papo" |
| **P.S.** | Elemento mais lido depois do assunto | Só na etapa de conversão — 1 linha de reforço ou prova social |
| **Texto do banner** | Impacto visual de campanha | Esta skill entrega só o **texto** (até 80 caracteres; em evento: título + data + horário). Montagem é do HTML |
| **Texto do header** | Kicker, headline e rótulo do botão | Adaptado a cada e-mail — nunca o texto genérico do modelo |

**Tamanho por tipo:** conversao — até 90 palavras / 700 caracteres · material-rico — 2 parágrafos, 600 a 800 caracteres, CTA repetido ao menos 2 vezes, um único link de destino · evento — 700 a 1.000 caracteres nos convites, CTA ao menos 2 vezes (botão + texto), data e horário no primeiro bloco.

## Estrutura por etapa do fluxo

### `tipo_email` = conversao

| Etapa | Objetivo | Estrutura |
|---|---|---|
| **Primeiro envio** | Apresentar tema e benefício central | Remetente fixo; assunto técnico e direto; preheader como segundo gancho; 1 ideia; dor → ganho → CTA antes do 3º parágrafo |
| **Repique** | Reenviar a quem não abriu | **Corpo e preheader idênticos** ao primeiro envio; só o assunto muda — novo ângulo da mesma dor |
| **Novo argumento** | Mostrar impacto no dia a dia | Assunto como pergunta sobre o processo atual; corpo contextual com situação concreta da rotina; bullets de benefício permitidos (nomear o produto **antes** da lista) |
| **Conversão (última chamada)** | Foco total na ação | CTA em hiperlink (mais pessoal); reforço do valor da **conversa**, não do produto; quem estará do outro lado; urgência implícita, nunca agressiva; menção aos e-mails anteriores; **P.S. obrigatório** |

### `tipo_email` = material-rico

| Etapa | Objetivo | Estrutura |
|---|---|---|
| **Lançamento** | Maior impacto inicial | Assunto com dor ou promessa; 1ª frase com dado ou dor; `[PRIMEIRO_NOME]` no 1º parágrafo; P1 dado/dor → benefício; CTA #1; P2 o que o leitor encontra (sem detalhar demais); CTA #2 |
| **Repique** | Reenviar a quem não abriu | Corpo e preheader idênticos; só o assunto muda |
| **Nova abordagem** | Quem abriu e não converteu | Outra dor que o mesmo material resolve; CTA em hiperlink; assunto com pergunta ou nova promessa |
| **Prova social** | Validação (fluxos maiores) | Assunto com número ou citação; corpo com downloads, mini case ou dado de mercado. **Sem dado real: pular a etapa ou marcar `[NECESSITA FONTE]`** |
| **Conexão com produto** | Ampliar além do material | O material mostrou o problema → o produto resolve na rotina; CTA de download vira CTA de conversa; nunca é o 1º envio; se o CTA é de demonstração, o copy passa a seguir as regras de `conversao` |

### `tipo_email` = evento

**Fluxo de convite (não inscritos):** Convite #1 (valor do conteúdo e benefício prático) → Novo argumento #2 (dor, desafio ou erro comum que o evento resolve; pode listar tópicos; urgência suave) → Novo argumento #3 (ângulo ainda não explorado; "ainda dá tempo"; o que se perde é o aprendizado, não o produto).

**Fluxo pós-inscrição:** Confirmação (tom caloroso e curto; vaga garantida; data e horário em destaque; CTA "adicionar à agenda"; único e-mail no modelo de automação) → Lembrete do dia (assunto "é hoje"; **nome do evento obrigatório no corpo** — o inscrito pode estar em mais de um; CTA único de acesso; sem argumentação extensa) → Ao vivo ("começa agora"; copy curta; link em destaque).

**Envio variável (a estratégia define):** convite para demonstração pós-evento · "estamos no ar" para inscritos ausentes · envio da gravação com CTA de próximo passo.

## Regras de escrita — comuns aos três tipos

**Sempre:** `[PRIMEIRO_NOME]` na abertura, **variando forma e posição** entre os e-mails do fluxo (integrado à 1ª frase, depois de um gancho, como saudação — nunca o mesmo padrão em dois disparos seguidos) · assunto ≤ 50 caracteres · preheader como gancho · 1ª frase com a proposta de valor · 1 ideia por e-mail · dado concreto quando disponível · mobile-first · oferecer o HTML ao final.

**Nunca:** adjetivo genérico sem substância · "bate-papo", "conversa rápida", "saiba mais" · preheader vazio ou repetindo o assunto · mais de 2 parágrafos antes do 1º CTA · informação crítica dependendo de imagem · tratar e-mail como peça de design (não há designer de e-mail) · todos os e-mails do fluxo iguais (exceto o repique, idêntico por definição) · **repetir a mesma ideia em blocos diferentes** (corpo, banner, header, P.S.) só trocando palavras — cada bloco traz informação nova · mais de 1 travessão por e-mail · CTA textual duplicando um botão fixo do template · lista de bullets de benefício antes de nomear o produto · duas frases seguidas sem relação de causa, consequência ou contraste · urgência agressiva.

**Variação ao longo do fluxo:** disparos consecutivos variam em pelo menos abertura (saudação, pergunta, dado, cena da rotina), ângulo do texto do banner e estrutura/ordem dos blocos e formato do CTA. Cada e-mail precisa parecer **um passo novo**, não o mesmo e-mail com outro assunto.

{{#if integracao:automacao-mkt}}**Plataforma de automação:** a integração de automação de marketing definida em `cortex.config.yaml` dita a sintaxe real da variável de nome e dos campos dinâmicos — substituir `[PRIMEIRO_NOME]` pela variável da plataforma antes de entregar o HTML, sempre com fallback definido.{{/if}}

## Exemplos de estrutura (adaptar — nunca copiar)

**Conversão · primeiro envio · base mercado**
```
REMETENTE: [nome fixo]
ASSUNTO: [dor nomeada em forma de pergunta — até 50 caracteres]
PREHEADER: [como identificar o problema antes da consequência]

[PRIMEIRO_NOME],

[Dor específica] custa caro — em [tempo, margem, relacionamento].

Com [produto], sua equipe [mecanismo concreto]:
- [ganho 1 observável]
- [ganho 2 observável]
- [ganho 3 observável]

[Quero ver como funciona na prática →]

Um especialista mostra, em [duração], como aplicar isso na sua operação.

[Agendar demonstração →]
```

**Material rico · lançamento · base mercado**
```
ASSUNTO: [nome do material] para [resultado concreto]
PREHEADER: [o que tem de novo ou por que é útil agora]

[PRIMEIRO_NOME], [dado com fonte ou dor específica em uma frase].

[Ponte: dá para mudar isso com algo simples.]

[Acessar o material gratuitamente →]

[O que o leitor encontra, com especificidade — sem detalhar demais.]

[Baixar agora →]
```

**Evento · lembrete do dia**
```
ASSUNTO: É hoje: [nome do evento] às [hora]
PREHEADER: [título do evento] · link de acesso

[PRIMEIRO_NOME], hoje às [hora] acontece [nome do evento].
[1 tópico ou benefício, em uma frase.]

[Acessar a transmissão →]
```

## Checklist

**Todos os e-mails**
- [ ] Briefing do tipo completo? Base diagnosticada e tom calibrado? Ideia central nomeada?
- [ ] Assunto ≤ 50 caracteres, contado? Preheader preenchido, complementar, nunca de sistema?
- [ ] 1ª frase carrega a proposta de valor? `[PRIMEIRO_NOME]` presente e variando no fluxo?
- [ ] Máximo 2 parágrafos antes do 1º CTA? Parágrafos ≤ 4 linhas, voz ativa?
- [ ] CTA com linguagem de ganho e link? Repetido o mínimo do tipo?
- [ ] Cada bloco (corpo, banner, header, P.S.) traz informação nova? No máximo 1 travessão?
- [ ] Produto nomeado antes de qualquer lista de benefícios?
- [ ] Texto do banner ≤ 80 caracteres, tratado como texto, nunca como arte?
- [ ] Nenhuma palavra da lista a evitar? Artigo e gênero da marca corretos?

**Por tipo**
- [ ] conversao: ≤ 90 palavras; remetente fixo; repique com corpo e preheader idênticos; P.S. só na conversão.
- [ ] material-rico: 600–800 caracteres; um único link de destino; sem conexão com produto no 1º envio para clientes; prova social sem dado real → pulada ou marcada.
- [ ] evento: data e horário no primeiro bloco; nome do evento no corpo dos lembretes; sem produto como gancho na base mercado; palestrante quando aumentar autoridade.

## Output esperado

```
REMETENTE: [nome fixo]
ASSUNTO PRINCIPAL:
ASSUNTO REPIQUE: (quando aplicável)
PREHEADER:

HEADER — TEXTO (kicker · headline · rótulo do botão — adaptado a este e-mail):
BANNER — TEXTO (≤ 80 caracteres; em evento, título + data + horário):

CORPO DO E-MAIL:
  [copy completa com [PRIMEIRO_NOME], parágrafos, bullets, CTA com link]

P.S. (só conversão):

NOTAS DE PRODUÇÃO:
  Contagem de palavras / caracteres:
  Base: [mercado / clientes] · Etapa:
  Link do CTA:
  Módulos de conteúdo disponíveis: [dado / tópicos / lista / evento]
```

Depois da copy aprovada: "Quer que eu já gere o HTML deste e-mail?" — só gerar com o "sim", só com os modelos que a organização já usa, nunca layout novo. Fechar com a **Nota de transparência** e a **oferta de revisão anti-IA** (política do canal `email` em `canais[]` no config).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
