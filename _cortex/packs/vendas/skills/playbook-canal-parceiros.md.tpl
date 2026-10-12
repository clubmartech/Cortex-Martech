---
tipo: skill
id: playbook-canal-parceiros
descricao: "Estrutura a venda por parceiros: perfil do parceiro, habilitação, registro de oportunidade, regras de conflito, acompanhamento e material mínimo para a revenda."
familia: PLANEJAR.canal-parceiros
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["playbook do parceiro", "como o parceiro vende", "venda por canal indireto", "habilitar o parceiro", "regras de registro de oportunidade", "comissionamento do canal", "conflito de canal", "material para a revenda"]
requires: lider-vendas · estagios-pipeline
owner: {{papel "lider-vendas"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Líder de Vendas** (`lider-vendas`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a definição de estágios antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Líder antes de estruturar.**

# Playbook de canal de parceiros

Vender por parceiro é vender duas vezes: primeiro para o parceiro (por que vale o esforço dele), depois com o parceiro para o cliente final. O playbook define **quem é parceiro**, **como ele é habilitado**, **como a oportunidade é registrada** (e a quem pertence), **como o conflito se resolve** e **o que o parceiro recebe** para vender. Modelo comercial da organização: **{{organizacao.modelo_comercial}}**.

{{#if publico:parceiro}}Públicos do tipo parceiro no config:
{{#each publicos as pu}}{{#if pu.tipo == "parceiro"}}- **{{pu.nome}}** (`{{pu.slug}}`) — dor: {{pu.dor}} · objeção: {{pu.objecao}}
{{/if}}{{/each}}{{else}}Nenhum público do tipo `parceiro` está registrado no config — antes de usar este playbook, cadastrar o perfil do parceiro em `publicos[]` com dor e objeção.{{/if}}

## Contexto de uso

- Estruturar ou revisar o programa de parceiros.
- Habilitar um parceiro novo (onboarding comercial).
- Decidir a quem pertence uma oportunidade disputada.
- Preparar material mínimo para a revenda vender sem a organização na sala.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Tipo de parceiro (revenda, indicação, implantador, integrador) | sim |
| Produtos que o parceiro pode vender | sim |
| Regras comerciais vigentes (comissão, desconto, exclusividade) | sim — do usuário, `[INFORMADO PELO CLIENTE]` |
| Processo atual de registro de oportunidade | sim |
| Volume e desempenho dos parceiros atuais (se houver) | não |

Comissão, margem e desconto **nunca** são sugeridos por esta skill — vêm do usuário.

## Processo

### 1. Perfil do parceiro ideal

Critérios de entrada: segmento que atende · base de clientes compatível com os públicos do config · capacidade de entrega · alinhamento com o tom de {{marca_mae.nome}}. Classificar em níveis (por exemplo: indicação · revenda · revenda com implantação) com direitos e deveres distintos. Parceiro fora do perfil não entra "para testar".

### 2. Habilitação (primeiros ciclos)

| Etapa | Entrega | Critério de conclusão |
|---|---|---|
| Acordo | contrato, regras comerciais, código de conduta | assinado; regras registradas |
| Formação comercial | dor por público, diagnóstico, objeções (versão do parceiro), demonstração | parceiro conduz demonstração sozinho |
| Formação de produto | doc do produto, limites, o que não prometer | avaliação prática |
| Primeiras oportunidades | acompanhamento conjunto nas primeiras negociações | primeira venda registrada |
| Rotina | reunião periódica de pipeline do parceiro | cadência definida |

### 3. Registro de oportunidade e propriedade

Regras mínimas, a ratificar: quem registra primeiro, com evidência de contato, detém a oportunidade por prazo definido · registro exige campos obrigatórios (conta, contato, produto, estágio, data) conforme `estagios-pipeline` · oportunidade já ativa no pipeline direto não pode ser registrada pelo parceiro, e o parceiro é avisado · renovação e expansão de cliente trazido pelo parceiro seguem a regra registrada no acordo. {{#if integracao:crm}}O registro acontece na integração de CRM definida em `cortex.config.yaml`, em pipeline ou campo próprio do canal.{{else}}Sem CRM integrado no config, o registro vive {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}, com os mesmos campos.{{/if}}

### 4. Conflito de canal

| Situação | Regra |
|---|---|
| Dois parceiros na mesma conta | vale o registro mais antigo com evidência; o segundo é avisado |
| Parceiro × venda direta | vale o registro; se simultâneo, decide o Líder com critério registrado |
| Cliente pede para trocar de parceiro | ouvir motivo; decidir pelo interesse do cliente; registrar |
| Parceiro vende fora do perfil ou com promessa fora do doc | advertência; reincidência é saída do programa |

Toda decisão de conflito é registrada com data e critério — a regra evolui pelo registro, não pelo caso a caso.

### 5. Material mínimo para o parceiro

Versões **do parceiro** (não cópias do material interno): resumo de dor por público · roteiro de diagnóstico simplificado (`diagnostico-comercial`) · matriz de objeções do parceiro (`matriz-objecoes`, linhas aplicáveis) · estrutura de proposta (`proposta-comercial`) com os campos comerciais que ele pode preencher · lista do que **não** prometer. {{#if pack:marketing}}Peças de divulgação do parceiro passam pelo pack de marketing, com o brandcenter.{{/if}}

### 6. Acompanhamento

Por parceiro e por ciclo ({{operacao.ciclo_planejamento}}): oportunidades registradas · conversão por estágio (`forecast-pipeline` com recorte de canal) · motivos de perda (`analise-motivos-de-perda`) · satisfação do cliente final{{#if pack:cs}} (pack de CS){{/if}}. Parceiro sem oportunidade registrada por mais de um ciclo entra em plano de reativação ou sai do programa.

## Regras

- Comissão, desconto e exclusividade vêm do usuário; a skill não sugere valor.
- O parceiro não promete o que o doc do produto não diz.
- Oportunidade sem registro não existe para fins de comissão.
- Cliente final nunca fica sem dono: toda conta tem um responsável nomeado (parceiro ou direto).
- Dados de clientes do parceiro seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Perfil e níveis de parceiro definidos com critério de entrada?
- [ ] Habilitação com etapas e critério de conclusão?
- [ ] Regras de registro e propriedade claras, com prazo e campos?
- [ ] Tabela de conflito cobre os casos previstos? Registro de decisões?
- [ ] Material do parceiro é versão própria, com "o que não prometer"?
- [ ] Acompanhamento por ciclo com métricas e regra de saída?
- [ ] Nenhum valor comercial inventado?

## Output esperado

| Saída | Formato |
|---|---|
| Playbook | documento por seção (perfil, habilitação, registro, conflito, material, acompanhamento) |
| Plano de habilitação de um parceiro | tabela com etapas, datas e critério |
| Decisão de conflito | registro: situação, regra aplicada, decisão, data |
| Kit do parceiro | lista de materiais com fonte interna de cada um |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — regras ratificadas podem virar doc na pasta `docs/` do time, com aprovação humana.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "lider-vendas"}} |
