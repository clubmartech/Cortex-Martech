---
tipo: skill
id: pesquisa-satisfacao
descricao: "Desenha e lê pesquisas de satisfação (NPS e CSAT): pergunta, momento e cadência, canal, leitura por segmento, tratamento de comentários e fechamento de loop."
familia: ANALISAR.satisfacao
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["pergunta do NPS", "pesquisa de CSAT", "quando enviar a pesquisa de satisfação", "ler o resultado do NPS", "fechar o loop com o detrator", "cadência da pesquisa", "comentários da pesquisa", "promotores e detratores"]
requires: gestor-sucesso · jornada-cliente
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a jornada e o dado disponível antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de desenhar ou ler a pesquisa.**

# Pesquisa de satisfação — NPS e CSAT

Dois instrumentos, dois usos: **NPS** (relacionamento: "recomendaria?") mede a relação ao longo do tempo, em cadência fixa por etapa da jornada; **CSAT** (transação: "como foi?") mede um atendimento, um onboarding, um treinamento, logo após o evento. O número importa menos do que o **comentário** e do que o **fechamento de loop**: pesquisa sem resposta ao cliente ensina que não vale responder.

## Contexto de uso

- Definir ou revisar o programa de pesquisa (perguntas, momentos, canais).
- Ler o resultado de um ciclo e decidir ações.
- Tratar detratores e promotores individualmente.
- Alimentar o `health-score` e a `escuta-de-cliente`.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Instrumento (NPS · CSAT) e objetivo | sim |
| Momento da jornada ou evento disparador | sim |
| Canal de envio ({{#each canais as c}}`{{c.slug}}` {{/each}}in-app) | sim |
| Base ou segmento; volume esperado | sim |
| Resultados anteriores (se houver), com fonte | não |
| Quem fecha o loop por faixa | sim, na leitura |

**Fonte dos resultados:** {{#if integracao:dados}}integração de dados definida em `cortex.config.yaml`{{else}}export da ferramenta de pesquisa fornecido pelo usuário, `[INFORMADO PELO CLIENTE]`{{/if}}{{#if integracao:automacao-mkt}}; envio pela integração de automação de marketing quando o canal for e-mail ou mensageria{{/if}}.

## Processo

### 1. Desenhar

| Elemento | NPS | CSAT |
|---|---|---|
| Pergunta principal | "De 0 a 10, quanto você recomendaria {{marca_mae.nome}} / [produto] a alguém com um desafio parecido?" | "Como foi [evento] hoje?" em escala curta |
| Pergunta aberta (obrigatória) | "O que mais pesou na sua nota?" | "O que poderíamos ter feito melhor?" |
| Momento | fim do onboarding · a cada ciclo definido · antes da janela de renovação | logo após o atendimento, treinamento ou marco |
| Cadência | fixa por etapa da `jornada-cliente`; nunca duas em menos de `[PENDENTE: definir intervalo]` | por evento, com limite por cliente no período |
| Quem responde | patrocinador e usuários-chave | quem viveu o evento |
| Canal | o de maior resposta do cliente | o canal do evento |
| Anonimato | identificado (para fechar o loop), dito claramente | identificado |

Pergunta curta, sem viés ("quanto você gostou" induz). Nunca pedir nota "boa"; nunca condicionar benefício à resposta.

### 2. Enviar e acompanhar

Convite curto com o motivo e o tempo estimado; um lembrete; taxa de resposta registrada por segmento. Taxa baixa é dado: revisar canal, momento e tamanho.

### 3. Ler

| Leitura | Como |
|---|---|
| Distribuição | promotores · neutros · detratores (ou faixas do CSAT), por produto, segmento, etapa, tempo de casa |
| Tendência | contra o ciclo anterior, mesma base — nunca contra benchmark externo sem `[BUSCADO: fonte + ano]` |
| Comentários | agrupar por tema (produto · atendimento · onboarding · valor · relacionamento · preço); frases exatas para o banco |
| Cruzamento | nota × uso × tickets × faixa de saúde: detrator saudável e promotor em risco são os casos a investigar |
| Volume mínimo | abaixo do definido pelo time, segmentar menos ou tratar como qualitativo |

### 4. Fechar o loop (em prazo definido pelo time)

| Faixa | Ação | Dono |
|---|---|---|
| Detrator | contato individual em até `[PENDENTE: prazo]`: ouvir, reconhecer, ação concreta; registrar na `matriz-risco-churn` | Gestor de Sucesso |
| Neutro | agradecer; perguntar o que faltou para a nota subir | Gestor ou Atendente |
| Promotor | agradecer; perguntar se aceitaria contar a experiência (prova, indicação) — sem pressão | Gestor{{#if pack:marketing}} → marketing para prova social, com consentimento{{/if}} |
| Todos | comunicado de "o que ouvimos e o que vamos mudar" ao fim do ciclo | Gestor |

### 5. Alimentar

Nota e comentário entram no `health-score` (dimensão satisfação); temas vão para `escuta-de-cliente`; lacunas de produto chegam a quem cuida do produto com evidência.

## Regras

- Pergunta aberta sempre; o comentário vale mais que a nota.
- Identificado e transparente; nunca condicionar benefício.
- Cadência respeitada; cliente não é pesquisado em cima de incidente ou de ticket aberto.
- Leitura por segmento e tendência própria; benchmark externo só referenciado com fonte.
- Loop fechado em prazo, com registro; detrator sem contato é falha, não pendência.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Instrumento, momento, canal e base definidos?
- [ ] Pergunta sem viés + pergunta aberta?
- [ ] Taxa de resposta registrada por segmento?
- [ ] Leitura por segmento e tendência; comentários agrupados por tema com frases exatas?
- [ ] Loop fechado por faixa, com dono e prazo?
- [ ] Resultado alimentou health score e escuta?
- [ ] Comunicado de retorno aos clientes ao fim do ciclo?

## Output esperado

| Saída | Formato |
|---|---|
| Desenho da pesquisa | tabela: pergunta, momento, cadência, canal, base |
| Convite e lembrete | textos por canal |
| Leitura do ciclo | distribuição, tendência, temas, cruzamentos, volume |
| Plano de fechamento de loop | lista por cliente: faixa, dono, prazo, status |
| Banco de frases | tema, frase, produto, data |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
