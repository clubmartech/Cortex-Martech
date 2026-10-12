---
tipo: skill
id: mensagens-por-publico
descricao: "Monta a matriz produto × público — dor, benefício e prova por célula — que o redator usa para derivar peças sem reinventar a mensagem."
familia: PLANEJAR.posicionamento
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["matriz de mensagens do produto", "o que dizer para cada público", "mensagem para o comprador e para o usuário", "benefício por público", "adapta a mensagem para outro público", "prova para cada mensagem"]
requires: product-marketer
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Product Marketer** (`product-marketer`), que carrega o gate (`_cortex/kernel/gate.md`) e o posicionamento antes de passar para cá. **Volte ao Product Marketer antes de montar a matriz.**

# Mensagens por público — a matriz produto × público

Transforma o posicionamento em **células reutilizáveis**: para cada público de um produto, a dor que ele reconhece, o benefício que responde a ela e a prova que sustenta. O Redator do pack marketing deriva e-mail, post, LP e anúncio **da célula**, não do zero. A matriz vive em `times/{{time.slug}}/docs/matriz-mensagens.md`.

## Contexto de uso

- Depois de `posicionamento-produto`, antes de qualquer campanha ou lançamento do produto.
- Pedido de adaptar uma mensagem de um público para outro (comprador → usuário, por exemplo).
- Auditoria: peças do mesmo produto dizendo coisas diferentes para o mesmo público.

## Briefing mínimo

Produto (slug) · públicos (slugs de `produtos[].publicos`; se vazio, perguntar) · posicionamento aprovado (ou abrir `posicionamento-produto` antes) · provas disponíveis com status.

## Processo

### Passo 1 — Montar o esqueleto

Uma linha por público do produto. Públicos declarados no config:

| Público | Tipo | Dor declarada | Objeção declarada |
|---|---|---|---|
{{#each publicos as pu}}| `{{pu.slug}}` — {{pu.nome}} | {{pu.tipo}} | {{pu.dor}} | {{pu.objecao}} |
{{/each}}
Tipos têm papéis diferentes na compra: **comprador** decide e paga (mensagem de resultado e risco); **usuário** opera (mensagem de rotina e esforço); **influenciador** recomenda (mensagem de critério e comparação); **parceiro** revende ou indica (mensagem de ganho e facilidade).

### Passo 2 — Preencher a célula: dor → benefício → prova

| Coluna | Regra |
|---|---|
| **Dor** | Na linguagem do público, concreta, com o momento em que dói. Fonte: config, entrevista, ticket, motivo de perda. Sem fonte, `[HIPÓTESE]` |
| **Benefício** | O que muda para esse público, não o que a funcionalidade faz. Verbo no degrau da prova |
| **Prova** | Uma por benefício: dado, case, tela, depoimento. Com fonte e status; sem, `[NECESSITA FONTE]` |
| **Objeção e resposta** | A objeção declarada do público e a resposta que a mensagem antecipa |
| **Nunca dizer** | Herdado de "o que nunca afirmar" do posicionamento, mais o específico deste público |

### Passo 3 — Testar a diferença entre públicos

Ler as linhas em sequência. Se duas células de públicos diferentes dizem a mesma coisa, uma delas não é mensagem — é a descrição do produto. Reescrever até o benefício mudar de público para público.

### Passo 4 — Marcar estágio e canal sugerido (opcional)

Para cada célula, em que estágio o público está (não sabe que tem o problema · sabe e procura · compara · decide) e por quais canais do config ele costuma ser alcançado ({{#each canais as c}}`{{c.slug}}`{{#if @last}}{{else}}, {{/if}}{{/each}}). Isso orienta o Estrategista, não o substitui.

### Passo 5 — Validar e gravar

Inteiro no chat; com aprovação, gravar na `matriz-mensagens` (uma seção por produto). Linha no `## Histórico`.

## Regras

- Célula sem prova não vai para peça externa — vai para a lista de provas a conseguir.
- Benefício que depende de o cliente fazer algo é escrito com a condição explícita.
- A matriz não contém copy final: headline, CTA e tom são do Redator, pela skill do canal.
- Termos proibidos da marca não entram em nenhuma célula.

## Checklist

- [ ] Uma linha por público do produto, com o tipo correto?
- [ ] Dor com fonte ou `[HIPÓTESE]`? Prova com fonte e status?
- [ ] Benefícios diferentes entre públicos (teste de leitura em sequência)?
- [ ] Objeção declarada respondida? "Nunca dizer" herdado?
- [ ] Gravado na `matriz-mensagens` com aprovação e histórico?

## Output esperado

| Saída | Formato |
|---|---|
| Matriz produto × público | tabela: público · dor · benefício · prova · objeção e resposta · nunca dizer |
| Lista de provas a conseguir | tabela: prova · para qual célula · quem consegue · prazo |

Destino: `times/{{time.slug}}/docs/matriz-mensagens.md`, após aprovação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
