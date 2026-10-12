---
tipo: skill
id: pesquisa-com-cliente
descricao: "Prepara o roteiro de entrevista de discovery com cliente e sintetiza as respostas em dores, frases e hipóteses com origem, sem transformar opinião em fato."
familia: ANALISAR.pesquisa-cliente
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["roteiro de entrevista com cliente", "sintetiza as entrevistas", "o que os clientes disseram sobre", "validar a dor com o cliente", "pesquisa de discovery", "perguntas para a entrevista de produto", "síntese da pesquisa com usuários"]
requires: product-marketer
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Product Marketer** (`product-marketer`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha do produto antes de passar para cá. **Volte ao Product Marketer antes de pesquisar.**

# Pesquisa com cliente — roteiro e síntese

Duas entregas: **(A) roteiro** de entrevista de discovery para um público e uma pergunta de negócio; **(B) síntese** do que foi dito, separando o que se repete do que é caso isolado, com a frase original ao lado. Pesquisa alimenta posicionamento, matriz de mensagens, ficha do produto e banco de criatividade — nunca substitui o dado da base.

## Contexto de uso

- Antes de posicionar ou lançar; quando a dor declarada no config é hipótese.
- Depois de perder negócios por motivo que ninguém entende.
- Validação de mensagem ou de funcionalidade com quem usa.

## Briefing mínimo

Produto (slug) · público (slug) · **pergunta de negócio** (o que a pesquisa decide) · hipóteses atuais (dor, promessa, objeção do config e da ficha) · quantidade e perfil de entrevistados · quem entrevista · como será registrado (gravação com consentimento, notas).

## Processo

### A. Roteiro

**Passo 1 — Fixar a pergunta de negócio.** Uma frase: "esta pesquisa decide se…". Sem decisão associada, não há pesquisa.

**Passo 2 — Listar as hipóteses a testar.** Da ficha e do config: dor, promessa, objeção, critério de escolha. Cada hipótese vira uma ou duas perguntas abertas.

**Passo 3 — Montar o roteiro (30–45 min).**

| Bloco | Tempo | Perguntas-tipo |
|---|---|---|
| Abertura e contexto | 5 | papel, rotina, o que faz na semana |
| A última vez que… | 10 | "me conta a última vez que [situação da dor]" — fatos, não opiniões |
| Como resolve hoje | 10 | ferramenta, processo, quem está envolvido, o que custa |
| Critérios e alternativas | 10 | o que faria trocar; o que já tentou; quem decide |
| Reação à promessa (opcional) | 5 | ler a promessa; "o que isso significaria para você?" — só no fim |
| Fecho | 5 | o que não perguntei; quem mais devo ouvir |

**Regras do roteiro:** perguntas abertas, sobre o passado concreto ("a última vez"), nunca sobre intenção futura ("você usaria?"); não vender; não corrigir; silêncio é ferramenta. Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não são pedidos nem registrados.

### B. Síntese

**Passo 4 — Codificar.** Uma linha por afirmação relevante: entrevistado (anonimizado: "Cliente A"), frase original, tema (dor, critério, alternativa, objeção, elogio, pedido), intensidade.

**Passo 5 — Agrupar e contar.** Temas por quantidade de entrevistados que mencionaram **espontaneamente** × quando perguntados. Tema dito por um só é caso, não padrão.

**Passo 6 — Confrontar com as hipóteses.** Para cada hipótese: confirmada · refutada · inconclusiva, com as frases que sustentam. O que surgiu sem hipótese vai para "achados".

**Passo 7 — Recomendar.** O que muda na ficha, no posicionamento, na matriz; o que vira pedido ao produto; o que precisa de mais entrevistas. Cada recomendação com as frases de origem.

**Passo 8 — Validar e gravar.** Inteiro no chat → aprovação → síntese em `times/{{time.slug}}/docs/pesquisa-<produto>-<AAAA-MM>.md`; frases aprovadas vão para "o dia do público" no banco de criatividade do pack marketing (quando instalado) e dores confirmadas para a ficha do produto.

## Regras

- Frase de cliente entra sempre com origem (entrevista, data) e anonimizada; sem consentimento, não é citada em peça.
- Opinião do entrevistado é dado sobre a percepção, não sobre o produto; não vira regra de negócio.
- Síntese sem contagem é impressão. Padrão exige repetição entre entrevistados diferentes.
- A pesquisa não substitui o dado da base: "quantos têm essa dor" é pergunta para a família CONSULTAR.

## Checklist

- [ ] Pergunta de negócio e hipóteses escritas antes do roteiro?
- [ ] Perguntas abertas sobre o passado concreto? Promessa só no fim?
- [ ] Codificação com frase original e anonimização?
- [ ] Hipóteses marcadas (confirmada, refutada, inconclusiva) com frases?
- [ ] Recomendações com destino (ficha, matriz, produto)? Aprovação registrada?

## Output esperado

| Saída | Formato |
|---|---|
| Roteiro | tabela por bloco, com tempo e perguntas |
| Síntese | doc: temas × contagem · hipóteses × veredito · achados · recomendações · frases |
| Propostas de atualização | lista: arquivo · o que muda · frase de origem |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
