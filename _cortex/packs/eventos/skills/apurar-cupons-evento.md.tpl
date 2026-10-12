---
tipo: skill
id: apurar-cupons-evento
descricao: "Apura cupom, desconto efetivo e vendas por origem — colaborador, parceiro, patrocinador — com uma base declarada e sem contar o mesmo ingresso duas vezes."
familia: ANALISAR.cupons-evento
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["quantos ingressos saíram com cupom", "o cupom de colaborador se paga", "qual foi o desconto real da edição", "quanto o parceiro vendeu de ingresso", "o cupom está canibalizando a venda", "penetração de cupom por lote", "cupom não reconhecido na base"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Produtor antes de apurar.**

# Apurar cupons e origens de venda

Apura penetração de cupom, desconto efetivo e desempenho de cada **origem** (colaborador, parceiro, patrocinador, influenciador) sem trocar a base no meio do texto. Existe porque este é o recorte com mais formas de errar: o mesmo programa tem mais de uma apuração legítima, o desconto tem duas leituras que divergem, e a conclusão intuitiva sobre canibalização não se sustenta em dado de timing.

## Contexto de uso

- Dentro de uma análise de ciclo ou do acompanhamento semanal.
- Avaliação de um programa de cupom (colaborador, parceiro) ou de uma política de desconto.
- "O desconto está grande demais?", "o parceiro vendeu quanto?", "o cupom se paga?".

**Não acionar para:** meta de cupom por janela (`acompanhar-metas-evento`) · política de desconto vigente (decisão na ficha §6) · cota contratual do patrocinador (`captar-patrocinio`).

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Base de vendas (transação) com cupom, tipo, data de pagamento, canal | sim | {{#if integracao:dados}}Base integrada (§3.2) ou {{/if}}exportação da plataforma |
| Lista de referência de cupons (código → origem → faixa) | sim | Sincronizada com a plataforma; sem ela, "cupom não reconhecido" |
| Preço de tabela por janela e tipo | sim | Ficha §5 |
| Custo da recompensa por ingresso (se houver) | sim | `[INFORMADO PELO CLIENTE]` |
| Pergunta que a apuração responde | sim | Split de canal, distribuição por lote, orçamento do programa |

## Regras para não contar duas vezes

1. **Origem ≠ canal.** Colaborador, parceiro, patrocinador e influenciador são **origem** da venda. Canal de tráfego registra a sessão. Quando os dois sinais existem (cupom + UTM), **manda o cupom** e o canal conta só a sessão.
2. **Um ingresso, uma linha.** Ingresso com cupom de colaborador que chegou por anúncio pago entra na linha "colaborador" e **não** na de mídia paga.
3. **Identidade bloqueante:** canais (só sem cupom de origem) + colaborador + parceiro + influenciador = total pago. Não fecha → parar.
4. **Cupom de patrocinador é contrato, não canal com meta.** Linha própria, pequena, sem leitura de performance.
5. **Três linhas que somam o total:** cupom identificado · cupom não reconhecido · sem cupom. Cupom não reconhecido é lista dessincronizada, não falha de mecânica — reportar volume e desconto médio, não jogar fora nem classificar por suposição.

## Processo

### 1. Declarar a base — antes de qualquer número
| Base | Nível | Serve para |
|---|---|---|
| Base de vendas | transação | **Split de canal e origem** — a única que fecha com o total pago |
| Arquivo de cupons | participante | Distribuição por lote e por faixa de desconto |
| Registro de recompensa | programa | Orçamento e pagamento |

Texto que mistura duas está errado mesmo com os dois números certos. Abrir declarando a base e mantê-la até o fim.

### 2. Penetração com denominador único
Penetração = ingressos com cupom ÷ ingressos pagos do período, nas três linhas da regra 5.

### 3. Desconto efetivo, não desconto de cupom
Desconto de cupom mede só o que passou por código. **Desconto efetivo** compara o valor pago com o preço de tabela do mesmo lote e tipo. Quando o desconto de cliente é embutido no tipo de ingresso, o de cupom despenca e o efetivo sobe. Reportar os dois lado a lado, com a diferença; só o efetivo serve para projeção e afirmação sobre política de preço.

### 4. Cliente × mercado dentro do mesmo ano
Critério de marcação de cliente muda entre edições — comparar entre anos mede mudança de registro, não de público. Dentro do ano: diferencial de ticket entre os dois, confrontado com a política declarada.

### 5. Distribuição por janela e por origem
Percentual do volume pago de cada janela que saiu por cada origem, com a edição anterior ao lado. Concentração na primeira metade → **motor de antecipação**; na reta final → **ferramenta de fechamento**. Quebra por operação ou parceiro com o nome exato. Declarar a imprecisão de borda (numerador por data de inscrição, denominador por data de pagamento).

> **Não concluir canibalização daqui.** Concentrar volume onde há volume é o comportamento nulo esperado. A evidência é de timing, não de substituição; a hipótese concorrente (deadline + indicação geram compras que não ocorreriam) explica os mesmos dados. Teto proposto é precaução sob incerteza — apresentar como tal.

### 6. Distribuição por faixa de desconto
Nunca assumir que o programa roda na faixa nominal. Distribuição real por faixa e **média ponderada**. Média realizada muito abaixo da faixa planejada para o próximo ciclo → sinalizar o multiplicador de custo. Código acima da política → listar para sincronizar.

### 7. Ponto de equilíbrio
(1) receita líquida sem cupom · (2) com cupom · (3) custo da recompensa por ingresso vendido com cupom, incremental ou não. Ganho de uso incremental = (2) − (3). Custo de uso não incremental = [(1) − (2)] + (3). **Ponto de equilíbrio = custo do não incremental ÷ (ganho + custo)** — percentual mínimo de usos incrementais para o programa se pagar. Omitir (3) subestima o resultado.

### 8. Incrementalidade
Único desenho válido: subconjunto de colaboradores (ou parceiros) **sem cupom** durante uma janela inteira, comparando a venda originada. Registrar confundidores antes e combinar a diferença mínima que conta como sinal; sem isso, resultado é indicativo, não conclusivo.

## Checklist

- [ ] Base declarada na primeira linha e mantida?
- [ ] Identidade canais + origens = total fechou?
- [ ] Três linhas de penetração somando o total?
- [ ] Desconto de cupom × efetivo lado a lado?
- [ ] Distribuição por janela sem conclusão de canibalização?
- [ ] Faixa de desconto com média ponderada?
- [ ] Ponto de equilíbrio com as três parcelas abertas?

## Output esperado

1. **Declaração da base.** 2. **Penetração** em três linhas. 3. **Desconto de cupom × efetivo.** 4. **Cliente × mercado** no ano. 5. **Distribuição por janela e origem** com leitura de antecipação × fechamento e ressalva de causalidade. 6. **Faixa de desconto** com média ponderada. 7. **Ponto de equilíbrio.** 8. **Estado da medição de incrementalidade** — desenhada, rodando, lida ou inexistente.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
