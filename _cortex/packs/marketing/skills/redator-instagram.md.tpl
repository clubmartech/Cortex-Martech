---
tipo: skill
id: redator-instagram
descricao: "Entrega a peça de Instagram pronta — estático, carrossel, stories ou reels — com formato decidido, gancho testado e legenda curta; cobre TikTok no vertical."
familia: CRIAR.social-instagram
output: texto
canal: {{#if canal:instagram}}instagram{{/if}}{{#if canal:instagram and canal:tiktok}} · {{/if}}{{#if canal:tiktok}}tiktok{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["post para o Instagram", "monta um carrossel", "legenda do Instagram", "roteiro do reel", "faz um reel", "stories para o Instagram", "vídeo curto para o TikTok", "gancho para carrossel", "capa do reel"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — Instagram (estático · carrossel · stories · reels){{#if canal:tiktok}} e TikTok{{/if}}

Cobre a execução da peça: decisão de formato, gancho, texto slide a slide, roteiro do vídeo curto, capa, legenda e output. A estratégia editorial da conta (quais editorias, que proporção, o que pode nomear produto) mora no brandcenter ou no doc editorial do time — em conflito, vale ele.

{{#if canal:tiktok}}> **TikTok usa esta skill** para o vídeo curto vertical: mesma estrutura de roteiro, mesma régua de ritmo. O que muda: legenda ainda mais curta, texto na tela desde o primeiro frame, áudio original ou trend da própria plataforma (nunca publicar com marca d'água de outro app), e a conversa acontece nos comentários — o CTA de fechamento pede comentário ou salvamento, não link.{{/if}}

## Contexto de uso

| Preciso de | Está em |
|---|---|
| Tom, vocabulário, princípios, checklist | `redator-comum` |
| Editorias da conta, o que pode nomear produto, termos de busca | `contexto/brandcenter/brandcenter.md` (ou doc editorial do time, se existir) |
| Calibração de tom por produto | `times/{{time.slug}}/docs/criatividade-<slug>.md` |
| Decisão de formato, gancho, copy, roteiro, capa, legenda, output | **aqui** |

## Briefing mínimo

Além de `redator-comum`: **objetivo** · **público** · **mensagem central única** · formato (ou deixar a skill decidir) · gancho pretendido · prova ou dado · CTA · há identidade visual ou arte definida? · para vídeo: **mecanismo** (como o problema ocorre ou como a solução funciona — não só o resultado).

## Processo

### 1. Decidir o formato — obrigatório, antes de qualquer palavra

Aplicar nesta ordem sobre o briefing (decidir e avançar; não apresentar as opções a quem pediu):

1. Formato especificado no briefing? → respeitar.
2. Mais de uma ideia, dado ou passo? → **Carrossel** (múltiplas ideias num estático viram parede de texto).
3. Objetivo é engajamento profundo, salvamento ou educação? → **Carrossel**.
4. Posição de marca, anúncio, lançamento ou frase de autoridade — força numa única ideia? → **Estático**.
5. Conversa direta, amplificar post do feed ou converter com link em 24h? → **Stories**.
6. Mecanismo, bastidor, demonstração ou reconhecimento rápido em vídeo? → **Reels / vídeo curto**.
7. Dúvida → **Carrossel**.

### 2. Encontrar o ângulo antes do gancho

Gerar mais de uma opção de ângulo e escolher a mais forte. O ângulo certo prende quem já vive o assunto **e** quem só tem curiosidade por ele.

**Fórmula do gancho vencedor** — combinar o máximo de elementos, no menor espaço: ponto de dor · promessa de transformação · emoção · contraintuitivo · número específico · urgência ou oportunidade · história pessoal · empoderar · claro e conciso. Gerar **2 variações de gancho**, escolher uma, descartar a outra.

**Hook visual** (obrigatório junto do verbal): figura humana e rosto com emoção · referência reconhecível nos primeiros frames ou na capa · cor saturada · **nunca banco de imagem** · **nunca print de post de terceiro**.

### 3. Escolher uma técnica narrativa e um gatilho

| Técnica | Quando | Lógica |
|---|---|---|
| **AIDA** | Lançamento, novidade, conversão | Atenção → interesse → desejo → ação |
| **PAS** | Dor, ineficiência, problema recorrente | Problema → agitação → solução |
| **PPPP** | Case, prova social, resultado | Cenário → promessa → prova → ação |
| **Storytelling de autoridade** | Reflexão, posicionamento | Aprendizado + credibilidade + emoção |

Gatilhos: curiosidade e loop aberto · dissonância (confrontar crença errada) · confirmação (verbalizar dor que o público sente) · prova social (dado do setor, não genérico) · escassez e oportunidade (com moderação).

### 4. Escrever conforme o formato (§ abaixo)

### 5. Revisar com `redator-comum` + checklist desta skill

## Estático

**O criativo para o scroll; a legenda ganha o leitor.** Headline de até 8 palavras: dado, pergunta ou afirmação de impacto — abre um loop que só a legenda fecha. Fórmulas: dado + implicação · pergunta de diagnóstico · afirmação contraintuitiva · posicionamento polarizador · nomeação direta da dor.

## Carrossel

```
SLIDE 1   → parar o scroll (gancho)
SLIDES 2…N-1 → entregar valor, um capítulo por slide
SLIDE N   → fechar o loop + CTA
```

**Slide 1:** único objetivo é levar ao slide 2. Responde "isso é para mim?" e "o que ganho se continuar?". Até 8–10 palavras. Tipos: dado chocante · diagnóstico direto · promessa específica · pergunta de espelho · afirmação contraintuitiva. **Nunca usar o slide 1 para apresentar a marca ou o produto.**

**Desenvolvimento:** uma ideia por slide; avança a narrativa; **todo slide tem um re-hook** que nasce da progressão (pergunta nova, revelação parcial, consequência) — não clickbait colado no fim. Dor → solução → produto em linha reta é previsível: construir a progressão "interessante → como assim? → entendi → então o problema era esse → faz sentido". Texto de 3–4 linhas por slide; uma afirmação + um apoio; sem CTA no meio (exceto carrossel longo, um CTA intermediário). Estruturas: passo a passo · dado + implicação · antes e depois.

**Slide final:** fechamento narrativo e CTA são funções diferentes — [fechamento da promessa em 1 frase] + [CTA específico: verbo + gancho + qualificador]. "Link na bio" sozinho é oportunidade desperdiçada. CTA de salvamento é sinal forte ("Salve para consultar antes da próxima reunião").

**Especificações:** 4:5; até 8–10 palavras por bloco de texto na imagem; 8–12 slides para educativo, 12–20 para guia ou case.

## Stories

Lógica oposta ao feed: feed é portfólio; stories é conversa com a audiência mais quente. Não precisa ser perfeito, precisa ser direto. 9:16; zona segura longe do topo e do rodapé; 3–4 linhas por frame; sessões curtas.

| Objetivo | Lógica | Estrutura |
|---|---|---|
| **Tráfego para o feed** | Trailer, não resumo | gancho de curiosidade → loop sem revelar → "ver no feed" |
| **Nutrição** | Bastidor, contexto, série; constrói familiaridade | conversa direta, 2–3 frames, sem roteiro aparente |
| **Conversão** | Uma ação mensurável | dor ou oportunidade → prova ou dado → CTA com link sticker |

Stickers (enquete, quiz, pergunta aberta, contagem regressiva, link) sempre com **follow-up** no story seguinte. Uma ação por sequência. Proporção da sessão: maior parte valor e interação, menor parte conversão.

## Reels / vídeo curto vertical

**Mecanismo vs. resultado:** roteiro que só descreve resultado é genérico. Sem mecanismo no briefing, perguntar.

| Trecho | Régua |
|---|---|
| **Abertura (0–3 s)** | Metade do público decide aqui. Frase de até 10 palavras; câmera já rolando; nunca "hoje eu vou falar sobre". Técnicas: pergunta direta · frase contraintuitiva · dado inesperado · situação real · promessa de valor |
| **Desenvolvimento (5–50 s)** | O gancho compra atenção; o desenvolvimento paga a dívida. Jornada (curiosidade → desenvolvimento → virada → fechamento), não lista de fatos. Frases de até 12 palavras; cortes a cada ideia nova; conectores que encadeiam: "ou seja", "isso significa que", "por isso", "a maioria faz X, mas Y faz Z" |
| **Fechamento (últimos 5–10 s)** | Frase que ecoa e, se a editoria permitir, CTA leve. CTA combina com o objetivo: tutorial → salvar; análise → compartilhar; comunidade → comentar |

**Técnicas narrativas:** storytelling · contraste antes/depois · bastidor real · lista rápida (3 causas, 3 erros) · trend contextualizado.

**Áudio:** voz + trilha própria recebe preferência e constrói identidade; trend só quando o contexto for genuíno; nunca marca d'água de outro app. **Legendas no vídeo obrigatórias** (maioria assiste sem som), na zona central, sem emoji, com 1–3 palavras-chave destacadas por frase.

**Capa:** título de até 4 palavras, fonte bold, alto contraste, rosto com expressão quando houver; elementos críticos no centro (o grid corta as bordas). Evitar clichê visual, promessa sensacionalista, frame borrado e repetir na legenda a frase da capa.

## Legenda — modelo único para todos os formatos

**Curta, sem exceção.** A peça carrega o conteúdo; a legenda provoca resposta.

```
[1 frase de contexto — opcional, só quando a capa ou abertura não basta]
[1 pergunta aberta que puxa comentário]

[3 a 5 hashtags]
```

Teto de duas frases fora as hashtags · não resume a peça · fecha em pergunta aberta (sim/não não conta) · sem CTA de link quando a peça já fecha em chamada · hashtags ao final · termo de busca abre o primeiro parágrafo (a legenda é indexável) · **fonte de dado vai na arte, não na legenda** (a arte sobrevive a repost e print).

**Emojis:** nenhum na primeira linha nem no texto da peça; 1–2 funcionais no corpo da legenda; 1 no CTA.

## Sinais que a plataforma prioriza

Do mais ao menos importante: envio por mensagem direta · taxa de conclusão (último slide, fim do vídeo) · replays · salvamentos · comentários com profundidade · compartilhamentos · curtidas. Critério de escrita: **essa peça faz alguém querer mandar para o sócio ou para o colega?**

## Padrões proibidos — motivo de reescrita

| Padrão | Exemplo |
|---|---|
| Metacomentário sobre a própria peça | "Neste vídeo vou mostrar…", "arrasta que vem o melhor" |
| Loop de frases curtas sem conteúdo | "É rápido. É simples. É eficiente." |
| Adjetivo de impacto sem evidência | "incrível", "surpreendente" sem dado |
| Introdução genérica | "Neste conteúdo vamos falar sobre…" |
| Abstração no lugar de consequência concreta | "gera impactos na operação" |
| Promessa sem sustentação | resultado ou velocidade que produto, fonte ou briefing não sustentam |
| Cara de relatório | frase que ninguém diria em voz alta |
| Antítese em série | três fechos seguidos com "X, não Y" |
| Abertura com "Então…", "Olá…", saudação | roteiro lento, público sai |
| Lista retórica com resposta embutida | "Custo alto? Sim. Retrabalho? Também." |
| Cenário hipotético genérico | "Imagina que você é um gestor…" |

**Testes de revisão:** da introdução (abre explicando o que vai fazer? deletar) · da consequência concreta · da promessa (produto, fonte ou briefing sustentam?) · dos fechos em sequência (ler só a última frase de cada tela) · da velocidade (primeira frase em voz alta passa de 4 s? cortar).

## Checklist

- [ ] Formato decidido pela regra, antes de escrever? Ângulo escolhido entre mais de uma opção?
- [ ] 2 ganchos gerados, 1 escolhido? Hook visual descrito?
- [ ] Carrossel: slide 1 sem marca/produto; re-hook em todo slide; fechamento + CTA separados?
- [ ] Vídeo: mecanismo presente; abertura ≤ 10 palavras; legendas no vídeo; capa ≤ 4 palavras; roteiro lido em voz alta cabe no tempo?
- [ ] Legenda ≤ 2 frases + 3–5 hashtags; fecha em pergunta aberta; fonte do dado na arte?
- [ ] Nenhum padrão proibido? Nenhuma palavra da lista a evitar? Regra de nome de produto da conta respeitada?
- [ ] Regra do canal sobre nomear produto (brandcenter) respeitada na locução, na arte e na legenda?

## Output esperado

Anotar no topo: **formato · editoria (se a conta tiver) · nível de consciência**.

- **Carrossel:** texto de cada slide (headline + apoio) · legenda · tipo de gancho escolhido e por quê.
- **Estático:** headline do criativo (≤ 8 palavras) · legenda · variação de headline para teste.
- **Stories:** frame a frame, com objetivo declarado e sticker de cada frame.
- **Reels / vídeo curto:** cabeçalho de produção (marca · objetivo · duração · técnica · mecanismo central · 2 ganchos com o escolhido · capa: título e orientação visual) + **script linear**, frase a frase, sem marcações de tempo ou rótulos — imprimível e entregável a quem grava sem explicação + legenda.

Fechar com a **Nota de transparência** e a **revisão anti-IA** conforme a política do canal (`revisao_anti_ia` no config).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
