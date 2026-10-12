---
tipo: skill
id: diagnostico-comercial
descricao: "Prepara a reunião de descoberta: hipóteses de dor por público, perguntas abertas, mapa de decisores e critérios de decisão — antes de qualquer proposta."
familia: PLANEJAR.diagnostico-conta
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["perguntas de descoberta", "reunião de diagnóstico com o cliente", "mapear os decisores", "entender a dor do cliente antes da proposta", "roteiro da primeira reunião", "quem decide na empresa do lead", "diagnóstico da conta antes de propor", "critérios de decisão do cliente"]
requires: executivo-vendas · dicionario-qualificacao
owner: {{papel "executivo"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Executivo de Vendas** (`executivo-vendas`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha de qualificação antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Executivo antes de preparar a reunião.**

# Diagnóstico comercial — descoberta e mapa de decisores

A reunião de diagnóstico existe para que a proposta responda a algo que o cliente **disse**, não a algo que a organização supôs. Saída: dor nas palavras dele, impacto, critérios de decisão, quem decide e quem influencia, prazo e orçamento declarados. Sem isso, `proposta-comercial` não roda.

## Contexto de uso

- Preparação da primeira reunião com lead qualificado.
- Segunda reunião quando a primeira não fechou o mapa de decisores.
- Conta cliente em expansão (novo centro de decisão).
- Revisão de diagnóstico de negócio travado.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Ficha de qualificação (`qualificacao-lead`) | sim |
| Público do contato e produto de interesse | sim |
| Participantes confirmados e cargos | sim |
| Formato e duração da reunião | sim |
| Histórico de contatos e o que o lead já viu | sim |
| Sinais da conta (de `sinais-de-compra`) | não |
| Concorrente ou alternativa conhecida | não |

{{#if integracao:crm}}Histórico vem da integração de CRM definida em `cortex.config.yaml` (consulta read-only); dado ausente é `[PENDENTE DE CONFIRMAÇÃO]`.{{else}}Sem CRM integrado no config, o histórico vem do briefing e entra marcado `[INFORMADO PELO CLIENTE]`.{{/if}}

## Processo

### 1. Hipóteses de dor (antes da reunião)

Da dor do público no config e do doc do produto, formular até três hipóteses — nunca uma lista de tudo o que o produto faz:

| Hipótese | Público afetado | Evidência (ficha, sinal, material) | Probabilidade |
|---|---|---|---|

Públicos registrados: {{#each publicos as pu}}**{{pu.nome}}** (dor: {{pu.dor}}) · {{/each}}

### 2. Roteiro de perguntas

Perguntas abertas, em sequência de funil — situação → problema → impacto → critério → decisão:

| Bloco | Exemplo de pergunta | O que anotar |
|---|---|---|
| Situação | "Como funciona hoje [processo ligado à dor]?" | processo, ferramentas, volume |
| Problema | "Onde isso trava? O que acontece quando [consequência]?" | a dor **nas palavras dele** |
| Impacto | "O que isso custa em tempo, dinheiro ou risco? Quem sente?" | impacto declarado, nunca estimado por nós |
| Tentativas | "O que já tentaram? Por que não resolveu?" | alternativas, objeções implícitas |
| Critério | "O que precisa ser verdade para vocês mudarem?" | critérios de decisão, ordem de importância |
| Decisão | "Quem mais participa dessa decisão? Como ela acontece aqui?" | decisores, processo, prazo |
| Investimento | "Há orçamento previsto? Em que faixa?" | só o que ele declarar; `[INFORMADO PELO CLIENTE]` |
| Próximo passo | "Faz sentido eu voltar com [proposta/demonstração] para [pessoas]?" | compromisso com data |

Regra: perguntar, ouvir, espelhar. Apresentação do produto, se houver, vem **depois** do bloco de impacto e só sobre a dor confirmada.

### 3. Mapa de decisores

| Papel | Quem (nome/cargo) | Postura | Dor própria | Próxima ação |
|---|---|---|---|---|
| decisor econômico (assina) | | apoia · neutro · cético · bloqueia | | |
| decisor funcional (dono da área) | | | | |
| avaliador técnico | | | | |
| campeão interno | | | | |
| usuário final | | | | |
| bloqueador potencial | | | | |

Cargo não é papel: confirmar pela conversa. Negócio sem **decisor econômico** e sem **campeão** mapeados não vai para proposta — vai para segunda reunião. Postura muda a cada interação: atualizar.

### 4. Validar o diagnóstico

Fechar a reunião com o resumo verbal ("então o que mais pesa hoje é…") e, em até um dia útil, o e-mail de resumo (`follow-up` § Pós-reunião) pedindo correção. O diagnóstico só vale depois que o cliente confirmou.

### 5. Registrar

Dor, impacto, critérios, decisores, prazo, orçamento declarado e próximo passo {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}; estágio avança conforme `estagios-pipeline`.

## Regras

- Dor nas palavras do cliente; impacto declarado por ele. Estimativa nossa é `[PENDENTE DE CONFIRMAÇÃO]`.
- Sem decisor econômico e campeão mapeados, não propor.
- Não apresentar funcionalidade que não responde a dor confirmada.
- Concorrente: ouvir e registrar; não desqualificar, não comparar sem fonte.
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não vão para prompt externo.

## Checklist

- [ ] Até três hipóteses, com evidência?
- [ ] Roteiro em funil, perguntas abertas?
- [ ] Mapa com decisor econômico e campeão? Lacunas anotadas?
- [ ] Critérios de decisão e prazo registrados?
- [ ] Resumo validado pelo cliente antes da proposta?
- [ ] Estágio e campos obrigatórios atualizados?

## Output esperado

| Saída | Formato |
|---|---|
| Roteiro da reunião | hipóteses + perguntas por bloco |
| Mapa de decisores | tabela com papel, postura, dor, próxima ação |
| Registro do diagnóstico | dor · impacto · critérios · tentativas · prazo · orçamento declarado · próximo passo |
| Lacunas | lista do que ficou `[PENDENTE DE CONFIRMAÇÃO]` e quem responde |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "executivo"}} |
