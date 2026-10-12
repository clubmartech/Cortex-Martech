---
tipo: doc
id: anti-alucinacao
descricao: "Define o que nunca inventar, as fontes válidas, os seis marcadores de incerteza e as respostas-padrão quando falta dado."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["posso inventar esse número", "o que faço quando não tenho o dado", "como marco uma incerteza", "qual a resposta-padrão sem fonte", "o que nunca inventar", "como cito um dado de conector", "dado de conector precisa de marcador"]
requires:
owner: cortex
origem: kernel
validado_em: 2026-10-03
---

# anti-alucinacao.md — Protocolo de prevenção de alucinação

> Guia operacional para IA. Aplica-se a todo agente antes de gerar qualquer entrega — um dos três pilares da fundação (`_cortex/kernel/gate.md` §2). Não substitui revisão humana antes de publicar.

---

## 1. Objetivo

Impedir que a IA gere fatos, números, funcionalidades, citações ou afirmações sem origem verificável. Define o que pode e o que nunca pode ser afirmado, como validar antes de responder, e o que fazer quando faltar evidência.

---

## 2. Princípios obrigatórios

- Precisão tem prioridade sobre velocidade ou completude. Na dúvida entre responder rápido e responder certo, pergunte.
- Proibido: inventar fatos, números, fontes, resultados, depoimentos ou evidências; preencher lacuna com suposição apresentada como fato; assumir contexto não informado; inferir datas, nomes, processos ou regras sem evidência.
- Regra de segurança máxima: **perguntar · não assumir · não inferir · não inventar · não completar lacuna.** Enquanto houver dúvida crítica em aberto, não gerar a entrega final.

---

## 3. O que nunca afirmar sem verificar

Por categoria — nunca afirmar o item abaixo sem consultar a fonte indicada.

| Categoria | Nunca afirmar sem verificar | Consultar |
|---|---|---|
| Dados e números | Número, variação percentual, data de lançamento ou projeção de mercado sem fonte confiável | material do solicitante · site oficial da marca (`marcas[].site` no `cortex.config.yaml` — conferir sempre a versão atual, o número muda) · fonte externa citada · a integração de dados definida em `cortex.config.yaml` (`integracoes[]` com `tipo: dados`) |
| Produtos e funcionalidades | Funcionalidade, integração, preço ou condição comercial não documentada na ficha do produto | `contexto/produtos/<slug>/<slug>.md` (doc-raiz primeiro; filhos só se a resposta não estiver lá) |
| Produto sem ficha | Qualquer descrição de produto que não tem `contexto/produtos/<slug>/` | depende **100 %** de insumo do solicitante, marcado `[INFORMADO PELO CLIENTE]` |
| Produto descontinuado | Apresentar como ativo um produto marcado como descontinuado na ficha | `[NECESSITA FONTE]` até confirmação |
| Clientes e casos | Nome de cliente, depoimento, citação ou resultado específico sem material aprovado. Fala de cliente com status "sugerida" **não é material aprovado** — só "aprovada" | o índice de provas/cases do pack (`times/<time>/docs/`), quando existir; senão, material do solicitante |
| Empresa e grupo | Dado sobre a organização fora de `contexto/organizacao.md`; nome de holding ou grupo controlador em conteúdo externo; faturamento, headcount ou estrutura interna | `contexto/organizacao.md` · `contexto/brandcenter/brandcenter.md` |
| Concorrência | Preço, funcionalidade, posicionamento ou superioridade sobre concorrente sem fonte validada | fonte externa citada · seção de concorrência da ficha do produto |
| Vozes e pessoas | Opinião, posição ou citação atribuída a alguém sem origem documentada | o doc apontado em `vozes[].doc` do `cortex.config.yaml` |
| Conector e banco de dados | Nome de tabela, coluna, procedimento, filtro ou métrica que não foi confirmado no schema; agregação inferida apresentada como se tivesse voltado da consulta | `contexto/integracoes/<slug>.md` da integração usada |

---

## 4. Processo de validação

Antes de gerar qualquer conteúdo, identifique a fonte de cada afirmação. Toda afirmação precisa de ao menos uma fonte válida:

| Fonte válida | Exemplo |
|---|---|
| Briefing do solicitante | card no registro primário, documento de briefing, cartão `BRIEFING VALIDADO ✅` |
| Documentação oficial | arquivos desta base: `contexto/**`, `times/<time>/docs/`, `iniciativas/<slug>/docs/` |
| Material do cliente | dados, planilhas, textos repassados pelo solicitante |
| Fonte externa validada | estudo, notícia ou indicador com origem citada |
| Conteúdo já aprovado | peças e materiais já publicados |
| Consulta a conector (MCP) | resultado de query executada **nesta sessão** na integração de dados, no registro primário ou em plataforma de mídia. Só vale como fonte com **sistema + data da consulta** declarados |

> **Conector é transporte, não é automaticamente fonte quantitativa.** Texto autoral lido via conector (briefing num card, comentário, descrição de tarefa) continua sendo **Briefing do solicitante** — não recebe marcador de conector. A linha acima vale para **dado numérico ou agregado** que veio de query: números da integração de dados, contagem ou soma de cards, métricas de plataforma.

Sem fonte válida: interromper a execução, perguntar *"Quais são as fontes oficiais que devo utilizar para construir este material?"*, não produzir conteúdo especulativo.

### 4.1 Os seis marcadores oficiais

Marcar todo trecho não 100 % verificado com um deles:

| Marcador | Quando usar |
|---|---|
| `[VALIDADO]` | Confirmado em fonte confiável |
| `[INFORMADO PELO CLIENTE]` | Dado ou premissa do solicitante, não validado por fonte oficial |
| `[PENDENTE DE CONFIRMAÇÃO]` | Uso provisório — depende de validação antes de publicar |
| `[NECESSITA FONTE]` | Sem origem identificável — não publicar sem fonte |
| `[BUSCADO: fonte]` | Benchmark externo com fonte citada (estudo ou relatório + ano, idealmente o endereço) — equivale a `[VALIDADO]` externo; sem fonte citada, rebaixar para `[NECESSITA FONTE]` |
| `[CONECTOR: sistema · data]` | Número lido ao vivo de conector nesta sessão (ex.: `[CONECTOR: integração de dados · 2026-10-03]`). O dado é real, mas é **retrato da data da consulta** — reconferir na origem antes de comprometer meta, verba ou número público. Sem sistema e data declarados, rebaixar para `[PENDENTE DE CONFIRMAÇÃO]` |

### 4.2 Fronteira `[VALIDADO]` × `[CONECTOR]` — quando o número existe nos dois lugares

| Situação | Marcador |
|---|---|
| Número **documentado** num doc da base (passou por validação humana, tem `validado_em`) | `[VALIDADO]` — sem marcador de conector |
| Número **lido ao vivo** na sessão via conector | `[CONECTOR: sistema · data]` |
| Os dois divergem | Vale o ao vivo. Entregar com `[CONECTOR: …]`, apontar a divergência e reportar a desatualização do doc via `_cortex/kernel/governanca.md` §11 (ou acionar o Documentador para corrigir, com fonte) |

### 4.3 Marcadores não oficiais

Não usar — converter: `[A BUSCAR]` ou número de mercado sem fonte → `[NECESSITA FONTE]`; `[ESTIMADO]` / `[INFERIDO]` → `[PENDENTE DE CONFIRMAÇÃO]`; dado interno de fonte confiável → `[VALIDADO]`; `[DADO DE INTEGRAÇÃO]` ou número de conector sem data → `[CONECTOR: sistema · data]`. Número de mercado escrito antes de existir fonte é proibido.

Nenhum trecho `[PENDENTE DE CONFIRMAÇÃO]` ou `[NECESSITA FONTE]` vai ao ar sem ser resolvido.

---

## 5. Ações quando houver incerteza

Quando faltar informação, responder com uma das opções abaixo — nunca preencher a lacuna:

- "Não encontrei informação suficiente para confirmar esse dado."
- "Essa informação não foi fornecida no material disponível."
- "Preciso de uma fonte ou validação adicional para prosseguir."
- "Não é possível afirmar isso com segurança."

Se um dado suspeito já foi gerado:

1. Não publicar.
2. Remover o dado e reescrever o trecho sem ele.
3. Se houver dado correto com fonte, usá-lo.
4. Se a causa for arquivo de referência desatualizado ou incompleto, reportar via `_cortex/kernel/governanca.md` §11 ("Sinalizar problemas").

---

## 6. Perguntas de verificação

Responder internamente antes de gerar qualquer resposta:

- A informação está documentada em algum arquivo de referência desta base?
- Existe evidência (fonte, arquivo, briefing) para esta afirmação específica?
- Estou inferindo algo ou utilizando um fato verificado?
- Há conflito entre documentos? Qual prevalece (o mais recente com `validado_em`, ou o ao vivo, §4.2)?
- Preciso consultar algum arquivo relacionado (§7) antes de responder?
- Tenho dados suficientes para responder com segurança?
- Preciso solicitar esclarecimento ou fonte ao solicitante antes de prosseguir?
- Estou assumindo contexto, produto, cliente ou número que não foi informado?
- Se consultei conector: cada tabela, coluna, procedimento ou filtro que estou citando foi **confirmado na ficha da integração**, e não deduzido pelo nome?
- Todo número que veio de conector está com `[CONECTOR: sistema · data]`, e nenhum número autoral está usando esse marcador emprestado?
- Cada trecho não verificado está marcado com o marcador oficial correto (§4.1)?

Se qualquer resposta indicar lacuna ou dúvida crítica: interromper e aplicar a §5.

---

## 7. Relação com outros arquivos

| Arquivo | Complementa este documento | Quando consultar |
|---|---|---|
| `_cortex/kernel/gate.md` | Define o gate de ativação — este arquivo é um dos três pilares carregados antes de qualquer entrega (§2 daquele arquivo); e trata a **primeira chamada de conector como entrega** (§1). Este arquivo cobre o passo seguinte: como citar o que voltou | Sempre, no início de qualquer pedido; sempre que a sessão for usar conector |
| `_cortex/kernel/governanca.md` | Política de uso e dados proibidos em prompt; §1 aponta para este arquivo como fonte única da regra anti-alucinação | Para saber o que exige validação humana, ou o que nunca entra em prompt |
| `contexto/brandcenter/brandcenter.md` | Identidade de marca e linguagem — cobre "como falamos"; este arquivo cobre "o que não pode ser inventado" | Ao validar tom, marca ou linguagem além do fato em si |
| `_cortex/kernel/descoberta.md` | Usa os marcadores deste arquivo ao montar o cartão `BRIEFING VALIDADO ✅` — a descoberta é onde a incerteza é declarada antes de produzir | Ao final de qualquer entrevista de briefing |
| `contexto/produtos/<slug>/<slug>.md` | Ficha do produto — fonte do que o produto é, faz e promete | Antes de nomear funcionalidade, preço ou condição de produto |
| `contexto/integracoes/<slug>.md` | Ficha da integração — schema, filtros e limites que existem. É o que impede inventar coluna ou procedimento (§3, *Conector e banco de dados*) | Antes de montar ou citar qualquer consulta a conector |

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
