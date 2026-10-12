---
tipo: skill
id: onboarding-cliente
descricao: "Monta o plano de onboarding de 30/60/90 dias por produto: marcos de ativação, primeiro valor, responsáveis dos dois lados, critérios de conclusão e alertas."
familia: PLANEJAR.onboarding-cliente
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["plano de 30 60 90 dias", "primeiros dias do cliente", "kickoff com o cliente", "implantação do cliente novo", "marcos do onboarding", "cliente novo não ativou", "checklist de onboarding", "tempo até o primeiro valor"]
requires: gestor-sucesso · jornada-cliente
owner: {{papel "cs"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Gestor de Sucesso** (`gestor-sucesso`), que carrega o gate (`_cortex/kernel/gate.md`), a jornada do cliente e a ficha de handoff antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Gestor antes de planejar.**

# Onboarding do cliente — plano de 30/60/90 dias por produto

Onboarding termina quando o cliente obteve o **primeiro valor** que comprou — não quando a implantação acabou. O plano organiza três janelas (ativar · adotar · comprovar valor), cada uma com marcos, dono dos dois lados, critério de conclusão e sinal de alerta. O ponto de partida é a expectativa registrada na venda; sem ela, o plano começa perguntando.

## Contexto de uso

- Cliente novo após o contrato assinado.
- Cliente que contratou um produto ou módulo adicional (onboarding do incremento).
- Cliente que não ativou: replanejar com o que faltou.
- Revisão do modelo de onboarding por produto.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Cliente, produto(s) e módulos contratados | sim |
| Ficha de handoff de vendas (dor, impacto esperado, decisores, promessas feitas) | sim — sem ela, `[PENDENTE: confirmar expectativas com o cliente]` |
| Contato principal e patrocinador do lado do cliente | sim |
| Data de início e restrições de agenda | sim |
| Pré-requisitos técnicos ou de dado (do doc do produto) | sim |
| Capacidade do time interno (horas, pessoas) | não |

## Processo

1. **Definir o primeiro valor** em uma frase, na linguagem do cliente: "[cliente] considera que deu certo quando [resultado observável] acontece". Vem da ficha de handoff ou da reunião de kickoff — nunca do que a organização acha.
2. **Escolher o modelo por produto** (abaixo) e adaptar ao contrato.
3. **Kickoff**: alinhar o primeiro valor, apresentar o plano, confirmar donos e datas, registrar riscos declarados pelo cliente.
4. **Executar por janela**, com um ponto de contato fixo por semana e o status registrado.
5. **Checar sinais de alerta** a cada contato; alerta ativo muda o plano e entra na `matriz-risco-churn`.
6. **Encerrar o onboarding** só com o critério de conclusão cumprido e validado pelo cliente; passar à etapa de adoção da `jornada-cliente` com o `plano-de-sucesso` iniciado.

### Modelo por produto

{{#each produtos as p}}#### {{p.nome}} (`{{p.slug}}`, {{p.tipo}})

Promessa registrada: {{p.promessa}}{{#if p.modulos}} · Módulos: {{join p.modulos ", "}}{{/if}}

| Janela | Objetivo | Marcos | Dono (nós / cliente) | Critério de conclusão | Sinal de alerta |
|---|---|---|---|---|---|
| **Dias 1–30 · Ativar** | acesso, configuração, dado inicial, primeiro uso | `[PENDENTE: preencher]` | {{papel "cs"}} / patrocinador | usuários-chave acessaram e completaram a primeira tarefa | sem acesso ou sem tarefa concluída ao fim da janela |
| **Dias 31–60 · Adotar** | uso recorrente no fluxo real | `[PENDENTE: preencher]` | {{papel "cs"}} / contato principal | uso no ritmo combinado por `[PENDENTE: definir métrica de uso]` | uso caindo; ticket repetido; patrocinador ausente |
| **Dias 61–90 · Comprovar valor** | primeiro valor observado e reconhecido | `[PENDENTE: preencher]` | {{papel "cs"}} / patrocinador | cliente confirma o primeiro valor na reunião de encerramento | valor não observável; expectativa diferente da venda |

{{/each}}
Marcos específicos de cada produto vêm do doc `contexto/produtos/<slug>/<slug>.md` e da prática do time — este modelo nasce `[PENDENTE: preencher]` de propósito.

### Reunião de kickoff (roteiro)

Apresentações e papéis → o que foi comprado e por quê (nas palavras da venda, confirmadas pelo cliente) → o primeiro valor em uma frase → plano por janela → o que precisamos do cliente, com datas → riscos que ele já enxerga → próximo contato.

### Comunicação durante o onboarding

Ponto de contato semanal no canal preferido do cliente ({{#each canais as c}}`{{c.slug}}` {{/each}}ou reunião), com status: feito · próximo · bloqueios · o que precisamos de você. Dúvida recorrente vira `artigo-central-ajuda`.

## Regras

- Primeiro valor definido pelo cliente, não por nós; sem ele, o onboarding não começa.
- Nenhum prazo ou funcionalidade fora do doc do produto; prazo de implantação é o do contrato.
- Expectativa diferente da venda é sinalizada no dia{{#if pack:vendas}} ao Executivo de Vendas{{/if}} — não absorvida em silêncio.
- Onboarding não encerra por calendário; encerra por critério validado.
- Dados do cliente seguem `governanca.dados_proibidos_em_prompt` ({{join governanca.dados_proibidos_em_prompt ", "}}).

## Checklist

- [ ] Primeiro valor em uma frase, confirmado no kickoff?
- [ ] Marcos com dono dos dois lados e data?
- [ ] Critério de conclusão por janela, observável?
- [ ] Sinais de alerta definidos e ligados à matriz de risco?
- [ ] Pré-requisitos do produto cobertos na primeira janela?
- [ ] Ponto de contato semanal e canal definidos?
- [ ] Encerramento validado pelo cliente; plano de sucesso iniciado?

## Output esperado

```
ONBOARDING — [cliente] — [produto(s)] — início [data]
Primeiro valor: "[uma frase, nas palavras do cliente]"
Patrocinador: [...] · Contato principal: [...] · Dono interno: [papel]

| Janela | Marco | Dono | Data | Critério | Status | Alerta |
|---|---|---|---|---|---|---|

Riscos declarados: [...]
Pendências do cliente: [...]
Nota de transparência: [VALIDADO] · [INFORMADO PELO CLIENTE] · [PENDENTE DE CONFIRMAÇÃO]
```

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "cs"}} |
