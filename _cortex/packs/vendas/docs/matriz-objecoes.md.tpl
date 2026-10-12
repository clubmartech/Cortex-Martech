---
tipo: doc
id: matriz-objecoes
descricao: "Registra, por público, cada objeção com a resposta validada, a prova que a sustenta e o estágio em que aparece — fonte única do contorno de objeções."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual a resposta registrada para essa objeção", "quais objeções cada público traz", "onde registro uma objeção nova", "qual prova sustenta a resposta à objeção", "objeções mais frequentes por produto"]
requires:
owner: {{papel "executivo"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

# Matriz de objeções — {{organizacao.nome}}

> **Este documento nasce com as objeções do config e sem respostas validadas, de propósito.** Resposta boa é a que foi testada com cliente real e tem prova registrada. Cada linha `[PENDENTE: preencher]` é preenchida pelo papel `{{papel "executivo"}}` a partir de conversas reais, com fonte da prova. Resposta sem prova entra como `[NECESSITA FONTE]` e não é usada como argumento — vira pergunta.

**Como usar:** `contorno-objecoes` aplica a linha do público e do estágio; `script-abordagem` antecipa a objeção de abertura; `proposta-comercial` responde às objeções do decisor dentro do texto. **Como atualizar:** objeção nova entra com `[PENDENTE: validar resposta]` no mesmo dia; a resposta é validada após uso real e revisada no ciclo ({{operacao.ciclo_planejamento}}) com os achados de `analise-motivos-de-perda`. Alteração passa por aprovação humana.

## Famílias e o que costuma estar por trás

| Família | O que o cliente diz | Normalmente significa | Primeira pergunta |
|---|---|---|---|
| Preço / orçamento | "está caro", "não tenho verba" | valor não ficou claro; comparação com alternativa | "caro em relação a quê?" |
| Status quo | "já tenho planilha / fornecedor / sistema" | custo de mudar; medo de perder o que funciona | "o que funciona bem hoje que você não quer perder?" |
| Timing | "não é o momento" | sem urgência; prioridade concorrente | "o que precisaria acontecer para ser o momento?" |
| Autoridade | "preciso falar com…" | decisor não mapeado | "quem mais participa? faz sentido incluir na próxima?" |
| Confiança | "nunca ouvi falar", "já tentamos algo assim" | prova insuficiente; experiência ruim | "o que deu errado da outra vez?" |
| Produto | "não faz X", "não integra com Y" | lacuna real ou desconhecimento | "qual o peso disso na decisão?" |
| Necessidade | "não vejo o problema" | fit baixo | voltar à qualificação |

## Matriz por público

{{#each publicos as pu}}### {{pu.nome}} (`{{pu.slug}}`, {{pu.tipo}})

Dor registrada: {{pu.dor}}

| Objeção (palavras do cliente) | Família | Estágio em que aparece | Resposta validada | Prova (fonte) | Pergunta de devolução | Status |
|---|---|---|---|---|---|---|
| "{{pu.objecao}}" | `[PENDENTE: classificar]` | `[PENDENTE: preencher]` | `[PENDENTE: preencher]` | `[NECESSITA FONTE]` | `[PENDENTE: preencher]` | `[PENDENTE: validar resposta]` |
| `[PENDENTE: objeção nova]` | | | | | | |

{{/each}}
## Objeções por produto

Lacunas de produto confirmadas no doc `contexto/produtos/<slug>/<slug>.md` entram aqui com a resposta honesta ("não faz; o peso disso é…") — nunca com promessa de roadmap.

| Produto | Objeção | Lacuna confirmada? | Resposta | Status |
|---|---|---|---|---|
{{#each produtos as p}}| {{p.nome}} (`{{p.slug}}`) | `[PENDENTE: preencher]` | `[PENDENTE: confirmar no doc do produto]` | `[PENDENTE: preencher]` | `[PENDENTE: validar resposta]` |
{{/each}}

## Provas autorizadas

Lista única do que pode ser usado como prova, com fonte e data de validação. Prova fora desta lista não entra em resposta.

| Prova | Tipo (dado · caso · demonstração · garantia contratual) | Fonte | Validada em | Pode citar nome do cliente? |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | | `[NECESSITA FONTE]` | | `[PENDENTE: confirmar]` |

## Banco de frases do cliente

Frases exatas colhidas em ligações, reuniões e conversas de perda, por família — insumo para scripts, proposta{{#if pack:marketing}} e copy de marketing{{/if}}.

| Família | Frase exata | Fonte (ligação · reunião · perda) | Data | Frequência |
|---|---|---|---|---|
| `[PENDENTE: preencher]` | "…" | | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "executivo"}} |
