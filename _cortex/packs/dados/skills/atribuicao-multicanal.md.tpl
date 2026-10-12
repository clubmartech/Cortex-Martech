---
tipo: skill
id: atribuicao-multicanal
descricao: "Distribui o crédito de uma conversão entre os canais da jornada por mais de um modelo, declara os limites do rastreamento e apresenta sem fingir precisão."
familia: ANALISAR.atribuicao
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["atribuição multicanal", "qual canal influenciou a venda", "primeiro toque e último toque", "jornada antes de converter", "modelo de atribuição", "quanto cada canal contribuiu", "distribuir o crédito entre canais"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`), a taxonomia de origens e a ficha da fonte antes de passar para cá. **Volte ao Analista de Dados antes de atribuir.**

# Atribuição multicanal

Responde "quais canais participaram das conversões e quanto crédito cada um merece?". A resposta honesta tem **mais de um modelo**, **um limite de rastreamento declarado** e **uma recomendação que não corta canal com base em um modelo só**. A decisão de verba é do Estrategista do pack marketing; aqui sai a evidência.

## Contexto de uso

- Realocação de verba entre canais; canal que "não converte" no último toque mas aparece em toda jornada.
- Avaliar conteúdo e canais de topo que raramente fecham sozinhos.
- Antes de qualquer corte de canal.

## Briefing mínimo

Pergunta de negócio e decisão · conversão analisada (métrica do dicionário) · período (mínimo recomendado: alguns meses, para a jornada caber) · fonte com ficha e **como os toques são registrados** (parâmetros de URL, eventos, campo de origem) · taxonomia de origens vigente.

## Processo

### Passo 1 — Verificar a qualidade do rastreamento

Cobertura: % das conversões do período com canal identificado (não "desconhecido"). Abaixo de um piso definido pelo time (`[PENDENTE: piso]`), a atribuição é inválida — abrir `qualidade-de-dados` e `definir-funil-e-origens` antes. Registrar a cobertura na entrega.

### Passo 2 — Mapear os toques por conversão

Para cada conversão: sequência de toques (canal, data), do primeiro registro até a conversão, via `consultar-metrica` (probe → consulta → citação). Toques fora do rastreamento digital (ligação, evento presencial, indicação) **não aparecem** — declarar.

### Passo 3 — Calcular por modelo (sempre mais de um)

| Modelo | Crédito | Revela | Esconde |
|---|---|---|---|
| Último toque | 100% ao último canal | o que fecha | o que inicia |
| Primeiro toque | 100% ao primeiro | o que inicia | o que fecha |
| Linear | igual entre todos | participação | peso real |
| Posição (U) | maior ao primeiro e ao último, resto no meio | início e fecho | o meio |

Tabela por canal: conversões por modelo lado a lado. Canal que some num modelo e aparece em outro é o achado principal.

### Passo 4 — Padrões de jornada

Jornadas mais frequentes (sequências de canais) · comprimento médio e mediano · tempo entre primeiro toque e conversão · canais que aparecem só como assistentes. Canal "assistente" com muitas aparições e nenhum último toque é candidato a subestimado.

### Passo 5 — Recomendar com limites

Para cada canal: posição em cada modelo · papel na jornada (inicia, assiste, fecha) · recomendação (manter, testar, investigar) · confiança (alta, média, baixa) conforme cobertura e volume. **Nunca** "cortar" com base em um modelo; "investigar" quando os modelos discordam.

### Passo 6 — Apresentar

Uma página: cobertura do rastreamento · tabela por modelo · jornadas típicas · recomendações com confiança · limitações. `[CONECTOR: fonte · data]` em todo número; leitura marcada `[HIPÓTESE]` onde for.

## Limitações a declarar sempre

- Dispositivo diferente entre o toque e a conversão quebra a jornada.
- Toques fora do digital não aparecem.
- Conteúdo consumido sem conversão (influência) não é medido.
- Janela curta subestima canais de topo.
- Canal de marca (busca pelo nome) aparece em toda jornada por ser consequência, não causa.

## Regras

- Cobertura abaixo do piso → não há atribuição, há diagnóstico de rastreamento.
- Mais de um modelo, sempre, lado a lado.
- Correlação não é causa; recomendação com confiança declarada.
- A decisão de verba é do Estrategista; esta skill entrega evidência.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem.

## Checklist

- [ ] Cobertura calculada e acima do piso? Taxonomia vigente usada?
- [ ] Toques mapeados com data de negócio? Fora do digital declarado?
- [ ] Pelo menos dois modelos lado a lado?
- [ ] Jornadas típicas e canais assistentes identificados?
- [ ] Recomendação com confiança e sem corte por modelo único? Limitações listadas?

## Output esperado

| Saída | Formato |
|---|---|
| Tabela de atribuição | canal × modelo, com `[CONECTOR: fonte · data]` |
| Jornadas típicas | tabela: sequência · frequência · tempo até converter |
| Recomendações | tabela: canal · papel · recomendação · confiança |
| Nota de limitações | lista |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
