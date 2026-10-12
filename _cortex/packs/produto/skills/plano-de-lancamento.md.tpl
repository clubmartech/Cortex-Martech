---
tipo: skill
id: plano-de-lancamento
descricao: "Estrutura o lançamento de produto ou funcionalidade — tier, públicos, canais do config, cronograma e kit de peças a pedir ao pack marketing."
familia: PLANEJAR.lancamento
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o plano de lançamento", "qual o tier desse lançamento", "cronograma do lançamento", "kit de peças do lançamento", "o que precisa para lançar a funcionalidade", "lançamento da nova versão", "go-to-market"]
requires: product-marketer
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Product Marketer** (`product-marketer`), que carrega o gate (`_cortex/kernel/gate.md`), a ficha do produto e a matriz de mensagens antes de passar para cá. **Volte ao Product Marketer antes de planejar.**

# Plano de lançamento

Decide **quanto esforço** um lançamento merece (tier), **para quem** fala, **por onde** chega e **quando** cada peça sai. O resultado é um plano que o Estrategista do pack marketing transforma em campanha e o Documentador de Produto em ficha, release notes e aviso. Não escreve peça: pede peça.

## Contexto de uso

- Funcionalidade, módulo, produto ou mudança de oferta prestes a ir ao mercado.
- Entrada de produto triada como lançamento (`triagem-entrada-produto`).
- Relançamento de algo que saiu sem comunicação.

## Briefing mínimo

Produto (slug) e o que exatamente é lançado · data ou janela prevista (com `[PENDENTE DE CONFIRMAÇÃO]` se o PM não confirmou) · públicos afetados · estágio de liberação (piloto, parcial, geral) · posicionamento e matriz aprovados (senão, abrir antes) · restrições (embargo, contrato, dependência técnica).

## Processo

### Passo 1 — Classificar o tier

| Tier | Quando | Esforço |
|---|---|---|
| **T1 — mercado** | Produto novo, módulo novo, mudança de oferta ou de preço, diferencial competitivo | Campanha completa; todos os canais prioritários; peças por público; evento ou live quando houver canal |
| **T2 — base** | Funcionalidade relevante para clientes atuais; melhora rotina ou resolve dor conhecida | Aviso in-app, e-mail para a base, artigo, release notes; sem mídia paga |
| **T3 — silencioso** | Correção, ajuste, melhoria pequena | Release notes e artigo quando houver; sem peça de canal |

O tier sai de critério, não de entusiasmo: impacto em novos clientes · impacto em receita dos atuais · evita cancelamento · diferencial frente à alternativa. Com entrada triada, reaproveitar a pontuação da triagem.

### Passo 2 — Definir públicos e mensagem

Para cada público afetado (slugs de `publicos[]`): o que muda para ele, a célula correspondente na `matriz-mensagens` e o estágio em que está. Público sem célula → abrir `mensagens-por-publico` antes de seguir. {{#if publico:parceiro}}Há público do tipo parceiro no config: parceiros recebem aviso **antes** do mercado quando o lançamento muda o que eles vendem ou suportam.{{/if}}

### Passo 3 — Escolher os canais (só os do config)

Canais ativos, por prioridade:
{{#each canais as c}}- `{{c.slug}}` (prioridade {{c.prioridade}}) → {{#if c.revisao_anti_ia == "obrigatoria"}}revisão anti-IA obrigatória{{else}}revisão anti-IA oferecida{{/if}}
{{/each}}
Para cada canal escolhido: público, objetivo da peça (avisar, educar, converter), momento (pré, dia, pós). T1 usa os canais de prioridade alta; T2 só canais da base; T3 não usa canal de marketing.

### Passo 4 — Montar o cronograma por fase

| Fase | O que acontece | Quem |
|---|---|---|
| **Preparação** | Ficha de funcionalidade, posicionamento, matriz, provas, telas em `_assets/` | Documentador de Produto · Product Marketer |
| **Pré-lançamento** | Aviso a parceiros e equipe interna (vendas, atendimento), treino, FAQ | Documentador de Produto · papéis internos |
| **Dia** | Aviso in-app, e-mail, post, release notes, artigo publicado | Redator e Designer (pack marketing) · Documentador de Produto |
| **Pós** | Métrica de adoção, perguntas recebidas, ajuste de mensagem, registro em `indice-publicacoes` | Product Marketer · Documentador de Produto |

Datas só com confirmação do PM; sem ela, usar semanas relativas (S-2, S-1, S0, S+2){{#if operacao.ciclo_planejamento}} e encaixar no ciclo de planejamento ({{operacao.ciclo_planejamento}}){{/if}}.

### Passo 5 — Listar o kit de peças a pedir

Uma linha por peça: canal · público · objetivo · fonte (célula da matriz, ficha) · prazo · quem produz (skill do pack marketing: `redator-*`, `designer-pecas`) · quem valida. É este kit que vai para o Estrategista e o Redator — eles não recebem "faça o lançamento", recebem a lista.

### Passo 6 — Definir sucesso e validar

Métrica de adoção ou de resposta, com fonte onde será lida ({{#if integracao:dados}}base integrada ou {{/if}}relatório da plataforma ou dado informado). Entregar inteiro no chat; com aprovação, gravar em `_saida/` ou no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}.

## Regras

- Lançamento sem posicionamento e matriz aprovados não sai da preparação.
- Nenhuma data prometida ao cliente sem `[VALIDADO]` do PM.
- Equipe interna (vendas, atendimento) sabe **antes** do cliente, sempre.
- Canal fora do config não entra no plano; se precisar, é mudança de config, não de plano.
- O plano pede peças; não escreve copy nem decide arte.

## Checklist

- [ ] Tier justificado por critério? Públicos com célula na matriz?
- [ ] Canais só do config, com público e objetivo por peça?
- [ ] Cronograma por fase, datas relativas até confirmação?
- [ ] Kit de peças com fonte, produtor e validador por linha?
- [ ] Métrica de sucesso com fonte? Equipe interna avisada antes?

## Output esperado

| Saída | Formato |
|---|---|
| Plano de lançamento | documento: tier · públicos · canais · cronograma · kit · sucesso |
| Kit de peças | tabela: canal · público · objetivo · fonte · prazo · produtor · validador |
| Briefing para o Estrategista | texto curto com o plano e o kit anexados |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
