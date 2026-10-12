---
tipo: skill
id: redator-whatsapp
descricao: "Entrega a mensagem de WhatsApp ou SMS pronta para disparo, com duas variações de abordagem e a pré-visualização otimizada."
familia: CRIAR.whatsapp
output: texto
canal: {{#if canal:whatsapp}}whatsapp{{/if}}{{#if canal:whatsapp and canal:sms}} · {{/if}}{{#if canal:sms}}sms{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["mensagem de WhatsApp", "disparo de WhatsApp", "manda uma mensagem para a base", "copy para disparo", "mensagem de SMS", "reengajar lead por WhatsApp", "confirmação por WhatsApp", "template de mensagem"]
requires: redator · redator-comum
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `redator-comum` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator — WhatsApp{{#if canal:sms}} e SMS{{/if}}

Mensagens enviadas por disparo manual ou automático para contatos engajados, com foco em ação rápida e alta taxa de resposta. Cinco formatos: convite para evento · confirmação de interesse · distribuição de material · agendamento de conversa · reengajamento de contato frio.{{#if canal:sms}} **SMS** usa as mesmas regras com um corte: até 160 caracteres, sem emoji, um link curto, nome do remetente na primeira palavra.{{/if}}

## Por que este canal funciona diferente

A mensagem **vai ser lida**. O risco não é não ser lido: é ser **bloqueado**. As plataformas monitoram bloqueio, denúncia e taxa de resposta de cada template e reduzem o limite de envio da conta inteira quando a qualidade cai. Copy irrelevante é operacionalmente perigoso — quem escreve é o primeiro filtro de qualidade da conta.

## Contexto de uso

| Formato | Objetivo |
|---|---|
| **Convite para evento** | Inscrição ou presença em webinar, demonstração coletiva ou encontro |
| **Confirmação de interesse** | Requalificar quem sinalizou interesse e não avançou |
| **Distribuição de material** | Entregar guia, case ou link de conteúdo relevante para o momento |
| **Agendamento de conversa** | Marcar conversa com especialista ou vendedor; follow-up |
| **Reengajamento** | Retomar contato parado há semanas, com novo ângulo e sem pressão |

## Briefing mínimo

Além de `redator-comum`: **produto ou tema** · **objetivo** (um dos cinco formatos) · **origem e comportamento do contato** (como chegou + o que fez: abriu e-mail, baixou material, participou de evento, comprou) · **ação esperada** · **link de destino com UTM** · variação de abordagem (pergunta × convite direto — se não souber, gerar as duas). Campo em branco → não escreva, pergunte.

## Processo

1. **Verificar contexto de marca** e, se houver produto, o doc do produto e o banco de criatividade.
2. **Confirmar o briefing.**
3. **Diagnosticar o momento do contato** — usar o dado disponível, nunca adivinhar:

| Momento | Sinal | Abordagem | Tom |
|---|---|---|---|
| **Primeiro contato pelo canal** | Nunca recebeu mensagem da marca aqui | Contextualizar de onde vem o contato | Cordial, direto, sem assumir intimidade |
| **Engajado** | Abriu e-mail, baixou material, acessou o site | Referenciar o que a pessoa fez — mostra que não é broadcast | Próximo, continuidade de conversa |
| **Quente** | Preencheu formulário, pediu demonstração, comprou recentemente | Foco total na próxima ação — não vender de novo | Objetivo, facilitador |
| **Frio** | Sem interação há semanas | Novo ângulo ou novidade — nunca repetir o argumento ignorado | Leve, sem cobrar resposta |

4. **Otimizar os primeiros 60–65 caracteres** — é a pré-visualização, o "assunto" da mensagem. A proposta ou o gancho precisa estar visível sem abrir. Fraco: "Olá, {1}, tudo certo? Queria falar sobre…" · Forte: "Olá, {1}, você ainda está avaliando [tema]?"
5. **Nomear a ação central** em uma frase. Mensagem com dois CTAs é mensagem sem CTA.
6. **Escrever** com as regras técnicas.
7. **Gerar duas variações:** pergunta (contato que ainda não demonstrou intenção clara) e convite direto (contato quente, com prazo, ou que interagiu há pouco). Indicar quando usar cada uma.
8. **Revisar** com `redator-comum` + checklist desta skill.

## Princípio central e anatomia

> **"Parece mensagem de gente, não de empresa."**

A pessoa precisa sentir que foi lembrada especificamente; a mensagem tem motivo claro para existir agora (ligado ao comportamento anterior); pede uma ação pequena.

| Elemento | Função | Regra |
|---|---|---|
| **Pré-visualização (60–65 caracteres)** | O "assunto" | Gancho ou pergunta direta; proposta visível antes de abrir |
| **Abertura** | Quebrar o padrão de automação | `Olá, {1},` com o primeiro nome — a sintaxe da variável é a da plataforma de disparo |
| **Contexto em 1 frase** | Por que esta mensagem existe agora | Referência ao comportamento anterior — nunca genérico |
| **Proposta ou convite** | O que a pessoa vai encontrar ou ganhar | Curto, concreto |
| **CTA com link** | Converter leitura em ação | Texto de ganho + link encurtado com UTM |

Nenhum elemento é opcional: sem contexto parece golpe; sem CTA desperdiça a abertura.

**Regras técnicas:** até 3 blocos de texto de no máximo 2 linhas, separados por linha em branco · 1 único CTA · UTM obrigatória · tom de colega, não de empresa · caixa alta no máximo em 1 palavra · no máximo 2 emojis, só se reforçarem o sentido · nunca "prezado(a)", "segue em anexo", "vide link", "qualquer dúvida estou à disposição" · bem abaixo do limite técnico da plataforma · só o primeiro nome.

## Estrutura por formato

| Formato | Estrutura | Atenção |
|---|---|---|
| **Convite para evento** | gancho sobre o evento na pré-visualização → nome + contexto → 1 frase do que vai aprender → data e horário → CTA "garanta sua vaga" | Escassez só se real |
| **Confirmação de interesse** | referência à ação anterior → nome + o que a pessoa fez → pergunta ou convite ligado àquilo → CTA leve (responder "sim" ou link) | **Nunca "você ainda tem interesse?"** — convida ao não. Preferir "ficou alguma dúvida sobre como aplicar?" |
| **Distribuição de material** | pré-visualização nomeia o material ou o problema → nome + por que é relevante agora → 1 frase do que vai encontrar → CTA de acesso | Nunca "segue o link". Sempre "separei porque [motivo específico]" |
| **Agendamento de conversa** | referência ao último contato → nome + o que aconteceu → 1 frase sobre o valor da conversa (não do produto) → link de agenda | Follow-up tardio precisa recontextualizar |
| **Reengajamento** | novidade ou mudança de ângulo (nunca cobrança) → nome + novo ângulo → 1 frase que justifica retomar agora → CTA de porta aberta | **No máximo 1–2 tentativas** sem resposta; depois, cadência de e-mail ou sair do fluxo |

**Exemplo de estrutura — convite, versão pergunta:**
```
Olá, {1}, você já viu [tema em forma de pergunta]?

Na próxima [dia], às [hora], [quem] mostra como [resultado concreto que o público reconhece].

[duração] práticos, foco em [o que a pessoa leva].

👉 Garanta sua vaga: [link com UTM]
```

**Exemplo de estrutura — reengajamento, porta aberta:**
```
Olá, {1}, tudo certo?

Não quero insistir, mas deixo aqui caso [tema] volte à pauta por aí.

Qualquer coisa, é só responder: [link com UTM]
```

## Qualidade da conta

Causas de queda do indicador de qualidade: mensagem irrelevante ou sem contexto · frequência alta · contato sem consentimento explícito · copy com cara de spam (caixa alta, excesso de emoji, promessa vaga). Disparo mal escrito pausa template e reduz a capacidade de envio da conta inteira.

**Horário:** evitar início de segunda, fim de sexta, fim de semana e datas de pico de atenção; preferir meio de semana, meio da manhã ou início da tarde. Calibrar com o dado dos próprios disparos — registrar em `times/{{time.slug}}/docs/benchmarks-canal.md`.

{{#if integracao:automacao-mkt}}**Plataforma:** a integração de automação de marketing do config define sintaxe da variável de nome, limite de caracteres e aprovação de template — conferir antes de entregar.{{/if}}

## Checklist

- [ ] Briefing completo, inclusive comportamento do contato e link com UTM?
- [ ] Momento do contato diagnosticado com dado real?
- [ ] Pré-visualização (primeiros 60–65 caracteres) com o gancho visível?
- [ ] `Olá, {1},` na abertura; só primeiro nome; contexto em 1 frase; 1 CTA com link?
- [ ] ≤ 3 blocos de ≤ 2 linhas; ≤ 2 emojis; caixa alta ≤ 1 palavra; nenhum termo de e-mail corporativo?
- [ ] Duas variações (pergunta e convite direto) com indicação de uso?
- [ ] Reengajamento dentro do limite de tentativas? Confirmação sem "ainda tem interesse?"?
- [ ] Nenhuma palavra da lista a evitar? Nenhum número sem fonte?

## Output esperado

```
OBJETIVO: [convite / confirmação / material / agendamento / reengajamento]
PRODUTO / TEMA:
MOMENTO DO CONTATO: [primeiro contato / engajado / quente / frio]
COMPORTAMENTO REFERENCIADO:

VARIAÇÃO A — Pergunta:
[mensagem completa]
Quando usar:

VARIAÇÃO B — Convite direto:
[mensagem completa]
Quando usar:

NOTAS DE DISPARO:
  Caracteres (A) / (B):
  Pré-visualização A (primeiros ~65 caracteres):
  Horário sugerido:
  Link com UTM:
  Risco de qualidade do template: [ponto de atenção, se houver]
```

Fechar com a **Nota de transparência** e a **revisão anti-IA** conforme a política do canal no config.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
