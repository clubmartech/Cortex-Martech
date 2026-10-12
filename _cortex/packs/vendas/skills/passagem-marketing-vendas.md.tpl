---
tipo: skill
id: passagem-marketing-vendas
descricao: "Formaliza o acordo de passagem de lead entre marketing e vendas: critérios de MQL e SQL, SLA, campos mínimos, devolução com motivo e rito de revisão."
familia: OPERAR.passagem-mkt-vendas
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["SLA de atendimento do lead", "critério de MQL", "critério de SQL", "devolver lead para o marketing", "passagem de lead", "o lead veio sem contexto", "reunião de alinhamento marketing e vendas", "lead qualificado pelo marketing"]
requires: lider-vendas · dicionario-qualificacao
owner: {{papel "lider-vendas"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Líder de Vendas** (`lider-vendas`), que carrega o gate (`_cortex/kernel/gate.md`) e o dicionário de qualificação antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Líder antes de redigir o acordo.**

# Passagem marketing → vendas — SLA, critérios e devolução

O acordo de passagem responde a quatro perguntas: **o que** é um lead pronto para vendas (MQL, nos termos do dicionário) · **em quanto tempo** vendas atende · **com que informação** o lead chega · **o que acontece** quando o lead não serve (devolução com motivo) ou quando vendas não atende (escalonamento). O acordo é documento ratificado, não conversa de corredor.

{{#if time:marketing}}O time de marketing existe no config: o acordo é firmado entre os dois times e ratificado por `governanca.ratificador`.{{else}}Não há time de marketing no config: o acordo é com quem gera as listas ou campanhas, com os mesmos critérios.{{/if}}

## Contexto de uso

- Primeiro acordo entre os times, ou revisão no ciclo ({{operacao.ciclo_planejamento}}).
- Reclamação recorrente ("lead ruim" de um lado, "ninguém atende" do outro).
- Nova campanha que vai gerar lead para vendas.
- Leitura de perdas por **Contato** ou **Perfil** apontando para a passagem.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Critérios atuais de MQL e SQL (ou a confirmação de que não existem) | sim |
| Origens de lead ativas (campanhas, formulários, listas) | sim |
| Tempo atual até o primeiro contato (medido ou estimado, com marcador) | sim |
| Volume de leads por origem no último ciclo | sim |
| Taxa de aceitação e devolução (se registradas) | não |
| Participantes do acordo (papéis) | sim |

**Fonte:** {{#if integracao:crm}}integração de CRM definida em `cortex.config.yaml`{{#if integracao:automacao-mkt}} e integração de automação de marketing (o que o lead recebeu antes){{/if}}, read-only{{else}}sem CRM integrado no config, dados vêm do usuário, `[INFORMADO PELO CLIENTE]`{{/if}}.

## Processo

### 1. Definições (do dicionário; aqui só se amarram)

| Termo | Definição (de `dicionario-qualificacao`) | Quem decide |
|---|---|---|
| Lead | contato identificado com consentimento | marketing / origem |
| MQL | lead que cumpre o critério de perfil + sinal de interesse definido no dicionário | marketing / origem |
| SQL | MQL que, após contato, cumpre fit e urgência (`qualificacao-lead`) | vendas (prospectador) |
| Oportunidade | SQL com reunião de diagnóstico realizada | vendas (executivo) |

Critério de MQL **não** é "preencheu o formulário". Perfil + sinal, ambos registrados.

### 2. SLA

| Item | Regra | Valor |
|---|---|---|
| Tempo até o primeiro contato | contado da entrada como MQL | `[PENDENTE: definir, em horas úteis]` |
| Número mínimo de tentativas antes de encerrar por contato | conforme `cadencia-prospeccao` (inbound) | `[PENDENTE: definir]` |
| Prazo para aceitar ou devolver o lead | | `[PENDENTE: definir]` |
| Escalonamento | lead sem contato dentro do SLA vai ao Líder de Vendas | automático quando houver integração |

Valores são decisão do time, não desta skill. Velocidade de contato costuma ser o maior fator na conversão de lead inbound — medir antes de qualquer outra hipótese.

### 3. Campos mínimos na passagem

Origem e campanha · o que o lead viu ou baixou · produto de interesse · público provável · campos do formulário · consentimento por canal · data e hora de entrada. Lead sem os campos mínimos é **lead sem contexto**: vendas aceita, mas registra a lacuna — a lacuna alimenta a revisão do acordo.

### 4. Devolução com motivo

Vendas devolve com um motivo da taxonomia (família **Perfil**, **Necessidade** ou **Contato** de `analise-motivos-de-perda`) e evidência. Marketing responde em prazo definido: aceita (ajusta critério ou origem) ou contesta (com dado). Devolução sem motivo não é aceita; devolução por "não respondeu" dentro do SLA de tentativas também não.

### 5. Rito de revisão

Reunião periódica ({{operacao.ciclo_planejamento}} ou mais curta): volume por origem · taxa de aceitação · tempo até o contato · conversão MQL → SQL → oportunidade por origem · devoluções por motivo · lacunas de contexto. Saída: ajustes no dicionário, nas origens, nas cadências — com dono e data. {{#if pack:marketing}}Insumo para o analista e o estrategista do pack de marketing: qualidade por origem e campanha.{{/if}}

### 6. Ficha de contexto de campanha (antes de cada campanha)

Uma página para quem vai atender: oferta · público · o que o lead recebeu · o que foi prometido · CTA que ele clicou · objeções esperadas (`matriz-objecoes`) · script sugerido (`script-abordagem`). Campanha sem ficha gera lead sem contexto.

## Regras

- Critérios vivem no dicionário; o acordo referencia, não duplica.
- SLA e prazos são decisão ratificada, registrados com data.
- Devolução sempre com motivo da taxonomia e evidência.
- Mesma linguagem na campanha e na abordagem: o que o anúncio promete, o prospectador propõe.
- Dados do lead seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Definições amarradas ao dicionário? Critério de MQL com perfil + sinal?
- [ ] SLA com valores definidos (ou `[PENDENTE]` explícito) e escalonamento?
- [ ] Campos mínimos listados; lacuna registrada quando faltam?
- [ ] Devolução com motivo e prazo de resposta?
- [ ] Rito de revisão com métricas, periodicidade e participantes?
- [ ] Ficha de campanha prevista?
- [ ] Ratificador identificado?

## Output esperado

| Saída | Formato |
|---|---|
| Acordo de passagem | documento com definições, SLA, campos, devolução, rito — para ratificação |
| Ficha de contexto de campanha | modelo de uma página |
| Relatório da revisão | tabela por origem com métricas e ajustes |
| Proposta de alteração do dicionário | quando o acordo muda critério |

Destino: o acordo ratificado vira doc na pasta `docs/` do time (aprovação humana); relatórios vão para o registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "lider-vendas"}} |
