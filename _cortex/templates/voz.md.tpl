---
tipo: doc
id: {{item.slug}}
descricao: "Registra a voz pessoal de {{item.papel}}: como fala, do que fala, o que nunca assina."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como {{item.slug}} escreve", "post assinado por {{item.slug}}", "voz pessoal de {{item.slug}}", "texto em nome de {{item.papel}}"]
requires: brandcenter
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# Voz pessoal: {{item.papel}} (`{{item.slug}}`)

> Peça assinada por pessoa abre esta ficha **antes** da skill do canal (`ROTAS.md` §3.3). A voz pessoal convive com a marca, não a substitui: regras de marca continuam valendo (`contexto/brandcenter/brandcenter.md`). Gerado pelo `cortex init`; o time edita — de preferência com a própria pessoa.

## 1. Quem fala

- **Papel:** {{item.papel}}
- **Temas que domina e sobre os quais fala em primeira pessoa:** [PENDENTE: preencher]
- **Temas que nunca assina:** [PENDENTE: preencher]

## 2. Como fala

- **Registro:** [PENDENTE: preencher — formal/informal, frases curtas/longas, usa humor?]
- **Expressões recorrentes:** [PENDENTE: preencher — 3 a 5, na letra]
- **O que nunca diria:** [PENDENTE: preencher]

## 3. Exemplos reais

| Fonte (data) | Trecho aprovado |
|---|---|
| [PENDENTE: preencher] | [PENDENTE: preencher] |

## 4. Aprovação

- Toda peça assinada passa pela pessoa antes de publicar: [PENDENTE: preencher — como e por onde aprova].

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
