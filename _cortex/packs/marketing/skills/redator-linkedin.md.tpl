---
tipo: skill
id: redator-linkedin
descricao: "Entrega a legenda de LinkedIn pronta para publicar, na voz de uma pessoa ou do perfil institucional, com gancho, desenvolvimento e hashtags."
familia: CRIAR.social-linkedin
output: texto
canal: linkedin
ferramenta:
produto: todos
publico:
gatilhos: ["post para o LinkedIn", "legenda do LinkedIn", "texto para o LinkedIn", "post na voz de", "conteúdo institucional para o LinkedIn", "transforma em post de LinkedIn", "carrossel de LinkedIn"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — LinkedIn

Cobre dois contextos: **thought leadership** (perfil pessoal de uma liderança ou porta-voz) e **conteúdo institucional** (página da marca). Para anúncio pago no LinkedIn, usar `redator-midia-paga`.

## Contexto de uso

### Cenário 1 — Thought leadership (perfil pessoal)

Post na voz de uma pessoa, publicado no perfil dela. O conteúdo parte da experiência, ponto de vista ou expertise da pessoa — não da marca.

**Quando:** o pedido nomeia uma pessoa, "voz de", "post do [cargo]", "perfil pessoal".
{{#if tem:vozes}}**Regra crítica:** se existir doc de voz para a pessoa (`contexto/vozes/`, modificador §3.3), ele tem prioridade sobre esta skill para linguagem, estilo e padrões. Esta skill define estrutura e regras do canal; o doc da voz define como a pessoa fala. Vozes cadastradas: {{#each vozes as v}}**{{v.papel}}** (`{{v.slug}}`) {{/each}}.{{else}}**Nota:** esta organização não tem vozes cadastradas em `cortex.config.yaml`. Post em nome de pessoa exige que o briefing traga o ponto de vista e a experiência real dela — nunca imitar voz sem material da própria pessoa.{{/if}}

### Cenário 2 — Institucional (página da marca)

Post para a página oficial de {{marca_mae.nome}}{{#if marcas}} ou de outra marca do config{{/if}}. Tom editorial, construção de autoridade, tendência do setor, posicionamento. Página institucional tem alcance orgânico estruturalmente menor — o padrão editorial precisa ser ainda mais alto, e o reshare por perfis pessoais amplifica.

## Contexto de plataforma

- **Perfis pessoais dominam a distribuição**; páginas de empresa alcançam uma fração.
- **Salvamentos valem mais que curtidas** — posts que ensinam (framework, checklist, passo a passo) são os mais salvos.
- **Link externo no corpo corta alcance** — link vai no comentário, com indicação no post.
- **Tempo de leitura conta**, mas a regra editorial vence: meta de ~1.000 caracteres, teto de 1.300. Passar disso só com storytelling genuíno ou legenda de carrossel.
- **Texto genérico com cara de IA perde alcance.** Perspectiva original, dado específico, experiência real.
- **"Uma frase por linha com lição genérica no fim" perdeu força.** O público B2B exige substância.
- **Relevância temática do perfil importa:** post fora da área de expertise da pessoa perde alcance.
- **Engajamento qualificado na primeira hora** amplia a distribuição — planejar horário e quem comenta primeiro.

## Briefing mínimo

**Thought leadership:** quem é a pessoa (há doc de voz?) · ideia central ou ponto de vista · dado, resultado ou experiência real que sustenta · ativo visual que acompanha (carrossel, vídeo, imagem) · objetivo (comentários, salvamentos, mensagens, awareness).

**Institucional:** tema ou pauta · material de apoio (artigo, dado, campanha) · objetivo (awareness, leads, engajamento) · CTA específico.

Sem ponto de vista ou dado real, não escrever: perguntar. Nunca inventar experiência para a pessoa.

## Processo

### 1. Coletar o briefing e identificar o cenário

### 2. Definir o formato

| Formato | Quando usar | Sinal que gera |
|---|---|---|
| **Texto padrão** (~1.000 caracteres) | Opinião, análise, história, aprendizado | Comentários |
| **Texto + imagem** | Dado visual, framework, infográfico | Alcance |
| **Documento / carrossel (PDF)** | Passo a passo, ranking, metodologia | Salvamentos |
| **Texto curto** (< 500 caracteres) | Provocação, pergunta, reflexão rápida | Comentários |
| **Vídeo + legenda** | Bastidor, depoimento, demonstração | Alcance |

### 3. Construir a legenda

```
[GANCHO — linhas 1 e 2, antes do "ver mais"]

[DESENVOLVIMENTO — corpo do post]

[ENCERRAMENTO — reflexão, dado ou provocação]

[CTA — opcional, recomendado]

[HASHTAGS — 3 a 5]
```

**Gancho** (~150 caracteres visíveis): específico ("3 erros que custam prazo em [contexto]" > "Aprendi muito nesses anos") · número quando possível · cria tensão ou curiosidade · sem clichê de autoajuda · não promete o que o post não entrega. Modelos: dado contraintuitivo · erro específico cometido · afirmação provocadora · resultado concreto · pergunta de tensão.

**Estrutura:** storytelling (cena real → tensão → virada → aprendizado) ou AIDA (atenção → interesse → desejo → ação), sempre com lastro: dado, framework, decisão ou perspectiva original. História sem substância vira "cena bonita + lição genérica"; dado sem cena vira artigo. **Teste da conversa:** ler em voz alta; se soa como release ou apresentação, reescrever. Vale também para o institucional.

**Desenvolvimento:** experiência real como âncora (sem dado real, perguntar antes de inventar) · parágrafos de 1–2 linhas com espaçamento · uma ideia central · sem frase motivacional genérica (se poderia estar em qualquer post sobre qualquer assunto, não pertence) · bullets com moderação — post 100% em tópicos soa como gerador de texto.

**CTA:** thought leadership → pergunta que convida o leitor a compartilhar a própria experiência; institucional → pode ter material, evento ou link (no comentário). **Sem engagement bait** ("comente SIM se concordar").

**Hashtags:** 3 a 5, no final, misturando nicho e setor.

### 4. Verificação antes de entregar

- [ ] `redator-comum` aplicado (tom, termos, gênero da marca, benefício)?
- [ ] Gancho específico, sem clichê?
- [ ] Perspectiva original, não resumo genérico do tema?
- [ ] Dados fornecidos pela pessoa ou pelo briefing, ou verificáveis? Senão, removidos e marcados `[NECESSITA FONTE]`.
- [ ] Tom alinhado ao doc de voz (se existir)?
- [ ] Link fora do corpo? Hashtags relevantes e em quantidade?
- [ ] Soa como pessoa real com experiência, não como marketing genérico? Soa como conversa, não como blogpost?
- [ ] ~1.000 caracteres (ou justificativa para passar de 1.300)? Parágrafos de 1–2 linhas?

## Diferenças entre os dois cenários

| Dimensão | Thought leadership | Institucional |
|---|---|---|
| **Voz** | 1ª pessoa do singular | 1ª do plural ou editorial |
| **Tom** | Pessoal, direto, opinativo | Editorial, sem engessar |
| **Âncora** | Experiência vivida | Tendência, dado setorial, novidade da marca |
| **CTA** | Pergunta que gera comentário | Link ou ação específica |
| **Reshare** | A marca pode repostar | Lideranças repostam com comentário próprio |

## Templates

**Opinião + dado (pessoal):** afirmação que desafia uma crença do setor → de onde vem essa visão (experiência, dado) → 2–3 parágrafos curtos de raciocínio → o que muda na prática → pergunta aberta → hashtags.

**Aprendizado de erro (pessoal):** erro específico → o que levou ao erro → o que mudou (decisão, processo, resultado) → lição transferível → pergunta ou reflexão → hashtags.

**Tendência + posicionamento (institucional):** dado ou tendência que o público subestima → por que importa para [público] → como a marca responde a isso → CTA ou convite (link no comentário) → hashtags.

**Carrossel:** a legenda é o contexto que faz abrir o documento — gancho que promete valor específico → 2–3 linhas do que o leitor vai encontrar → instrução ("Arraste para ver" / "Salve para consultar depois") → hashtags.

## O que evitar

| Evitar | Preferir |
|---|---|
| Gancho vago ("Aprendi muito essa semana") | Gancho específico com número ou cena |
| Linguagem de autoajuda | Opinião profissional com lastro |
| Tom de blogpost (introdução, desenvolvimento, conclusão) | Tom de conversa com um colega |
| Parágrafo de 3+ linhas | Parágrafo de 1–2 linhas |
| Lista interminável de bullets | Parágrafos curtos com ritmo |
| Link no corpo | Link no comentário, indicado no post |
| "Curta se concordar" | "O que você faria diferente nessa situação?" |
| Post sobre tudo e nada | Uma ideia central |
| Mais de 5 hashtags | 3 a 5 precisas |

## Output esperado

1. **Legenda pronta** em texto limpo — sem markdown, asteriscos ou negrito (o canal não renderiza).
2. **Nota de briefing incompleto** com `[NECESSITA FONTE]` onde faltou dado da pessoa.
3. **Opcional:** 2 opções de gancho quando o post for estratégico.
4. **Nota de transparência** + **revisão anti-IA** conforme a política do canal (`revisao_anti_ia` de `linkedin` no config).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
