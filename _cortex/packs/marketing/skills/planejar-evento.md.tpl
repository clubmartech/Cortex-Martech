---
tipo: skill
id: planejar-evento
descricao: "Orquestra o evento, webinar ou live de ponta a ponta — da definição ao follow-up e ao reaproveitamento — acionando a skill de cada etapa."
familia: PLANEJAR.evento
output: plano
canal: {{#if canal:eventos}}eventos{{/if}}
ferramenta:
produto: todos
publico:
gatilhos: ["planejar um webinar", "vamos fazer uma live", "estratégia do evento", "o que precisa para o evento ir ao ar", "régua de lembretes do evento", "follow-up pós-evento", "plano do evento presencial", "reaproveitar a gravação"]
requires: estrategista
owner: {{papel "estrategista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Estrategista** (`estrategista`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e as faixas de referência antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Estrategista antes de planejar.**

# Planejar evento, webinar e live

Skill de **regência**: conduz o ciclo completo de um evento — online ou presencial — da definição estratégica ao reaproveitamento do conteúdo, com follow-up comercial estruturado e análise. Não reescreve copy nem refaz análise: invoca a skill de cada fatia e garante que o evento seja operado como processo, não como peças soltas.

| Fatia | Skill |
|---|---|
| Briefing | `planejar-campanha` (modelo `briefings/_modelo.md`) |
{{#if canal:email}}| E-mail (convite, confirmação, lembrete, gravação) | `redator-email` (`tipo_email: evento`) |
{{/if}}{{#if canal:landing-page}}| Página de inscrição | `redator-lp` (`tipo_lp: evento`) |
{{/if}}{{#if canal:midia-paga}}| Divulgação paga | `redator-midia-paga` |
{{/if}}{{#if canal:whatsapp}}| Convite e lembrete por mensagem | `redator-whatsapp` |
{{/if}}{{#if canal:instagram}}| Divulgação orgânica em social | `redator-instagram` |
{{/if}}{{#if canal:linkedin}}| Divulgação no LinkedIn | `redator-linkedin` |
{{/if}}{{#if canal:comunidade}}| Divulgação na comunidade | `redator-comunidade` |
{{/if}}| Peças de divulgação | `designer-pecas` |
| Roteiro da transmissão | `roteiro-video` (estrutura de blocos e falas por extenso) |
| Análise pós-evento | `analisar-performance` (recorte de evento) |

> Se está escrevendo copy de e-mail ou calculando custo por lead aqui dentro, parou de orquestrar. Chame a skill-fonte.

## Contexto de uso

- Planejamento de um novo webinar, live, transmissão{{#if canal:eventos}} ou evento presencial{{/if}}.
- Padronização de eventos recorrentes.
- Follow-up pós-evento fraco (inscritos não convertem).
- Conteúdo que "morre" depois da transmissão.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| **Objetivo do evento** | sim | Lead qualificado · awareness · ativação de base{{#if modelo_comercial:B2B}} · aquecimento de conta-alvo{{/if}} |
| **Tema e formato** | sim | Educacional, demonstração ao vivo, especialista, painel{{#if canal:eventos}}, presencial{{/if}} |
| **Produto ou segmento foco** | sim | Define o doc de produto e o público |
| Palestrantes | recomendado | {{#if tem:vozes}}Voz pessoal → doc em `contexto/vozes/` (§3.3){{else}}Nome, cargo, vínculo{{/if}} |
| **Data e meta numérica** | sim | Ver protocolo de dado |

Banco completo em `times/{{time.slug}}/docs/descoberta-bancos.md` (Evento). Sem objetivo, tema e meta, **pergunte** antes de produzir.

## Processo

As sete etapas do ciclo, em ordem:

### 1. Estratégia e definição
Objetivo de negócio define formato, oferta e KPI · demonstração ao vivo tende a converter mais em lead qualificado que evento puramente educativo (validar com o histórico próprio) · tema e ângulo a partir da dor do produto (`contexto/produtos/<slug>/<slug>.md`) e dos públicos do config · data: sazonalidade + competição de calendário · KPIs: inscritos, comparecimento, leads, conversão para a próxima etapa.

### 2. Captação e promoção
Briefing via `planejar-campanha`; distribuição em canais **próprios** ({{#if canal:email}}e-mail{{/if}}{{#if canal:whatsapp}}, mensagem{{/if}}{{#if canal:newsletter}}, newsletter{{/if}}), **alugados** ({{#if canal:midia-paga}}mídia paga{{/if}}{{#if canal:linkedin}}, LinkedIn{{/if}}{{#if canal:instagram}}, Instagram{{/if}}) e **emprestados** (palestrantes, parceiros). Página de inscrição e convites pelas skills de canal; peças pelo Designer.

### 3. Pré-evento e nutrição
Régua de lembretes: confirmação → véspera → lembrete do dia → ao vivo. Quem se inscreve com muita antecedência comparece menos — reforçar nos dois dias anteriores. Meta de comparecimento vem do histórico próprio em `benchmarks-canal`.

### 4. Execução ao vivo
Roteiro por tempo (run-of-show): papéis (host, palestrante, moderação), engajamento (enquete, perguntas), **CTA ao vivo**, checklist técnico e ensaio.{{#if canal:eventos}} Presencial: logística, credenciamento, captura de contato e material de palestrante.{{/if}}

### 5. Follow-up comercial — a etapa mais negligenciada
Leads de evento têm dor explícita e janela curta: follow-up qualificado em **menos de 24 h**.

| Segmento | Critério | Tratamento |
|---|---|---|
| **Quente** | Compareceu, ficou a maior parte, interagiu ou perguntou | Passagem imediata a vendas com contexto (o que viu, o que perguntou, objeção provável, próximo passo) |
| **Morno** | Compareceu, baixo engajamento | Nutrição + convite a demonstração ou diagnóstico |
| **Ausente inscrito** | Inscreveu, não compareceu | Gravação + reabertura do tema |
| **Frio** | Só visitou a página | Nutrição padrão |

### 6. Reaproveitamento
Gravação → pacote multicanal: cortes curtos, carrossel com os dados, post do palestrante, artigo, trecho para a newsletter. Registrar o destilado onde o time guarda transcrições e insights.

### 7. Análise e aprendizado
`analisar-performance` com o recorte de evento: funil (visitas → inscritos → comparecimento → leads → próxima etapa), engajamento, custo, recomendações. Aprendizado validado vai para `benchmarks-canal`.

**Ritual:** D-21 estratégia e abertura da captação → D-14 a D-1 promoção e nutrição → D-3 roteiro fechado e ensaio → dia 0 → D+1 follow-up segmentado e gravação → D+2 a D+10 reaproveitamento → D+7 análise.

## Regras

- **Orquestra, não duplica.**
- **Protocolo de dado:** meta e benchmark de evento vêm {{#if integracao:dados}}da base integrada ou{{/if}} do histórico interno; senão, perguntar; sem resposta → `[NECESSITA FONTE]` e plano qualitativo. Benchmark de mercado só com `[BUSCADO: fonte]`. Nunca fabricar taxa de comparecimento ou conversão.
- Base mercado: o conteúdo é o gancho, nunca o produto (`redator-email`).
- Plano e peças vão para o registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}, nunca para a documentação.

## Checklist

- [ ] Objetivo, tema, formato, produto, data e meta confirmados? Meta com origem?
- [ ] Sete etapas cobertas, cada uma com skill-fonte, responsável e prazo?
- [ ] Régua de lembretes definida? Follow-up segmentado em menos de 24 h previsto?
- [ ] Plano de reaproveitamento e análise agendados antes do evento?
- [ ] Nenhum copy ou cálculo feito aqui dentro?

## Output esperado

| Saída | Etapa |
|---|---|
| Plano do evento (7 etapas + checklist de prontidão) | todas |
| Plano de captação por tipo de canal | 2 |
| Régua de lembretes | 3 |
| Roteiro da transmissão (via `roteiro-video`) | 4 |
| Listas segmentadas + fichas para vendas | 5 |
| Matriz de reaproveitamento | 6 |
| Diagnóstico pós-evento (via `analisar-performance`) | 7 |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "estrategista"}} |
