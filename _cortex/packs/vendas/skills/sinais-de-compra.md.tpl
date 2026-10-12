---
tipo: skill
id: sinais-de-compra
descricao: "Monta o radar de sinais públicos de contas-alvo: categorias, fontes, intensidade, hipótese de dor por sinal e recomendação de timing e ângulo de abordagem."
familia: ANALISAR.sinais-de-compra
output: relatorio
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["sinais de compra da conta", "o que está acontecendo na empresa alvo", "momento certo de abordar", "radar de contas-alvo", "notícias e vagas da conta", "intenção de compra", "a conta deu sinal", "monitorar contas-alvo"]
requires: prospectador · dicionario-qualificacao
owner: {{papel "sdr"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Prospectador** (`prospectador`), que carrega o gate (`_cortex/kernel/gate.md`) e o dicionário de qualificação antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Prospectador antes de montar o radar.**

# Sinais de compra — radar de contas-alvo

Transforma movimentação pública de uma conta (vagas, notícias, publicações, mudanças de liderança, investimentos) em **hipótese operacional**: o que a conta provavelmente está sentindo, quem sente, e se é hora de abordar. Sinal sem hipótese é dado bruto. Hipótese sem fonte é invenção. Modelo comercial: **{{organizacao.modelo_comercial}}**.

## Contexto de uso

- Priorizar quais contas de uma lista abordar primeiro.
- Preparar o ângulo de abertura de uma conta específica.
- Monitoramento periódico de contas-alvo (leitura semanal da planilha de sinais).
- Negócio parado que precisa de gatilho novo para retomar.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Escopo (uma conta, lista ou segmento) | sim |
| Objetivo (timing, ângulo, priorização, expansão) | sim |
| Produto de interesse | sim |
| Fontes disponíveis (site, notícias, vagas, rede profissional, diário oficial, relatórios) | sim |
| Planilha de sinais mantida pelo time (para monitoramento) | sim, no modo monitoramento |
| Contexto comercial (nova, cliente, negócio ativo) | não |

**Modo monitoramento:** sem a planilha de contas e sinais enviada pelo usuário, parar e pedir — nunca gerar score a partir de memória ou suposição. Colunas mínimas: conta · identificador · responsável · produto · sinal observado · categoria · data · fonte.

## Processo

### 1. Coletar por categoria

| Categoria | O que observar | Fontes típicas |
|---|---|---|
| **Crescimento** | novas unidades, contratos, projetos, aumento de equipe | notícias, site, vagas |
| **Mudança organizacional** | nova liderança, nova diretoria, reestruturação, fusão | rede profissional, releases |
| **Transformação** | vagas de tecnologia e processo, projetos de sistema, padronização | vagas, publicações |
| **Investimento** | captação, aquisição, concessão, entrada em mercado | notícias, publicações oficiais |
| **Intenção direta** | visita a página de preço ou demonstração, material de fundo de funil, resposta a campanha | {{#if integracao:automacao-mkt}}integração de automação de marketing do config{{else}}formulário, briefing{{/if}}{{#if integracao:crm}}, CRM{{/if}} |
| **Risco** | demissões em massa, crise, saída do campeão, concorrente ativo na conta | notícias, rede profissional |

Só fontes públicas ou dados próprios com consentimento. Toda linha com **fonte e data**.

### 2. Interpretar operacionalmente

| Sinal | Hipótese de dor | Público afetado (`publicos[]`) | Probabilidade |
|---|---|---|---|
| [o que foi visto] | [que pressão isso cria no processo] | [slug] | alta · média · baixa |

Cruzar com a dor registrada dos públicos ({{#each publicos as pu}}**{{pu.slug}}**: {{pu.dor}} · {{/each}}) e com a dor principal do produto. Comunicação institucional nem sempre é mudança real: dizer por que o sinal importa — ou descartar.

### 3. Classificar a intensidade

| Nível | Critério | Recomendação |
|---|---|---|
| **Alto** | sinais convergentes de categorias diferentes, indicando pressão ativa | abordar agora; `script-abordagem` com o ângulo do sinal |
| **Médio** | sinal relevante isolado | preparar; nutrir; reler no próximo ciclo |
| **Baixo** | sinais difusos | manter em observação |
| **Risco** | retração, crise, saída de campeão | pausar abordagem; registrar |

Se o time usa pontuação, os pesos ficam registrados em `dicionario-qualificacao` § Sinais; sem pesos, a classificação é qualitativa.

### 4. Ângulo de abordagem

Para cada hipótese de probabilidade alta: **pergunta consultiva** que usa o contexto sem citar a fonte. Anti-padrão: "vi que vocês abriram vaga de X". Padrão: "como vocês estão lidando com [pressão operacional que a vaga sugere]?". O ângulo vai para `script-abordagem`; a sequência, para `cadencia-prospeccao`.

### 5. Monitoramento (planilha)

Rotina: ler só o que está na planilha (sinal citado no chat entra na planilha antes de contar) · consolidar por conta · classificar · listar as contas que mudaram de nível desde a última leitura · para as de nível alto, registrar a nota {{#if integracao:crm}}na integração de CRM definida em `cortex.config.yaml`{{else}}{{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}{{/if}} e acionar o responsável com o ângulo sugerido.

## Regras

- Só fontes públicas ou dado próprio com consentimento; nada de dado de terceiros sem base legal.
- Fonte e data em toda linha; sem fonte, `[NECESSITA FONTE]` e o sinal não pontua.
- O sinal nunca é citado literalmente na abordagem.
- Sinal de risco pausa a conta.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não vão para prompt externo.
- Conta cliente: sinal de expansão vai {{#if pack:cs}}ao Gestor de Sucesso (pack de CS){{else}}a quem cuida da conta{{/if}} antes de qualquer abordagem.

## Checklist

- [ ] Escopo, objetivo e produto confirmados? Planilha recebida (modo monitoramento)?
- [ ] Sinais com categoria, fonte e data?
- [ ] Cada sinal com hipótese operacional e público afetado?
- [ ] Intensidade classificada; risco pausando a conta?
- [ ] Ângulo como pergunta consultiva, sem citar fonte?
- [ ] Contas que mudaram de nível listadas e responsáveis acionados?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório de sinais | tabela por conta e categoria, com fonte e data |
| Hipóteses de dor | lista por conta com público, probabilidade e ângulo |
| Priorização | contas por nível de intensidade; mudanças desde a última leitura |
| Briefing de abordagem | por conta de nível alto: contexto + ângulo + canal sugerido |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou a planilha de sinais do time — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "sdr"}} |
