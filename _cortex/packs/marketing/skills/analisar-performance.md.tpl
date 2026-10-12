---
tipo: skill
id: analisar-performance
descricao: "Entrega o diagnóstico de performance por canal e o relatório do ciclo com narrativa executiva — resultado, funil, causas, aprendizados e próximas ações."
familia: ANALISAR.performance
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["performance dos canais", "relatório mensal de marketing", "onde cortar verba", "onde ampliar verba", "motivos de descarte", "resultado do mês para a liderança", "diagnóstico do canal", "fechamento do mês de marketing", "por que o canal caiu"]
requires: analista
owner: {{papel "analista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista** (`analista`), que carrega o gate (`_cortex/kernel/gate.md`), as faixas de referência e a definição de funil antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Analista antes de analisar.**

# Analisar performance — canais e relatório do ciclo

Duas entregas: **(A) diagnóstico por canal** — qual canal gera demanda qualificada, qual consome verba sem converter e o que muda no próximo período; **(B) relatório do ciclo** com narrativa executiva para a reunião de resultado. Não é compilado de números: é diagnóstico com causa, aprendizado e decisão.

## Contexto de uso

- Análise periódica de performance por canal; decisão de cortar ou ampliar verba; rebalancear o mix.
- Preparação do relatório para liderança de marketing{{#if modelo_comercial:B2B}}, vendas e produto{{/if}}.
- Queda ou alerta num canal; pós-evento (inscrições, comparecimento, leads).
- Histórico de performance e accountability sobre as ações do ciclo anterior.

## Briefing mínimo

Período · canal(is) · **pergunta de negócio** (qual decisão depende disso) · recorte (produto, origem) · métricas de interesse. Sem a pergunta de negócio, perguntar.

**Fonte do dado** — nenhum número entra sem origem:
{{#if integracao:dados}}- Base integrada (`integracoes[]` com `tipo: dados`), via `consultar-dado`, read-only, com data de extração registrada.
{{/if}}{{#if integracao:crm}}- CRM integrado: funil, etapas, motivos de descarte — pela definição oficial dele.
{{/if}}{{#if integracao:automacao-mkt}}- Automação de marketing: abertura, clique, bounce, descadastro.
{{/if}}- Dado fornecido pelo usuário (export, planilha, print) → `[INFORMADO PELO CLIENTE]`.{{#if integracao:dados}}{{else}} Esta organização não tem base integrada: **toda** análise parte de dado fornecido.{{/if}}
- Faixas de referência: `times/{{time.slug}}/docs/benchmarks-canal.md`. Sem dado próprio preenchido, `[NECESSITA FONTE]` — nunca número de mercado sem `[BUSCADO: fonte]`.

## Processo

### A. Diagnóstico por canal

**Entradas:** volume por etapa do funil e por canal · custo por canal · motivos de descarte · metas do período · histórico de 12 meses (se houver).

**Etapa 1 — Coletar e validar.** Confirmar que a atribuição de canal está configurada (lead sem canal distorce); agrupar descartes por canal e categoria; conferir que todos os números vêm da mesma fonte ou que as diferenças estão explicadas.

**Etapa 2 — Escrever a narrativa antes de montar o deck.** Qual canal surpreendeu e por quê? Qual está pior do que deveria — campanha, segmentação, oferta ou abordagem de vendas? Quais 2–3 mudanças teriam maior impacto?

**Etapa 3 — Estrutura fixa (não reorganizar):**

| # | Bloco | Conteúdo |
|---|---|---|
| 1 | Capa e contexto | Período, responsável, uma linha do que foi o ciclo |
| 2 | Funil consolidado | Volume por etapa, meta vs. realizado, taxa entre etapas, comparativo com o período anterior. Verde acima da meta · vermelho abaixo · cinza dentro da tolerância |
| 3 | Meta vs. realizado por canal | Ordenado por volume. Canais: {{#each canais as c}}`{{c.slug}}` {{/each}}+ os que o CRM reconhecer (orgânico, direto, indicação, vendas ativa) |
| 4 | Qualidade por canal | Taxa de passagem para a próxima etapa · custo por lead · **custo por lead qualificado** (verba ÷ leads que avançaram — a métrica mais honesta) · índice de qualidade (taxa do canal ÷ média × custo médio ÷ custo do canal) |
| 5 | Campanhas do período | Nome, canal, objetivo, leads, custo, taxa, status; melhor e pior com uma linha de análise |
| 6 | Motivos de descarte por canal | Perfil fora do ICP (**segmentação**) · cargo sem decisão (**targeting**) · timing · concorrência · sem retorno (velocidade e abordagem) · já é cliente (base). Maioria dos descartes por "fora do ICP" → problema de segmentação, não de conversão |
| 7 | Evolução anual | Volume e taxa por canal nos últimos 12 meses; queda consistente pede investigação, não verba |
| 8 | Diagnóstico e recomendações | **O bloco mais importante.** Até 4, por impacto: observação + diagnóstico + ação + impacto esperado + responsável e prazo. Se não muda o comportamento do time, o relatório falhou |

**Causa raiz — árvore de decisão antes de recomendar:**
```
Canal abaixo da média
├── Taxa de passagem baixa (abaixo do piso histórico do time)? → QUALIDADE DO LEAD
│     → descartes por "fora do ICP" dominam? → SEGMENTAÇÃO da campanha (não vendas)
│     → não? → mensagem × expectativa do lead
├── Volume baixo, taxa ok? → ESCALA (verba, frequência esgotada, audiência pequena)
├── Tráfego ok, lead baixo? → CONVERSÃO DA PÁGINA → redator-lp / Estrategista
└── Tudo ok, custo alto? → calcular custo por lead QUALIFICADO antes de concluir
```
Complemento: ângulo do criativo (dor, resultado, prova, curiosidade, urgência) alinhado à origem esperada? Mais de 3 ângulos testados no trimestre? A maioria das "quedas de canal" é queda de ângulo ou de segmentação.

**Boas práticas:** custo por lead sozinho não é qualidade · volume alto com conversão baixa é segmentação errada · motivo de descarte é dado de campanha, não de vendas · não escalar canal que não se entende.

### B. Relatório do ciclo — 7 blocos, ordem deliberada

Começa pelo resultado de negócio e termina com decisão; quem lê entende a história antes do detalhe.

| # | Bloco | Regra |
|---|---|---|
| 0 | **Accountability** | Ações do ciclo anterior: executada · parcial · não executada + resultado observado. Abertura obrigatória |
| 1 | **Resumo executivo** | 3–5 linhas em linguagem de negócio: o que o ciclo significou e o principal ponto de atenção |
| 2 | **Resultado de negócio** | Vendas, receita nova ou o resultado que o negócio acompanha — meta, realizado, variação vs. meta e vs. anterior |
| 3 | **Funil** | Volume **e** taxa entre cada etapa (volume sem taxa esconde qualidade; taxa sem volume esconde escala). Verificar sazonalidade antes de concluir queda ou alta |
| 4 | **Por canal** | Leads, custo, taxa, variação, status |
| 5 | **Causa e contexto** | Para cada desvio relevante (2–3): métrica · direção · magnitude · causa provável · evidência que sustenta |
| 6 | **Aprendizados** | O que muda a forma de trabalhar — diferente de causa (explica o passado) · aprendizado **muda o futuro**. Sem aprendizado claro é um dado: o ciclo rodou no piloto automático. Cada linha vira proposta de registro em `benchmarks-canal`, com aprovação humana |
| 7 | **Próximas ações** | Até 5, com origem, dono, prazo e métrica de sucesso |

**Preparação:** começar a coleta antes do fechamento · validar consistência entre fontes (número diferente na mesma reunião destrói credibilidade) · responder por escrito as 3 perguntas (o que aconteceu em uma frase · por quê · o que muda) · no máximo 10 páginas · linguagem sem jargão (a leitura inclui quem não é de marketing) · enviar com 24 h de antecedência com uma linha de contexto e os pontos de decisão · na reunião, abrir pelo resumo, usar dados só para sustentar, reservar o fim para decisão.

**Linguagem por audiência:** liderança → "o canal X consumiu [parte] da verba e gerou [parte] dos leads qualificados; realocar" · vendas → "os leads que não avançaram tinham perfil fora do ICP; segmentação" · marketing → "o assunto em pergunta abriu mais; repetir". Específico > vago; causa antes de solução; uma conclusão por bloco.

### Recorte de evento

Funil visitas → inscritos → comparecimento → leads → próxima etapa · engajamento (tempo, perguntas, enquetes) · custo por inscrito e por lead · comparação com eventos anteriores · recomendação de formato e tema.

## Checklist

- [ ] Pergunta de negócio definida? Fonte de cada número registrada (base, CRM, usuário)?
- [ ] Narrativa escrita antes do deck? Estrutura na ordem fixa?
- [ ] Custo por lead qualificado calculado antes de julgar custo? Descartes por categoria?
- [ ] Sazonalidade e histórico considerados antes de concluir?
- [ ] Causa com evidência; aprendizado separado de causa; até 4–5 ações com dono e prazo?
- [ ] Accountability do ciclo anterior aberta? Dados sensíveis anonimizados?
- [ ] Aprendizado proposto para `benchmarks-canal` com aprovação, não gravado sozinho?

## Output esperado

| Saída | Formato |
|---|---|
| Diagnóstico por canal (8 blocos) | deck ou documento |
| Relatório do ciclo (0–7) | deck ou documento, ≤ 10 páginas |
| Análise de motivos de descarte | tabela por canal |
| Plano de ação | tabela: ação · origem · dono · prazo · métrica |
| Follow-up da reunião | texto: decisões, donos, prazos |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}; marcadores de incerteza em todo número sem fonte.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "analista"}} |
