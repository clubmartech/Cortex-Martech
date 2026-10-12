---
tipo: skill
id: deck-do-dia
descricao: "Especifica o deck de abertura e encerramento do dia — slots fixos intercalados com o material dos speakers — com contrato de entrada e critérios de aceite."
familia: CRIAR.deck-do-dia
output: apresentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["deck de abertura da edição", "apresentação do dia do evento", "slides de programação com estamos aqui", "intercalar os slides dos palestrantes", "slide de encerramento com CTA", "o material do patrocinador não chegou e o slide dele", "padronizar os logos no deck", "regerar o deck depois que o cronograma mudou"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de montar.**

# Deck do dia

A cada edição alguém intercala à mão o material recebido de speakers e patrocinadores com os slides fixos do evento. Esta skill é a **especificação desse deck** — entrada, ordem, slots fixos, regras de logo e critérios de aceite — para que a montagem pare de depender de quem montou da última vez. O que muda entre edições é **dado**, não design. A arte final segue o brandcenter{{#if pack:marketing}} e vai ao agente `designer` (`designer-pecas`, frente A){{/if}}.

## Contexto de uso

- Montar o deck de uma edição; regerar depois de mudança no cronograma; conferir deck montado por outra pessoa.
- Material de speaker ou patrocinador chegando aos poucos.

**Não acionar para:** peças de divulgação (antes do dia) · conteúdo das palestras ou copy dos slides · ordem do dia (vem do `run-of-show`).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Run-of-show fechado | sim | A ordem do deck deriva dele, não é fixada à mão |
| Ficha §1, §8, §9 | sim | Nome, data, local, patrocinadores contratados, speakers publicados |
| Material de cada speaker (apresentação ou PDF) | por slot | Ausente → slide de espera |
| Logos oficiais (realização e apoio) | sim | Arquivo oficial com transparência; nunca recorte de PDF |
| Foto e bio de cada speaker | sim | Retrato, resolução suficiente |
| Encerramento: recap, CTA, QR | sim | Um CTA; link testado |
| Variante de fundo e tokens | sim | Do brandcenter |

## Anatomia do deck

`[F]` fixo do evento · `[E]` externo, inserido como veio.

| # | Bloco | Tipo | Repetição |
|---|---|---|---|
| 1 | Capa — nome do evento, edição, local e data | `[F]` | 1 |
| 2 | Programação completa (sem destaque) | `[F]` | 1 |
| 3 | Programação com "estamos aqui" no bloco N | `[F]` | 1 por bloco |
| 4 | Divisória do speaker — foto, nome, cargo, título | `[F]` | 1 por speaker |
| 5 | Material do speaker | `[E]` | 1 por speaker |
| 6 | Momento fixo — pausa · bate-papo · perguntas | `[F]` | conforme programação |
| 7 | Slide de espera — material não recebido | `[F]` | conforme necessário |
| 8 | Encerramento — recap, CTA e QR | `[F]` | 1 |
| 9 | Agradecimento final | `[F]` | 1 |

Ciclo real: programação → divisória → material → programação → … → programação → momento fixo. A programação reaparece antes de cada bloco novo, com uma linha ativa só; a primeira (slide 2) é a visão geral, sem destaque.

## Processo

### 1. Validar a entrada
Abortar antes de montar se: material referenciado não existe · logo em formato sem transparência · slot de palestra sem speaker · programação vazia · horários fora de ordem.

### 2. Contrato de entrada da edição
```yaml
evento: {nome: "...", edicao: "...", local: "...", data: AAAA-MM-DD}
marca: {variante_fundo: padrao, realizacao: [logo-a, logo-b], apoio: [logo-c, logo-d]}
encerramento: {recap: "...", cta: "...", qr: arquivo}
programacao:
  - {id: credenciamento, inicio: "hh:mm", fim: "hh:mm", tipo: simples, titulo: "Credenciamento"}
  - {id: abertura, inicio: "hh:mm", fim: "hh:mm", tipo: palestra, bloco: "ABERTURA", speaker: {nome: "...", cargo: "...", foto: arquivo}, titulo: "...", material: arquivo}
  - {id: pausa, inicio: "hh:mm", fim: "hh:mm", tipo: pausa, titulo: "Pausa", chamada: "..."}
  - {id: painel, inicio: "hh:mm", fim: "hh:mm", tipo: batepapo, titulo: "...", participantes: [...], perguntas: [...]}
  - {id: patrocinador-x, tipo: palestra, bloco: "PATROCINADOR", speaker: {...}, material: null, empresa: "..."}
```
`tipo` ∈ simples · palestra · batepapo · pausa · perguntas · encerramento. `material: null` → slide de espera. A ordem da lista é a ordem do dia. Tudo que varia está aqui; nada mais.

### 3. Normalizar ativos
Logos em PNG com canal alfa verdadeiro (imagem em paleta indexada com transparência aparece com fundo preto ou colorido no apresentador real — e só na sala). Fotos de speaker recortadas em retrato, rosto no terço superior, comprimidas. Logo recortado de PDF entra como **risco visual** no relatório.

### 4. Posicionar logos — proporção nunca se perde
Altura uniforme no rodapé; largura calculada pela proporção original; se estourar a largura máxima, limitar pela largura e recalcular a altura. A cápsula cresce; os logos, não. Rodapé "Realização / Apoio" em **todos** os slides fixos, inclusive capa e encerramento; **nunca** sobre material de terceiros.

### 5. Ingerir materiais
O conteúdo do speaker **não é recriado nem recolorido** — entra como veio. PDF → cada página como imagem de sangria total. Apresentação → padrão: converter para PDF e tratar como imagem (fidelidade total); opção por bloco: copiar slides editáveis (risco de conflito de tema e de elementos que não copiam).

### 6. Intercalar e emitir "estamos aqui"
Um slide de programação por bloco, lista completa, uma linha ativa (destaque + marcador), demais inativas. Momentos fixos usam o horário de retorno da programação, não digitado.

### 7. Otimizar e validar
Imagens comprimidas, mídia idêntica deduplicada, peso dentro do limite combinado. Checklist de aceite:

| # | Verificação | Critério |
|---|---|---|
| V1 | Nenhuma imagem em paleta indexada | zero |
| V2 | Proporção de cada logo preservada | sem distorção |
| V3 | Altura uniforme dos logos no rodapé | todos iguais |
| V4 | Slides de programação | 1 visão geral + 1 por bloco |
| V5 | "Estamos aqui" | exatamente 1 linha ativa por slide com destaque |
| V6 | Todo bloco com material tem conteúdo inserido | zero perdidos |
| V7 | Todo bloco sem material tem slide de espera | zero lacunas silenciosas |
| V8 | Cores e fontes só do brandcenter | zero desvios |
| V9 | Nome, edição, local e data na capa | confere com a ficha |
| V10 | Abre no apresentador real sem aviso de reparo | sim |

Qualquer falha bloqueia a entrega.

### 8. Relatório de montagem
O que entrou, o que foi ajustado (texto encolhido, logo recortado, cor normalizada), o que ficou pendente — um item por bloco sem material.

## Regras

- Ordem deriva do run-of-show; mudou o cronograma, regera-se o deck.
- Nenhum dado de slide fixo fora da ficha; CTA único e testado.
- Patrocinador sem contrato não entra no rodapé; sem material, entra com slide de espera.
- Fontes não universais: embutir, declarar fallback ou rasterizar — decidir antes.

## Checklist

- [ ] Contrato de entrada completo e validado?
- [ ] Logos oficiais com transparência; fotos em retrato?
- [ ] Programação com "estamos aqui" correta em todos os blocos?
- [ ] Materiais inseridos como vieram; espera onde faltou?
- [ ] V1–V10 marcados; nenhuma falha?
- [ ] Relatório de montagem entregue com pendências?

## Output esperado

- **Deck da edição** — arquivo único e editável, ordem da anatomia, brandcenter, peso dentro do limite.
- **Relatório de montagem** no chat.
- **Checklist V1–V10** marcado.

Destinatário: quem opera o dia. Precisa abrir no apresentador real e continuar editável.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
