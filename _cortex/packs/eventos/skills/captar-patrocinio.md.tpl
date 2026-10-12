---
tipo: skill
id: captar-patrocinio
descricao: "Estrutura cotas e contrapartidas, monta a proposta de patrocínio e opera o pipeline de patrocinadores da edição até o contrato e a entrega."
familia: PLANEJAR.patrocinio
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["montar as cotas de patrocínio", "o que o patrocinador recebe em cada cota", "proposta de patrocínio para a edição", "pipeline de patrocinadores", "quanto cobrar da cota", "renovar o patrocinador do ano passado", "contrapartidas do patrocínio", "entregamos tudo que prometemos ao patrocinador"]
requires: produtor-evento · ficha-edicao · regras-comunicacao-evento
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de produzir.**

# Captar patrocínio

Transforma a edição em produto vendável para marcas: cotas com contrapartidas claras, proposta que não promete o que a ficha não sustenta, pipeline com estágios e probabilidade, e controle de entrega do que foi contratado. Existe porque patrocínio costuma ser a segunda receita do evento e a primeira fonte de promessa não cumprida.

## Contexto de uso

- Desenho das cotas de uma edição nova ou revisão das cotas da anterior.
- Proposta para um patrocinador específico (novo ou renovação).
- Rotina de pipeline: quem está em que estágio, o que falta, quanto já está fechado.
- Checklist de entrega de contrapartidas antes, durante e depois do evento.

**Não acionar para:** receita projetada total (`projetar-receita-evento`) · cupom do patrocinador na bilheteria (`apurar-cupons-evento`) · a arte da proposta ({{#if pack:marketing}}agente `designer`{{else}}papel de design do time{{/if}}).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Edição e ficha | sim | Data, formato, públicos, capacidade, speakers já confirmados |
| Meta de receita de patrocínio | sim | Ficha §3; sem meta, montar cotas é chute |
| Públicos e perfil esperado na sala | sim | `publicos[]` com papel; **sem número de presença prometido** |
| Inventário de contrapartidas possíveis | sim | Palco, estande, logo, conteúdo, base, cortesias, dados |
| Histórico de patrocinadores | recomendado | Quem patrocinou, cota, renovou ou não, por quê |
| Restrições | sim | Concorrente da organização, exclusividade por categoria, limite de cortesias |

## Processo

### 1. Inventariar contrapartidas antes de precificar
Listar tudo que a edição pode entregar, por família: **visibilidade** (logo em peças, palco, credencial, deck do dia, página) · **presença** (estande, ativação, inserção em pausa) · **conteúdo** (palestra ou painel patrocinado, com curadoria editorial — ver `curadoria-speakers`) · **relacionamento** (cortesias, área VIP, encontro fechado) · **dados** (lista de inscritos só com consentimento e base legal; se não houver, não oferecer) · **pós-evento** (menção em conteúdo derivado, gravação). Cada item com custo de entrega e dono.

### 2. Montar as cotas
Três a quatro níveis, cada um um **pacote** (não um menu): o nível superior contém o inferior mais o que é escasso (palco, exclusividade de categoria). Valor de cada cota: `[INFORMADO PELO CLIENTE]`, ancorado na meta de patrocínio ÷ número realista de cotas por nível. Cota contratual de cupom ou cortesia entra como **cortesia contratual, não como canal com meta**.

### 3. Escrever a proposta
Estrutura fixa: por que este público · o que a edição é (dados da ficha, nunca projeção de presença) · as cotas e o que cada uma entrega · prova (depoimento qualitativo de patrocinador anterior, com autorização) · próximos passos e prazo. Passa por `kit-comunicacao-evento` e `regras-comunicacao-evento` §7 (nunca prometer leads, reuniões ou vendas). Copy e arte vão para os handoffs do Produtor.

### 4. Operar o pipeline
| Estágio | Critério de entrada | Probabilidade de referência |
|---|---|---|
| Mapeado | Marca com aderência ao público e sem conflito | `[PENDENTE: definir]` |
| Contato | Decisor identificado e abordado | |
| Proposta enviada | Cota e valor formalizados | |
| Negociação | Contraproposta ou ajuste de contrapartidas | |
| Fechado | Contrato assinado | contratado |
| Perdido | Motivo registrado | — |

Pipeline ponderado alimenta `projetar-receita-evento` §3. Exclusividade por categoria é checada antes de abrir contato com concorrentes entre si. Registro no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}{{#if integracao:crm}} ou no CRM (§3.2){{/if}}.

### 5. Contratar e entregar
Contrato lista contrapartidas item a item com prazo e dono. Abrir o **checklist de entrega** com três momentos: pré-evento (logo recebido em arquivo oficial, inserções em peças), dia (estande, palco, deck do dia — ver `deck-do-dia`), pós-evento (relatório de entrega com evidências, menção em conteúdo derivado). Patrocinador que não enviou material a tempo recebe slide de espera, nunca logo recortado de PDF.

### 6. Fechar o ciclo
Relatório de entrega por patrocinador (o que foi prometido × entregue, com evidência) e pergunta de renovação registrada ainda no pós-evento, enquanto o resultado está fresco.

## Regras

- Nunca prometer número de presença, leads ou resultado de negócio.
- Valor de cota é `[INFORMADO PELO CLIENTE]`; a skill estrutura, não precifica.
- Dado de inscrito só com base legal; sem ela, a contrapartida não existe.
- Logo só com arquivo oficial do patrocinador e contrato assinado.
- Ficha §8 é a fonte da lista de patrocinadores; o pipeline vive no registro.

## Checklist

- [ ] Inventário de contrapartidas com custo e dono?
- [ ] Cotas como pacotes, com o escasso no topo e exclusividade definida?
- [ ] Proposta sem promessa de presença, lead ou venda?
- [ ] Pipeline com estágios, probabilidade e motivo de perda?
- [ ] Checklist de entrega em três momentos aberto?
- [ ] Ficha §8 atualizada e registro feito?

## Output esperado

- **Mapa de cotas** (níveis × contrapartidas × valor `[INFORMADO PELO CLIENTE]`).
- **Proposta** em estrutura fixa, pronta para copy e arte.
- **Pipeline** com estágios, ponderação e próximos passos.
- **Checklist de entrega** por patrocinador e **relatório de entrega** no pós-evento.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
