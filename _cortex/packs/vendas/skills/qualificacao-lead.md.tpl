---
tipo: skill
id: qualificacao-lead
descricao: "Classifica o lead por perfil, fit e urgência a partir dos públicos e produtos do config e devolve a ficha com a decisão: avançar, nutrir ou encerrar."
familia: PLANEJAR.diagnostico-conta
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["esse lead tem fit", "ficha de qualificação do lead", "critérios de qualificação", "o lead está pronto para vendas", "qualificar antes de agendar", "perguntas de qualificação", "lead fora do perfil"]
requires: prospectador · dicionario-qualificacao
owner: {{papel "sdr"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Prospectador** (`prospectador`), que carrega o gate (`_cortex/kernel/gate.md`) e o dicionário de qualificação antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Prospectador antes de qualificar.**

# Qualificação de lead — perfil, fit e urgência

Qualificar é decidir, com critério registrado, se vale o tempo do executivo. A decisão sai de três eixos — **perfil** (a empresa ou pessoa é quem a organização quer atender?), **fit** (a dor que ela tem é a que o produto resolve?) e **urgência** (há motivo para agir agora?) — e termina numa ficha que o Executivo de Vendas lê antes da primeira reunião. Os critérios oficiais vivem em `times/{{time.slug}}/docs/dicionario-qualificacao.md`; esta skill os aplica, não os redefine.

## Contexto de uso

- Lead novo (inbound ou outbound) antes de entrar em cadência ou agendar.
- Lead que respondeu à cadência: requalificar com o que ele disse.
- Lead devolvido pelo executivo por falta de fit.
- Auditoria de amostra para checar se o critério está sendo aplicado.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Dados do lead (empresa ou pessoa, cargo ou papel, origem, campos preenchidos) | sim |
| Público provável (`publicos[]`) | sim |
| Produto ou oferta de interesse | sim |
| O que o lead já disse ou fez (formulário, resposta, material baixado) | sim |
| Sinal da conta (se houver) | não |

Sem dados mínimos do lead, a ficha sai com `[PENDENTE DE CONFIRMAÇÃO]` em cada eixo — e a decisão é "qualificar antes de agendar", nunca "agendar e ver".

## Processo

### 1. Perfil — é quem queremos atender?

Conferir contra o perfil ideal do dicionário: segmento, porte, território, papel do contato. Públicos do config e o tipo de cada um:

| Público | Tipo | Dor registrada |
|---|---|---|
{{#each publicos as pu}}| {{pu.nome}} (`{{pu.slug}}`) | {{pu.tipo}} | {{pu.dor}} |
{{/each}}

Contato do tipo `usuario` ou `influenciador` qualifica a conta, mas a decisão exige mapear o `comprador` — anotar na ficha. {{#if tem:publicos.territorio}}Território fora do padrão (`publicos[].territorio`) muda a dor e a prova: anotar antes de classificar.{{/if}}

### 2. Fit — a dor é a que resolvemos?

Cruzar o que o lead disse com a dor principal de cada produto:

| Produto | Dor que resolve | Promessa |
|---|---|---|
{{#each produtos as p}}| {{p.nome}} (`{{p.slug}}`) | {{default p.dor_principal "[PENDENTE: preencher]"}} | {{p.promessa}} |
{{/each}}

Fit **alto**: o lead descreveu a dor com as próprias palavras. **Médio**: a dor é inferida do cargo ou do material que baixou. **Baixo**: não há sinal de dor; só curiosidade ou pedido de preço sem contexto. Pergunta de fit quando não está claro: "Hoje, como vocês lidam com [dor do público]? O que acontece quando [consequência]?"

### 3. Urgência — por que agora?

Procurar gatilho: prazo declarado, evento (mudança de equipe, crescimento, contrato vencendo, problema recente), sinal público da conta, orçamento previsto. Sem gatilho, o lead pode ter fit e ainda assim ser **nutrido**, não agendado. Pergunta de urgência: "O que muda se isso continuar como está pelos próximos meses?"

### 4. Decidir

| Perfil | Fit | Urgência | Decisão |
|---|---|---|---|
| ideal | alto | com gatilho | **avançar** — agendar com o executivo |
| ideal | alto | sem gatilho | **nutrir** — cadência de contexto, data de retorno |
| ideal ou parcial | médio | qualquer | **qualificar** — uma pergunta de fit antes de agendar |
| parcial | baixo | qualquer | **nutrir** ou encerrar, conforme o dicionário |
| fora | qualquer | qualquer | **encerrar** — registrar motivo; não entra em cadência |

A pontuação numérica, se a organização usar, é a do dicionário (`§ Pontuação`); sem pontuação definida, a decisão é qualitativa pela tabela.

### 5. Preencher a ficha e registrar

Registrar decisão e motivo {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}{{#if integracao:crm}} e nos campos de qualificação da integração de CRM definida em `cortex.config.yaml`{{/if}}. Lead encerrado leva motivo da taxonomia de `analise-motivos-de-perda` — "sem retorno" não é motivo.

## Regras

- Critério vem do dicionário; esta skill não cria critério novo. Caso não previsto → `[PENDENTE: decidir critério]` e escalar ao Líder de Vendas.
- Não inferir dor a partir de nome de empresa ou cargo sem marcar como inferência.
- Pedido de preço sem contexto não é urgência.
- Lead fora do perfil não recebe "só uma tentativa".
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não entram em prompt externo.

## Checklist

- [ ] Três eixos avaliados com evidência (o que o lead disse ou fez)?
- [ ] Comprador mapeado ou anotado como pendente?
- [ ] Decisão coerente com a tabela e com o dicionário?
- [ ] Motivo registrado quando encerrado ou nutrido?
- [ ] Próxima pergunta definida quando a decisão é "qualificar"?
- [ ] Nenhuma inferência sem marcador?

## Output esperado

```
FICHA DE QUALIFICAÇÃO — [lead] — [data]
Origem: [inbound/outbound · canal · campanha, se houver]
Público: [slug] · Tipo de contato: [comprador/usuario/influenciador/parceiro]
Produto de interesse: [slug]

PERFIL: ideal / parcial / fora — evidência: [...]
FIT: alto / médio / baixo — a dor nas palavras do lead: "[...]"
URGÊNCIA: gatilho [qual] / sem gatilho — evidência: [...]
Decisores conhecidos: [...] · Pendentes: [...]

DECISÃO: avançar / nutrir / qualificar / encerrar
Motivo: [...]
Próximo passo: [reunião em … / pergunta … / retorno em … / encerrado]
Marcadores: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO]
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "sdr"}} |
