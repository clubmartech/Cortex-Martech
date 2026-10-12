---
tipo: skill
id: calendario-divulgacao-evento
descricao: "Monta o calendário de divulgação da edição — o que sai em cada semana, por canal ativo, com os gatilhos de virada de lote e as regras fixas de disparo."
familia: PLANEJAR.divulgacao-evento
output: plano
canal: {{#if canal:eventos}}eventos{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["o que disparo essa semana do evento", "calendário de divulgação da edição", "que canal entra em cada lote", "quando ligo a mídia paga do evento", "o que fazer na véspera de virada de lote", "plano de divulgação por marco", "semana de esquenta do evento", "pausar disparo no recesso"]
requires: produtor-evento · ficha-edicao · kit-comunicacao-evento
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), a ficha da edição e o kit de comunicação antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de planejar.**

# Calendário de divulgação do evento

Diz **o que sai, por qual canal, em que semana**, marco a marco. Não repete preço (ficha §5) nem meta (acompanhamento) — cita por referência. Existe porque a venda de ingresso é sequência de canais, não soma: canal próprio vende na abertura e some; canal pago demora a maturar e vende no fim; indicação preenche o vale. Ligar cada um na hora errada é a causa mais comum de "canal fraco".

## Contexto de uso

- Depois do plano da edição (janelas e pré-requisitos na ficha §4) e antes da abertura.
- Toda semana: "o que sai agora?".
- Véspera de virada, feriado dentro de janela crítica, pausa de recesso.
- Reajuste depois de checkpoint ou de mudança de calendário.

**Não acionar para:** copy da peça ({{#if pack:marketing}}sub-skill do canal no pack marketing{{else}}papel de redação{{/if}}) · regras do que pode ser dito (`kit-comunicacao-evento`) · metas de canal (`acompanhar-metas-evento`).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Ficha §4 (janelas, pré-requisitos) e §10 (canais) | sim | Sem janelas, não há marcos |
| Meta de volume por janela e por canal | sim | Do acompanhamento; `[NECESSITA FONTE]` se não houver |
| Canais ativos e dono de cada um | sim | Lista abaixo, vinda do config |
| Feriados, recessos e pontes do ciclo | sim | Ficha §4 |
| Verba de mídia por janela | se há mídia paga | `[INFORMADO PELO CLIENTE]` |
| Grade de speakers e data de publicação | sim | `curadoria-speakers` — é gatilho de reaquecimento |

## Regras fixas de disparo

1. **Fim de semana não recebe disparo comercial pesado.** Véspera de virada em fim de semana → antecipar o pico para o último dia útil anterior.
2. **A véspera de cada virada é o dia de maior retorno por disparo.** Sem lote seguinte, o gatilho muda de "preço sobe" para "vaga acaba".
3. **Canal próprio primeiro, pago depois, indicação no vale.** Mídia paga liga na abertura com verba baixa — para acumular audiência e teste de criativo, não para converter — e escala rumo ao trecho em que historicamente faz o pico.
4. **Recesso e feriado pausam disparo pesado**, nunca o canal inteiro: conteúdo leve segue.
5. **Nenhum disparo cita preço de janela futura** nem desconto não ativado (`regras-comunicacao-evento` §1).

## Canais ativos no config

| Canal | Prioridade | Papel típico no ciclo de evento | Dono |
|---|---|---|---|
{{#each canais as c}}| `{{c.slug}}` | {{c.prioridade}} | `[PENDENTE: próprio · pago · orgânico · indicação]` | `[PENDENTE: papel]` |
{{/each}}

## Processo

### 1. Marcar os marcos
Um marco por virada de lote (ficha §4) mais a abertura, a esquenta, a publicação da agenda e o dia. Para cada marco: data, o que fecha, o que entra, **pré-requisito operacional** (cupons ativados, agenda publicada, UTM auditada) com data-limite.

### 2. Montar a semana de esquenta
Sem venda. Objetivo único: expectativa para a abertura. Teaser sem preço, bastidor, depoimento qualitativo da edição anterior (nunca estatística de satisfação).

### 3. Preencher cada janela
Tabela por janela: `data · canal · ação · gatilho`. Padrão: abertura com disparo principal → reforço nas primeiras horas segmentado por quem clicou e não converteu → manutenção → "faltam N dias para o reajuste" → **pico na véspera** (dois envios: manhã e fim de tarde). No vale, manutenção mínima e indicação ativa — não insistir: não é falha de execução.

### 4. Encaixar os gatilhos de reaquecimento
Publicação da agenda de speakers · anúncio de patrocinador · abertura de desconto de grupo (só na janela elegível) · conteúdo derivado da edição anterior. Cada um ligado a um marco.

### 5. Definir a virada de tom na reta final
Última janela: contagem regressiva diária, tom de vaga e não de preço, todos os canais simultâneos, feriado da reta final compensado com intensidade nos dias úteis.

### 6. Entregar para execução
Cada linha do calendário vira pedido de peça: canal, data, mensagem-chave, dado liberado (conferido na ficha no dia), CTA. {{#if pack:marketing}}O pedido vai ao **Redator** e ao **Designer** do pack marketing com `kit-comunicacao-evento` anexado.{{else}}O pedido vai ao papel de redação e design do time com `kit-comunicacao-evento` anexado.{{/if}} Lembretes automáticos para vésperas, feriados e pré-requisitos no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}.

## Regras

- O calendário não guarda copy pronta nem preço.
- Toda ação tem canal, data, dono e gatilho.
- Mudança de janela na ficha → recalcular marcos no mesmo dia.
- Linha "Desconhecido" do rastreio crescendo → auditar UTM antes do próximo marco.

## Checklist

- [ ] Um marco por virada, com pré-requisito e data-limite?
- [ ] Esquenta sem preço e sem venda?
- [ ] Pico na véspera de cada virada, antecipado se cair em fim de semana?
- [ ] Mídia paga ligada cedo com verba baixa e escalada no trecho certo?
- [ ] Gatilhos de reaquecimento ligados a marcos?
- [ ] Reta final com tom de vaga e feriados compensados?
- [ ] Nenhum preço de janela futura em nenhuma linha?

## Output esperado

- **Mapa de marcos** (data · fecha · entra · pré-requisito · limite).
- **Tabela por janela** (data · canal · ação · gatilho).
- **Divisão de trabalho por canal** (trecho do ciclo × canal protagonista).
- **Lista de pedidos de peça** para os handoffs.
- **Lembretes** a registrar (vésperas, feriados, pré-requisitos, checkpoints).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
