---
tipo: skill
id: curadoria-speakers
descricao: "Seleciona, convida e prepara os speakers da edição — critérios, convite, briefing do speaker e grade de palestras por trilha e horário."
familia: PLANEJAR.speakers
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["critérios para escolher os palestrantes", "convidar um speaker para a edição", "briefing para o palestrante", "montar a grade de palestras", "painel ou palestra para esse tema", "quando publicar a agenda de palestrantes", "o speaker ainda não confirmou", "trilhas da edição"]
requires: produtor-evento · ficha-edicao · regras-comunicacao-evento
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de produzir.**

# Curadoria de speakers

Conduz a grade de conteúdo da edição: quem sobe ao palco, por quê, em que formato e em que ordem — e o que cada speaker precisa receber para entregar o que o público veio buscar. Existe porque a grade é o principal gancho de venda do meio do ciclo e a principal fonte de promessa quebrada ("speaker anunciado que não veio").

## Contexto de uso

- Montar a grade de uma edição nova a partir das dores dos públicos.
- Avaliar um nome sugerido (interno, cliente, parceiro, patrocinador, mercado).
- Convidar, confirmar e briefar speakers; decidir quando publicar a agenda.
- Encaixar palestra patrocinada sem perder a curadoria.

**Não acionar para:** roteiro minuto a minuto do dia (`run-of-show`) · peças de divulgação do speaker (`kit-comunicacao-evento` + canal) · voz pessoal da organização escrevendo conteúdo{{#if tem:vozes}} (`contexto/vozes/`, §3.3){{/if}}.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Edição e ficha | sim | Data, formato, públicos, trilhas já decididas |
| Públicos e dores | sim | `publicos[]` do config — a grade responde a elas |
| Número de slots e duração | sim | Vem do calendário reverso e do `run-of-show` |
| Orçamento de speakers | sim | `[INFORMADO PELO CLIENTE]` — cachê, viagem, hospedagem |
| Cotas de patrocínio com palco | recomendado | `captar-patrocinio` — quantos slots são contratuais |
| Histórico de speakers | recomendado | Quem já falou, avaliação qualitativa, repetir ou não |

## Processo

### 1. Definir a tese da grade
Uma frase: o que o público sai sabendo ou decidindo. Trilhas (se houver) derivam das dores dos públicos — cada trilha responde a uma dor de `publicos[]`, não a um produto.

### 2. Critérios de seleção (pontuar antes de convidar)
| Critério | Pergunta |
|---|---|
| Relevância para o público | Fala da dor de quem compra o ingresso? |
| Autoridade verificável | Prática real no tema, não só presença em rede |
| Capacidade de palco | Já falou para esse formato e tamanho? Há registro? |
| Diversidade da grade | Perfis, organizações e pontos de vista diferentes |
| Conflito e risco | Concorrente, exclusividade de patrocinador, exposição reputacional |
| Custo total | Cachê + logística dentro do orçamento |

Nome sem pontuação não entra na grade. Palestra patrocinada passa pelos mesmos critérios — a cota compra o slot, não a isenção de curadoria.

### 3. Convidar
Convite em três partes: por que esse speaker para esse público · o que se espera (tema, formato, duração, data) · o que a edição oferece (cachê ou não, logística, cortesias, divulgação). Prazo de resposta explícito. Status na ficha §9: **convidado → confirmado → publicado**. Só "confirmado" com aceite por escrito; só "publicado" depois da aprovação do material de divulgação pelo speaker.

### 4. Briefar o speaker
Documento curto enviado após a confirmação: tese da grade e onde a fala se encaixa · público (quem está na sala, o que já sabe, o que quer) · formato, duração e regras (sem pitch de produto, salvo slot comercial) · o que entregar e quando (título, resumo, foto, bio, slides no formato do deck do dia — ver `deck-do-dia`) · logística e contato · autorização de imagem e gravação.

### 5. Montar a grade
Ordem do dia pensada por energia: abertura forte, conteúdo denso antes da pausa, painel ou bate-papo depois, encerramento com CTA. Um slot por fala, com respiro. Validar com `run-of-show`. Painel: um mediador e no máximo três convidados.

### 6. Publicar a agenda no momento certo
A agenda é gancho de venda: publicá-la é **pré-requisito de virada** registrado na ficha §4 (tipicamente antes do trecho de recuperação do ciclo). Publicar em ondas quando houver muitos nomes; nunca anunciar nome em status "convidado".

### 7. Acompanhar até o dia
Material recebido × pendente por speaker, ensaio técnico (online) ou passagem de palco (presencial), substituição com plano B para os slots críticos.

## Regras

- Nunca anunciar speaker não confirmado por escrito (`regras-comunicacao-evento` §7).
- Cachê e condições: `[INFORMADO PELO CLIENTE]`.
- Curadoria vale para slot patrocinado.
- Autorização de imagem e gravação antes do dia.
- Ficha §9 é a fonte da grade; o resto vive no registro.

## Checklist

- [ ] Tese da grade e trilhas amarradas às dores dos públicos?
- [ ] Todo nome pontuado nos critérios?
- [ ] Convites com prazo e status na ficha?
- [ ] Briefing enviado a cada confirmado, com entregas e datas?
- [ ] Grade validada com o run-of-show?
- [ ] Data de publicação da agenda registrada como pré-requisito de virada?

## Output esperado

- **Tese da grade** e trilhas.
- **Lista pontuada** de candidatos com decisão.
- **Convite** e **briefing do speaker** prontos para envio.
- **Grade** (slot × speaker × formato × status) para a ficha §9.
- **Quadro de pendências** por speaker até o dia.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
