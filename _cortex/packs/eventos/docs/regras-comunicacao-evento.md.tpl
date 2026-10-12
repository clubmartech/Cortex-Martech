---
tipo: doc
id: regras-comunicacao-evento
descricao: "Define o que pode e o que não pode virar comunicação pública de um evento da organização — a trava de copy que toda peça da edição passa."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["posso usar esse número na peça do evento", "o que não posso afirmar sobre o evento", "pode publicar a nota de satisfação", "como escrevo o nome do evento", "posso citar quantas pessoas foram", "que dado do evento preciso conferir antes de publicar", "de onde tiro depoimento do evento"]
requires:
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

# Regras de comunicação de evento — {{organizacao.nome}}

> Trava obrigatória antes de escrever, revisar ou aprovar qualquer peça de evento — e-mail, post, página, banner, mídia paga, roteiro, arte, proposta de patrocínio. Vale para todas as edições e para todos os eventos da organização. Complementa `_cortex/kernel/anti-alucinacao.md`, que continua sendo a fundação; aqui ficam só as regras **específicas de evento**. A skill `kit-comunicacao-evento` aplica estas regras peça a peça.

> **Anti-alucinação:** nenhum dado de evento pode ser inferido, arredondado para cima ou "completado". Se não estiver na ficha da edição, marque `[VERIFICAR]` e pergunte ao papel `{{papel "eventos"}}` antes de publicar.

## 1. Proibições absolutas

Nunca, em nenhuma peça, interna ou externa:

1. **Inventar speaker, lote, valor, benefício, parceiro, local ou horário.** Se não está na ficha da edição, não existe.
2. **Publicar métrica numérica de satisfação** — regra detalhada na §2.
3. **Comprometer número de presença** com patrocinador, fornecedor ou imprensa antes da primeira medição de check-in. Ingresso distribuído não é pessoa presente.
4. **Apresentar dado de uma edição como se fosse de outra.** Cada número carrega o ano.
5. **Somar público pagante e cortesia** num único número de "participantes" sem dizer que é o total distribuído.
6. **Citar preço de janela futura** ou desconto ainda não ativado. Preço é da janela vigente, conferido no dia.
7. **Usar termo proibido da marca** — a lista vive no brandcenter{{#if marca_mae.termos_proibidos}} (marca-mãe: {{join marca_mae.termos_proibidos ", "}}){{/if}}.

## 2. Métricas de satisfação e prova social

**Nenhuma métrica numérica de satisfação vai para peça pública** — nota média, percentual de recomendação ou variações — mesmo que o número seja verdadeiro internamente. Motivos: a amostra é autosselecionada e, em evento com cortesia, majoritariamente não pagante; e a formulação em percentual costuma não ser derivável da pergunta feita.

| Permitido como prova social | Fonte |
|---|---|
| Depoimento qualitativo nominal, com autorização | Campos abertos da pesquisa de satisfação da edição |
| Menção espontânea em rede social | Monitoramento da edição |
| Logo de patrocinador ou parceiro | Só depois de contrato assinado e com arquivo oficial |

Números de satisfação **seguem valendo para uso interno** — leitura de produto, comparação entre edições, apresentação à liderança. Só não viram copy. Decisão em contrário é registrada aqui, com data e papel.

## 3. Dados que sempre exigem verificação

Nunca inserir em copy sem consultar a ficha da edição atualizada no dia:

- [ ] Valor de cada lote e de cada tipo de ingresso
- [ ] Data de abertura e de encerramento de cada janela
- [ ] Speaker confirmado depois da última atualização da ficha (convidado ≠ confirmado ≠ publicado)
- [ ] Programação detalhada — horário, sala ou trilha por speaker
- [ ] Disponibilidade de ingresso por tipo
- [ ] Regra de cumulatividade de desconto vigente na janela
- [ ] Patrocinador com contrato assinado
- [ ] Local, endereço, link de acesso e horário de credenciamento

**Por que a lista existe:** são os campos que mudam durante o ciclo e que causam retrabalho quando citados de memória.

## 4. Números que existem em mais de uma versão

| Indicador | Versões | Qual usar |
|---|---|---|
| **Volume de cupom de colaborador ou parceiro** | base de vendas · arquivo de cupons · registro de recompensa | Declarar a base (`apurar-cupons-evento`); nunca trocar no mesmo texto |
| **Desconto praticado** | de cupom × efetivo | Sempre o **efetivo** em projeção e em afirmação sobre política de preço |
| **Meta do ciclo** | institucional × curva de trabalho | Peça e report externo usam a **institucional**; acompanhamento interno usa a curva |
| **Público** | pagante · distribuído · presente | Dizer qual é; "participantes" sem qualificador é proibido |

## 5. Fronteira entre eventos e formatos

Cada evento ou série da organização tem a própria pasta em `iniciativas/` e a própria ficha. **Nunca misturar** dados, speakers, preços ou mensagens entre eventos diferentes, nem entre uma edição nacional e edições regionais ou pocket do mesmo evento. A ponte legítima entre eles (um evento alimentando o outro) é uma frase-ponte registrada na ficha de cada um — não criar variações.

{{#if pack:marketing}}Webinar e live sem bilheteria seguem o pack marketing (`planejar-evento`); estas regras valem para eles no que couber (speaker, número, promessa).{{/if}}

## 6. Grafia e nomenclatura

- **Nome do evento:** grafia oficial registrada na ficha da edição (§1) — uma forma só, inclusive maiúsculas e espaços. Nunca abreviar nem traduzir.
- **Nome completo na primeira menção** de qualquer peça; forma curta só depois, se a ficha a definir.
- **Edição:** ordinal + ano conforme a ficha; nunca "a maior edição" ou "a edição mais X" sem fonte.
- **Produto ou marca citado em peça do evento** segue a grafia de `produtos[].nome` e `marcas[].nome`.
- **Slug técnico** do evento em frontmatter, nome de arquivo e UTM: `produtos[].slug` da oferta.

## 7. O que nunca prometer

- Presença de speaker ainda não confirmado (teaser sem nome é permitido com aprovação).
- Número de participantes, de empresas ou de "decisores" na sala.
- "Último lote", "últimas vagas" ou "preço mais baixo" fora da janela em que isso é verdade na ficha.
- Benefício, brinde, certificado, gravação ou acesso posterior que não esteja na ficha.
- Resultado de negócio para o patrocinador (leads, reuniões, vendas).

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
