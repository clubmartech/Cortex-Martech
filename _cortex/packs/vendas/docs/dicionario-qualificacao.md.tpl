---
tipo: doc
id: dicionario-qualificacao
descricao: "Fixa o vocabulário de qualificação do time: perfil ideal, fit, urgência, MQL, SQL, pontuação e passagem — derivado dos públicos e produtos do config."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que é um lead qualificado aqui", "quais critérios definem o ICP", "o que é fit", "o que é urgência na qualificação", "pontuação de qualificação", "quando um lead é desqualificado"]
requires:
owner: {{papel "sdr"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

# Dicionário de qualificação — {{organizacao.nome}}

> **Vocabulário único.** Se marketing, prospecção e vendas usam a mesma palavra para coisas diferentes, o acordo de passagem não existe. Este doc nasce com o que o config já diz (públicos, dores, produtos) e com os critérios em `[PENDENTE: preencher]`, preenchidos pelo papel `{{papel "sdr"}}` com o Líder de Vendas e ratificados por `governanca.ratificador`.

**Quem usa:** `qualificacao-lead` (aplica), `passagem-marketing-vendas` (referencia), `cadencia-prospeccao` (classifica a lista), `sinais-de-compra` (pesos), `analise-motivos-de-perda` (família Perfil e Necessidade). Modelo comercial: **{{organizacao.modelo_comercial}}**.

## Termos

| Termo | Definição nesta organização | Quem decide |
|---|---|---|
| **Lead** | contato identificado, com consentimento para o canal em que chegou | origem |
| **Perfil ideal (ICP)** | conta ou pessoa que cumpre os critérios de § Perfil ideal | este doc |
| **Fit** | a dor que o lead descreve é uma dor que um produto do config resolve (§ Fit) | prospectador |
| **Urgência** | há gatilho registrado para agir agora (§ Urgência) | prospectador |
| **MQL** | lead com perfil ideal **e** sinal de interesse (§ Sinais) | origem / marketing |
| **SQL** | MQL que, após contato, confirmou fit e urgência (ficha de `qualificacao-lead`) | prospectador |
| **Oportunidade** | SQL com reunião de diagnóstico realizada | executivo |
| **Desqualificado** | não cumpre perfil, ou sem fit confirmado após pergunta; motivo da taxonomia registrado | prospectador |
| **Nutrição** | perfil e fit sem urgência; data de retorno definida | prospectador |

## Perfil ideal

| Critério | Dentro do perfil | Fit parcial | Fora do perfil |
|---|---|---|---|
| Segmento | `[PENDENTE: preencher]` | | |
| Porte | `[PENDENTE: preencher]` | | |
| Território | {{#if tem:publicos.territorio}}{{#each publicos as pu}}{{#if pu.territorio}}`{{pu.territorio}}` {{/if}}{{/each}}{{else}}`[PENDENTE: preencher]`{{/if}} | | |
| Papel do contato | `comprador` ou `influenciador` com acesso ao comprador | `usuario` com campeão possível | sem acesso a decisão |
| Maturidade mínima (processo, equipe, ferramenta) | `[PENDENTE: preencher]` | | |
| Exclusões (concorrente, conflito, segmento não atendido) | — | — | `[PENDENTE: preencher]` |

### Públicos e o que cada um sinaliza

| Público | Tipo | Dor registrada | Objeção registrada | Papel típico na decisão |
|---|---|---|---|---|
{{#each publicos as pu}}| {{pu.nome}} (`{{pu.slug}}`) | {{pu.tipo}} | {{pu.dor}} | {{pu.objecao}} | `[PENDENTE: preencher]` |
{{/each}}

## Fit

| Produto | Dor que resolve | Perguntas de fit | Sinal de fit alto |
|---|---|---|---|
{{#each produtos as p}}| {{p.nome}} (`{{p.slug}}`, {{p.tipo}}) | {{default p.dor_principal "[PENDENTE: preencher]"}} | `[PENDENTE: preencher]` | o lead descreve a dor com as próprias palavras |
{{/each}}

Fit **alto**: dor descrita pelo lead. **Médio**: dor inferida do cargo ou do material. **Baixo**: só curiosidade ou pedido de preço sem contexto. Inferência é marcada como inferência.

## Urgência

| Gatilho aceito | Evidência mínima |
|---|---|
| Prazo declarado pelo lead | data ou evento nomeado |
| Evento na conta (mudança de equipe, crescimento, contrato vencendo, problema recente) | sinal com fonte (`sinais-de-compra`) ou declaração do lead |
| Orçamento previsto | declaração do lead `[INFORMADO PELO CLIENTE]` |
| `[PENDENTE: outros gatilhos do segmento]` | |

Pedido de preço sem contexto **não** é urgência.

## Sinais de interesse (para MQL)

| Sinal | Peso (se o time pontuar) |
|---|---|
| Pediu contato comercial | `[PENDENTE: preencher]` |
| Visitou página de preço ou demonstração | `[PENDENTE: preencher]` |
| Baixou material de fundo de funil | `[PENDENTE: preencher]` |
| Respondeu a campanha ou cadência | `[PENDENTE: preencher]` |
| Participou de evento com a oferta | `[PENDENTE: preencher]` |
| Sinal público de conta (`sinais-de-compra`) | `[PENDENTE: preencher]` |

## Pontuação (opcional)

Se o time pontuar: perfil + fit + urgência + sinais, com corte para **avançar** / **qualificar** / **nutrir** / **encerrar** em `[PENDENTE: definir cortes]`. Sem pontuação, vale a tabela de decisão de `qualificacao-lead`.

## Passagem para o executivo

Lead só é agendado quando: perfil ideal ou parcial com campeão · fit alto ou médio com pergunta respondida · gatilho de urgência ou pedido explícito de reunião · comprador mapeado ou nomeado como pendente · ficha de qualificação preenchida. Faltando qualquer item: `qualificar` ou `nutrir`, nunca "agendar e ver".

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "sdr"}} |
