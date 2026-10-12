---
tipo: skill
id: consultar-dado
descricao: "Extrai da base integrada a lista ou o número pedido — conversões de uma página, leads de uma campanha — com probe do schema antes da consulta final."
familia: CONSULTAR.dado
output: dado
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quero a lista de quem converteu", "leads da página", "conversões do formulário", "puxa o dado da base", "quantos leads vieram de", "exporta os convertidos", "consulta o dado de"]
requires: analista
owner: {{papel "analista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista** (`analista`), que carrega o gate (`_cortex/kernel/gate.md`) e a definição de funil antes de passar para cá. Consulta read-only **não dispensa** abrir esta skill. **Volte ao Analista antes de consultar.**

# Consultar dado na base integrada

Responde "quem são, exatamente, as pessoas por trás desse número?" ou "quanto foi X no período?" — registro a registro ou agregado — a partir da integração de **dados** definida em `cortex.config.yaml` (`integracoes[]` com `tipo: dados`). Consulta sempre **read-only**. Não é análise: quem interpreta é `analisar-performance`.

## Contexto de uso

- Lista ou planilha de quem converteu numa página, formulário, evento ou campanha.
- Insumo detalhado para análise de evento, atribuição multicanal ou enriquecimento de base.
- Número pontual (leads por origem no período, conversões de um identificador).

## Briefing mínimo

| Entrada | Obrigatório | Descrição |
|---|---|---|
| **Identificador** (chave de conversão, nome da campanha) **ou** URL da página | sim (um dos dois) | Com URL, extrair o slug e buscar por aproximação |
| Período | não | Omitido → todo o histórico |
| Recorte | não | Produto, origem, segmento |
| **Formato de saída** | sim — perguntar, nunca assumir | Preview no chat · planilha · CSV · markdown · texto |

## Processo

### Passo 1 — Confirmar o identificador exato

Nunca assumir. Buscar por aproximação (`ILIKE '%slug%'` ou equivalente) na chave de conversão, no slug e na URL da página; listar as variações encontradas com contagem; **confirmar com o usuário** qual usar — variações de nome podem ser a mesma campanha rastreada de forma inconsistente ou campanhas diferentes.

### Passo 2 — Probe do schema

Antes de montar a consulta final, descobrir **quais campos existem e estão preenchidos para esse recorte**: listar colunas e chaves do payload com contagem de preenchimento. Campos extras variam por formulário — uma lista fixa de colunas funciona para o identificador testado e perde dado em silêncio em qualquer outro.

### Passo 3 — Montar a extração

Join padrão com contato e empresa (quando a base tiver), ajustando os campos do payload conforme o probe. Incluir sempre o enriquecimento de empresa, mesmo com cobertura parcial. Usar a data do **evento de negócio**, não a data de gravação. Cada campo vira sua própria coluna — nunca concatenar dois campos numa célula. Volume grande → paginar.

### Passo 4 — Verificar amostra

Conferir 3–5 registros aleatórios contra o registro bruto para garantir que nenhum campo preenchido ficou de fora.

### Passo 5 — Entregar no formato escolhido

Perguntar: amostra no chat ou completo? Se completo, qual formato? Só depois gerar.

## Regras

- **Read-only.** Nunca executar escrita, mesmo que o conector permita — a garantia é do papel do banco; se não estiver registrado, `[PENDENTE DE CONFIRMAÇÃO]`.
- Nunca fixar lista de colunas sem o probe. Nunca decidir o formato de saída sem perguntar.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem da base para prompt externo; anonimizar quando a saída for compartilhada.
- Integração indisponível → pedir o dado ao usuário; sem resposta → `[NECESSITA FONTE]`, nunca estimativa.

## Tratamento de exceções

| Situação | Ação |
|---|---|
| Identificador não encontrado exato | Buscar por aproximação e confirmar |
| Payload nulo em parte dos registros | Seguir com os dados normalizados; sinalizar quantos |
| Join vazio | Conferir chave alternativa (registros antigos podem usar outra); não assumir que o lead não existe |
| Volume muito grande | Paginar extração e arquivo |
| Usuário não sabe o formato | Oferecer as opções como múltipla escolha |

## Checklist

- [ ] Identificador confirmado com o usuário? Probe rodado antes da consulta final?
- [ ] Enriquecimento de empresa incluído? Data do evento de negócio?
- [ ] Amostra verificada? Formato perguntado antes de gerar?
- [ ] Nenhuma escrita executada? Dados sensíveis tratados?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório de cobertura de campos (do probe) | tabela no chat, antes da extração |
| Lista ou número extraído | conforme escolhido pelo usuário |

Toda entrega leva o marcador **`[CONECTOR: <integração de dados do config> · <data da extração>]`** e o identificador consultado.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "analista"}} |
