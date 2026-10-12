---
tipo: skill
id: aviso-de-produto
descricao: "Define e redige o aviso de mudança, descontinuação ou novidade — quem avisa, quando, por qual canal e com qual prazo — a partir do material do PM."
familia: CRIAR.aviso-produto
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["aviso de mudança no produto", "comunicar a descontinuação", "aviso in-app da novidade", "precisa avisar os clientes", "prazo para migrar", "aviso aos parceiros sobre a funcionalidade", "mudança de comportamento do sistema"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da funcionalidade antes de passar para cá. **Volte ao Documentador de Produto antes de avisar.**

# Aviso de produto — mudança, descontinuação, novidade

Um aviso responde quatro perguntas na ordem: **o que muda · para quem · a partir de quando · o que a pessoa precisa fazer**. A skill decide quem avisa, quando e por qual canal, e redige o texto-base que o Redator do pack marketing adapta quando o canal pede.

## Contexto de uso

| Tipo | Sinal | Prazo mínimo de aviso |
|---|---|---|
| **Novidade** | Funcionalidade liberada; o cliente ganha algo | no dia da liberação |
| **Mudança** | Comportamento, tela, regra ou integração muda; o cliente precisa se adaptar | antes da mudança, com tempo para adaptar `[PENDENTE: prazo definido pelo time]` |
| **Descontinuação** | Algo deixa de existir; o cliente precisa migrar | antes, com alternativa e prazo; repetir perto da data |
| **Incidente** | Não é desta skill — comunicado de incidente é do pack de atendimento, quando instalado |

## Briefing mínimo

Produto (slug) · tipo do aviso · **material do PM** (o que muda, desde quando, para quem, pré-requisito, alternativa) · estágio de liberação (piloto, parcial, geral) · públicos afetados · se há artigo ou ficha para apontar.

## Processo

### Passo 1 — Decidir quem avisa, quando e onde

| Estágio ou público | Quem produz | Canal | Momento |
|---|---|---|---|
| Piloto ou parceiro{{#if publico:parceiro}} (há parceiro no config){{/if}} | PM, com apoio desta skill | canal de parceiro ou e-mail direto | antes do mercado |
| Mercado, dentro do produto | Documentador de Produto + PM | aviso in-app | na liberação |
| Base de clientes | Redator (pack marketing), com este texto como fonte | {{#if canal:email}}e-mail{{/if}}{{#if canal:comunidade}} · comunidade{{/if}}{{#if canal:whatsapp}} · mensagem{{/if}}{{#if canal:email}}{{else}}{{#if canal:comunidade}}{{else}}{{#if canal:whatsapp}}{{else}}`[PENDENTE: canal da base não configurado]`{{/if}}{{/if}}{{/if}} | conforme o tipo |
| Equipe interna (vendas, atendimento) | Documentador de Produto | canal interno | **antes** de qualquer cliente |

### Passo 2 — Escrever na estrutura

1. **Título com o benefício ou a mudança**, não o nome técnico ("Agora o fechamento sai sem…", não "Novo parâmetro X").
2. **Cenário** em uma ou duas frases: quando isso aparece na rotina de quem usa.
3. **O que muda**: o comportamento novo, em linguagem de uso. Caminho de menu em itálico quando o material traz.
4. **A partir de quando**: data só com `[VALIDADO]` do PM; senão, "nas próximas semanas" com `[PENDENTE DE CONFIRMAÇÃO]`.
5. **O que fazer**: pré-requisito, configuração, migração — ou "nada" quando for o caso. Em descontinuação, a alternativa e o prazo.
6. **Saiba mais**: link para o artigo da central de ajuda ou ficha; sem link, `[PENDENTE: artigo]`.

### Passo 3 — Regras de escrita

- Começar pelo cenário, nunca pela descrição técnica.
- Uma mudança por aviso; duas mudanças, dois avisos.
- Liberação gradual: dizer para quem já está disponível só se o material informar o critério.
- Nada de "melhorias e correções diversas": se não dá para dizer o que mudou, não há aviso.

### Passo 4 — Validar, publicar, registrar

Inteiro no chat → validação do papel `{{papel "pm"}}` → publicação → linha em `times/{{time.slug}}/docs/indice-publicacoes.md`. Descontinuação: agendar o lembrete perto da data e registrar.

## Regras

- Tudo vem do material do PM; o que falta é perguntado, não deduzido.
- Termos proibidos da marca não entram — `contexto/brandcenter/brandcenter.md`{{#each marcas as m}}{{#if m.termos_proibidos}}; `{{m.slug}}`: {{join m.termos_proibidos ", "}}{{/if}}{{/each}}.
- Descontinuação sem alternativa e prazo não é publicada.
- Equipe interna avisada antes do cliente, sempre.

## Checklist

- [ ] Tipo do aviso e prazo mínimo respeitados? Equipe interna avisada antes?
- [ ] Título com benefício ou mudança? Cenário antes da técnica?
- [ ] Data só com validação? O que fazer está explícito?
- [ ] Link de "Saiba mais" ou marcador? Validação humana? Índice atualizado?

## Output esperado

| Saída | Formato |
|---|---|
| Plano do aviso | tabela: público · quem · canal · momento |
| Texto-base do aviso | título · cenário · o que muda · quando · o que fazer · saiba mais |
| Linha para `indice-publicacoes` | data · produto · canal · título · link |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
