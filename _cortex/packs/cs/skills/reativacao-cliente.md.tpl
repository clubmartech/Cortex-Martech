---
tipo: skill
id: reativacao-cliente
descricao: "Monta a régua de reativação de clientes inativos: segmentos por tempo e motivo, sequência por canal, valor antes de oferta, critérios de reativação e descarte."
familia: CRIAR.reativacao
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["cliente inativo", "régua de reativação de clientes", "cliente parou de comprar", "trazer o cliente de volta", "oferta de reativação", "clientes sem uso há meses", "base de clientes inativos", "reconquistar cliente"]
requires: gestor-sucesso · matriz-risco-churn
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a matriz de risco antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de montar a régua.**

# Reativação de cliente — inativos, régua e oferta

Cliente inativo é quem **já comprou e parou** — de usar, de comprar ou de responder. Reativar é mais barato do que adquirir, mas só funciona com valor antes de oferta: quem sumiu não quer promoção, quer motivo. A régua segmenta por tempo e motivo provável, define canal e sequência, e tem critério claro de reativação e de descarte. Oferta e condição, quando entram, vêm do usuário.

{{#if modelo_comercial:B2C}}Em modelo B2C, "inativo" costuma ser quem não comprou dentro do intervalo típico de recompra do produto; a régua trabalha com a base e os canais de relacionamento.{{else}}Em modelo {{organizacao.modelo_comercial}}, "inativo" costuma ser conta com uso baixo ou nulo, sem resposta ao Gestor, ou contrato encerrado recentemente; a régua trabalha conta a conta antes de qualquer disparo.{{/if}}

## Contexto de uso

- Carteira ou base com clientes sem uso ou sem compra além do intervalo definido.
- Ex-clientes recentes com motivo de saída tratável.
- Antes de limpar a base de comunicação.
- Revisão de régua com taxa de reativação baixa.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Base com data do último uso, compra ou contato, por produto | sim |
| Definição de "inativo" por produto (intervalo) | sim — do time, `[PENDENTE: definir]` se não existir |
| Motivo de inatividade quando conhecido (matriz de risco, cancelamento) | não |
| Canais liberados e consentimento por canal | sim |
| Oferta ou condição autorizada (se houver) | não — do usuário, `[INFORMADO PELO CLIENTE]` |
| Capacidade do time para contato individual | sim |

**Fonte:** {{#if integracao:dados}}integração de dados definida em `cortex.config.yaml` para uso e compra{{else}}export fornecido pelo usuário{{/if}}{{#if integracao:crm}}; CRM para contrato e contatos{{/if}}{{#if integracao:automacao-mkt}}; integração de automação de marketing para envio e medição em escala{{/if}}.

## Processo

### 1. Segmentar

| Segmento | Critério (convenção do time) | Abordagem |
|---|---|---|
| **Esfriando** | pouco além do intervalo de inatividade | um toque de valor; contato individual se conta relevante |
| **Inativo** | além do intervalo, sem gatilho de risco grave | régua completa (abaixo) |
| **Muito inativo** | muito além do intervalo | sequência curta de última chance |
| **Ex-cliente recente** | contrato encerrado dentro de `[PENDENTE: janela]` com motivo tratável | contato individual do Gestor; sem régua automática |
| **Não reativar** | pediu para não ser contatado · motivo de saída não tratável · rejeição de canal | fora de qualquer régua; registrar |

Intervalos são do time (`[PENDENTE: definir]`), calibrados com o comportamento real da base — nunca de benchmark externo.

### 2. Entender o motivo antes de escrever

Cruzar com `matriz-risco-churn`, tickets, pesquisa e escuta: parou por falta de valor percebido · por mudança no cliente · por problema não resolvido · por preço · por esquecimento. Motivo diferente, mensagem diferente. Sem motivo conhecido, o primeiro toque pergunta.

### 3. Régua para o segmento "Inativo" (adaptar)

| Toque | Intervalo | Canal | Conteúdo | Regra |
|---|---|---|---|---|
| 1 | D+0 | canal de maior resposta histórica | **valor**: novidade do produto que responde à dor dele, dado útil, guia — sem oferta, sem citar a inatividade | CTA de baixo compromisso |
| 2 | poucos dias depois | mesmo canal | **pergunta direta**: "ainda faz sentido [objetivo que ele tinha]?" — três linhas | resposta binária fácil |
| 3 | dias depois, só se não respondeu | segundo canal com consentimento | mesma pergunta, curta | nunca no mesmo dia de outro toque |
| 4 | fim da régua | escrito | **última chance** honesta: "se não ouvir de você, paro por aqui" + caminho de volta | saída limpa |

Oferta ou condição, se autorizada, entra no toque 2 ou 3 — nunca no primeiro. {{#if canal:whatsapp}}`whatsapp` só com consentimento ativo; {{/if}}{{#if canal:email}}`email` com assunto sobre a dor, não sobre "sentimos sua falta"; {{/if}}contato individual (ligação ou reunião) para contas relevantes, pelo Gestor.

### 4. Critério de reativação e de descarte

Reativado quando: usou o produto · comprou · respondeu com interesse · agendou conversa. Vai para `onboarding-cliente` (reonboarding curto) ou `plano-de-sucesso`. Não reativado ao fim da régua: sai dos disparos regulares, fica em lista de observação, com motivo; pedido explícito de saída é cumprido na hora.

### 5. Medir

Por segmento e canal: entregues, respostas, reativados, pedidos de saída, custo de contato ÷ reativados. Régua com resposta zero após volume mínimo é reescrita, não repetida.

## Regras

- Valor antes de oferta; oferta nunca no primeiro toque; condição só autorizada pelo usuário.
- Só canais do config, só com consentimento; nunca dois toques no mesmo dia.
- Quem pediu para sair, sai de tudo imediatamente.
- Ex-cliente recente recebe contato humano, não régua automática.
- Mensagem não cita a inatividade de forma constrangedora; cita a dor e o objetivo dele.
- Tom de {{marca_mae.nome}}; termos proibidos ({{join marca_mae.termos_proibidos ", "}}) fora.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Inativo definido por produto; segmentos com volume?
- [ ] Motivo provável por segmento; mensagem coerente com ele?
- [ ] Primeiro toque com valor, sem oferta?
- [ ] Canais do config, consentimento confirmado, sem sobreposição no mesmo dia?
- [ ] Critério de reativação e de descarte definidos; destino pós-reativação?
- [ ] "Não reativar" respeitado?
- [ ] Métricas por segmento e canal previstas?

## Output esperado

```
REATIVAÇÃO — [produto/base] — [segmento] — [volume]
Definição de inativo: [...] · Motivo provável: [...]
| Toque | Intervalo | Canal | Conteúdo | CTA | Se não responder |
|---|---|---|---|---|---|
MENSAGENS: [uma por toque, no tom da marca]
CONTATO INDIVIDUAL: [contas relevantes → Gestor, roteiro curto]
CRITÉRIOS: reativado = [...] · descarte = [...]
MÉTRICAS: [...]
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO]
```

{{#if pack:marketing}}Mensagens para canal com `revisao_anti_ia: obrigatoria` passam pela redação e pelo revisor do pack de marketing.{{/if}} Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou a ferramenta de envio — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
