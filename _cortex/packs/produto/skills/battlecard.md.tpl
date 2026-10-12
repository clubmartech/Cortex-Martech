---
tipo: skill
id: battlecard
descricao: "Monta o battlecard de um concorrente — onde ganhamos, onde perdemos, objeção e resposta — só com fonte citada por linha; sem fonte, a linha fica marcada."
familia: DOCUMENTAR.battlecard
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o battlecard", "onde ganhamos e onde perdemos do concorrente", "o cliente citou o concorrente", "como responder quando comparam com", "objeções sobre o concorrente", "comparativo com a alternativa", "atualiza o battlecard"]
requires: product-marketer
owner: {{papel "product-marketer"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Product Marketer** (`product-marketer`), que carrega o gate (`_cortex/kernel/gate.md`) e o posicionamento do produto antes de passar para cá. **Volte ao Product Marketer antes de comparar.**

# Battlecard — concorrente ou alternativa

Uma página por concorrente (ou por categoria de alternativa: planilha, processo manual, não fazer nada) para quem está na conversa com o cliente. O battlecard é **interno**; o que vai para peça externa passa por `posicionamento-produto` e validação humana. A regra que o define: **cada linha tem fonte**; o que não tem, fica marcado até ter.

## Contexto de uso

- Concorrente citado em negociação, pesquisa ou motivo de perda.
- Página de comparação, pitch ou treinamento do time de vendas.
- Revisão periódica: battlecard envelhece a cada versão do concorrente.

## Briefing mínimo

Produto (slug) · concorrente ou alternativa · público em que a comparação acontece (slug) · **fontes disponíveis** (site e documentação pública do concorrente, proposta recebida pelo cliente com autorização, motivos de perda, entrevistas) · onde o card será usado (interno, página pública, pitch).

## Processo

### Passo 1 — Listar as fontes e classificar

| Fonte | Vale para | Marcador |
|---|---|---|
| Site, documentação, preço público do concorrente | funcionalidade, posicionamento declarado, oferta | `[BUSCADO: url + data]` |
| Proposta ou material recebido pelo cliente, com autorização | oferta real, condições | `[INFORMADO PELO CLIENTE]` |
| Motivos de perda e entrevistas | por que perdemos ou ganhamos | fonte: registro + período |
| Relato de vendedor sem documento | sinal, não prova | `[HIPÓTESE]` |

Nada entra sem uma linha desta tabela.

### Passo 2 — Perfil do concorrente (curto)

Quem é, para quem vende, como se posiciona (nas palavras dele), por quais canais aparece. Três a cinco linhas, todas com fonte.

### Passo 3 — Onde ganhamos · onde perdemos · onde empata

| Critério (o que o público valoriza) | Nós | Eles | Fonte | Veredito |
|---|---|---|---|---|
| derivado de `mensagens-por-publico` e das dores do público | o que entregamos, com prova | o que entregam, com fonte | | ganhamos · perdemos · empate |

Critérios vêm do que o **público** valoriza (dores e objeções do config, entrevistas), não da lista de funcionalidades. Onde perdemos é escrito com a mesma honestidade de onde ganhamos — battlecard que só ganha não ajuda ninguém na conversa.

### Passo 4 — Objeção → resposta

| Objeção (como o cliente diz) | O que está por trás | Resposta curta | Prova | Nunca dizer |
|---|---|---|---|---|

A resposta reconhece o ponto, redireciona para o critério em que ganhamos e termina com uma prova. Não desqualifica o concorrente; não afirma sobre ele o que não está em fonte.

### Passo 5 — Perguntas para fazer ao cliente

Três a cinco perguntas que revelam se o critério em que ganhamos importa para esse cliente. Pergunta boa expõe o custo da alternativa sem citar o concorrente.

### Passo 6 — Validar e gravar

Inteiro no chat → validação do papel `{{papel "product-marketer"}}` → gravar em `times/{{time.slug}}/docs/battlecard-<produto>-<concorrente>.md` (`tipo: doc`, `produto:` com o slug) → apontar a partir da seção de concorrência de `ficha-produto-<slug>`. Revalidar a cada ciclo ({{operacao.ciclo_planejamento}}) ou quando o concorrente lançar versão.

## Regras

- **Nenhuma afirmação sobre concorrente sem fonte citada.** Linha sem fonte recebe marcador e não sai em peça externa.
- Preço e condição comercial do concorrente só com `[INFORMADO PELO CLIENTE]` ou fonte pública; nunca estimativa.
- Dados sensíveis próprios ({{join governanca.dados_proibidos_em_prompt ", "}}) não entram no card que circula.
- Comparação pública (página, anúncio) exige validação humana e, quando houver, revisão jurídica — registrar no histórico.
- Battlecard não é posicionamento: a mensagem para o mercado continua em `posicionamento-produto`.

## Checklist

- [ ] Toda linha com fonte ou marcador? Critérios do público, não da funcionalidade?
- [ ] Onde perdemos escrito com honestidade?
- [ ] Objeções com resposta curta, prova e "nunca dizer"?
- [ ] Perguntas para o cliente? Data de revalidação?
- [ ] Validação humana registrada? Apontado a partir da ficha do produto?

## Output esperado

| Saída | Formato |
|---|---|
| Battlecard | doc: fontes · perfil · ganhamos/perdemos/empata · objeções · perguntas |
| Lacunas de fonte | tabela: afirmação · fonte que falta · quem consegue |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "product-marketer"}} |
