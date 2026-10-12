---
tipo: skill
id: descoberta
descricao: "Completa lacunas materiais do briefing, preservando decisões, fontes e autorizações já fornecidas."
familia:
output: briefing
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que preciso perguntar antes de produzir", "faz a descoberta comigo", "quais as perguntas obrigatórias", "não sei o que informar no briefing", "levanta o briefing", "monta o briefing dessa tarefa"]
requires: entrevistador · gate · anti-alucinacao
owner: cortex
origem: kernel
validado_em: 2026-10-04
---

# Descoberta — completar o briefing antes de produzir

Confira primeiro o pedido, o briefing e as decisões existentes. Investigue lacunas que mudem a execução. A suficiência do contexto rege a passagem à produção, conforme `_cortex/kernel/gate.md` §3.

## Contexto de uso

Acionar **antes de produzir** quando a demanda for de criação ou estratégia: peça de qualquer canal, campanha, página, e-mail, post, anúncio, arte, conteúdo ou pauta, análise com decisão a tomar, posicionamento de oferta, plano de conta.

**Isenção — fonte única desta regra:** consultas read-only (família CONSULTAR) — consultar um produto, buscar um dado já documentado, tirar uma dúvida de marca. Nesses casos, responder direto, sem transformar a consulta em interrogatório. Tarefas operacionais (OPERAR, REGISTRAR, DOCUMENTAR, GOVERNAR) usam a crítica leve de `gate.md` §1.1 e o briefing próprio do agente, não esta skill.

**Como acionar:** via Maestro → Entrevistador (`_cortex/kernel/entrevistador.agent.md`), automaticamente — o agente não espera a pessoa pedir a descoberta; ou direto, quando a pessoa pede *"monta o briefing de [tarefa]"*.

> Marcadores de incerteza a aplicar durante e depois da entrevista: `_cortex/kernel/anti-alucinacao.md` §4.1. Números e fatos institucionais citados na entrevista só valem com fonte válida (ficha do produto, site oficial, material do cliente) — sem fonte, `[NECESSITA FONTE]`.

---

## Processo

### 1. Protocolo de entrevista

1. Classifique a tarefa e consulte o banco pertinente.
2. Preencha os campos com o que já foi informado ou documentado; preserve a origem.
3. Pergunte somente o que falta e muda a entrega, em uma rodada curta com opções úteis.
4. Avance no trabalho independente enquanto a informação essencial não chega. Para escolhas reversíveis, proponha uma hipótese explícita.
5. Consolide o contexto; use o cartão quando ajudar. Reaproveite a aprovação já existente, sem pedir confirmação duplicada.

### 2. Núcleo anti-genérico — conferir quando pertinente

Estas são as perguntas que separam peça específica de peça genérica. **Pergunte apenas pelos campos pertinentes ainda ausentes:**

| # | Pergunta | Por que muda a peça |
|---|---|---|
| 1 | **Ângulo / ideia central:** qual é a ideia, em uma frase? O que esta peça diz que ninguém mais diz? | Sem ângulo, o texto vira correto e invisível |
| 2 | **Prova concreta:** que dado, case ou fonte sustenta o argumento? (ou: não há prova ainda) | Especificidade vence generalidade; sem prova, vira promessa vaga |
| 3 | **A única coisa que não pode faltar** nesta peça | Define a prioridade quando algo precisa ser cortado |
| 4 | **O que NÃO pode aparecer** (tema, palavra, abordagem, concorrente) | Evita retrabalho e desvio de marca |
| 5 | **Referência que você admira** (uma peça ou empresa cujo tom você quer) | Calibra tom melhor que qualquer adjetivo |
| 6 | **Nível de consciência do público** sobre o problema e a solução | Define quão direto ou educativo é o texto |
| 7 | **Restrições** (extensão, prazo, formato, obrigatórios) | Evita entrega fora do que era possível usar |

### 3. Bancos de perguntas genéricos

> Campos em **negrito** são referências de suficiência quando se aplicarem à tarefa. Some o núcleo anti-genérico pertinente. **Os bancos por canal** (e-mail, social, página, mídia paga, arte, roteiro…) **vivem no pack**, em `times/<time>/docs/descoberta-bancos.md` — este arquivo guarda só os bancos que não dependem de canal.

**Planejamento (campanha, plano, experimento, evento)**
**Objetivo de negócio + indicador** · **público / persona** · **oferta da demanda** (§4) · **marca que assina e que divulga** · janela e prazo · verba disponível · canais pretendidos · etapa do funil · o que define sucesso · restrições.

**Análise (resultado, funil, atribuição)**
**Período** · **canal(is)** · **pergunta de negócio / decisão que depende disso** · recorte (oferta, origem, segmento) · métricas de interesse · fonte do dado (doc da base ou conector — e a ficha `contexto/integracoes/<slug>.md`).

**Posicionamento / oferta (como falar de um produto, serviço, evento ou conteúdo)**
**Oferta** · **perfil / cargo do público** · **objetivo** (educar, converter, abrir conversa) · canal de destino · contexto da conversa (objeção, lançamento, comparação).

**Operação (base de contatos, automação, integração)**
**Sistema envolvido** (ficha em `contexto/integracoes/<slug>.md`) · **ação esperada** (importar, higienizar, disparar, integrar) · **o que não pode acontecer** (duplicar, sobrescrever, disparar automação) · volume · critério de aceite · quem valida antes de executar.

### 4. A oferta da demanda

`produto: todos` declara abrangência da skill. Não obriga perguntar se a oferta já consta do pedido ou do briefing. Se a tarefa depende de uma oferta e há ambiguidade material, pergunte qual. Em manutenção ou conteúdo sem oferta, marque não aplicável. Não carregue todas as fichas nem invente um produto padrão.

**Ordem de leitura da documentação de produto.** Definida a oferta, abre-se **o doc-raiz dela primeiro**: `contexto/produtos/<slug>/<slug>.md`. Os arquivos filhos — módulos, concorrência, lançamentos, lentes por público — só entram **se a resposta não estiver na raiz**. Isso evita carregar vinte documentos para responder o que está no primeiro.

### 5. Regras

- Não invente fatos, números, provas, depoimentos ou crenças.
- Diferencie preferência confirmada de hipótese criativa proposta pelo especialista.
- Reaproveite decisões e autorização dentro do mesmo escopo.
- Aplique os marcadores de incerteza de `_cortex/kernel/anti-alucinacao.md`.
- Consulte diretamente em pedidos read-only e use descoberta proporcional nas demais tarefas.

## Output esperado

Este é o modelo canônico de resumo para tarefas complexas ou passagem entre skills. Um pedido ou briefing equivalente já fornecido dispensa repetir o cartão. Preencha campos aplicáveis e preserve as fontes. Use “não aplicável” quando pertinente; não rotule hipótese ou fato pendente como validado. Persistir em `briefings/` depende do destino solicitado.

```
BRIEFING VALIDADO ✅ — [tipo de tarefa]
- Objetivo:
- Marca que assina / que divulga:
- Público / persona (cargo + dor):
- Oferta / tema central:
- Ângulo (ideia central):
- Prova concreta (dado/case/fonte):
- Canal e formato:
- Nível de consciência / etapa do funil:
- O que NÃO pode aparecer:
- Referência de tom:
- Critério de sucesso (como saber que ficou bom):
- Restrições:

Fontes — da pessoa: […] | de fonte confiável: […] | ausente/pendente: […]
Marcadores: [VALIDADO] / [INFORMADO PELO CLIENTE] / [PENDENTE DE CONFIRMAÇÃO] / [NECESSITA FONTE] / [BUSCADO: fonte] / [CONECTOR: sistema · data]
```

> Lacuna essencial bloqueia a etapa dependente. As demais etapas continuam; não peça nova aprovação do que já foi autorizado.

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-04 | Descoberta proporcional com reaproveitamento de briefing e autorização. | cortex |
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
