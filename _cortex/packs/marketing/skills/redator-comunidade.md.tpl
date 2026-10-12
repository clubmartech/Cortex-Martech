---
tipo: skill
id: redator-comunidade
descricao: "Entrega post, divulgação de evento ou novidade de produto para a comunidade de clientes, com direcional de imagem e thank you page."
familia: CRIAR.social-comunidade
output: texto
canal: comunidade
ferramenta:
produto: todos
publico:
gatilhos: ["post para a comunidade", "divulgar evento na comunidade", "convite para a comunidade", "thank you page do evento da comunidade", "novidade de produto na comunidade", "capa do evento da comunidade", "pergunta para o grupo de clientes"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — Comunidade (post · evento · novidade de produto)

Publicações na comunidade de clientes e profissionais mantida por {{marca_mae.nome}}: espaço de conversa, não de venda. Três formatos: **Post** (reflexão e troca), **Evento** (divulgação de webinar, live ou encontro, com copy de capa e de thank you page) e **Novidade de produto** (entrega lançada, assinada por quem é dono do produto).

## Contexto de uso

| Formato | Objetivo | Quando usar |
|---|---|---|
| **Post** | Conversa qualificada entre membros: reflexão, troca de experiência, debate sobre um problema do setor | Dado de mercado, provocação, pergunta ao grupo |
| **Evento** | Inscrições qualificadas e posicionamento da marca como promotora de debate | Webinar, live ou encontro da comunidade |
| **Novidade de produto** | Transformar uma entrega de produto em conversa entre clientes: contexto do problema, o que mudou, valor no dia a dia, convite à troca | Um post **por lançamento** cuja entrega impacta a operação do cliente |

## Briefing mínimo

**Perguntar o formato sempre, antes de qualquer coisa** — mesmo que o briefing já traga tema e dado.

| Campo | Post | Evento | Novidade de produto |
|---|---|---|---|
| Tema ou dado central | sim | sim | — |
| Ângulo ou provocação | sim | — | — |
| CTA desejado | sim (participar, comentar, inscrever) | sim (inscrição) | — (sempre convite à troca) |
| Data, horário e modalidade | — | sim | — |
| Convidado (nome, cargo, vínculo) | — | sim | — |
| Temas que serão debatidos | — | sim | — |
| Perfil indicado | — | sim | — |
| Link de inscrição | — | sim | — |
| Material do dono do produto (descrição da entrega, prints) | — | — | sim |
| **Quem assina** (decidido por quem opera, nunca pela IA) | — | — | sim |
{{#if tem:vozes}}| Doc de voz de quem assina (`contexto/vozes/`) | — | — | sim |
{{/if}}

Evento sem data, convidado ou link: **não escreva** — pergunte.

## Processo

1. **Perguntar o formato.**
2. **Confirmar o briefing** do formato.
3. **Escrever** seguindo as especificações do formato (abaixo); contar caracteres de cada elemento.
4. **Entregar o direcional de imagem** junto do texto (dimensão + conteúdo) — a comunidade publica texto + imagem.
5. **Revisar** com `redator-comum` + checklist desta skill.
6. Novidade de produto: **revisão anti-IA obrigatória** antes de entregar (assina em nome de pessoa).

## Especificações por formato

### Post

- Título claro com provocação, pergunta ou dado · introdução curta · parágrafos breves e escaneáveis · problema contextualizado com exemplo real do setor · dado ou consequência prática (custo, prazo, pessoas) · linguagem próxima e convidativa · CTA claro.
- **Limites:** 1.000 a 1.800 caracteres · parágrafos de até 3 linhas · lista de destaques com 3 a 5 bullets.
- **Imagem:** formato de post da plataforma; visual forte e legível no mobile; identidade da marca; sem excesso de informação.

### Evento

- **Título:** indica formato e tema; orientado a benefício ou provocação; até 90 caracteres.
- **Sobre o evento:** contexto do problema → conexão com a realidade do público → impacto prático → convidado e enfoque. 800 a 1.200 caracteres; linguagem técnica, acessível e consultiva; foco em valor, não só divulgação.
- **Temas que serão debatidos:** até 5 bullets objetivos, ligando prática e impacto.
- **Indicado para:** 3 a 5 bullets com cargos, áreas ou responsabilidades.
- **Data e formato:** data completa, horário, modalidade.
- **Convidado:** nome, cargo ou especialidade, vínculo com a comunidade.
- **Thank you page:** mensagem curta e acolhedora; reforça data e horário; informa que o acesso vai por e-mail.
- **Imagem (capa):** formato de capa de evento da plataforma; tipo do evento ("webinar ao vivo"), título, data e horário, CTA curto; fundo neutro.

### Novidade de produto

> **Regra central:** comunicação por comunicação não serve. Todo post precisa gerar debate, validação ou aprendizado entre clientes. Post que só lista funcionalidade não sai.

- **De onde vem o conteúdo:** só do material do dono do produto. Não descrever funcionalidade, caminho de menu, regra ou data que não esteja ali — faltou dado, perguntar e aguardar.
- **Quem assina — a IA não escolhe.** Perguntar a quem enviou o briefing. {{#if tem:vozes}}Se a pessoa tem doc de voz, escrever com ele; sem doc de voz, não escrever — perguntar quem assina no lugar ou se o post não sai.{{else}}Sem material de voz da pessoa que assina, não imitar: pedir ao menos um texto dela como referência ou escrever em nome da marca, com aval de quem pediu.{{/if}} Tema com mais de um dono: não escolher — perguntar.
- **Ordem do texto:** (1) contexto do problema em situação concreta do cliente; (2) o que mudou — uma frase sem adjetivo, nome da funcionalidade idêntico ao da interface, onde entra no fluxo, pré-requisito se houver; (3) valor no dia a dia — sem comparativo nem promessa de resultado; (4) onde aprender mais — link do artigo de ajuda se publicado, senão dizer que vem em seguida (nunca inventar link); (5) convite à troca — pergunta, enquete ou provocação que quem assina queira ouvir de volta.
- **Limites:** 800 a 1.400 caracteres · parágrafos de até 3 linhas · 3 a 5 bullets.
- **Imagem:** não leva arte. Se usar print, só o que veio no material — nunca tela recriada — com legenda dizendo o que mostra.

## Regras — todos os formatos

**Sempre:** confirmar o formato antes de escrever · contar caracteres · entregar o direcional de imagem · CTA específico.

**Nunca:** ultrapassar os limites · escrever evento sem data, convidado e link · jargão sem explicação (público diverso) · tratar post como peça de venda · escrever novidade sobre funcionalidade fora do material · anunciar data não confirmada · tratar novidade como lançamento comercial · escolher sozinho quem assina · fechar novidade sem pergunta.

## Checklist

- [ ] Formato confirmado com quem pediu? Briefing do formato completo?
- [ ] Caracteres contados dentro do limite? Parágrafos ≤ 3 linhas?
- [ ] Post: termina em CTA de conversa, não de venda?
- [ ] Evento: data, horário, modalidade, convidado e link presentes? Thank you page escrita?
- [ ] Novidade: só conteúdo do material; nome da funcionalidade igual à interface; quem assina confirmado; fecha em pergunta; passou pela revisão anti-IA?
- [ ] Direcional de imagem entregue? Nenhuma palavra da lista a evitar?

## Output esperado

```
FORMATO: [Post / Evento / Novidade de produto]
ASSINA: [só novidade — nome e papel, como decidido por quem pediu]

TEXTO ([N] caracteres):
[copy completo]

DIRECIONAL DE IMAGEM (post e evento):
  Dimensão: [formato da plataforma]
  Conteúdo recomendado: [lista]

THANK YOU PAGE (só evento):
[mensagem pós-inscrição]

NOTAS:
  Link de inscrição / artigo de ajuda: [URL ou "ainda não publicado"]
  Prints (só novidade): [legenda de cada um, ou "sem imagem"]
  Pendências do briefing:
```

Fechar com a **Nota de transparência** e a **revisão anti-IA** (política do canal `comunidade` no config; obrigatória em novidade de produto).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
