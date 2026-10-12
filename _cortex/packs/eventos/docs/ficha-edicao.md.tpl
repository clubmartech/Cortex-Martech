---
tipo: doc
id: ficha-edicao
descricao: "Modela a ficha de uma edição — nome, data, formato, públicos, metas, lotes, cortesias, patrocinadores, speakers e canais — fonte única das decisões travadas."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quais são os lotes da edição", "quando vira o lote", "quantas cortesias tem a edição", "qual a data do evento", "quem são os patrocinadores da edição", "quais os públicos do evento", "quando abre a venda de ingressos", "modelo de ficha da edição"]
requires:
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

# Ficha da edição — modelo ({{organizacao.nome}})

> **Este arquivo é o modelo.** Cada edição ganha a própria cópia dentro da pasta da iniciativa: `iniciativas/<evento>-<ano>/ficha-<evento>-<ano>.md` (nome único na base → id único), criada junto com o `iniciativa.yaml` conforme `modelo-iniciativa-evento`. Preencha a cópia, nunca este modelo.

> **Fonte única das decisões estruturais da edição:** data, formato, janelas, preços, regras de desconto, cortesias, patrocinadores, speakers e canais. Muda **por exceção**, por decisão da área — nunca por leitura de dado. Meta e realizado vivem no acompanhamento; calendário de disparo vive em `calendario-divulgacao-evento`. Nenhum dos três repete número do outro.

> **Anti-alucinação:** preço, data, regra de cumulatividade e speaker **só** daqui. Antes de usar qualquer um em peça, rode a checagem de `regras-comunicacao-evento` §3. Campo vazio é `[PENDENTE: preencher]`; valor de ingresso é sempre `[INFORMADO PELO CLIENTE]` até a área decidir.

## 1. Dados essenciais

| Campo | Valor |
|---|---|
| Evento (nome oficial e grafia) | `[PENDENTE: preencher]` |
| Oferta no config (`produtos[].slug`) | `[PENDENTE: preencher]`{{#each produtos as p}}{{#if p.tipo == "evento"}} · candidata: `{{p.slug}}`{{/if}}{{/each}} |
| Marca que assina | `[PENDENTE: preencher]` (marca-mãe: {{marca_mae.nome}}) |
| Edição (número ordinal) | `[PENDENTE: preencher]` |
| Data(s) e horário | `[PENDENTE: preencher]` |
| Formato | `[PENDENTE: presencial · online · híbrido]` |
| Local ou plataforma | `[PENDENTE: preencher]` |
| Capacidade (lugares ou vagas) | `[PENDENTE: preencher]` |
| Plataforma de venda ou inscrição | `[PENDENTE: preencher]` |
| Ciclo de vendas (abertura → último dia) | `[PENDENTE: preencher]` |
| Semana de esquenta (sem venda) | `[PENDENTE: preencher]` |
| Dona ou dono da edição (papel) | {{papel "eventos"}} |

## 2. Públicos

| Público (`publicos[].slug`) | Papel no evento | Ingresso ou cortesia | Observação |
|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` — {{pu.nome}} | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | dor: {{pu.dor}} |
{{/each}}

## 3. Metas (referência — o número vive no acompanhamento)

| Meta | Institucional | Curva de trabalho | Margem entre as duas |
|---|---|---|---|
| Receita de ingressos | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| Volume de ingressos pagos | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
| Receita de patrocínio | `[PENDENTE: preencher]` | — | — |
| Presença no dia (medida por check-in) | `[PENDENTE: preencher]` | — | não-show nunca medido → não prometer |

Qual meta cede em caso de conflito: `[PENDENTE: receita ou volume]`.

## 4. Janelas do ciclo (lotes)

| Janela | Abre | Fecha | Dias | % do ciclo | Pré-requisito para virar | Índice de velocidade esperado |
|---|---|---|---|---|---|---|
| Esquenta (sem venda) | `[PENDENTE]` | `[PENDENTE]` | | — | — | — |
| Pré-venda | `[PENDENTE]` | `[PENDENTE]` | | | `[PENDENTE]` | `[NECESSITA FONTE]` |
| Lote 1 | `[PENDENTE]` | `[PENDENTE]` | | | `[PENDENTE]` | `[NECESSITA FONTE]` |
| Lote N | `[PENDENTE]` | `[PENDENTE]` | | | `[PENDENTE]` | `[NECESSITA FONTE]` |

Feriados, recessos e pontes dentro de janelas críticas: `[PENDENTE: preencher]`.

## 5. Tabela de preços e escada

> Informação comercial sensível até a publicação da janela correspondente. Não citar preço de janela futura em peça, conversa com parceiro ou material de patrocínio.

| Janela | Tipo de ingresso A | Tipo de ingresso B | Salto para a próxima | Piso (maior desconto cumulativo) | Folga sobre o piso anterior |
|---|---|---|---|---|---|
| Pré-venda | `[INFORMADO PELO CLIENTE]` | `[INFORMADO PELO CLIENTE]` | | | — |
| Lote 1 | `[INFORMADO PELO CLIENTE]` | `[INFORMADO PELO CLIENTE]` | | | |
| Lote N | `[INFORMADO PELO CLIENTE]` | `[INFORMADO PELO CLIENTE]` | | | |

Validação da escada (`planejar-edicao-evento` §5): `[PENDENTE: aprovada em AAAA-MM-DD por <papel>]`.

## 6. Política de descontos e cumulatividade

| Desconto | Percentual | Soma com | Não soma com | Janelas elegíveis |
|---|---|---|---|---|
| Cliente | `[INFORMADO PELO CLIENTE]` | | | |
| Cupom de colaborador | `[INFORMADO PELO CLIENTE]` | | | |
| Cupom de parceiro ou patrocinador | `[INFORMADO PELO CLIENTE]` | | | |
| Grupo | `[INFORMADO PELO CLIENTE]` | | | |

Regras travadas que protegem a escada: `[PENDENTE: listar]`.

## 7. Distribuição de público (ingressos e cortesias)

| Categoria | Quantidade | % do distribuído | Quem cura |
|---|---|---|---|
| Pagantes | `[PENDENTE]` | | — |
| Cortesia — clientes estratégicos | `[PENDENTE]` | | `[PENDENTE: papel]` |
| Cortesia — patrocinadores | `[PENDENTE]` | | `[PENDENTE: papel]` |
| Cortesia — equipe e liderança | `[PENDENTE]` | | `[PENDENTE: papel]` |
| Cortesia — speakers e acompanhantes | `[PENDENTE]` | | `[PENDENTE: papel]` |
| Cortesia — ações de marketing e imprensa | `[PENDENTE]` | | `[PENDENTE: papel]` |
| **Total distribuído** | `[PENDENTE]` | | capacidade: ver §1 |

Distribuído **não é** presença esperada — a diferença é o no-show.

## 8. Patrocinadores

| Patrocinador | Cota | Status (prospecção · proposta · negociação · fechado) | Contrapartidas | Cupom ou cortesias | Material recebido |
|---|---|---|---|---|---|
| `[PENDENTE]` | | | | | |

## 9. Speakers

| Speaker | Cargo e organização | Tema ou título | Formato (palestra · painel · bate-papo) | Status (convidado · confirmado · publicado) | Voz pessoal da organização? |
|---|---|---|---|---|---|
| `[PENDENTE]` | | | | | {{#if tem:vozes}}ver `contexto/vozes/`{{else}}não{{/if}} |

## 10. Canais da edição

| Canal (`canais[].slug`) | Papel no ciclo | Trecho em que é protagonista |
|---|---|---|
{{#each canais as c}}| `{{c.slug}}` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` |
{{/each}}

## 11. Decisões ainda abertas

| Decisão | Trava o quê | Prazo | Dono (papel) |
|---|---|---|---|
| `[PENDENTE]` | | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
