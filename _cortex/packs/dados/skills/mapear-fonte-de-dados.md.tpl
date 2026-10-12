---
tipo: skill
id: mapear-fonte-de-dados
descricao: "Documenta uma fonte de dados — entidades, campos, chaves, granularidade, atualização e limitações — gerando ou atualizando a ficha da fonte no time."
familia: DOCUMENTAR.fonte-de-dados
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["documenta a fonte de dados", "ficha da base", "quais tabelas e campos existem", "de onde vem esse dado", "mapeia a integração de dados", "granularidade e atualização da fonte", "limitações da base"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`) antes de passar para cá. Mapear uma fonte é read-only, mas **não dispensa** o gate. **Volte ao Analista de Dados antes de mapear.**

# Mapear fonte de dados — a ficha da fonte

Uma fonte sem ficha é uma fonte que cada pessoa consulta de um jeito. A ficha responde: **o que existe** (entidades e campos), **como se liga** (chaves), **em que grão** (por contato, por negócio, por dia), **quando atualiza**, **o que não dá para responder** com ela e **quais armadilhas** já foram encontradas. Destino: `times/{{time.slug}}/docs/fonte-<slug>.md`, um por integração de tipo dados ou analytics.

## Contexto de uso

- Integração de dados ou analytics nova, ou nunca documentada.
- Consulta que revelou campo vazio, chave alternativa ou comportamento inesperado (atualização da ficha).
- Antes de definir métrica cuja fonte ninguém conhece bem.

## Briefing mínimo

Integração (slug de `integracoes[]`{{#if integracao:dados}}{{else}}{{#if integracao:analytics}}{{else}} — esta organização não tem integração de dados ou analytics; a fonte pode ser um export recorrente, documentado do mesmo jeito{{/if}}{{/if}}) · acesso (conector, export, painel) · o que a fonte deveria responder (perguntas de negócio) · quem é o dono técnico.

## Processo

### Passo 1 — Inventário de entidades

Listar o que a fonte guarda, no nível mais alto: contato, empresa, negócio, evento de conversão, sessão, pedido, campanha. Para cada entidade: nome na fonte · o que representa no negócio · volume aproximado (`[CONECTOR: fonte · data]`) · desde quando há dado.

### Passo 2 — Probe por entidade

Amostra pequena (5 linhas) de cada entidade. Para cada campo: nome · tipo · preenchimento (% na amostra) · significado no negócio · exemplo anonimizado. Campo com nome parecido em duas entidades ganha nota: é o mesmo dado ou não?

### Passo 3 — Chaves e ligações

| De | Para | Chave | Cobertura | Observação |
|---|---|---|---|---|

Chave que não liga em parte dos registros (registros antigos, outra origem) vira limitação declarada. Chave natural (e-mail, documento) e chave técnica (id) são registradas separadamente.

### Passo 4 — Granularidade e datas de negócio

Para cada entidade: o grão (uma linha = o quê?) e **qual campo é a data do evento de negócio** (abertura, conversão, fechamento) em oposição à data de gravação. Fuso horário usado. Sem isso, toda métrica por período sai errada.

### Passo 5 — Atualização e consultas preferidas

Como e quando a fonte atualiza (tempo real, diária, manual) · se há consultas, visões ou funções prontas que já aplicam as regras oficiais — **preferir sempre o que já existe** sobre tabela bruta · permissões (leitura, escrita, quem concede).

### Passo 6 — Limitações e armadilhas

O que a fonte **não** responde (ex.: não separa por produto; não guarda histórico de etapa) · campos que parecem uma coisa e são outra · valores fora de taxonomia · exclusões oficiais (teste, duplicado, interno) e onde vivem. Cada armadilha com data e `[CONECTOR: …]` ou `[INFORMADO PELO CLIENTE]`.

### Passo 7 — Validar e gravar

Inteiro no chat → aprovação do dono técnico e do papel `{{papel "analista-dados"}}` → gravar ou atualizar `times/{{time.slug}}/docs/fonte-<slug>.md` → apontar a partir de `contexto/integracoes/<slug>.md` (ficha de integração do kernel, que fala de acesso e uso; a ficha de fonte fala do dado). Linha no `## Histórico`.

## Regras

- Read-only em toda a etapa. Nada de criar visão, função ou tabela para "facilitar".
- Nenhum campo documentado sem ter sido visto no probe.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não aparecem nos exemplos; anonimizar.
- Ficha de fonte não define métrica: aponta para o dicionário. Métrica nova → `dicionario-de-metricas`.
- Limitação descoberta em consulta volta para a ficha no mesmo dia, com aprovação.

## Checklist

- [ ] Entidades com volume e período de cobertura? Campos vistos no probe?
- [ ] Chaves com cobertura declarada? Data de negócio vs. gravação identificada?
- [ ] Atualização, permissões e consultas prontas registradas?
- [ ] Limitações e armadilhas com data e marcador?
- [ ] Ficha gravada no padrão e apontada da ficha de integração?

## Output esperado

| Saída | Formato |
|---|---|
| Ficha da fonte | doc em `times/{{time.slug}}/docs/fonte-<slug>.md` |
| Relatório do probe | tabela por entidade: campo · tipo · preenchimento · significado |
| Lista de perguntas que a fonte não responde | lista, para o dicionário e para quem pediu |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
