---
tipo: skill
id: analise-motivos-de-perda
descricao: "Investiga onde e por que o funil perde: taxonomia de motivos, coleta por safra e estágio, cruzamento com origem e público, escuta do time e plano de ação."
familia: ANALISAR.perdas
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["motivos de perda", "por que perdemos esse negócio", "taxonomia de motivos de perda", "perdas por estágio", "o concorrente está ganhando", "entrevista com negócio perdido", "onde o funil de vendas vaza", "padrão nas perdas do trimestre"]
requires: lider-vendas · estagios-pipeline
owner: {{papel "lider-vendas"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Líder de Vendas** (`lider-vendas`), que carrega o gate (`_cortex/kernel/gate.md`) e a definição oficial de estágios antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Líder antes de analisar.**

# Análise de motivos de perda — taxonomia, coleta e leitura

O motivo registrado raramente é o motivo real: "sem retorno" e "sem interesse" são atalhos. Esta skill define a **taxonomia** que o time usa, organiza a **coleta** (registro + escuta do time + conversa com quem não comprou) e faz a **leitura** por safra, estágio, origem e público — terminando em duas ou três causas-raiz com ação, dono e prazo.

## Contexto de uso

- Conversão caindo por mais de um ciclo de leitura.
- Análise periódica do ciclo ({{operacao.ciclo_planejamento}}), mesmo sem queda.
- Antes de mudar critério de qualificação, cadência ou matriz de objeções.
- Suspeita de concorrente ganhando espaço ou de lacuna de produto.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Período (por data de criação do negócio, não da perda) | sim |
| Export de negócios perdidos com estágio, motivo, origem, público, produto, dono | sim |
| Taxa de passagem esperada por estágio (do histórico ou meta) | sim |
| Acesso ao time (prospectadores e executivos) para escuta | não |
| Contas perdidas recentes para conversa de aprendizado | não |

**Fonte:** {{#if integracao:crm}}a integração de CRM definida em `cortex.config.yaml`, read-only, com data da extração{{else}}sem CRM integrado no config, o export vem do usuário e entra `[INFORMADO PELO CLIENTE]`{{/if}}{{#if integracao:dados}}; a integração de dados complementa com histórico por safra{{/if}}.

## Processo

### 1. Taxonomia de motivos (a do time; sem ela, usar esta como ponto de partida)

| Família | Motivos | Lido junto do estágio, indica |
|---|---|---|
| **Contato** | tentativas esgotadas · dado de contato inválido · não pediu contato | velocidade e disciplina de cadência, qualidade do formulário, origem |
| **Perfil** | fora do perfil ideal · sem maturidade · porte inadequado | critério de qualificação ou segmentação da origem |
| **Necessidade** | sem dor · já resolveu de outro jeito | fit; mensagem da origem |
| **Timing** | sem gatilho agora · orçamento em outro ciclo · projeto adiado | nutrição; sazonalidade |
| **Decisão** | decisor não mapeado · comitê travou · campeão saiu | diagnóstico incompleto |
| **Valor / preço** | caro para o valor percebido · sem verba | sustentação de valor; proposta |
| **Concorrência** | escolheu alternativa · ficou com o atual | prova, relacionamento, lacuna |
| **Produto** | funcionalidade ausente · integração inexistente · implantação pesada | lacuna real → produto |
| **Processo nosso** | follow-up abandonado · proposta à pessoa errada · demonstração genérica | execução comercial |

Regra: um motivo por negócio, da taxonomia; campo livre para o detalhe. "Sem retorno" é sintoma — obriga a escolher a família de **Contato** ou **Timing** com evidência.

### 2. Qualidade do registro

Percentual de perdidos com motivo preenchido e específico. Baixo preenchimento **já é o primeiro achado** e a primeira ação.

### 3. Leitura — sempre por safra e por estágio

1. Distribuição de motivos por estágio (do doc `estagios-pipeline`): o mesmo motivo significa coisas diferentes na prospecção e na negociação.
2. Motivo × **origem** (canal, campanha, lista): perdas concentradas numa origem são problema de geração, não de vendas.
3. Motivo × **público** e **produto** ({{#each produtos as p}}`{{p.slug}}` {{/each}}): média entre produtos esconde o padrão.
4. Motivo × **dono**: um dono muito acima dos demais → abordagem e treinamento; todos parecidos → problema sistêmico.
5. Concentração: as poucas famílias que explicam a maior parte das perdas são as que merecem ação; o resto é registro.

Pergunta central: o negócio foi perdido porque **não tinha o problema** (qualificação) ou porque tinha e **não se convenceu** (processo de venda)?

### 4. Escuta do time

Conversas curtas com quem prospecta e com quem fecha: "qual a razão mais comum quando não avança?" · "que tipo de lead você já sabe que não converte?" · "qual objeção você ainda não sabe responder?" · "o que o concorrente diz que não conseguimos rebater?". Percepção é calibrada com o dado — percepção de uma pessoa sem padrão no dado é hipótese, não achado.

### 5. Conversa com quem não comprou (quando possível)

Negócios com fit, com interação real, perdidos recentemente. Conversa de aprendizado, não de recuperação: o que motivou a busca · o que pesou · o que faltou · o que usam hoje. Registrar as **frases exatas** por família — alimentam a matriz de objeções e os scripts.

### 6. Causas-raiz e plano

Separar problema de geração (perfil errado, mensagem errada, critério permissivo) de problema de venda (decisor errado, demonstração genérica, follow-up abandonado, proposta sem valor) e de problema de produto (lacuna com evidência quantificada). Formular como hipótese testável: "acreditamos que [parte] das perdas em [estágio] ocorre por [causa]; se [ação], esperamos [efeito] em [prazo]".

| Causa | Ação | Dono | Prazo | Métrica de sucesso | Doc a atualizar |
|---|---|---|---|---|---|
| | | | | | `dicionario-qualificacao` · `matriz-objecoes` · `estagios-pipeline` · cadência · produto |

### 7. Apresentar e acompanhar

Contexto e volume → padrões com dado → causas-raiz separadas por tipo → plano. Revisão ao fim do prazo das ações; aprendizado registrado no doc correspondente com aprovação humana. Fechar o loop com o time ouvido: "você disse isso, o dado confirma, isto é o que muda".

## Regras

- Período por data de criação; nunca misturar safras.
- Motivo lido junto do estágio; nunca motivo isolado.
- Padrão, não caso: concentração, recorrência, desvio. Volume mínimo definido pelo time.
- Lacuna de produto chega a produto como evidência quantificada, nunca como reclamação.
- Nenhuma faixa externa como referência sem `[BUSCADO: fonte + ano]`.
- Contas anonimizadas; dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem para prompt externo.

## Checklist

- [ ] Safra, estágios e recorte definidos?
- [ ] Qualidade do preenchimento medida e reportada?
- [ ] Cruzamentos por estágio, origem, público, produto e dono?
- [ ] Escuta do time calibrada com dado?
- [ ] Duas ou três causas-raiz como hipóteses testáveis?
- [ ] Plano com dono, prazo, métrica e doc a atualizar?
- [ ] Frases do cliente registradas para matriz e scripts?

## Output esperado

| Saída | Formato |
|---|---|
| Diagnóstico de perdas | documento: período, volume, padrões com dado, causas-raiz |
| Taxonomia (se criada ou revisada) | tabela, para ratificação |
| Plano de ação | tabela com dono, prazo, métrica |
| Banco de frases | por família, com fonte e frequência |
| Insumo para outros times | lista: qualificação, objeções, cadência{{#if pack:marketing}}, marketing{{/if}}{{#if pack:cs}}, sucesso do cliente{{/if}}, produto |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "lider-vendas"}} |
