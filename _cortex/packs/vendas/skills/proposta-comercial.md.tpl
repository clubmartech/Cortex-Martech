---
tipo: skill
id: proposta-comercial
descricao: "Estrutura a proposta a partir do diagnóstico: resumo do problema, âncora de valor, escopo, condições e próximos passos — preço vem do usuário, nunca inventado."
familia: CRIAR.proposta
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["estrutura da proposta", "escreve a proposta para o cliente", "resumo executivo da proposta", "âncora de valor da proposta", "proposta depois do diagnóstico", "apresentação da proposta", "próximos passos na proposta", "revisa a proposta antes de enviar"]
requires: executivo-vendas · matriz-objecoes
owner: {{papel "executivo"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Executivo de Vendas** (`executivo-vendas`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e o diagnóstico registrado antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Executivo antes de propor.**

# Proposta comercial — estrutura e âncora de valor

A proposta é a devolução do diagnóstico: mostra que a organização entendeu o problema, descreve o que muda, delimita o escopo e diz o que acontece depois. O preço é uma linha dentro dela — e essa linha é **informada por quem pediu**, marcada `[INFORMADO PELO CLIENTE]`. Esta skill estrutura e escreve; não calcula, não estima, não sugere valor.

## Contexto de uso

- Proposta após diagnóstico validado pelo cliente.
- Revisão de proposta antes do envio ou após objeção.
- Proposta de renovação ou expansão{{#if pack:cs}} (em conjunto com o pack de CS){{/if}}.
- Apresentação ao vivo da proposta (roteiro).

## Briefing mínimo

| Campo | Obrigatório | Nota |
|---|---|---|
| Diagnóstico registrado (dor, impacto, critérios, decisores) | sim | de `diagnostico-comercial`, validado pelo cliente |
| Produto(s), módulos e escopo | sim | só o que está no doc do produto |
| Valores, condições, prazo de validade, forma de pagamento | sim | **do usuário**; sem eles, `[PENDENTE: informar valor]` |
| Limite de desconto autorizado | sim | do usuário |
| Prova autorizada (caso, dado, referência) | não | fonte válida ou `[NECESSITA FONTE]` |
| Formato de entrega (documento, apresentação, e-mail) | sim | |
| Quem lê (decisor econômico, técnico, campeão) | sim | muda a ordem e a linguagem |

Sem diagnóstico validado, não escrever — voltar a `diagnostico-comercial`.

## Processo

1. **Reler o diagnóstico** e extrair: a dor nas palavras do cliente · o impacto declarado · os critérios de decisão na ordem dele · os decisores que vão ler.
2. **Nomear a âncora de valor** em uma frase: "[dor do cliente] custa [impacto declarado]; com [escopo], [resultado esperado em linguagem dele]". Resultado sem fonte vem com modificador ("ajuda a", "pode reduzir") — nunca número prometido.
3. **Montar a estrutura** (abaixo), na ordem que o decisor econômico lê: problema → valor → como → quanto → próximo passo.
4. **Antecipar objeções** da matriz para esse público e responder dentro do texto (seção "O que você pode estar se perguntando") ou preparar a resposta para a apresentação.
5. **Preencher valores** exatamente como o usuário informou; conferir que cada número tem origem.
6. **Revisar** com o checklist; tom de {{marca_mae.nome}} ({{join marca_mae.tom ", "}}); termos proibidos fora.
7. **Preparar a apresentação** (se ao vivo): roteiro de vinte minutos, com a proposta apresentada, não lida, e o pedido de decisão explícito ao final.
8. **Registrar** envio, versão, validade e próximo passo {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}; estágio avança conforme `estagios-pipeline`.

### Estrutura de referência

| Seção | Conteúdo | Regra |
|---|---|---|
| **Resumo executivo** | o problema nas palavras do cliente + a âncora de valor + o pedido de decisão | meia página; lido sozinho, basta |
| **O que entendemos** | contexto, dor, impacto, critérios — como registrados no diagnóstico | nada que ele não tenha dito |
| **O que propomos** | escopo por produto/módulo, ligado a cada dor | funcionalidade só se responde a dor confirmada |
| **Como acontece** | etapas, prazos, responsabilidades, o que o cliente precisa fazer | prazos só do doc do produto ou do usuário |
| **Resultados esperados** | o que muda, com modificador; prova autorizada com fonte | sem número prometido |
| **Investimento** | valores, condições, validade | `[INFORMADO PELO CLIENTE]`; sem estimativa |
| **O que você pode estar se perguntando** | respostas às objeções da matriz para esse público | prova registrada |
| **Próximos passos** | decisão esperada, data, quem assina, o que acontece após o sim | sempre com data |

Produtos disponíveis no config: {{#each produtos as p}}**{{p.nome}}** (`{{p.slug}}`, {{p.tipo}}) · {{/each}}— escopo fora dessa lista é `[PENDENTE: confirmar oferta]`.

## Regras

- **Preço, desconto, prazo e condição vêm do usuário.** Campo vazio fica `[PENDENTE: informar valor]`; nunca preenchido por analogia.
- Nenhum resultado, caso ou cliente sem fonte válida; o que não tem fonte sai ou recebe `[NECESSITA FONTE]`.
- Nenhuma funcionalidade, integração ou prazo fora do doc do produto.
- A proposta responde ao diagnóstico; seção que não responde a uma dor registrada sai.
- Proposta tem validade e próximo passo com data.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não vão para prompt externo.
- Material final vai para o registro ou pasta indicada — nunca a documentação.

## Checklist

- [ ] Diagnóstico validado pelo cliente antes de escrever?
- [ ] Âncora de valor em uma frase, na linguagem do cliente?
- [ ] Resumo executivo basta sozinho?
- [ ] Cada item do escopo responde a uma dor registrada?
- [ ] Todo número com origem; preço marcado `[INFORMADO PELO CLIENTE]`?
- [ ] Objeções do público antecipadas com prova?
- [ ] Validade, próximo passo e data presentes?
- [ ] Tom da marca; termos proibidos ausentes?

## Output esperado

```
PROPOSTA — [conta] — [produto/escopo] — v[n] — válida até [data]
Leitores: [decisores]
Âncora de valor: [uma frase]

[seções preenchidas na estrutura de referência]

ROTEIRO DE APRESENTAÇÃO (se ao vivo): abertura · problema · valor · como · investimento · pedido de decisão
NOTA DE TRANSPARÊNCIA: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

{{#if pack:marketing}}Deck ou peça visual da proposta: handoff ao agente de design do pack de marketing, com o texto pronto.{{/if}}

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "executivo"}} |
