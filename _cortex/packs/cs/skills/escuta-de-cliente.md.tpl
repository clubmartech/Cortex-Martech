---
tipo: skill
id: escuta-de-cliente
descricao: "Transforma tickets, comentários, pesquisas e conversas em dores, oportunidades e pautas: coleta por fonte, temas, nível de confiança e destino por time."
familia: ANALISAR.escuta-cliente
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que os clientes estão dizendo", "transformar tickets em dores", "pautas a partir do atendimento", "voz do cliente", "padrão nas reclamações", "insumo para produto a partir do suporte", "frases dos clientes", "temas recorrentes nos tickets"]
requires: gestor-sucesso · matriz-risco-churn
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`) e o dado disponível antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de sintetizar.**

# Escuta do cliente — de comentários a dores, oportunidades e pautas

O cliente fala o tempo todo: em tickets, chats, pesquisas, comunidade, reuniões de resultados, pedidos de cancelamento. A escuta organiza isso em **temas com evidência e nível de confiança** e entrega a cada time o que lhe cabe — produto recebe lacuna quantificada, marketing recebe pauta e linguagem{{#if pack:vendas}}, vendas recebe objeção e prova{{/if}}, o próprio time recebe artigo e resposta-modelo. Escuta sem destino é arquivo.

## Contexto de uso

- Síntese periódica (ciclo {{operacao.ciclo_planejamento}} ou mais curta).
- Antes de priorizar artigos da central de ajuda.
- Depois de uma pesquisa de satisfação ou de um incidente.
- Pedido de outro time ("o que os clientes dizem sobre X?").

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Período e fontes incluídas | sim |
| Export ou acesso às fontes (tickets, comentários, pesquisa, comunidade, notas de reunião) | sim |
| Recorte (produto, segmento, etapa da jornada) | sim |
| Pergunta de quem pediu (se houver) | não |
| Síntese anterior (para tendência) | não |

**Fontes e acesso:** {{#if integracao:dados}}integração de dados definida em `cortex.config.yaml` para tickets e uso{{else}}export fornecido pelo usuário, `[INFORMADO PELO CLIENTE]`{{/if}}{{#if canal:comunidade}}; canal `comunidade` como fonte de conversa entre clientes{{/if}}; notas de reunião e pesquisa do registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}.

## Processo

### 1. Coletar por fonte

| Fonte | O que revela | Cuidado |
|---|---|---|
| Tickets e chats | dor operacional, lacuna, confusão de uso | motivo registrado ≠ motivo real; ler a mensagem |
| Pesquisas (NPS/CSAT) | relação e momentos críticos | comentário vale mais que nota |
| Comunidade e redes | o que dizem entre si; linguagem própria | público, não conta individual; sem dado pessoal |
| Reuniões de resultados | objetivo, mudança de contexto, expectativa | registrado pelo Gestor, com frase exata |
| Cancelamentos e reduções | causa real de saída | conversa de aprendizado, não de retenção |
| Pedidos de funcionalidade | lacuna percebida | separar "não sabe que existe" de "não existe" |

### 2. Agrupar por tema e produto

Temas: uso e adoção · lacuna de produto · erro e estabilidade · atendimento · onboarding · valor e resultado · preço e contrato · comunicação. Por produto ({{#each produtos as p}}`{{p.slug}}` {{/each}}) e por público ({{#each publicos as pu}}`{{pu.slug}}` {{/each}}). Para cada tema: contagem, fontes distintas, tendência contra a síntese anterior, **frases exatas**.

### 3. Nível de confiança (convenção do time)

| Nível | Critério | Uso permitido |
|---|---|---|
| **Alto** | várias fontes independentes convergem; recorrência no período | embasar mudança (produto, artigo, processo, pauta) |
| **Médio** | duas fontes ou recorrência em uma | hipótese para validar |
| **Baixo** | caso isolado ou percepção de uma pessoa | registrar como suspeita; não acionar mudança |

Cortes numéricos são definidos pelo time (`[PENDENTE: definir cortes]`), não desta skill.

### 4. Estruturar cada achado

```
TEMA: [...] — produto: [...] — público: [...] — confiança: alta / média / baixa
O que o cliente tenta fazer: [...]
Dor (palavras dele): "[frase exata]" — fonte, data
O que o fez falar agora: [...]
Alternativa que ele usa: [...]
Causa-raiz provável: [...]
Frequência e tendência: [...]
```

### 5. Destinar

| Tipo de achado | Destino | Formato |
|---|---|---|
| dúvida recorrente com resposta conhecida | Atendente → `artigo-central-ajuda` e `respostas-modelo` | lista priorizada |
| lacuna de produto com confiança alta | quem cuida do produto | evidência quantificada: contagem, frases, impacto |
| risco em conta específica | `matriz-risco-churn` → Gestor | linha por cliente |
| linguagem do cliente e dor para comunicação | {{#if pack:marketing}}estrategista e redação do pack de marketing{{else}}quem cuida de comunicação{{/if}} | banco de frases por tema |
{{#if pack:vendas}}| objeção e prova | `matriz-objecoes` do pack de vendas | linha por objeção |
{{/if}}| oportunidade de expansão | `playbook-expansao` | sinal com fonte |
| tema para a comunidade ou conteúdo | {{#if canal:comunidade}}pauta do canal `comunidade`{{else}}pauta de conteúdo{{/if}} | pergunta aberta, não resposta pronta |

### 6. Fechar o loop

Com o cliente: "você disse isso; isto é o que mudou". Com os times: síntese curta por destino, com o que se espera de volta e quando.

## Regras

- Frase exata com fonte e data; paráfrase não é evidência.
- Nível de confiança sempre declarado; achado baixo não aciona mudança.
- Lacuna de produto chega como evidência, nunca como reclamação.
- Sem dado pessoal em síntese compartilhada; contas anonimizadas; `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}) respeitado.
- Toda síntese tem destino e dono; o que não tem destino fica registrado como suspeita.

## Checklist

- [ ] Período, fontes e recorte definidos?
- [ ] Temas por produto e público, com contagem, fontes e tendência?
- [ ] Frases exatas com fonte e data?
- [ ] Confiança declarada por achado?
- [ ] Cada achado com destino, formato e dono?
- [ ] Loop fechado com cliente e times?

## Output esperado

| Saída | Formato |
|---|---|
| Síntese do período | temas por produto/público, confiança, tendência |
| Achados estruturados | bloco por achado (modelo acima) |
| Lista por destino | artigos · produto · risco · comunicação{{#if pack:vendas}} · objeções{{/if}} · expansão · pautas |
| Banco de frases | tema, frase, produto, público, fonte, data |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
