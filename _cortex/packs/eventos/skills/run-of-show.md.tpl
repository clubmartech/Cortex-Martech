---
tipo: skill
id: run-of-show
descricao: "Entrega o roteiro minuto a minuto do dia do evento — presencial ou online — com blocos de tempo, papéis da equipe, engajamento, CTA ao vivo e checklist técnico."
familia: CRIAR.run-of-show
output: roteiro
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["roteiro minuto a minuto do dia", "run of show do evento", "quem fala o quê no dia", "ordem do dia do evento", "roteiro de abertura e encerramento do evento", "checklist técnico do dia", "credenciamento, palco e pausas", "plano B se o speaker atrasar"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de roteirizar.**

# Run-of-show — roteiro do dia

Estrutura o dia minuto a minuto: o que acontece, quem conduz, como o público é engajado e para onde é levado no fim. Não é o conteúdo das palestras — é a **regência** do evento. Vale para presencial, online e híbrido; o que muda são os blocos operacionais.

## Contexto de uso

- Depois da grade de speakers (`curadoria-speakers`) e antes do deck do dia (`deck-do-dia`).
- Ensaio e passagem de palco; alinhamento da equipe do dia.
- Evento recorrente que precisa de padrão.

**Não acionar para:** falas por extenso ({{#if pack:marketing}}`redator` / `roteiro-video` do pack marketing{{else}}papel de redação{{/if}}) · a apresentação (`deck-do-dia`) · divulgação (`calendario-divulgacao-evento`).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Formato, data, horário de início e fim | sim | Ficha §1 |
| Grade confirmada (slot × speaker × formato) | sim | Ficha §9 |
| Equipe do dia e papéis | sim | Quem apresenta, quem modera, quem opera, quem atende |
| Oferta ou próximo passo do CTA ao vivo | sim | Define o encerramento |
| Patrocinadores com momento contratado | se houver | `captar-patrocinio` — inserção, estande, pausa patrocinada |
| Restrições de local ou plataforma | sim | Capacidade, som, credenciamento, limite de transmissão |

## Processo

### 1. Montar o esqueleto por blocos
Toda a duração dividida em blocos com início e fim. **Valor antes de pitch.** Abertura forte, conteúdo denso antes da pausa, interação depois, encerramento com um CTA. Respiro entre falas; nunca dois blocos longos seguidos sem interação.

**Referência presencial (um dia):**

| Bloco | O que acontece | Responsável |
|---|---|---|
| Credenciamento | Chegada, crachá, orientação, café; música e telão com programação | Recepção + produção |
| Abertura | Boas-vindas, regras da casa, agradecimento a patrocinadores, gancho do dia | Host |
| Palestra 1…N | Conteúdo; divisória de speaker no deck; cronômetro visível ao speaker | Speaker + palco |
| Momento patrocinado | Inserção contratada, limitada ao combinado | Host + patrocinador |
| Pausa | Café, networking, estandes; horário de retorno anunciado | Produção |
| Painel ou bate-papo | Mediador + até três convidados; perguntas-âncora preparadas | Mediador |
| Perguntas | Da plateia (microfone volante ou app); perguntas-âncora de reserva | Host |
| Encerramento | Recap, CTA ao vivo (um só), agradecimentos, próxima edição se decidida | Host |
| Pós-sala | Desmontagem, coleta de material, check-in de speakers e patrocinadores | Produção |

**Referência online:** abertura (boas-vindas, regra do chat, gancho) → contexto e dor → enquete de abertura → conteúdo central em sub-blocos com microganchos → demonstração ou caso → perguntas do chat + âncoras → CTA ao vivo + o que vem depois (gravação). Maior abandono é no meio: quebrar com "daqui a pouco mostro na prática".

**Híbrido:** dois roteiros sincronizados; a transmissão tem host próprio e não fica refém das pausas da sala.

### 2. Mapa de papéis
| Papel | Responsabilidade |
|---|---|
| Host / âncora | Ritmo, transições, tempo, condução do CTA |
| Speaker | Conteúdo do slot |
| Mediador | Painéis e perguntas; filtra e prioriza |
| Produção / palco | Deck, cronômetro, microfone, troca de speaker, pausas |
| Moderação de chat (online) | Perguntas, enquetes, links, sinaliza perguntas quentes |
| Técnica | Som, vídeo, transmissão, plano B |
| Recepção / atendimento | Credenciamento, orientação, imprevistos |

Equipe enxuta acumula funções, exceto speaker + moderação.

### 3. Engajamento e CTA ao vivo
Enquete de abertura (segmenta) e uma no meio (recupera atenção); perguntas-âncora que conectam à oferta; perguntas quentes marcadas viram insumo do pós-evento. CTA: antecipar na abertura, fazer a ponte do conteúdo, um só, link ou QR no momento exato, dizer o que acontece depois. Tom consultivo; a oferta é o próximo passo de valor.

### 4. Planos B
Speaker atrasado ou ausente (bloco reserva: bate-papo, perguntas, conteúdo gravado) · falha técnica (segundo link, áudio alternativo) · estouro de tempo (o que corta primeiro, decidido antes) · material não recebido (slide de espera — `deck-do-dia`).

### 5. Checklist técnico do dia
- [ ] Som, vídeo e transmissão testados com cada speaker · [ ] Deck final carregado e conferido · [ ] Cronômetro e sinais de tempo combinados · [ ] Enquetes e perguntas-âncora prontas · [ ] Link ou QR do CTA testado · [ ] Gravação ativada e autorizada · [ ] Credenciamento com lista atualizada · [ ] Logos e inserções de patrocinador no lugar · [ ] Contatos de emergência e plano B impressos

## Regras

- Tempo é roteiro: todo bloco tem início e fim; estourar o central derruba perguntas e CTA.
- Nenhum dado inventado na fala: números seguem `anti-alucinacao` e a ficha; marcar o que confirmar antes do dia.
- Nada de promessa ao vivo que a ficha não sustente (`regras-comunicacao-evento` §7).
- Momento de patrocinador limitado ao contrato.

## Checklist

- [ ] Blocos com início, fim e responsável cobrem o dia inteiro?
- [ ] Mapa de papéis sem acúmulo proibido?
- [ ] Enquetes, âncoras e CTA único definidos?
- [ ] Planos B por risco?
- [ ] Checklist técnico anexado?
- [ ] Grade da ficha §9 e roteiro batem?

## Output esperado

- **Run-of-show** em tabela por bloco (hora · duração · o que · quem · recurso).
- **Mapa de papéis.** · **Enquetes e perguntas-âncora.** · **Roteiro do CTA ao vivo** (texto curto).
- **Planos B** e **checklist técnico**.

Destino: registro ou pasta da iniciativa; o deck nasce de `deck-do-dia` a partir deste roteiro.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
