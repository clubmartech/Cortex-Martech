---
tipo: skill
id: script-abordagem
descricao: "Escreve o script de ligação e a mensagem de abordagem por público: abertura, gancho de dor, pergunta de qualificação e pedido de próximo passo."
familia: CRIAR.script-vendas
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["script de ligação", "roteiro da cold call", "mensagem de abordagem para o decisor", "como abro a ligação", "script por público", "o que falar nos primeiros segundos", "abordagem por mensagem", "script de agendamento"]
requires: prospectador · matriz-objecoes
owner: {{papel "sdr"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Prospectador** (`prospectador`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a matriz de objeções antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Prospectador antes de escrever.**

# Script de abordagem — ligação e mensagem por público

Um script não é texto para ler: é uma **estrutura de conversa** com o que dizer em cada momento e o que fazer com cada resposta. Dois formatos: **ligação** (abertura, gancho, pergunta, próximo passo, saídas) e **mensagem** (um canal escrito do config, curta, com uma pergunta). Sempre por público — o que funciona com quem compra não funciona com quem usa.

## Contexto de uso

- Primeiro contato de uma cadência (`cadencia-prospeccao` define o passo; esta skill escreve o que se diz).
- Ligação de qualificação ou de agendamento.
- Mensagem de abordagem a um decisor mapeado em `diagnostico-comercial`.
- Reescrita de script com baixa taxa de conversa.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Formato (ligação · mensagem) e canal (se mensagem, slug do config) | sim |
| Público (`publicos[]`) | sim |
| Produto ou oferta | sim |
| Objetivo da conversa (qualificar · agendar · reativar) | sim |
| Passo da cadência em que o script entra | sim |
| Gancho disponível (sinal da conta, material baixado, indicação) | não |
| Prova autorizada (do doc do produto) | não |

Sem público e objetivo, não escrever.

## Processo

1. **Abrir o doc do produto** e o público do config. Ganchos por público:
{{#each publicos as pu}}   - **{{pu.nome}}** — dor: {{pu.dor}} · objeção provável: {{pu.objecao}}
{{/each}}2. **Escolher o gancho** (um só): sinal da conta convertido em pergunta · dor do público em forma de cenário · referência ao que o lead fez (material, evento) · indicação nomeada (com autorização).
3. **Montar a estrutura** do formato (abaixo).
4. **Prever as saídas**: para cada resposta provável, o que o script faz — inclusive a objeção de abertura da matriz.
5. **Revisar** com o checklist e o brandcenter de {{marca_mae.nome}} (tom: {{join marca_mae.tom ", "}}).

### Estrutura — ligação

| Momento | O que fazer | Regra |
|---|---|---|
| **Abertura** | nome, organização, motivo em uma frase, pedido de permissão ("tem um minuto?") | sem "como vai?", sem pitch; se não tem o minuto, pedir horário |
| **Gancho** | o cenário da dor na rotina do público | sem nome do produto; sem citar a fonte do sinal |
| **Pergunta de qualificação** | aberta, sobre como lidam hoje com a dor | ouvir; anotar as palavras do lead |
| **Escuta e espelho** | repetir a dor nas palavras dele e ligar à consequência | nenhuma funcionalidade ainda |
| **Próximo passo** | propor a reunião com objetivo claro ("mostrar como [público parecido] resolveu [dor]") | duas opções de horário; confirmar canal do convite |
| **Saídas** | objeção de abertura → resposta curta da matriz + pergunta · "manda por e-mail" → pergunta antes de aceitar · "não é comigo" → pedir o nome certo · "não tenho interesse" → agradecer, perguntar o motivo uma vez, encerrar | registrar a saída |

Duração-alvo da abertura até a pergunta: curta o bastante para caber numa respiração do lead. Script escrito em frases faladas, não em texto de e-mail.

### Estrutura — mensagem

```
[Saudação com o primeiro nome]
[Gancho: cenário ou pergunta sobre a dor — uma frase]
[Contexto: por que estou falando com você — uma frase, sem produto]
[Pergunta única que pede resposta curta]
[Assinatura conforme o canal]
```

Regras por canal: {{#if canal:whatsapp}}`whatsapp` — até quatro linhas, uma pergunta, sem link no primeiro contato, só com consentimento; {{/if}}{{#if canal:linkedin}}`linkedin` — nota de conexão curta com motivo genuíno; mensagem de dor só depois da aceitação; {{/if}}{{#if canal:email}}`email` — assunto como pergunta sobre o processo, sem nome de produto, três parágrafos curtos; {{/if}}{{#if canal:sms}}`sms` — uma frase, uma pergunta, remetente identificado; {{/if}}canal sem regra própria — aplicar a estrutura acima e declarar isso na entrega.

## Regras

- Produto não aparece antes da pergunta de qualificação.
- Nenhum número, caso ou cliente sem fonte válida; sem fonte, trocar por pergunta.
- Sinal público vira pergunta consultiva; a fonte não é citada.
- Termos proibidos da marca ({{join marca_mae.termos_proibidos ", "}}) fora; sem superlativo; sem urgência artificial.
- Script tem saídas; script sem saída para "não" está incompleto.
- Variável dinâmica só com campo existente na lista e fallback definido.

## Checklist

- [ ] Um gancho, um público, um objetivo?
- [ ] Abertura com motivo e permissão? Sem pitch?
- [ ] Pergunta de qualificação aberta e anotável?
- [ ] Saídas previstas, inclusive a objeção da matriz?
- [ ] Próximo passo com objetivo e duas opções?
- [ ] Mensagem dentro do limite do canal? Consentimento confirmado?
- [ ] Nenhuma afirmação sem fonte? Tom da marca?

## Output esperado

```
SCRIPT — [ligação/mensagem · canal] — [público] — [produto] — passo [n] da cadência
Objetivo: [...]
Gancho: [...]

[estrutura preenchida, em frases faladas ou na forma da mensagem]

SAÍDAS:
- "[resposta provável]" → [o que dizer/fazer]
- objeção "[da matriz]" → [resposta curta + pergunta]

Variáveis: campo → fonte → fallback
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

{{#if pack:marketing}}Mensagem que vai para canal com `revisao_anti_ia: obrigatoria` no config passa pelo revisor antes de entregar.{{/if}} Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou a ferramenta de cadência — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "sdr"}} |
