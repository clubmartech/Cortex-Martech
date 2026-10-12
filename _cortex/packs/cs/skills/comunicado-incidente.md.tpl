---
tipo: skill
id: comunicado-incidente
descricao: "Escreve o comunicado de incidente ou manutenção — abertura, atualização, encerramento e pós-incidente — com status, impacto, próximos passos e horário."
familia: CRIAR.comunicado-incidente
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["comunicado de incidente", "sistema fora do ar o que digo", "status do incidente para os clientes", "atualização do incidente", "comunicado de encerramento do incidente", "impacto do incidente", "pós-incidente para o cliente", "aviso de manutenção"]
requires: atendente · respostas-modelo
owner: {{papel "atendimento"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Atendente** (`atendente`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e o status confirmado do incidente antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Atendente antes de comunicar.**

# Comunicado de incidente e manutenção

Em incidente, o cliente quer três coisas: **saber que sabemos**, **saber o que afeta** e **saber quando volta a ter notícia**. O comunicado não explica causa antes de confirmar, não promete hora de solução que não existe e não some: tem **cadência de atualização** mesmo sem novidade. Quatro momentos: abertura · atualização · encerramento · pós-incidente. Manutenção programada usa a mesma estrutura, com antecedência.

## Contexto de uso

- Indisponibilidade ou degradação confirmada que afeta mais de um cliente.
- Manutenção programada com impacto.
- Atualização periódica durante o incidente.
- Encerramento e relato pós-incidente.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Momento (abertura · atualização · encerramento · pós · manutenção) | sim |
| Produto(s) e funcionalidades afetadas, conforme confirmado por quem opera | sim |
| Início (horário e fuso), status atual, próxima atualização prevista | sim |
| Impacto para o cliente (o que não consegue fazer; o que continua funcionando) | sim |
| Contorno disponível, se houver | não |
| Causa e correção — **só confirmadas** | não (só no encerramento ou pós) |
| Canais de publicação ({{#each canais as c}}`{{c.slug}}` {{/each}}página de status, in-app) | sim |

Sem confirmação de quem opera, não há comunicado — há resposta de espera (`resposta-ticket`).

## Processo

1. **Confirmar os fatos** com quem opera: o que, desde quando, quem é afetado, status. Nada é publicado por suposição.
2. **Escolher o momento** e a estrutura (abaixo).
3. **Escrever** com horário e fuso explícitos, impacto em linguagem do cliente, próximo passo e **hora da próxima atualização**.
4. **Adaptar por canal** (`respostas-modelo` § Incidente): página de status completa; mensageria curta com link; e-mail só na abertura, encerramento e pós.
5. **Publicar** com aprovação de quem o config define para comunicação externa; registrar horário de cada publicação.
6. **Atualizar na hora prometida**, mesmo que a mensagem seja "sem mudança; próxima atualização às [hora]".
7. **Encerrar** só com estabilidade confirmada; **pós-incidente** quando a causa e as medidas estiverem validadas.

### Estruturas

**Abertura**
```
[Produto] — [instabilidade / indisponibilidade] em [funcionalidade] — [status: investigando]
Desde [hora, fuso]. Impacto: [o que o cliente não consegue fazer]. O que continua funcionando: [...].
Contorno: [se houver]. Estamos atuando. Próxima atualização: [hora].
```

**Atualização**
```
[Produto] — [status: identificado / em correção / monitorando] — [hora]
O que mudou desde a última atualização: [...]. Impacto atual: [...].
Próxima atualização: [hora].
```

**Encerramento**
```
[Produto] — resolvido — [hora]
A funcionalidade [X] está normalizada desde [hora]. Se ainda notar [sintoma], [o que fazer / canal].
Vamos compartilhar o relato do ocorrido em [prazo].
```

**Pós-incidente** (linguagem de cliente, não de engenharia)
```
O que aconteceu: [em uma frase, sem jargão].
Quando: [início → fim, fuso]. Quem foi afetado: [...].
Causa (confirmada): [...]. O que fizemos: [...]. O que vamos mudar para não repetir: [...].
Pedimos desculpas pelo impacto. [Canal para dúvidas.]
```

**Manutenção programada** (com antecedência definida pelo time): o quê · quando (início, fim previsto, fuso) · o que ficará indisponível · o que fazer antes · canal de dúvidas. Lembrete próximo do início; confirmação ao término.

### Vocabulário de status

investigando → identificado → em correção → monitorando → resolvido. Usar sempre os mesmos termos; não "pequena instabilidade", não "alguns usuários" quando o número é conhecido.

## Regras

- Nada publicado sem confirmação de quem opera.
- Causa só depois de confirmada; hora de solução só se garantida — senão, hora da **próxima atualização**.
- Atualização na hora prometida, sempre.
- Impacto em linguagem do cliente; sem jargão; sem minimizar.
- Pedido de desculpas quando o problema foi nosso; sem culpar terceiro em público.
- Tom de {{marca_mae.nome}}; termos proibidos ({{join marca_mae.termos_proibidos ", "}}) fora.
- Clientes em renovação ou em risco (matriz) recebem contato individual do Gestor de Sucesso além do comunicado.

## Checklist

- [ ] Fatos confirmados por quem opera?
- [ ] Horário e fuso em todas as peças? Hora da próxima atualização?
- [ ] Impacto e o que continua funcionando, em linguagem do cliente?
- [ ] Status no vocabulário padrão?
- [ ] Versão por canal; aprovação registrada?
- [ ] Encerramento só com estabilidade confirmada; pós com causa validada?
- [ ] Contas em risco avisadas individualmente?

## Output esperado

| Saída | Formato |
|---|---|
| Comunicado do momento | texto na estrutura, por canal |
| Linha do tempo | horário de cada publicação e status |
| Lista de clientes para contato individual | com dono |
| Pós-incidente | texto para cliente + registro interno de causa e medidas |

Destino: página de status, canais definidos e registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "atendimento"}} |
