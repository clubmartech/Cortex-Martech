---
tipo: skill
id: plano-de-sucesso
descricao: "Escreve o plano de sucesso do cliente: objetivos dele, marcos de valor com data e métrica, riscos e ações, rito de revisão — a base de renovação e expansão."
familia: PLANEJAR.plano-sucesso
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["objetivos do cliente com o produto", "marcos de valor da conta", "plano de sucesso do cliente", "o que o cliente quer alcançar", "revisão trimestral com o cliente", "riscos do plano de sucesso", "reunião de resultados com o cliente"]
requires: gestor-sucesso · jornada-cliente
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a jornada do cliente e o dado disponível antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Gestor antes de escrever o plano.**

# Plano de sucesso — objetivos, marcos e riscos do cliente

O plano de sucesso responde: **o que o cliente quer alcançar** com o que comprou, **como vamos saber** que alcançou, **quando**, **o que pode impedir** e **o que fazemos a respeito**. É escrito com o cliente, revisado em rito fixo e é a base de toda conversa de renovação ou expansão — quem renova renova um resultado, não um contrato.

## Contexto de uso

- Ao encerrar o onboarding (primeiro plano).
- Revisão periódica (ciclo {{operacao.ciclo_planejamento}} ou o combinado com o cliente).
- Mudança no cliente (nova liderança, novo objetivo, novo produto).
- Preparação de reunião de resultados.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Cliente, produto(s), etapa da jornada | sim |
| Objetivos declarados pelo cliente (handoff, kickoff, última revisão) | sim |
| Dado de uso e de resultado disponível (com fonte) | sim — ou `[PENDENTE DE CONFIRMAÇÃO]` |
| Patrocinador e contato principal | sim |
| Vencimento do contrato | sim |
| Health score atual | não |

**Fonte do dado:** {{#if integracao:dados}}integração de dados definida em `cortex.config.yaml` (read-only){{else}}sem integração de dados no config — o que o cliente ou o time informar, `[INFORMADO PELO CLIENTE]`{{/if}}{{#if integracao:crm}}; contrato e contatos da integração de CRM{{/if}}.

## Processo

1. **Objetivos do cliente** (até três), nas palavras dele, cada um ligado à promessa de um produto do config:
{{#each produtos as p}}   - `{{p.slug}}` → promessa: {{p.promessa}}
{{/each}}   Objetivo que não se liga a nenhuma promessa é expectativa fora do produto — registrar e tratar como risco.
2. **Marcos de valor**: para cada objetivo, o resultado observável, a métrica (do que existe), o valor atual, o alvo (definido pelo cliente), a data.
3. **Riscos**: o que pode impedir (adoção, dado, patrocinador, processo do cliente, lacuna de produto) com probabilidade, impacto, sinal de detecção e ação preventiva. Cruzar com `matriz-risco-churn`.
4. **Ações**: dos dois lados, com dono e data. Ação nossa sem dono não entra.
5. **Rito de revisão**: periodicidade, participantes, pauta (marcos → riscos → ações → próximos passos) e canal.
6. **Validar com o cliente** e registrar {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}. Plano não validado é rascunho.

### Reunião de resultados (roteiro)

O que combinamos → o que aconteceu (marco a marco, com dado e fonte) → o que não aconteceu e por quê → riscos e ações → próximos marcos → oportunidade (se houver, nas palavras do cliente: "você mencionou que…"). Expansão aparece como consequência de valor; não é pauta própria.

### Sinais que mudam o plano

Patrocinador saiu · objetivo mudou · uso caiu abaixo do combinado · ticket repetido sobre o mesmo fluxo · pesquisa de satisfação com detrator · marco atrasado sem causa conhecida. Qualquer um deles: revisar antes do rito.

## Regras

- Objetivos e alvos são do cliente; nós propomos métrica e marco, não a meta dele.
- Métrica só do que existe; sem dado, o marco é qualitativo e marcado.
- Nenhuma promessa fora do doc do produto; lacuna é risco registrado, não compromisso.
- Plano revisado em rito; plano sem revisão há mais de um ciclo está vencido.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Até três objetivos, nas palavras do cliente, ligados a promessas do config?
- [ ] Cada objetivo com marco, métrica (existente), alvo do cliente e data?
- [ ] Riscos com sinal de detecção e ação preventiva?
- [ ] Ações dos dois lados com dono e data?
- [ ] Rito de revisão definido?
- [ ] Plano validado pelo cliente e registrado?

## Output esperado

```
PLANO DE SUCESSO — [cliente] — [produto(s)] — versão [n] — validado em [data]
Patrocinador: [...] · Contato: [...] · Vencimento: [data]

OBJETIVOS
1. "[nas palavras do cliente]" → promessa: [produto]
| Marco | Métrica | Atual (fonte) | Alvo (cliente) | Data | Status |

RISCOS
| Risco | Prob. | Impacto | Sinal de detecção | Ação preventiva | Dono |

AÇÕES
| Ação | Lado | Dono | Data | Status |

RITO: [periodicidade · participantes · canal]
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO] · [NECESSITA FONTE]
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
