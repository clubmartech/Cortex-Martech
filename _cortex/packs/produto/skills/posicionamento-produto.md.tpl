---
tipo: skill
id: posicionamento-produto
descricao: "Entrega o posicionamento de um produto para um público — problema, promessa, prova, diferenciais e o que nunca afirmar — com fonte por linha."
familia: PLANEJAR.posicionamento
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o posicionamento de", "qual a promessa do produto", "diferenciais com prova", "o que nunca afirmar sobre o produto", "proposta de valor para o público", "reposicionar o produto", "posicionamento do módulo"]
requires: product-marketer
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Product Marketer** (`product-marketer`), que carrega o gate (`_cortex/kernel/gate.md`), o doc-raiz e a ficha do produto antes de passar para cá. **Volte ao Product Marketer antes de posicionar.**

# Posicionamento de produto — por produto e por público

Responde "por que **este público** escolheria **este produto** e não a alternativa que já usa?". Uma folha por par produto × público. Não é descrição de funcionalidades: é a escolha do problema que o produto resolve melhor, a promessa que ele sustenta e a prova que a sustenta.

## Contexto de uso

- Produto ou módulo novo sem posicionamento registrado; reposicionamento após pesquisa, concorrente novo ou mudança de oferta.
- Antes de lançamento (`plano-de-lancamento`), de matriz de mensagens (`mensagens-por-publico`) e de battlecard.
- Pedido de "pitch do produto" — o pitch é a versão falada desta folha.

## Briefing mínimo

| Entrada | Obrigatório | Onde está |
|---|---|---|
| Produto (slug) | sim | `cortex.config.yaml › produtos[]`{{#if oferta:produto}}; se tem módulos, qual módulo{{/if}} |
| Público (slug) | sim | `publicos[]` — com `dor` e `objecao` declaradas |
| Alternativa atual do público | sim — perguntar | planilha, processo manual, concorrente, não fazer nada |
| Provas disponíveis | sim | doc-raiz `contexto/produtos/<slug>/<slug>.md` § provas; ficha do produto; `indice-publicacoes` |
| Restrições | não | o que a marca não diz (`brandcenter`), o que o jurídico veta |

## Processo

### Passo 1 — Fixar o problema (não a funcionalidade)

Escrever o problema na linguagem do público, em uma frase, com o custo de conviver com ele. Partir de `publicos[].dor` e `produtos[].dor_principal`; validar contra entrevista, ticket ou motivo de perda — sem fonte, `[HIPÓTESE]`. Teste: se o problema cabe em qualquer produto do mercado, está genérico demais.

### Passo 2 — Escrever a promessa que o produto sustenta

Uma frase, resultado observável, no tempo do público ("fecha o mês sem…", "sabe na segunda-feira…"). Partir de `produtos[].promessa`. Regra de degrau: promessa com prova forte usa verbo de resultado; com prova fraca usa verbo de apoio ("ajuda a", "reduz"); sem prova, não é promessa — é hipótese a validar.

### Passo 3 — Listar as provas, uma por promessa

| Tipo | Vale como prova? | Marcador quando falta |
|---|---|---|
| Dado próprio (base, pesquisa com clientes) | sim, com período e fonte | `[NECESSITA FONTE]` |
| Case ou depoimento aprovado pelo cliente | sim, com autorização registrada | `[PENDENTE DE CONFIRMAÇÃO: autorização]` |
| Tela ou demonstração da funcionalidade | sim, para promessa funcional | `[PENDENTE: tela em _assets/]` |
| Benchmark de mercado | só como contexto, com `[BUSCADO: fonte + ano]` | nunca como prova própria |
| Opinião interna | não | vira `[HIPÓTESE]` |

### Passo 4 — Escolher os diferenciais (máximo três)

Diferencial é o que o público valoriza **e** a alternativa não entrega **e** conseguimos provar. Os três filtros juntos; falhou um, sai da lista. Para cada um: contra qual alternativa, qual a prova, o que o concorrente diria em resposta (alimenta `battlecard`).

### Passo 5 — Escrever "o que nunca afirmar"

Lista curta e explícita: promessa que o produto não sustenta, comparação sem evidência, termo proibido da marca, funcionalidade em roadmap descrita como disponível, resultado que depende do cliente fazer algo. Esta lista vai para a ficha do produto e vale para todos os canais.

### Passo 6 — Validar e gravar

Entregar inteiro no chat. Com aprovação do papel `{{papel "product-marketer"}}`, gravar na seção de posicionamento de `times/{{time.slug}}/docs/ficha-produto-<slug>.md`; o doc-raiz em `contexto/produtos/` recebe só o apontamento. Linha no `## Histórico` dos dois.

## Regras

- Um público por folha. Posicionamento "para todos" é descrição, não posicionamento.
- Nenhuma promessa sem prova ao lado; nenhuma prova sem fonte e status.
- Termos proibidos da marca que assina não entram — `contexto/brandcenter/brandcenter.md`{{#each marcas as m}}{{#if m.termos_proibidos}}; `{{m.slug}}`: {{join m.termos_proibidos ", "}}{{/if}}{{/each}}.
- Comparação nominal com concorrente só com evidência pública citada; caso contrário, comparar com a **categoria** de alternativa.
- Posicionamento não decide canal nem copy: isso é do Estrategista e do Redator do pack marketing.

## Checklist

- [ ] Problema na linguagem do público, com custo de não resolver e fonte?
- [ ] Promessa no degrau que a prova sustenta?
- [ ] Até três diferenciais, cada um com alternativa, prova e contra-argumento esperado?
- [ ] "O que nunca afirmar" escrito e gravado na ficha?
- [ ] Marcadores em tudo que não tem fonte? Validação humana registrada?

## Output esperado

| Saída | Formato |
|---|---|
| Folha de posicionamento (produto × público) | tabela: problema · promessa · provas · diferenciais · o que nunca afirmar |
| Pitch em 30 segundos | parágrafo, versão falada da folha |
| Entradas para `mensagens-por-publico` e `battlecard` | lista de dores, provas e contra-argumentos |

Destino: `times/{{time.slug}}/docs/ficha-produto-<slug>.md` (seção de posicionamento), após aprovação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
