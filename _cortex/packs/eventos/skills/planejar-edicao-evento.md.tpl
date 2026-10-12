---
tipo: skill
id: planejar-edicao-evento
descricao: "Desenha o ciclo completo de uma edição — formato, metas de público e receita, calendário reverso, janelas de lote e escada de preço validada."
familia: PLANEJAR.edicao-evento
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["desenhar o ciclo de vendas da edição", "quantos lotes a edição deve ter", "montar o calendário de lotes", "testar a tabela de preços do evento", "calendário reverso da edição", "como distribuir os dias entre os lotes", "quantas cortesias a edição comporta", "presencial, online ou híbrido"]
requires: produtor-evento · ficha-edicao
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a ficha da edição antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de planejar.**

# Planejar a edição do evento

Desenha uma edição de ponta a ponta: formato, metas separadas, calendário reverso, quantas janelas de venda, quantos dias em cada uma, qual preço entra em cada virada, quais descontos somam, quantas cortesias e qual curva de metas isso produz. Existe porque o desenho do ciclo é a decisão de maior alavancagem do evento — e porque ele tem uma restrição aritmética (a escada de descontos) que, quebrada, faz o cliente ganhar dinheiro esperando em vez de comprar.

## Contexto de uso

- Edição nova — tipicamente de oito a dez meses antes de evento presencial, antes de a plataforma de venda ser configurada.
- **Remanejar janelas** de um ciclo em andamento, depois de um checkpoint disparar.
- **Testar uma tabela de preços** proposta pela área contra a integridade da escada.
- Responder "quantos lotes?", "esse lote pode ser tão longo?", "posso subir o preço da pré-venda?".

**Não acionar para:** realizado contra a meta (`acompanhar-metas-evento`) · por que um lote vendeu mal (`analisar-ciclo-evento`) · número de receita futura (`projetar-receita-evento`, chamada no passo 7){{#if pack:marketing}} · webinar ou live sem bilheteria (`planejar-evento`, pack marketing){{/if}}.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| **Edição** (slug em `iniciativas/`) | sim | Sem pasta, abrir antes (`modelo-iniciativa-evento`) |
| **Formato** | sim | presencial · online · híbrido — muda capacidade, custo e no-show |
| **Meta de receita** e **meta de volume** | sim | Separadas, com qual cede em conflito |
| **Data do evento** e data-limite de abertura | sim | Define o tamanho do ciclo |
| **Capacidade** (lugares ou vagas) | sim | Teto do distribuído |
| Histórico de edições anteriores | recomendado | Velocidade por janela, terços, efeito de virada; sem histórico → `[NECESSITA FONTE]` |
| Públicos da edição | sim | `publicos[]` do config, com papel (pagante · cortesia) |
| Preços de referência | não | **Nunca propostos pela skill**: todo valor é `[INFORMADO PELO CLIENTE]` |

Faltando qualquer item obrigatório, **perguntar e esperar**.

## Processo

### 1. Fixar as duas metas antes de qualquer desenho
Registrar separadamente **meta de receita** e **meta de volume**, com a margem de cada uma. Se a área pedir crescimento simultâneo de volume e ticket, sinalizar: sem precedente próprio, isso é hipótese — e obriga a declarar qual das duas cede.

### 2. Escolher o formato e suas consequências
| Formato | O que muda no desenho |
|---|---|
| Presencial | Capacidade física, cortesias pesam, no-show alto em cortesia, custo fixo de palco e local |
| Online | Capacidade elástica, ingresso mais barato ou gratuito, comparecimento é a métrica crítica, gravação vira ativo |
| Híbrido | Dois produtos, duas escadas, duas metas de presença; nunca somar os dois públicos num número só |

### 3. Montar o calendário reverso
Da data do evento para trás: encerramento das vendas → última virada → … → abertura → esquenta → publicação da grade → fechamento de patrocínio → contratação de local ou plataforma. Marcar feriados, recessos e pontes que caem dentro do ciclo.

### 4. Marcar a geografia do ciclo, não o calendário
Dividir o ciclo em trechos percentuais e, com o histórico próprio, atribuir um **índice de velocidade esperado** a cada trecho (`[NECESSITA FONTE]` sem histórico). Padrão típico a validar com dado próprio: abertura ativa · **vale estrutural** no meio do ciclo (encurtar ao mínimo — é o erro mais caro alocar a janela mais longa aqui) · recuperação · **reta final** (alongar e subdividir — produz mais receita por dia). Só depois projetar sobre o calendário real e ajustar bordas para dias úteis.

### 5. Definir o número de janelas
O **deadline gera a corrida; o tamanho do aumento, não.** Mais viradas com aumentos menores produzem mais eventos de conversão sem exigir aumento total maior. Contrapeso: cada janela é operação a mais (configuração, comunicação, risco de escada). Parar de subdividir quando a janela ficar curta demais fora da reta final. Pré-requisito operacional de cada virada (cupons ativados, grade publicada, UTM auditada) vai na ficha §4.

### 6. Montar e validar a escada de preços
1. Preço da pré-venda **por último** — ele determina o piso de todo o resto.
2. Saltos com **gradiente invertido**: menos aumento onde a demanda é frágil, mais onde é inelástica.
3. Diferencial entre tipos de ingresso constante.
4. **Validação obrigatória:** para cada janela, piso = preço × (1 − maior combinação de descontos que soma ali). **Critério de aceite: o piso de cada janela é maior que o da anterior.** Registrar a folga em valor e em percentual de cada virada; folga pequena exige regra travada explícita (nenhum cupom extra naquela janela). Rodar os cenários cruzados (cliente + parceiro, cliente + grupo, parceiro sozinho na pré-venda).

> Nunca entregar tabela sem esta validação. Ela é aritmética, não julgamento — e é silenciosa.

### 7. Distribuir cortesias e volume
Cortesias por categoria (ficha §7), com quem cura cada uma; razão cortesia : pagante comparada com a edição anterior. Volume pago distribuído pelas janelas: índice de velocidade → padrão de terços dentro da janela → multiplicador de véspera nos últimos dias úteis (reduzido na última janela) → amortecimento de feriado **dentro da mesma janela** → fim de semana com peso reduzido. **A soma fecha exatamente na meta de volume.** Receita: chamar `projetar-receita-evento`.

### 8. Definir checkpoints de correção
Antes de o ciclo começar: dois checkpoints onde ainda sobra ciclo para reagir, cada um com **métrica**, **limiar** e **reação combinada** — decidida agora para não ser renegociada sob pressão.

### 9. Fechar com o que o plano não sustenta
Premissas assumidas e não testadas (elasticidade de preço, mix de ingressos, no-show), colinearidades herdadas do histórico. Plano sem isso apresenta hipótese como fato.

## Regras

- Preço nunca nasce aqui: `[INFORMADO PELO CLIENTE]` até estar na ficha.
- Tabela sem validação de escada **não sai**.
- Metas separadas, projeção em faixa, premissas declaradas.
- O plano vai para o chat antes de virar arquivo; janelas, escada e cortesias entram na **ficha da edição**; a curva de metas vai para o acompanhamento. Não duplicar.

## Checklist

- [ ] Duas metas fixadas, com margem e qual cede?
- [ ] Formato escolhido e consequências registradas?
- [ ] Calendário reverso com feriados e pré-requisitos de virada?
- [ ] Escada validada: piso crescente em toda virada, folga registrada, regras travadas?
- [ ] Cortesias por categoria com curador? Soma do volume fecha na meta?
- [ ] Checkpoints com métrica, limiar e reação?
- [ ] Bloco de premissas e do que o plano não sustenta?

## Output esperado

Plano de edição, no chat antes de virar arquivo, com: metas separadas · tabela de janelas (período, dias, % do ciclo, índice esperado, pré-requisito) · tabela de preços por janela e tipo (`[INFORMADO PELO CLIENTE]`) · matriz de cumulatividade · tabela de pisos com folga e regras travadas · distribuição de cortesias · curva de volume por janela · projeção em faixa (via `projetar-receita-evento`) · checkpoints · premissas. Destino: ficha da edição + acompanhamento.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
