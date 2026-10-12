---
tipo: skill
id: roteiro-video
descricao: "Entrega o roteiro de vídeo no tipo certo — case, material rico, podcast ou demonstração de produto — em tabela de produção, com recorte curto sob demanda."
familia: CRIAR.video
output: roteiro
canal: {{#if canal:youtube}}youtube{{/if}}{{#if canal:youtube and canal:tiktok}} · {{/if}}{{#if canal:tiktok}}tiktok{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["roteiro de vídeo", "roteiro de YouTube", "case em vídeo", "roteiro de podcast", "vídeo de demonstração", "roteiro de shorts", "vídeo tutorial do produto", "vídeo de material rico"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Roteiro de vídeo (case · material rico · podcast · demonstração)

Roteiro audiovisual para vídeo longo e para o recorte vertical curto. Quatro tipos: **case** (depoimento de cliente — tradicional ou visita filmada), **material rico** (apresentador mostra um material gratuito na tela), **podcast** (mediador e convidado) e **demonstração** (funcionalidade de produto gravada de tela, editoria de produto). Vídeo curto nativo de social (reels) é de `redator-instagram`.

## Contexto de uso

| Se o pedido menciona… | `tipo_roteiro` |
|---|---|
| case, depoimento, visita filmada, "case em vídeo" | **case** |
| material rico, planilha, guia, kit, "vídeo do material" | **material-rico** |
| podcast, episódio, convidado, mediador | **podcast** |
| "como fazer X no produto", funcionalidade, tela, tutorial, módulo | **demonstracao** |

**Fronteira material rico × demonstração:** os dois são tour de tela. Material gratuito com objetivo de download → `material-rico`; funcionalidade do produto com objetivo de ensinar a rotina → `demonstracao`. Pedido com os dois: escrever a demonstração e o material entra só como CTA secundário.

## Briefing mínimo

Além de `redator-comum`:

| Tipo | Obrigatório |
|---|---|
| **case** | cliente (nome, tempo de mercado, porte) · porta-voz (nome e cargo) · subformato (tradicional × visita) · desafio anterior · solução implementada · resultado com fonte · ângulo do case · logística (só visita) |
| **material-rico** | material (nome e tipo) · dor que resolve · estrutura (abas, seções) · apresentador · CTA de download (texto exato + link ou QR) · produto conectado |
| **podcast** | episódio e programa · convidado(s) · mediador · tema central · subtemas em progressão · formato (gravado, ao vivo, videocast) · data, horário, local · CTA de fechamento |
| **demonstracao** | **nome do produto** (grafia do config) · **funcionalidade ou rotina** · **objetivo** (o que o espectador sai sabendo fazer) · persona (proposta no checkpoint, se não vier) · formato curto × médio (proposto no checkpoint) · **passo a passo real** (prints, descrição do fluxo ou doc) |

Sem os campos em negrito, **não escreva**. Pergunte.

## Processo

1. **Identificar o tipo.** Ambíguo → perguntar.
2. **Verificar contexto de marca** e o tom da marca que assina; se houver produto, `contexto/produtos/<slug>/<slug>.md`.
3. **Confirmar o briefing.**
4. **Identificar o mecanismo central** (case, material, demonstração): o que muda **na prática** quando a solução é aplicada — não só o resultado. Roteiro que descreve só resultado é genérico.
5. **Demonstração — checkpoint obrigatório antes do roteiro completo:** apresentar produto, funcionalidade, objetivo, formato (curto 1–3 min × médio 6–8 min, com justificativa em uma linha: tarefa pontual × processo com etapas), persona priorizada (com origem: doc do produto ou estratégia geral) e 2–3 títulos de trabalho — e **parar**. Só pular se o usuário disser explicitamente; nesse caso, declarar formato e persona no topo, persona marcada `[PENDENTE DE CONFIRMAÇÃO]`. **O passo a passo real nunca é dispensado**: sem ele, não há roteiro possível — inventar tela ou clique é o pior defeito deste formato.
6. **Escrever** na estrutura do tipo.
7. **Conferir a duração:** ritmo de referência ≈ 2,5 palavras por segundo em locução didática; em screencast, reduzir 10–15% do orçamento de palavras (tela que carrega, clique que precisa ser visto). Calibrar contra um vídeo real já publicado do canal, se existir.
8. **Revisar** com `redator-comum` + checklist desta skill.
9. **Perguntar sobre o recorte curto** — não gerar por padrão: "Quer que eu prepare a versão vertical de 45–60 s?"
10. **Sinalizar handoffs:** título, descrição, capítulos e tags publicados não fazem parte desta entrega.

## Formato obrigatório — tabela de produção

Todo roteiro com direção de imagem sai em tabela de **três colunas: `IMAGEM | LOCUÇÃO | LETTERING`**. Demonstração acrescenta a coluna **Tempo** à esquerda (`Tempo | Tela/Imagem | Locução | Lettering`) — é ela que fecha a conta de duração. Podcast é conversa aberta: cabeçalho + blocos escritos por extenso + lista de tópicos; a tabela só entra em trechos com inserts visuais reais.

**Lettering é reforço, não repetição:** número do passo, um dado, nome e cargo (`GC:`), nome de campo, QR Code — nunca parágrafo inteiro competindo com a fala.

## Princípios universais

Comece pelo objetivo · pense audiovisual (toda fala tem imagem) · crie progressão (nada de blocos intercambiáveis) · clareza vence sofisticação · oralidade (leia em voz alta) · fidelidade às fontes · profundidade adequada ao tempo · escreva para produção (cena viável) · sem excesso de direção (ideia da cena, não storyboard) · encerre com propósito.

**Arco de referência:** gancho → contexto → desenvolvimento → evidência ou aplicação → síntese → CTA. Gancho não é clickbait: forte porque é relevante, nunca por prometer o que o vídeo não entrega.

## Estrutura por tipo

### case

Arco: apresentar cliente e situação → dimensionar o desafio → processo anterior e limitações → a mudança → vozes diferentes → evidências (números, prazos) → impacto na operação e na decisão → aprendizado e futuro.

- **Tradicional (fundo neutro):** a pergunta some na edição — cada resposta precisa ser completa e autossuficiente. Orientar o entrevistado a evitar resposta curta ("melhorou bastante") e dar contexto ("antes levava dois dias; hoje leva horas, porque…"). Pauta fixa de 9 perguntas: apresentação · desafio anterior · o que motivou a busca · como entrou na rotina · melhorias práticas · resultado ou indicador · exemplo concreto · mudança de decisão ou conexão entre áreas · próximos passos. Definir 1–2 ênfases a partir do briefing — nunca reaproveitar o ângulo de outro cliente sem confirmar.
- **Visita filmada:** apresentador conduz (mostra o lugar, alterna fala para câmera e deslocamento, entrevista em movimento, encerra em local significativo). Cabeçalho de produção (data, hora, locações, equipe, apresentador, entrevistados, dados institucionais do cliente) · conceito em 1 parágrafo + tom + formato · blocos temáticos numerados com local/ação, fala do apresentador por extenso, `[Nome responde]` para pergunta aberta, `GC:` na primeira aparição, e trechos **"Base [cliente]"** com citações e números literais — intocáveis · checklist final de produção: EPIs, termo de uso de imagem, momentos espontâneos, repetir números-chave, imagens de cobertura, nenhum dado sensível em tela.

### material-rico

Arco: gancho ligado à dor → apresentação breve do material → visão geral da estrutura → tour guiado por etapas, mostrando na tela → como interpretar ou preencher → síntese do ganho → CTA de download. Dar mais tempo às seções de maior valor; associar cada benefício a uma seção visível; lettering numerado por etapa; "gratuito" e CTA de download recorrentes ao longo do vídeo; nunca prometer que o material resolve sozinho.

### podcast

Cabeçalho de produção (episódio, programa, data, horário, local, mediação, convidados, duração estimada, formato) · **abertura por extenso** (saudação, autoapresentação da mediação, contextualização do tema, apresentação do convidado, boas-vindas → `[Convidado fala]`, objetivo e subtemas) · **desenvolvimento como tópicos abertos** (5–6 perguntas em episódio curto, em progressão lógica; uma pergunta por tópico; curtas e abertas; sem resposta embutida; sem tom promocional ao citar marcas) · **encerramento por extenso** (agradecimento nominal → `[Convidado se despede]`, síntese, CTA de material complementar se houver, convite ao canal, despedida).

### demonstracao

A pergunta de fundo: **"isso ensina algo prático da rotina, ou soa como peça de vendas?"** Cinco blocos fixos, peso variável por formato:

| Bloco | Regra |
|---|---|
| **1. Hook (≈15 s, sempre)** | Qual problema real este vídeo resolve, direto. Promessa que o vídeo cumpre |
| **2. Contexto** | Sanduíche narrativo: diz o que vai mostrar, mostra, recapitula. Curto: uma frase. Médio: explica o conceito. **Não** é bloco de dor lento — o contexto do problema vai distribuído no bloco 3 |
| **3. Mão na massa** | O bloco mais longo. Locução amarrada **exatamente** à tela do momento; cada passo carrega seu porquê em uma frase (o ganho da ação, não o clique). Teste: "clique aqui, clique ali" sem porquê = raso |
| **4. Mid-roll de conversão** | **Durante** a demonstração, num respiro natural (depois de um passo, nunca no meio de uma sequência): convite a demonstração personalizada. QR Code no lettering **+** menção falada ao link da descrição — quem assiste no celular não escaneia a própria tela |
| **5. End-roll** | Link da descrição + inscrição no canal. Um CTA principal |

**Orçamento de tempo:** curto 2:00 — hook 0:15 · contexto 0:10 · mão na massa 1:15 (mid-roll ~10 s) · end-roll 0:20 → ≈255–270 palavras com respiro. Médio 7:00 — hook 0:15 · contexto 0:45 · mão na massa 5:15 (mid-roll ~20 s) · end-roll 0:45 → ≈890–945 palavras. Locução curta demais → aprofundar o porquê do passo, nunca encher; longa demais → cortar passo redundante ou dividir em dois vídeos, nunca acelerar.

**Tom:** host único, consultivo (parceiro explicando a um colega) · caso real da rotina · autoridade e educação, não venda (conversão só no mid-roll e end-roll) · direto, mas não raso · benefício antes de feature · modificador em afirmação de resultado · metáfora só para conceito difícil, do universo do público, nunca metáfora de software · naturalidade sem mexer em número, nome de campo ou ordem de passo · frases conectadas.

**Insumo técnico, por prioridade:** doc do produto (`contexto/produtos/<slug>/`) → o que o usuário forneceu → pedir prints ou descrição do fluxo **antes de prosseguir**. Produto sem doc: todo conteúdo técnico entra `[INFORMADO PELO CLIENTE]`.

**Títulos de trabalho** (2–3, só para alinhar ângulo; o título publicado sai depois): "Como fazer [tarefa] em [contexto]" · "[Funcionalidade]: [o que resolve] no dia a dia". Evitar cara de anúncio ("Conheça o novo…").

**Política de dados em tela:** ambiente de demonstração ou dado anonimizado; nunca cliente real, preço ou dado listado em `governanca.dados_proibidos_em_prompt`.

## Recorte curto vertical (45–60 s) — só sob demanda

Aprofunda **um ponto específico** do vídeo principal; resumo não serve. Objetivo: alcance. Estrutura fixa: **gancho** ("Fiz [X] sem precisar de [Y]…" ou "Quando precisar fazer [X], não faça [Z], faça [Y]" — exceção documentada à proibição de negação/afirmação, válida só neste gancho, porque cada lado carrega ação concreta) → **desenvolvimento** (passo a passo curto do "como fazer") → **fechamento + CTA** (frase de ganho + convite a comentar; prometer cadência só se o canal cumpre). Orçamento ≈ 20 + 100 + 36 palavras. Mesma tabela de produção.

{{#if canal:tiktok}}> **TikTok:** o recorte vertical vale como está quando a conta de TikTok é da marca e pode nomear o produto. Se a estratégia da conta vertical proíbe nomear produto (ver brandcenter), reescrever via `redator-instagram` — não adaptar por conta própria.{{/if}}

## Regras de fidelidade

Nunca inventar dado, nome, cargo, número ou resultado — `[NECESSITA FONTE]` ou `[PENDENTE DE CONFIRMAÇÃO]` e perguntar. Citações do cliente são intocáveis. Não atualizar número por conta própria nem transformar hipótese em afirmação. Nome de concorrente ou de benchmark de outro setor nunca aparece em locução, lettering ou descrição.

**O que evitar:** abertura genérica ("Olá, hoje eu vou falar sobre…") · tom de release · pergunta longa ou dupla · superlativo sem evidência · lettering que reproduz parágrafo · imagem sem relação com a fala · CTA com várias ações · fala artificial em depoimento · mesmo nível de detalhe em todas as seções · prometer que resolve tudo.

## Checklist

- [ ] Tipo identificado; briefing do tipo completo; mecanismo central nomeado?
- [ ] Demonstração: checkpoint apresentado (ou pulado a pedido, com declaração)? Passo a passo real em mãos? Persona com origem?
- [ ] Tabela de produção no formato do tipo? Lettering como reforço?
- [ ] Palavras da locução contadas contra o orçamento do formato?
- [ ] Toda fala tem imagem? Progressão entre blocos? Lido em voz alta?
- [ ] Nenhum dado sem fonte; citações literais; nada sensível em tela?
- [ ] Nenhuma palavra da lista a evitar; regras de marca de `redator-comum`; "não é X, é Y" só no gancho do recorte?
- [ ] Recorte curto oferecido, não gerado por padrão? Handoff de metadados sinalizado?

## Output esperado

- **Cabeçalho de produção** do tipo (cliente/material/episódio/produto · porta-voz ou apresentador · ângulo ou objetivo · CTA).
- **Corpo:** tabela `IMAGEM | LOCUÇÃO | LETTERING` (demonstração: `Tempo | Tela/Imagem | Locução | Lettering`); case tradicional: pauta de 9 perguntas com ênfases + orientação ao entrevistado; podcast: abertura e encerramento por extenso + tópicos.
- **Checklist de produção** (visita filmada).
- **Recorte vertical** quando pedido, na mesma tabela.
- Legível por quem grava sem explicação adicional. Fechar com a **Nota de transparência**, a **revisão anti-IA** (política do canal) e o aviso de que metadados publicados saem em entrega separada.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
