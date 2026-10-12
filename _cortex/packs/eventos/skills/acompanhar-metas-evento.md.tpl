---
tipo: skill
id: acompanhar-metas-evento
descricao: "Entrega o acompanhamento do ciclo — realizado contra a curva por semana, por lote e por canal — com a checagem de integridade e os alertas de checkpoint."
familia: ANALISAR.metas-evento
output: relatorio
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como está a venda de ingressos", "quanto falta para a meta da edição", "estamos dentro da curva do lote", "acompanhamento semanal da bilheteria", "fechamento do lote", "disparou o checkpoint do ciclo", "report da bilheteria para a liderança"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Produtor antes de reportar.**

# Acompanhar as metas do evento

Compara o realizado com a curva de trabalho por semana, por janela e por canal, roda a checagem de integridade que impede dupla contagem e diz se algum checkpoint disparou. Existe porque acompanhamento sem checagem produz "realizado" maior que a venda real — e nenhum sinal avisa.

## Contexto de uso

- Rotina semanal do ciclo.
- Fechamento de cada janela.
- Checkpoints de correção definidos no plano.
- "Como estamos?" ou report para a liderança.

**Não acionar para:** por que o número é esse (`analisar-ciclo-evento`) · redesenhar o ciclo (`planejar-edicao-evento`) · recorte de cupom (`apurar-cupons-evento`).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Edição e janela vigente | sim | Ficha §4 |
| Curva de trabalho e meta institucional | sim | Separadas; `[NECESSITA FONTE]` se só uma existir |
| Base de vendas do período | sim | {{#if integracao:dados}}Base integrada (§3.2) ou {{/if}}exportação da plataforma; data da extração |
| Metas por canal e por janela | sim | Do plano de divulgação |
| Para quem é o report | sim | Time → curva; liderança → institucional |

## Processo

### 1. Puxar o realizado pelas regras de tratamento
Só ingressos **pagos**, receita **líquida**, **data de pagamento** (não de inscrição), atribuição de janela pela data. Cortesias em linha separada, nunca somadas ao pago.

### 2. Comparar contra a referência certa
Time → curva de trabalho. Liderança → meta institucional. Dizer sempre contra qual das duas o número está sendo lido — misturar faz o time comemorar folga que não existe ou correr atrás de gap planejado.

### 3. Checagem de integridade — passo bloqueante
```
soma das linhas de canal (só vendas SEM cupom de origem)
+ linha de colaborador (origem)
+ linha de parceiro ou influenciador (origem)
= total de ingressos pagos do período
```
Se não fechar, **parar**: não reportar antes de corrigir. Modo de falha típico: descontar a origem de um canal só e deixar os outros brutos. A parcela de parceiro é a que mais escapa — conferir mesmo quando o total bate.

### 4. Ler por janela e por semana, não por mês
O mês é unidade contábil; a janela é unidade de comportamento. Dentro da janela, comparar o ritmo diário com o esperado para a posição (padrão de terços): estar atrás no meio da janela é **esperado** — não disparar alarme no terço central.

### 5. Ler cada canal contra a própria meta e o próprio histórico
Duas colunas: realizado × meta da janela e realizado × mesmo trecho da edição anterior. Atenção a canal cuja meta exige mudança de comportamento (monitorar como linha própria), à linha **"Desconhecido"/sem UTM** (crescendo = rastreio degradando) e ao custo por ingresso da mídia paga contra o que a meta exige (acima por duas janelas seguidas → gap migra de canal enquanto há ciclo).

### 6. Acompanhar cupons por janela e por origem
Realizado × meta da janela × piso ou teto vigente. Cobrança por janela, não pelo total do ciclo. Quebra por operação ou parceiro com o nome exato. Detalhe em `apurar-cupons-evento`.

### 7. Verificar checkpoints
Em cada checkpoint do plano: acumulado × limiar; disparou → aplicar a **reação combinada** (decidida antes, para não ser renegociada sob pressão) e registrar.

### 8. Registrar
O acompanhamento fecha com o número no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — não com arquivo novo na documentação.

## Regras

- Sem checagem de integridade, não há report.
- Metas de receita e de volume separadas, cada uma com a própria margem.
- Cortesia nunca entra no pago; distribuído nunca vira "presença".
- Número sem data de extração não é número.

## Checklist

- [ ] Regras de tratamento aplicadas (pago, líquido, data de pagamento)?
- [ ] Referência declarada (curva × institucional)?
- [ ] Integridade fechou, com as três parcelas?
- [ ] Leitura por janela com posição no terço?
- [ ] Canal × meta × histórico, com "Desconhecido" e custo por ingresso?
- [ ] Cupons por janela e por origem?
- [ ] Checkpoints verificados e reação registrada?

## Output esperado

1. **Cabeçalho:** período, janela vigente, dias corridos e restantes, data da extração.
2. **Acumulado do ciclo:** ingressos e receita contra a curva **e** contra a institucional, em % de atingimento.
3. **Resultado da integridade** — explícito, mesmo quando passa.
4. **Quadro por janela:** meta, realizado, gap, ritmo diário realizado × esperado.
5. **Quadro por canal:** meta, realizado, gap, edição anterior, "Desconhecido", custo por ingresso da mídia.
6. **Cupons por janela e origem.**
7. **Status dos checkpoints.**
8. **Uma frase de leitura**, marcada como interpretação quando for.

Tabelas no chat; número no registro.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
