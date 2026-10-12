---
tipo: skill
id: analisar-ciclo-evento
descricao: "Diagnostica um ciclo de vendas de evento — velocidade por janela, efeito de virada, papel de cada canal, timing e o que os dados não permitem concluir."
familia: ANALISAR.ciclo-evento
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["por que o lote vendeu mal", "o que puxou a venda da edição", "pós-mortem da edição", "comparar duas edições do evento", "qual canal trouxe os ingressos", "o lote fechou bem ou mal", "efeito da virada de lote", "a venda parou no meio do ciclo"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Produtor antes de analisar.**

# Analisar o ciclo do evento

Lê um ciclo — em andamento ou fechado — e devolve o diagnóstico: onde a velocidade caiu e se era esperado, quanto a virada rendeu, qual canal sustentou cada trecho, que timing funcionou e o que os dados **não** permitem concluir. Existe porque a leitura ingênua erra de forma previsível: confunde tráfego com venda, soma origem com canal e lê como problema o vale que é estrutural.

## Contexto de uso

- Um lote fechou e é preciso entender o resultado.
- A venda caiu, subiu ou parou.
- Pós-mortem de uma edição inteira; comparação entre edições.
- Insumo para `planejar-edicao-evento` da próxima edição.

**Não acionar para:** quanto falta para a meta (`acompanhar-metas-evento`) · cupom, desconto, colaborador ou parceiro (`apurar-cupons-evento`){{#if pack:marketing}} · webinar sem bilheteria (`analisar-performance`, pack marketing){{/if}}.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Edição(ões) e janelas | sim | Ficha §4 de cada uma |
| Base de vendas com data de pagamento, tipo, cupom, canal | sim | {{#if integracao:dados}}Base integrada (§3.2) ou {{/if}}exportação; conferir cabeçalho contra conteúdo antes de analisar |
| Sessões por canal (tráfego) | recomendado | Para separar tráfego de venda |
| Calendário de disparo realizado | sim | O que de fato saiu, não o planejado |
| Índices de velocidade esperados | recomendado | Da ficha; sem eles, o padrão desta edição vira a primeira referência `[NECESSITA FONTE]` |

## Processo

### 1. Regras de tratamento antes de tocar em número
Receita líquida, só pagos, data de pagamento, atribuição de janela por data, calendário realizado, visitas deduplicadas, ticket ponderado. Planilha nova: conferir se o cabeçalho corresponde às colunas.

### 2. Normalizar por duração e posição
Nunca comparar janelas por volume absoluto. Converter para **ingressos por dia** e **receita por dia**; **índice de velocidade** = velocidade da janela ÷ média do ciclo; **posição da janela no ciclo** em % — é isso que explica o rendimento, não o número do lote.

### 3. Comparar contra o índice esperado, não contra o lote anterior
Dentro do esperado → comportou-se como o padrão prevê; **não é achado**. Abaixo → investigar: dias sem venda, canal que sumiu, disparo que não saiu. Acima → registrar o que foi diferente; candidato a aprendizado. **O vale do meio do ciclo não é problema de execução**: avalia-se se foi encurtado no desenho e se a alavanca prevista (indicação) foi acionada.

### 4. Medir o efeito de virada
Por janela: volume dos últimos dias ÷ média diária da própria janela; distribuição por terços. Multiplicador fraco aponta para **falha de comunicação da véspera**, não para tamanho do aumento de preço — a correlação entre os dois costuma ser nula.

### 5. Separar canal de tráfego de origem da venda
Duas leituras: **tráfego** (share de sessões por canal) e **venda** (ingressos por canal contando só vendas sem cupom de origem, mais as linhas de origem à parte). Checagem: canais + colaborador + parceiro = total pago; se não fechar, parar. Tráfego alto com venda baixa é oportunidade de segmentação, não sucesso de canal.

### 6. Ler o papel de cada canal por posição no ciclo
Matriz canal × janela. Padrão esperado: canais próprios vendem na abertura e desaparecem; pagos vendem no fim; indicação no vale. Desvio é o achado. Linha "Desconhecido" crescendo numa janela = problema de rastreio, e a leitura daquela janela fica comprometida.

### 7. Ler o timing
Disparo × venda no mesmo dia e no dia seguinte; dia da semana; feriados; hora do disparo quando disponível. O que puxou venda: conteúdo (agenda publicada), preço (véspera), vaga (reta final) ou indicação.

### 8. Decompor variação entre edições
Ponte: efeito volume (Δ ingressos × ticket do ano-base) + efeito ticket (Δ ticket × ingressos do ano corrente). Repetir excluindo tipos de ingresso que só existiram em um dos anos.

### 9. Declarar o que não é analisável
Lista explícita das perguntas que os dados não respondem (incrementalidade de cupom, elasticidade, no-show, atribuição sem UTM). Diagnóstico sem isso dá confiança que os dados não sustentam.

### 10. Propor aprendizado
Fricção recorrente → registro de aprendizado na iniciativa (`docs/aprendizados-<evento>-<ano>.md`): o que aconteceu, análise, ação para o próximo ciclo{{#if pack:marketing}}; faixa de canal validada → `benchmarks-canal`{{/if}}.

## Regras

- Normalizar antes de comparar; posição explica, número do lote não.
- Vale estrutural não é falha de execução.
- Integridade canais + origens = total é bloqueante.
- Interpretação marcada como interpretação.

## Checklist

- [ ] Tratamento aplicado e cabeçalho conferido?
- [ ] Velocidade normalizada e índice × esperado por janela?
- [ ] Efeito de virada e terços?
- [ ] Duas tabelas de canal com integridade explícita?
- [ ] Matriz canal × janela e leitura de timing?
- [ ] Ponte de receita (se comparação)?
- [ ] Lista do que não é analisável? Aprendizados propostos?

## Output esperado

1. **Quadro por janela:** período, dias, ingressos, receita, ticket, ingressos/dia, índice realizado × esperado.
2. **Efeito de virada** por janela e terços.
3. **Duas tabelas de canal** (tráfego e venda) com integridade.
4. **Matriz canal × janela** e **leitura de timing**.
5. **Ponte de receita**, com e sem os tipos que mudaram.
6. **Diagnóstico em texto:** o que fugiu do padrão, magnitude, explicação mais provável (marcada).
7. **O que não é analisável.** 8. **Aprendizados propostos.**

Chat primeiro; relatório vai para o registro ou a iniciativa, nunca para a documentação do time.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
