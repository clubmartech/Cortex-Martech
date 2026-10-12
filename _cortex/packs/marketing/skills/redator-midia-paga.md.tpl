---
tipo: skill
id: redator-midia-paga
descricao: "Entrega títulos, descrições e roteiros de anúncio no formato exato de cada plataforma paga — Meta, Google Search, PMax e LinkedIn Ads — e itera com dados."
familia: CRIAR.midia-paga
output: texto
canal: midia-paga
ferramenta:
produto: todos
publico:
gatilhos: ["copy de anúncio", "texto para o Meta Ads", "títulos para Google Search", "copy para PMax", "anúncio no LinkedIn", "criativo de tráfego pago", "variações de anúncio", "itera o anúncio com base nos dados"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — Mídia paga (Meta · Google Search · PMax · LinkedIn Ads)

Aplica `redator-comum` às especificações de copy de anúncio em cada plataforma. Cobre criação do zero e iteração com base em performance. Post orgânico é das skills de social.

## Contexto de uso

- **Meta Ads** — feed, stories e reels; imagem e vídeo.
- **LinkedIn Ads** — imagem única para audiência B2B.
- **Performance Max (PMax)** — assets de texto e vídeo combinados automaticamente em busca, vídeo, display, e-mail e descoberta.
- **Google Search** — anúncio de pesquisa para quem já busca.

## Briefing mínimo

Além de `redator-comum`: **modo** (criação × iteração) · **plataforma** · **formato** (imagem × vídeo) · **objetivo** (lead, tráfego, conversão, reconhecimento) · **público** · **oferta** (material, demonstração, produto, promoção) · **estágio no funil** · **produto** · **página de destino** (URL ou descrição — verificar coerência com o copy) · dados de performance (só no modo iteração: títulos e textos com melhor e pior resultado).

## Processo

1. **Verificar contexto de marca** e, se houver produto, `contexto/produtos/<slug>/<slug>.md` + `times/{{time.slug}}/docs/criatividade-<slug>.md`.
2. **Confirmar o briefing.** Modo iteração → seguir § Iteração antes de qualquer variação nova.
3. **Diagnosticar o nível de consciência** (tabela em `redator-comum`). Tráfego frio (display, topo de social) → inconsciente e consciente do problema. Retargeting e busca → consciente da solução em diante.
4. **Decidir: vende o clique ou vende a solução.** Clique → copy curto, gancho de dor ou curiosidade, mínimo revelado; a página faz a venda (tráfego frio, oferta que precisa de explicação). Solução → copy mais longo, mecanismo e prova; a página só fecha (retargeting, consciente do produto). Se o criativo mostra o produto em tela, o leitor vira consciente do produto — nunca mandar para página genérica.
5. **Aplicar a lógica da plataforma:** Meta e LinkedIn — audiência passiva, interrompida: parar o scroll · Google Search — audiência ativa: capturar intenção · PMax — assets diversos e complementares, sem repetição.
6. **Escrever** com a seção técnica da plataforma.
7. **Orientar a verificação de qualidade na própria plataforma** quando ela oferecer (pontuação de anúncio) — o time de mídia confere; a IA não acessa a conta.
8. **Revisar** com `redator-comum` + checklist desta skill.

## Esqueleto estratégico — WHY / WHAT / HOW

Para toda audiência passiva, antes de escrever qualquer variação:

```
WHY  — por que isso importa agora? A dor ou situação que o leitor já vive. Sem produto.
WHAT — o que resolve isso? O mecanismo: o que o produto faz de diferente. Revelar o suficiente para criar desejo, não para dispensar o clique.
HOW  — como dar o próximo passo? CTA orientado ao que o leitor ganha.
```

O gancho (linha 1) é escrito **por último**, com o argumento já claro. A cadeia "E daí?" de `redator-comum` vale aqui com força: o copy vive no terceiro nível, não na feature.

## Meta Ads

Alcança quem **não está buscando**. A qualidade do criativo pesa mais que verba ou segmentação; testar várias variações de texto é prática obrigatória.

| Campo | Limite | Observação |
|---|---|---|
| **Texto principal** | 125 caracteres visíveis (até 230 por variação) | Só os primeiros 125 aparecem antes do "ver mais" no celular; entregar 3 variações |
| **Título** | até 25 caracteres | Função de CTA |
| **Descrição** | até 30 caracteres | Nome do material, produto ou benefício; não aparece em todo posicionamento |
| **Texto na imagem** | até 90 caracteres | Sem CTA; menos texto na imagem = mais alcance |

**Formatos de imagem:** 1:1 · 4:5 (prioritário no feed mobile) · 9:16 (stories e reels) · 1,91:1 (desktop). Entregar o mesmo criativo nos quatro.

**Estrutura do texto principal:** linha 1 gancho (dor, dado ou provocação nos primeiros 80 caracteres) → linha 2 mecanismo e benefício → linha 3 prova ou identificação → linha 4 CTA de ganho.

**Três variações obrigatórias, de ângulos diferentes** (não reformulação): V1 dor (tráfego frio) · V2 provocação — contradiz uma crença (tráfego morno) · V3 resultado — benefício de cara (retargeting).

**Vídeo (15–30 s feed; até 60 s reels):** gancho visual + textual no primeiro segundo; legenda queimada no vídeo com alto contraste (toca sem som); marca visível nos primeiros 3 s; roteiro linear em 4 cenas — frase de impacto · dor nomeada · o que o produto faz de diferente · o que ganha ao clicar. Tom estruturado converte mais que casual em B2B; pessoa falando para a câmera e problema-solução são os formatos que mais convertem.

## LinkedIn Ads

Decisor em contexto de trabalho; cada impressão custa mais — copy genérico ou "vendedor" perde. Imagem única em 1,91:1 ou 1:1 (vertical não entra no desktop).

| Campo | Limite | Observação |
|---|---|---|
| **Texto introdutório** | até 150 caracteres (máx. 600) | Acima de 150 trunca com "ver mais", e cada clique nele é cobrado |
| **Título** | até 70 caracteres | CTA direto com proposta de valor |
| **Descrição** | até 70 caracteres | Só na rede de audiência — opcional |

Estrutura: [texto introdutório — dor ou dado direto, cargo implícito, reconhecível em 2 s] + [título — CTA com proposta de valor].

## Performance Max (PMax)

A plataforma combina os assets e decide onde exibir; **a qualidade dos assets é a única alavanca de copy**. Asset groups por **tema ou solução**, não por audiência. Combinação de até 3 títulos em sequência precisa ser coerente em qualquer ordem. Testar um elemento por vez — substituir só o título avaliado como fraco, sem mexer no resto.

| Asset | Quantidade | Limite |
|---|---|---|
| Títulos curtos | 15 | 30 caracteres |
| Títulos longos | 5 | 90 caracteres |
| Descrições | 5 | 90 caracteres |
| Frases para estático | 5 | — |
| Roteiros de vídeo | 5 | — |
| Imagens | 5 por formato (1:1, 4:5, 9:16, 16:9) | — |
| Vídeos | ao menos 1 por formato (1:1, 16:9, 9:16) | sempre produzir 1 vídeo próprio — o automático da plataforma representa mal a marca |

**Copy por tipo de asset group:** topo (tráfego frio) → dor ou dado, sem citar produto · meio (consciente da solução) → mecanismo do produto · retargeting → benefício concreto + CTA direto. Entregar os 15 títulos já identificando o group.

**15 títulos curtos em 5 grupos de 3** (qualquer combinação de 3 forma argumento): nome do material ou produto · dor do usuário · benefício (nível 3 da cadeia) · solução/mecanismo · CTA. Indicar o título a **fixar** na busca (maior aderência à palavra-chave).

**5 descrições, cada uma autônoma:** D1 dor + mecanismo (topo e meio) · D2 benefício com dado (meio e retargeting) · D3 identificação de público + CTA (topo) · D4 diferencial vs. alternativa (meio) · D5 custo de não agir (retargeting).

**5 títulos longos:** nome + benefício + prova ou especificidade; um por ângulo (dor, benefício, mecanismo, público, CTA).

**Vídeo PMax (15 s não pulável; 30 s pulável):** criativo animado, não storytelling — motion com texto na tela; marca nos primeiros 5 s; legenda queimada; formatos 16:9 + 9:16 + 1:1. Três cenas: impacto · benefício ou mecanismo · nome + CTA. Cinco roteiros por ângulo: dor → mecanismo → CTA · dado → solução → CTA · benefício → marca → CTA · público → problema → CTA · provocação → mecanismo → CTA.

## Google Search

Audiência com **intenção ativa**: capturar a intenção e converter. Relevância entre busca, copy e página define o índice de qualidade e o custo por clique.

| Asset | Quantidade | Limite |
|---|---|---|
| Títulos | 15 | 30 caracteres |
| Descrições | 5 | 90 caracteres |
| Títulos longos | 5 | 90 caracteres |

Mesmos 5 grupos de títulos e 5 focos de descrição do PMax. **Boas práticas:** palavra-chave principal nos primeiros títulos · cada título acrescenta um argumento · ao menos 2–3 títulos de CTA (sem eles o anúncio não converte) · indicar título fixo na posição 1 · descrições autônomas · **sem ponto final em título** (a plataforma corta).

## Técnicas para mídia paga

**Categorias de ângulo** — variação que só troca palavras não é teste; ângulo diferente = motivação diferente: dor · resultado · prova social · identidade ("para [cargo] que não aceita mais…") · contrariano · curiosidade · comparação com a alternativa · custo de não agir. Nas 3 variações do Meta, cobrir ao menos 3 ângulos.

**Hierarquia de teste** (uma variável por ciclo): ângulo/conceito > gancho/headline > estilo visual > corpo > CTA.

**Coerência anúncio → página:** mesmo tema, mesma promessa, mesmo nível de consciência. Custo alto com bom copy quase sempre é problema de página. Antes de entregar: a página de destino sustenta a promessa do anúncio? Se não, sinalizar o gap.

**Gancho por nível:** inconsciente → dado de setor ou situação reconhecível · consciente do problema → nomear a dor · consciente da solução → contradizer crença ou diferenciar · consciente do produto → prova ou resultado específico · pronto → oferta direta.

**Gatilhos B2B:** especificidade de resultado · identificação de cargo ou situação em 2 s · custo de não agir (mais efetivo que urgência artificial) · prova por comportamento observável, não número genérico · "o que o copy não é" (dizer o que não é intensifica o que é — estrutura permitida aqui, só em lista de três negativas concretas, nunca como "não é X, é Y").

## Iteração com base em performance

Nunca gerar variação nova sem analisar o que já roda — iterar sem dado é adivinhar.

1. **Vencedores:** tema (que dor, benefício ou ângulo), estrutura (pergunta, afirmação, número), tom, tamanho.
2. **Perdedores:** ângulos a descartar; padrões comuns (genérico, tom errado, promessa vaga).
3. **Novas variações:** expandir os ângulos vencedores com formulação nova; explorar 1–2 ângulos ainda não testados; evitar padrões perdedores; uma variável por ciclo.
4. **Documentar o ciclo:** `Ciclo — [plataforma] — [data]: vencedores analisados · padrão identificado · perdedores descartados · novas variações · ângulos novos · ângulos aposentados`.

Regra de aposentadoria: não pausar asset antes do volume mínimo de impressões definido pelo time em `times/{{time.slug}}/docs/benchmarks-canal.md` — antes disso é ruído, não dado.

## Checklist

- [ ] Plataforma, formato, objetivo, público, oferta, estágio e página confirmados?
- [ ] Nível de consciência diagnosticado e decisão clique × solução tomada?
- [ ] Esqueleto WHY/WHAT/HOW escrito antes do gancho? Copy no nível 3 da cadeia?
- [ ] Limites de caracteres de cada campo contados? Sem ponto final em título de busca?
- [ ] 3 variações de ângulos distintos (Meta)? 15 títulos em 5 grupos + título fixo indicado (busca e PMax)? Descrições autônomas?
- [ ] Página de destino sustenta a promessa? Gap sinalizado?
- [ ] Modo iteração: ciclo documentado, uma variável por vez?
- [ ] Nenhuma palavra da lista a evitar? Nenhum número sem fonte? Regras de marca de `redator-comum`?

## Output esperado

A entrega vai direto ao registro da peça e é lida por quem executa (mídia e criação). **Regra do bloco por peça:** uma peça = um bloco autossuficiente = copy no formato exato da plataforma + **ficha do criativo** (formato fechado do agente `designer`, 8 bullets). Sem seção global: objetivo, público, dor e mote vivem no briefing da campanha.

**Teto duro:** ficha de 8 bullets de uma linha · 3 variações de copy por peça · roteiro de vídeo de até 5 cenas · zero tabela e zero prosa dentro do bloco. Variação é numerada (`Copy 1`, `Copy 2`), sem nome de ângulo ou público no rótulo. Restrição de marca entra uma vez, na ficha.

```
Meta / LinkedIn (imagem):  Títulos · Títulos longos · Descrições · Texto na imagem 1, 2…
Meta / PMax (vídeo):       Roteiro N → Cena 1 [o que aparece] [áudio] · Cena 2 · Cena 3
Search / PMax (texto):     Títulos · Títulos longos · Descrições · Frases para estático · Título recomendado para fixação
```

> **Proibido na entrega:** rótulo de gatilho ou público no copy; justificativa de escolha; nota de fonte ou padrão; comentário sobre a própria entrega; parêntese explicativo; pendência dentro do bloco; restrição repetida. Divergência técnica, link ou aprovação pendente: uma linha no chat ou comentário no registro.

Fechar com a **Nota de transparência** e a **revisão anti-IA** conforme a política do canal `midia-paga` no config.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
