---
tipo: skill
id: planejar-campanha
descricao: "Monta o briefing da campanha com leitura cruzada e checagem de suficiência, ou o plano integrado do ciclo conectando demanda, conteúdo, lançamentos e eventos."
familia: PLANEJAR.campanha
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o briefing da campanha", "plano da campanha", "planejamento integrado do ciclo", "o que vamos fazer esse mês", "cronograma de pautas da campanha", "pitch de pré-vendas", "leitura cruzada do briefing", "plano integrado de marketing"]
requires: estrategista
owner: {{papel "estrategista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Estrategista** (`estrategista`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e as faixas de referência do time antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Estrategista antes de planejar.**

# Planejar campanha e plano do ciclo

Dois usos: **(A) briefing de campanha** — o direcional de quem pediu (campos 01–07) é cruzado com a base de conhecimento (Leitura Cruzada) e o decisor complementa (08–10) antes de liberar a produção; **(B) plano integrado do ciclo** ({{operacao.ciclo_planejamento}}) — conecta demanda, conteúdo, campanhas, lançamentos{{#if oferta:evento}}, eventos{{/if}}{{#if modelo_comercial:B2B}} e contas-alvo{{/if}} num documento só, com metas e insumos para quem vende. O modelo persistido é `briefings/_modelo.md`; o gate efêmero de chat é o `BRIEFING VALIDADO` do kernel — um não substitui o outro.

## Contexto de uso

- Pedido de campanha, lançamento, material rico, régua ou experimento que precisa de briefing formal.
- Início de cada ciclo de planejamento; quando a liderança pede "o plano do ciclo".
- Lançamento, evento ou campanha grande exigindo coordenação entre frentes.
- Ponte entre o relatório de fechamento (Analista) e a execução do ciclo seguinte.

## Briefing mínimo

**Campanha:** objetivo de negócio + KPI · público · produto · marca que assina e que divulga · janela · orçamento · canais pretendidos · oferta central · etapa do funil · o que define sucesso · restrições. Banco completo em `times/{{time.slug}}/docs/descoberta-bancos.md` (Campanha).

**Plano do ciclo:** período · relatório do ciclo anterior (recomendado) · forecast e gap atual (obrigatório — da base integrada ou do usuário) · meta de negócio do ciclo (obrigatória). Faltou dado crítico → **perguntar**, nunca assumir.

## Processo

### A. Briefing de campanha (campos 01–10)

1. **Copiar a estrutura** de `briefings/_modelo.md` — nunca editar o modelo. Nome em kebab-case `[area]-[tipo]-[tema]`, sem espaço, acento ou maiúscula; cópia local só em `briefings/<ciclo>/`.
2. **Colar o direcional de quem pediu nos campos 01–07, sem editar.** Em cada campo, acrescentar a linha `➡️ Em uma frase:` com o resumo acionável (o quê, para quem, com qual prova).

| Campo | Pergunta que ele responde |
|---|---|
| 01. Contexto da demanda | O que aconteceu para esta comunicação ser necessária agora? |
| 02. Objetivo | O que precisa gerar ou tornar claro para o público? |
| 03. Público prioritário | Para quem? (slug de `publicos[]`, com dor e objeção) |
| 04. Direcionamento estratégico | O que ganha protagonismo nesta demanda? |
| 05. Mensagem que queremos sustentar | A ideia principal que o público deve compreender |
| 06. Docs para consulta | Quais docs de produto são obrigatórios e quais complementares |
| 07. Materiais complementares | Apresentações, dados, demonstrações, telas a considerar |

3. **Gate da Leitura Cruzada — antes de perguntar qualquer coisa ao decisor.** Fontes: `contexto/produtos/<slug>/<slug>.md` (dor, promessa, públicos, módulos) · `times/{{time.slug}}/docs/criatividade-<slug>.md` · `times/{{time.slug}}/docs/benchmarks-canal.md` · índice de provas de cliente, se existir. Sempre do produto da campanha, nunca de todos.
   - **A. Cadeia dor → público → produto → prova:** [dor específica] → [público que a sente, com a objeção do config] → [módulo ou produto que resolve] → [prova: promessa, dado ou tela].
   - **B. Match com o direcional:** onde 01–07 já é sustentado por benchmark, sazonalidade ou resultado de campanha parecida; onde há lacuna ou divergência que só o decisor resolve.
   - **C. Correlações na base:** produto e telas · conteúdo já publicado · **prova de cliente** (consulta obrigatória; não achar é resposta válida — "sem prova de cliente para esta dor, lacuna para conteúdo"). Item vazio é declarado, nunca omitido.
   Tudo aqui é leitura e sugestão — **não decide** estratégia, canal, período ou meta.
4. **Gate do complemento (08–10) — perguntar, não assumir.** Antes de escrever qualquer linha em 08 (estratégia), 09 (canais) e 10 (observações), perguntar ao decisor: estratégia, canais, **período de veiculação** e **meta numérica**. Sem resposta → `[PENDENTE — aguardando definição]`, nunca inferido nem herdado de campanha parecida. Depois da resposta, complemento marcado `[proposta IA]` só como adição, sempre com fonte.
5. **Checagem de Suficiência:** a dor está específica? o público está amarrado à dor e ao módulo? a mensagem-chave (05) tem prova concreta nomeada (dado, tela ou prova de cliente)? ficou algum `[PENDENTE]`? Conclusão: "argumentação suficiente para produzir" ou "lacuna em [X] — recomendo completar". Sinalizar no chat; não trava, mas não fecha calado.
6. **Perguntar sempre:** (a) **cronograma de pautas** — tabela semana a semana (pauta · ângulo · canal · prova que sustenta · de qual campo vem); toda linha remete a um campo ou à Leitura Cruzada, nunca pauta sem base; (b) **pitch de pré-vendas** — condensação em linguagem de cliente: rastreio (origem, identificador, página) · contexto · proposta de valor · 3–5 argumentos · públicos (cargo + contexto + dor) · mensagem-chave · criativo principal. Ambos opcionais e independentes.
7. **Registrar** no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}; `requires` do briefing declara o doc do produto e o índice de provas para o Redator abrir junto.

### B. Plano integrado do ciclo

Skill de **regência**: não recalcula o que outra skill já faz — puxa cada fatia e consolida. Se estiver recalculando forecast, meta ou custo por lead aqui, parou de orquestrar.

| Bloco | O que entra | Fonte |
|---|---|---|
| **0. Ponto de partida** | Fechamento do ciclo anterior (resumo, aprendizados, accountability das ações) + forecast e gap de pipeline | `analisar-performance` (Analista){{#if integracao:dados}} · base integrada via `consultar-dado`{{/if}} |
| **1. Direção do ciclo** | 2–3 hipóteses priorizadas (segmento × mensagem × canal × métrica); públicos e estágio; ajuste por sazonalidade | esta skill, com `benchmarks-canal` |
| **2. Metas e orçamento** | Meta por etapa do funil, de trás para frente a partir da meta de negócio; distribuição de verba por canal (próprio, pago, emprestado) | decisor + `benchmarks-canal`; gap `[NECESSITA FONTE]` → metas pendentes, sem fabricar |
| **3. Insumos para quem vende** | Ficha de contexto por campanha, objeções esperadas (`publicos[].objecao` + doc do produto), próximo passo — linguagem de abordagem, não de marketing | doc do produto |
| **4. Riscos e acompanhamento** | Riscos, dependências entre frentes, checagens (meio e fim do ciclo contra este plano) | esta skill |

**Protocolo de dado faltante:** {{#if integracao:dados}}tentar a base integrada → registrar data da extração; indisponível → perguntar ao usuário; sem resposta → {{else}}perguntar ao usuário (não há base integrada); sem resposta → {{/if}}`[NECESSITA FONTE]` e plano qualitativo (direção, prioridades, insumos), com metas numéricas pendentes. Nenhum número entra sem origem.

**Ritual:** fechamento do ciclo anterior → forecast, direção e metas → montagem do plano → apresentação e alinhamento com vendas e produto no primeiro dia útil. O calendário de execução vive no registro, não neste documento.

## Checklist

- [ ] Campos 01–07 colados sem edição, cada um com "em uma frase"?
- [ ] Leitura Cruzada preenchida antes de acionar o decisor, com fonte em cada item e prova de cliente consultada?
- [ ] 08–10 só com resposta do decisor; pendências marcadas; complemento `[proposta IA]` só como adição?
- [ ] Checagem de Suficiência respondida e lacuna sinalizada no chat?
- [ ] Cronograma de pautas e pitch oferecidos?
- [ ] Plano do ciclo: nenhum número recalculado aqui; toda meta com origem; accountability do ciclo anterior aberta?
- [ ] Nome do arquivo na taxonomia; destino no registro, nunca na documentação?

## Output esperado

- **Briefing de campanha** completo (01–10 + Leitura Cruzada + Checagem de Suficiência), pronto para o registro; cronograma de pautas e pitch quando pedidos.
- **Plano integrado do ciclo** (blocos 0–4) em `.md` ou deck + bloco "para quem vende" + lista de pendências.
- Toda incerteza marcada: `[VALIDADO]` · `[INFORMADO PELO CLIENTE]` · `[PENDENTE DE CONFIRMAÇÃO]` · `[NECESSITA FONTE]`.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "estrategista"}} |
