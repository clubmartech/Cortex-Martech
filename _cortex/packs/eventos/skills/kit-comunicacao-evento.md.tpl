---
tipo: skill
id: kit-comunicacao-evento
descricao: "Aplica a cada peça da edição as regras de grafia, nomenclatura, tom e promessa do evento — o checklist que toda peça passa antes do redator e do revisor."
familia: PLANEJAR.divulgacao-evento
output: briefing
canal: {{#if canal:eventos}}eventos{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["checklist da peça do evento", "como grafar o nome da edição", "tom das peças do evento", "o que não prometer na divulgação do evento", "briefing de peça para a edição", "libera esse dado para a peça", "nomenclatura dos lotes na peça"]
requires: produtor-evento · regras-comunicacao-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter, a ficha da edição e `regras-comunicacao-evento` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de liberar qualquer peça.**

# Kit de comunicação do evento

Converte as regras de `regras-comunicacao-evento` (o doc) em **briefing de peça**: o que a peça pode dizer, com que nome, em que tom e com quais dados conferidos hoje. É a última parada antes de a peça ir para quem escreve e desenha{{#if pack:marketing}} (Redator e Designer do pack marketing){{/if}}, e a primeira do revisor. Não escreve copy.

## Contexto de uso

- Toda peça da edição: e-mail, post, página, anúncio, mensagem, roteiro, arte, proposta de patrocínio, deck do dia.
- Dúvida de grafia, nomenclatura de lote, tom ou promessa.
- Liberação de um dado (preço, data, speaker, número) para uso público.

**Não acionar para:** calendário de disparo (`calendario-divulgacao-evento`) · escrever a peça (canal) · decidir a regra (é do doc; mudança passa pelo Documentador).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Peça: canal, formato, data de publicação | sim | A data define a janela vigente |
| Objetivo da peça | sim | Venda, reaquecimento, anúncio de speaker, patrocinador, pós-evento |
| Dados que a peça quer usar | sim | Cada um será conferido na ficha |
| Marca que assina | sim | Brandcenter; marca-mãe {{marca_mae.nome}} é o padrão |
{{#if tem:vozes}}| Voz pessoal que assina | se houver | `contexto/vozes/` prevalece sobre o tom da marca (§3.3) |
{{/if}}

## Processo

### 1. Fixar a nomenclatura
Do doc §6 e da ficha §1: nome oficial do evento, forma curta (se definida), edição (ordinal + ano), nomes das janelas exatamente como na ficha ("Pré-venda", "Lote 1"…), tipos de ingresso, nomes de trilhas e dos speakers com cargo e organização como aprovado por eles. Uma grafia só por peça e por ciclo.

### 2. Conferir cada dado na ficha, hoje
Para cada item da peça: preço da janela **vigente na data de publicação**, data de virada, speaker em status "publicado", patrocinador com contrato, local e horário, regra de desconto ativa. Dado que não está na ficha → `[VERIFICAR]`; a peça não sai com `[VERIFICAR]`.

### 3. Decidir o que a peça pode e não pode afirmar
| Pode | Só com aprovação | Não pode |
|---|---|---|
| Formato, data, local, janela vigente e seu preço | Teaser de speaker não publicado (sem nome) | Meta, volume vendido, verba |
| Speakers publicados, patrocinadores contratados | Parceiro em negociação | Métrica numérica de satisfação |
| Depoimento qualitativo autorizado | Telas da plataforma de venda | Preço de janela futura, desconto não ativado |
| "Menor preço da edição" durante a pré-venda | Número de edição anterior, com ano | Presença prometida, "maior edição", leads ao patrocinador |

### 4. Calibrar o tom
Tom da marca que assina (brandcenter{{#if marca_mae.tom}}: {{join marca_mae.tom ", "}}{{/if}}) adaptado ao momento do ciclo: esquenta (expectativa) · abertura (convite) · vale (conteúdo, sem insistência) · reta final (urgência de vaga, nunca de pânico) · pós-evento (gratidão e continuidade). Termos proibidos da marca valem; "último", "imperdível" e similares só se verdadeiros na ficha e permitidos pelo brandcenter.

### 5. Montar o briefing da peça
```
PEÇA: [canal · formato · data]      JANELA VIGENTE: [nome, conferida em AAAA-MM-DD]
OBJETIVO: [...]                      MARCA / VOZ: [...]
NOMENCLATURA: evento · edição · lote · ingresso · speakers (grafia exata)
DADOS LIBERADOS: [item → fonte na ficha §]
NÃO AFIRMAR: [lista do passo 3 que se aplica]
TOM: [momento do ciclo + tom da marca]
CTA: [um só]
```

### 6. Checklist de peça (vai junto ao revisor)
- [ ] Nome do evento e da edição na grafia oficial, nome completo na primeira menção
- [ ] Nenhum `[VERIFICAR]` pendente; todo dado conferido na ficha na data
- [ ] Nenhum item da coluna "não pode"
- [ ] Preço só da janela vigente; data de virada correta
- [ ] Speaker só em status "publicado"; patrocinador só contratado
- [ ] Termos proibidos da marca ausentes
- [ ] Um CTA; link rastreado com UTM padronizada
- [ ] Nota de transparência: o que veio da ficha, o que veio de quem pediu

## Regras

- O kit libera dados, não cria dados.
- Regra nova ou exceção não nasce aqui: vai para `regras-comunicacao-evento` via Documentador, com data e papel.
- Peça de patrocinador ou de speaker passa pelo mesmo checklist.

## Output esperado

- **Briefing da peça** (bloco acima) anexado ao pedido para quem escreve e desenha.
- **Checklist de peça** preenchido, anexado ao pedido ao Revisor.
- **Lista de pendências** (`[VERIFICAR]`) devolvida ao Produtor quando a ficha não sustenta a peça.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
