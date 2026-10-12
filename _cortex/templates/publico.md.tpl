---
tipo: doc
id: {{item.slug}}
descricao: "Descreve o público {{item.nome}}: perfil, dor, objeção, território, nível de consciência e canais onde está."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico: {{item.slug}}
gatilhos: ["quem é {{item.nome}}", "qual a dor de {{item.nome}}", "como falar com {{item.nome}}", "objeção de {{item.nome}}", "onde {{item.nome}} está"]
requires: brandcenter
owner: {{default sessao.papel_configurador governanca.ratificador}}
origem: gerado-inicial
validado_em: {{agora}}
---

# Público: {{item.nome}} (`{{item.slug}}`)

> Quando o **leitor** muda, muda antes do canal (`ROTAS.md` §3.4): público, ângulo, dor, prova e linguagem. Gerado pelo `cortex init`; o time edita.

## 1. Perfil

- **Tipo:** {{item.tipo}} (comprador decide · usuário usa · influenciador recomenda · parceiro revende/indica)
- **Quem é:** [PENDENTE: preencher — cargo/situação, contexto do dia a dia, o que mede o sucesso dele]
- **Ofertas para este público:** {{#each produtos as p}}{{#each p.publicos as pp}}{{#if pp == item.slug}}`{{p.slug}}` {{p.nome}} · {{/if}}{{/each}}{{/each}}

## 2. Dor

- **Dor declarada:** {{default item.dor "[PENDENTE: preencher]"}}
- **Dor por trás da dor:** [PENDENTE: preencher — o que acontece se não resolver]
- **Como ele descreve o problema com as próprias palavras:** [PENDENTE: preencher — 2 a 3 frases ouvidas]

## 3. Objeção

- **Objeção principal:** {{default item.objecao "[PENDENTE: preencher]"}}
- **Resposta aprovada:** [PENDENTE: preencher]
- **Prova que sustenta:** [PENDENTE: preencher]

## 4. Território

- **Território:** {{#if tem:item.territorio}}`{{item.territorio}}`{{else}}não definido{{/if}}
- **O que muda quando o território muda:** [PENDENTE: preencher — vocabulário, exemplos, prova]

## 5. Nível de consciência típico

- **Onde costuma entrar:** [PENDENTE: preencher — inconsciente do problema · consciente do problema · consciente da solução · consciente da oferta · pronto para decidir]
- **O que o move de um nível para o próximo:** [PENDENTE: preencher]

## 6. Canais onde está

| Canal | Como usa | Melhor formato |
|---|---|---|
{{#each canais as c}}| {{c.slug}} | [PENDENTE: preencher] | [PENDENTE: preencher] |
{{/each}}
## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex init` a partir de `cortex.config.yaml`. | cortex |
