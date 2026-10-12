---
tipo: skill
id: redator-lp
descricao: "Entrega a copy completa da landing page, bloco a bloco, no tipo certo (demonstração, material rico ou evento), com contagem de caracteres."
familia: CRIAR.lp
output: texto
canal: landing-page
ferramenta:
produto: todos
publico:
gatilhos: ["texto da LP", "landing page de", "página de inscrição", "página de download", "LP de demonstração", "bloco de abertura da LP", "headline da landing page", "copy da página de captura"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — Landing pages (demonstração · material rico · evento)

Aplica `redator-comum` às especificações de copy dos três tipos de página: **demonstração** (pedido de contato, orçamento ou compra), **material rico** (download) e **evento** (inscrição). Os três compartilham briefing, diagnóstico de público e regras de escrita; diferem na estrutura de blocos.

## Contexto de uso

- **Nova página** — criação completa do conteúdo editável.
- **Revisão** de página existente com baixa conversão.
- **Adaptação** para novo produto, material ou evento do mesmo tipo.
- Otimização de conversão de página já publicada é diagnóstico (Analista) antes de ser reescrita.

### Como identificar o `tipo_lp`

| Se o pedido menciona… | `tipo_lp` |
|---|---|
| demonstração, agendamento, orçamento, pedido de contato, compra, bloco de abertura | **demo** |
| material rico, guia, planilha, kit, checklist, página de download | **material-rico** |
| webinar, live, evento, página de inscrição | **evento** |

## Briefing mínimo

Além de `redator-comum`:

| Campo | demo | material-rico | evento |
|---|---|---|---|
| **O que será demonstrado** / **material** (nome e tipo) / **nome do evento** | sim | sim | sim |
| **Benefício central** ou **dor que resolve** | sim | sim | sim |
| **Público** (cargo ou perfil, contexto, desafio) | sim | sim | sim |
| Diferencial em relação ao que o público usa hoje | sim | — | — |
| Momento da jornada em que o material é útil | — | sim | — |
| Produto conectado (para o bloco de produto) | — | sim | sim |
| Links internos disponíveis | — | opcional | opcional |
| Há mockup, gif ou imagem? | — | sim/não | sim/não |
| **Data, horário e fuso** · palestrantes · tópicos · transformação esperada | — | — | sim |

Sem os campos em negrito, **não escreva**. Pergunte.

## Processo

1. **Identificar o `tipo_lp`.** Se ambíguo, perguntar.
2. **Verificar contexto de marca** e, se houver produto, `contexto/produtos/<slug>/<slug>.md` + `times/{{time.slug}}/docs/criatividade-<slug>.md`.
3. **Confirmar o briefing.**
4. **Diagnosticar o público e calibrar o tom** — os públicos do config, com dor e objeção:
{{#each publicos as pu}}   - **{{pu.nome}}** (`{{pu.slug}}`): dor — {{pu.dor}} · objeção — {{pu.objecao}}
{{/each}}
   Se o canal de origem do tráfego for conhecido, calibrar também pela temperatura: busca por dor (quente → direto ao ganho, mais prova) · busca pela marca (muito quente → reforçar diferencial, reduzir fricção) · social e mídia paga (morno → problema em destaque antes da oferta) · e-mail base fria (frio → proposta direta e curta, um CTA) · e-mail base engajada (pode referenciar a jornada).
5. **Nomear a ideia central em uma frase:** "[Público] que [dor específica] pode [ganho concreto] com [o que está sendo oferecido]." Em evento: "…vai [transformação concreta] participando de [nome]".
6. **Escrever a página** seguindo a estrutura do tipo (abaixo). Não misturar blocos de tipos diferentes.
7. **Revisar** com `redator-comum` + checklist desta skill.

## Princípio central

**Valor explícito nos primeiros três segundos de leitura.** A página não descreve o produto, o material ou o evento: faz o leitor sentir que precisa daquilo agora. Em segundos ele entende (1) o que isso resolve na rotina dele, (2) o que ganha ao agir e (3) que é aplicável ao contexto dele — e, em evento, quando é e que pode garantir a vaga agora.

## Estrutura por `tipo_lp`

### demo — bloco de abertura (layout fixo; o formulário não é editável)

Cinco elementos, nesta ordem:

| Elemento | Regra |
|---|---|
| **1. Título (H1)** | Até 60 caracteres; ganho concreto ou provocação da dor, nunca funcionalidade; sem adjetivo genérico ("completo", "inteligente", "avançado"); até 2 linhas. Fórmulas: [verbo de ganho] + [o que se conquista] + [contexto] · [resultado] + [aplicado a quê] · [frase curta sobre o problema.] + [frase curta sobre a consequência.] — a estrutura de contraste é preferida quando há tese de campanha |
| **2. Linha fina** | Até 180 caracteres; complementa o título sem repetir; **nomeia o produto** e o benefício; até 3 linhas |
| **3. Corpo** | Exatamente 2 parágrafos de até 2 linhas: P1 nomeia o problema (o que a situação atual esconde ou gera); P2 reposiciona o investimento (por que resolver sai mais barato do que continuar pagando pelo erro) |
| **4. CTA** | 3 a 6 palavras; conceitual quando há campanha ("Enxergue o custo invisível"), funcional quando não há ("Quero uma demonstração gratuita"); coerente com o que o bloco prometeu |

### material-rico — cinco blocos

Checar antes: o material resolve uma dor específica (não um tema amplo); consome-se em menos de meia hora; leva naturalmente ao produto; é enxuto; corresponde ao momento da jornada do briefing.

| Bloco | Regra |
|---|---|
| **1. Título e subtítulo** | H1 com a palavra-chave do material; subtítulo é promessa, não descrição; até 100 caracteres somados; sem adjetivo genérico. Título: [nome do material] + [resultado] ou [problema que resolve]; subtítulo: [verbo] + [o que o leitor consegue fazer] + [contexto] |
| **2. Imagem ou gif** | Mostra o que o leitor vai receber: páginas internas, planilha preenchida, painel em uso — nunca só a capa. Texto visual ≤ 80 caracteres; CTA no banner com verbo + benefício. Esta skill entrega a orientação de produção, não a arte |
| **3. Sobre o material** | Até 4 parágrafos, 250 a 400 palavras, parágrafos ≤ 4 linhas: (1) contexto do problema com dado ou situação; (2) o que o material entrega, com especificidade — opcional: sub-bloco "O que você encontra" com 3 a 5 bullets (nome do entregável + o que entrega); (3) quando usar, como aplicar, quem se beneficia; (4) o que muda na rotina + CTA. Até 2 links internos |
| **4. Para quem é indicado** | "Profissão X que busca Y." — 2 a 4 perfis, uma linha cada, até 40 palavras; sem abertura genérica ("Este material é para…") |
| **5. Produto** | **Padrão fixo da equipe — não gerar copy novo.** Orientar que o bloco é preenchido com o conteúdo padrão do produto conectado |

### evento — cinco blocos

| Bloco | Regra |
|---|---|
| **1. Título e subtítulo** | Tema explícito no título; subtítulo responde "o que vai aprender, ganhar ou evitar"; até 100 caracteres somados; **data e horário visíveis na dobra** |
| **2. Imagem ou gif** | Data e horário em destaque; foto dos palestrantes quando houver; texto visual ≤ 80 caracteres; CTA de participação |
| **3. Sobre o evento** | Até 4 parágrafos, 250 a 400 palavras: (1) contexto do problema; (2) o que o evento entrega, com especificidade — não lista genérica de tópicos; (3) o que só acontece ao vivo (interação, perguntas em tempo real, perspectiva dos especialistas); (4) o que muda depois de participar + CTA |
| **4. Para quem é indicado** | Mesma regra do material rico |
| **5. Produto** | Padrão fixo — não gerar |

## Regras de escrita — comuns

**Sempre:** valor nos primeiros 3 segundos · voz ativa, parágrafos curtos · vocabulário do público · CTA com verbo + benefício · tom informativo com autoridade e proximidade · marca para credibilidade sem exagero · uma ideia por bloco; cada bloco leva ao próximo.

**Nunca:** adjetivo vago (completo, incrível, essencial, robusto, inteligente, avançado) · abertura genérica ("No cenário atual…", "Sabemos que…") · pergunta + resposta retórica ("O resultado? Mais eficiência") · travessão em copy de página · repetição do mesmo argumento entre blocos · linguagem poética ou motivacional · jargão que o público não usa.

**Adicionais:** demo — foco no ganho, produto nomeado na linha fina, parágrafos ≤ 2 linhas, CTA genérico proibido · material rico — conexão com produto como apoio, nunca foco; nome do material em todas as variações; excesso de scroll proibido · evento — tema no título e subtítulo; data na dobra; diferencial do ao vivo destacado.

## Checklist

- [ ] `tipo_lp` identificado e briefing do tipo completo? Público diagnosticado? Ideia central nomeada?
- [ ] Valor explícito nos primeiros 3 segundos?
- [ ] Caracteres e palavras contados contra os limites de cada bloco?
- [ ] demo: título ≤ 60, linha fina ≤ 180 com produto nomeado, 2 parágrafos de ≤ 2 linhas, CTA de 3–6 palavras coerente com a narrativa?
- [ ] material rico / evento: 5 blocos na ordem; bloco 5 não gerado; "para quem" sem abertura genérica; orientação de imagem entregue?
- [ ] evento: data, horário e fuso visíveis na dobra; o que só acontece ao vivo?
- [ ] Nenhum adjetivo vago, travessão, repetição entre blocos ou palavra da lista a evitar?
- [ ] Objeção do público respondida em algum bloco?

## Output esperado

**demo**
```
BLOCO DE ABERTURA
TÍTULO (H1): [texto] — X caracteres
LINHA FINA: [texto] — X caracteres
CORPO: [P1 problema] / [P2 reposicionamento]
CTA: [texto]
NOTAS: o que será demonstrado · público · dor · conceito de campanha (sim/não) · ideia central
```
Quando pedido, 2 variações do bloco completo para teste A/B, com títulos de estrutura diferente.

**material-rico / evento**
```
BLOCO 1 — TÍTULO E SUBTÍTULO (+ data e horário na dobra, em evento) — X caracteres
BLOCO 2 — ORIENTAÇÃO DE IMAGEM: texto do banner (≤ 80) · CTA do banner · o que mostrar
BLOCO 3 — SOBRE O [MATERIAL / EVENTO]: copy completa · links internos · CTA — X palavras
BLOCO 4 — PARA QUEM É INDICADO — X palavras
BLOCO 5 — PRODUTO: padrão fixo, não gerado
NOTAS DE PRODUÇÃO: material/evento · público · produto conectado · imagem disponível · links inseridos
```

Fechar com a **Nota de transparência** e a **revisão anti-IA** conforme a política do canal `landing-page` no config.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
