---
tipo: skill
id: playbook-renovacao
descricao: "Conduz a renovação do contrato: régua por antecedência, leitura de saúde e valor entregue, proposta de renovação, tratamento de risco e registro do resultado."
familia: PLANEJAR.renovacao
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["renovação do contrato", "régua de renovação", "cliente não quer renovar", "preparar a renovação", "antecedência da renovação", "proposta de renovação", "negociar a renovação", "renovação em risco"]
requires: gestor-sucesso · matriz-risco-churn
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a matriz de risco e o plano de sucesso antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de conduzir.**

# Playbook de renovação

A renovação começa muito antes do vencimento: é a conclusão do `plano-de-sucesso`. O cliente renova um **resultado**; a conversa sobre contrato é a última etapa, não a primeira. Este playbook organiza a régua por antecedência, a leitura prévia (saúde, valor entregue, riscos), a proposta de renovação e o que fazer quando a renovação está em risco. Valores e condições vêm do usuário.

## Contexto de uso

- Contratos com vencimento no horizonte da régua.
- Cliente que sinalizou que não quer renovar.
- Renovação com mudança de escopo (redução ou expansão).
- Revisão da régua do time.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Cliente, produto(s), vencimento, modelo de renovação (automática, manual, prazo de aviso) | sim |
| Health score e faixa; gatilhos ativos | sim |
| Plano de sucesso: marcos atingidos e não atingidos | sim |
| Condições comerciais vigentes e autorizadas para a renovação | sim — do usuário, `[INFORMADO PELO CLIENTE]` |
| Decisor da renovação e patrocinador | sim |
| Histórico de tickets e pesquisa recentes | não |

**Fonte:** {{#if integracao:crm}}contrato e vencimento da integração de CRM definida em `cortex.config.yaml`{{else}}sem CRM integrado no config, contrato e vencimento vêm do usuário{{/if}}{{#if integracao:dados}}; uso da integração de dados{{/if}}.

## Processo

### 1. Régua por antecedência (convenção do time)

| Momento | Ação | Dono | Saída |
|---|---|---|---|
| **Longe do vencimento** (`[PENDENTE: definir antecedência]`) | leitura de saúde e do plano de sucesso; classificar a renovação (segura · atenção · risco) | {{papel "cs"}} | classificação registrada; risco já vai à matriz |
| **Preparação** | reunião de resultados (`plano-de-sucesso` § Reunião de resultados); confirmar decisor; levantar mudanças de escopo | {{papel "cs"}} | valor entregue reconhecido pelo cliente; pendências |
| **Proposta** | proposta de renovação (abaixo); apresentar ao decisor | {{papel "cs"}}{{#if pack:vendas}} com Executivo de Vendas se houver reestruturação{{/if}} | proposta enviada com data de decisão |
| **Negociação** | tratar pedidos; condições só dentro do autorizado | {{papel "cs"}} | condições aceitas |
| **Fechamento** | assinatura; registro; plano de sucesso do novo ciclo | {{papel "cs"}} | contrato renovado; plano novo |
| **Pós** | registrar resultado e motivo (renovou · reduziu · expandiu · cancelou) | {{papel "cs"}} | dado para a matriz e a escuta |

Renovação automática não dispensa a régua: o cliente que não percebeu valor cancela depois.

### 2. Classificar a renovação

| Classe | Critério | Caminho |
|---|---|---|
| **Segura** | faixa saudável, marcos atingidos, patrocinador ativo | régua padrão; explorar expansão (`playbook-expansao`) |
| **Atenção** | faixa de atenção ou marco relevante não atingido | plano de recuperação de valor antes da proposta |
| **Risco** | faixa de risco ou gatilho (cancelamento pedido, patrocinador saiu, inadimplência) | ação da matriz de risco hoje; decisor envolvido; proposta só depois de tratar a causa |

### 3. Proposta de renovação

Estrutura: o que combinamos → o que entregamos (marcos com dado e fonte) → o que não entregamos e o que mudamos → o que propomos para o próximo ciclo (objetivos novos do cliente) → escopo e condições `[INFORMADO PELO CLIENTE]` → próximos passos com data. {{#if pack:vendas}}Reestruturação de contrato ou novo escopo comercial: estrutura de `proposta-comercial` do pack de vendas, com o Executivo.{{/if}}

### 4. Renovação em risco — tratamento

Ouvir antes de propor: "o que precisaria ser diferente para fazer sentido continuar?" → separar causa (valor não percebido · uso baixo · produto · atendimento · preço · mudança no cliente) → ação específica por causa, com dono e prazo curto → envolver o decisor com o patrocinador → nova leitura antes de reapresentar. Desconto não trata causa; só entra se autorizado e depois de tratar a causa.

### 5. Cancelamento

Se o cliente decidir sair: conversa de aprendizado (motivo real, nas palavras dele), registro na taxonomia da matriz de risco, transição digna (dados, prazo, acesso) e porta aberta. Motivo vai para `escuta-de-cliente`{{#if pack:vendas}} e, quando aponta expectativa errada na venda, ao Líder de Vendas{{/if}}.

## Regras

- Régua começa pela leitura de valor, nunca pelo contrato.
- Condições comerciais vêm do usuário; a skill não sugere valor nem desconto.
- Risco é tratado na causa antes de qualquer proposta.
- Nenhuma promessa fora do doc do produto para segurar a renovação.
- Resultado e motivo registrados sempre, inclusive quando renova.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Vencimento, modelo de renovação e decisor confirmados?
- [ ] Renovação classificada com base em saúde e plano de sucesso?
- [ ] Reunião de resultados feita antes da proposta?
- [ ] Proposta com valor entregue (dado e fonte) e condições do usuário?
- [ ] Risco tratado na causa, com dono e prazo?
- [ ] Resultado e motivo registrados; plano do novo ciclo iniciado?

## Output esperado

```
RENOVAÇÃO — [cliente] — [produto(s)] — vence em [data] — classe: segura / atenção / risco
Leitura: faixa [..] · gatilhos [..] · marcos atingidos [..] · não atingidos [..]
Decisor: [...] · Patrocinador: [...]

RÉGUA APLICADA
| Momento | Ação | Dono | Data | Status |

PROPOSTA DE RENOVAÇÃO: [estrutura preenchida; condições [INFORMADO PELO CLIENTE]]
TRATAMENTO DE RISCO (se houver): causa → ação → dono → prazo
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
