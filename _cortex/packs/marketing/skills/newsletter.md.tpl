---
tipo: skill
id: newsletter
descricao: "Escreve a edição da newsletter a partir das notícias e dados da semana e adapta para os canais ativos, com assunto A/B e conclusão mensurável."
familia: CRIAR.newsletter
output: texto
canal: newsletter
ferramenta:
produto: todos
publico:
gatilhos: ["edição da newsletter", "montar a newsletter", "escrever a newsletter da semana", "notícias para a newsletter", "versão da newsletter para redes", "assunto da newsletter", "boletim da semana"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Newsletter — edição completa e versões por canal

Newsletter recorrente de {{marca_mae.nome}}: curadoria de notícias, análise e indicadores para o público prioritário. Formatos de entrega: **e-mail completo**{{#if canal:linkedin}}, **versão para LinkedIn**{{/if}}{{#if canal:comunidade}}, **versão para a comunidade**{{/if}}{{#if canal:instagram}}, **carrossel de Instagram com o dado mais forte**{{/if}}. Qualquer pessoa do time gera a edição a partir de um briefing curto com as informações da semana.

> **Anti-alucinação:** nunca completar com informação externa não fornecida no briefing. Nunca inventar link, dado ou nome de empresa. Contexto insuficiente para uma notícia → perguntar antes de escrever.

## Contexto de uso

- Alguém traz as notícias da semana e precisa transformá-las em edição publicável.
- Adaptar a edição já redigida para outro canal ativo.
- Edição especial de um único tema aprofundado com dados.

## Briefing mínimo

| Campo | Obrigatório | Descrição |
|---|---|---|
| Notícias ou temas da semana | sim | 3 a 5, com título + link ou resumo |
| Destaque principal | sim | Qual vai primeiro |
| Citação de especialista | sim | Aspas exatas + nome, cargo, empresa |
| Curadoria de indicadores | sim | Dados selecionados, com fonte |
| Eventos (agenda) | sim | 3 a 5 eventos do setor, com data e formato |
| Imagens sugeridas | não | Links de imagem por bloco |
| Dia e horário de envio | sim | Fixos da newsletter |

Campo obrigatório ausente → não gerar; perguntar e aguardar.

## Processo

### 1. Ler e organizar o briefing

Identificar as 3 a 5 notícias; confirmar o destaque; separar os insumos das editorias fixas (citação, indicadores, agenda). O tom é sempre analítico — não varia por semana.

### 2. Escolher o tipo de edição

| Tipo | Quando | Estrutura |
|---|---|---|
| **Regular** | 3 a 5 notícias variadas | Blocos independentes por tema + editorias fixas (Voz do especialista · Indicadores · Agenda) |
| **Especial** | 1 tema aprofundado com dados | Seções nomeadas (Visão geral · Perfil · Mercado) + "Fique por dentro" com notícias recentes |

### 3. Gerar a edição por e-mail, nesta ordem

**[1] Assunto — sempre em versão A/B.** Frase curta e jornalística que resume o destaque; até 60 caracteres; sem emoji; direto; curiosidade sem clickbait. A e B com abordagens diferentes (factual × provocativa). Assunto com dado concreto (%, valor, contagem) ou urgência real tende a abrir mais que formulação genérica de tendência — registrar o resultado dos próprios testes em `times/{{time.slug}}/docs/benchmarks-canal.md`.

**[2] Headline de abertura.** Afirmação forte sobre o destaque + emoji ao final.

**[3] Intro.** Frase fixa de identidade da newsletter + 1 frase de contextualização da edição.

**[4] "Na edição de hoje".** Até 5 bullets, um por editoria, preferindo número quando houver. Em seguida, a chamada fixa de feedback no fim da edição.

**[5] Seções de conteúdo.**
- Regular — por notícia: `[RÓTULO DA SEÇÃO]` + emoji temático + título em negrito (≤ 6 palavras) + 3 a 5 frases analíticas, cada afirmação vinda de uma notícia do briefing, com hiperlink quando fornecido + elemento fixo de compartilhar.
- Editorias fixas: **Voz do especialista** (1–2 frases de contexto + aspas exatas + crédito) · **Indicadores** (número mais relevante primeiro; o que significa para o setor; fonte de cada dado) · **Agenda** (3 a 5 eventos — nome, data, local ou formato, link se houver).
- Especial — seções nomeadas com texto analítico, bullets para números, tabela se o briefing trouxer, fonte sempre.

**[6] Conclusão — obrigatória.** Consolida o argumento da edição numa afirmação só: não resume, não repete a intro, não abre tema novo. 2 a 3 frases: a primeira fecha o argumento; a última diz o que o leitor faz com isso. É **a frase que o leitor repetiria** se contasse a edição a alguém; se funcionaria em qualquer edição, está genérica. É ela que torna a edição mensurável.

**[7] Fique por dentro.** 4 a 6 links relacionados, títulos curtos; só do briefing — faltando, indicar quantos faltam.

**[8] Chamada de feedback.** Texto fixo com as opções de reação.

{{#if canal:linkedin}}### 4. Versão para LinkedIn

Resumo editorial com título numerado (`[Nome] #[número] — [tema 1], [tema 2] e [tema 3]`; até 3 temas, destaque primeiro) · frase de identidade · CTA de assinatura com UTM no início e no fim · no máximo 3 blocos, até 3 frases cada, com hiperlinks · imagem entre blocos.
{{/if}}
{{#if canal:comunidade}}### 5. Versão para a comunidade

Post de engajamento sobre **uma** notícia (o destaque): título direto (≤ 8 palavras) · 2–3 frases de contexto · 3–4 bullets · **pergunta de engajamento obrigatória**, genuína, voltada à experiência do leitor · convite fixo de assinatura com dia e horário.
{{/if}}
{{#if canal:instagram}}### 6. Carrossel com o dado

Capa com o número mais forte da edição, sem contexto · segunda tela dá a escala · telas do meio abrem uma causa por tela · última tela convida a assinar. Todo número com fonte e período **na arte**. Sem número forte, usar a fonte de indicadores da organização. Estrutura de carrossel em `redator-instagram`.
{{/if}}

## Regras editoriais

- **Público:** liderança e decisores do setor de {{organizacao.nome}}. **Tom:** analítico, direto, informado — sem alarmismo nem condescendência.
- Cada bloco começa com emoji + título em negrito; hiperlink embutido no texto, nunca URL crua; bullets só em listas de exemplos e na versão de comunidade; pergunta retórica só se genuína.
- **Nunca:** inventar link, dado ou empresa · frase de efeito vazia ("num mundo em constante transformação…") · repetir a mesma informação em formatos diferentes sem adaptar o ângulo · gerar sem todos os campos obrigatórios · mais de 5 notícias por edição.
- Aplicar `redator-comum` (tom da marca, palavras a evitar, estrutura de frase) na revisão final.

## Aprendizados da edição — o ciclo pós-disparo

A **Conclusão** é a hipótese que foi ao ar; depois do disparo, o cartão abaixo é preenchido no registro da edição{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}, nunca na documentação:

```
APRENDIZADOS — edição [nº/data] · tema
- Hipótese que foi ao ar (= Conclusão):
- Números: entregas · abertura · clique · clique por link · descadastro (por público, se segmentada)
- O que o dado diz da hipótese: [confirmou | negou | inconclusivo]
- Link mais clicado e o que indica:
- Bloco com melhor e pior desempenho:
- Decisão para a próxima edição: repetir · cortar · testar
- Vira aprendizado de canal? [sim → benchmarks-canal | não → fica no registro]
Fonte: [plataforma de disparo] · Período:
```

Regras: a hipótese é a Conclusão, não o assunto · um aprendizado por edição, no máximo dois · sem número, sem aprendizado (`[PENDENTE DE CONFIRMAÇÃO]`, nunca estimativa) · métrica interna não vai para peça · em série planejada, a fase seguinte herda o que funcionou; fase que não moveu engajamento não vira fase de ativação sem ajuste.

## Checklist

- [ ] Todos os campos obrigatórios presentes? Tipo de edição escolhido?
- [ ] Assunto em A/B, ≤ 60 caracteres, sem emoji? Headline, intro e "na edição de hoje" na ordem?
- [ ] Cada afirmação vem de uma notícia do briefing, com link quando fornecido? Aspas exatas e creditadas? Fonte em cada indicador?
- [ ] Conclusão fecha o argumento e diz o que o leitor faz? Passaria no teste "funcionaria em qualquer edição"?
- [ ] Fique por dentro com 4 a 6 links do briefing? Feedback fixo presente?
- [ ] Versões por canal só as pedidas, com ângulo adaptado? Nenhuma palavra da lista a evitar?

## Output esperado

Na sequência: **versão e-mail completa** (elementos 1 a 8){{#if canal:linkedin}} · **versão LinkedIn**{{/if}}{{#if canal:comunidade}} · **versão comunidade**{{/if}}{{#if canal:instagram}} · **carrossel com o dado**{{/if}} — só os formatos pedidos. Pronto para colar na plataforma de envio ou no agendador, sem edição estrutural. Verificar com quem traz a pauta se há link de CTA específico antes de usar o link fixo. Depois do disparo: cartão de aprendizados no registro. Fechar com a **Nota de transparência** e a **revisão anti-IA** (política do canal `newsletter`).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
