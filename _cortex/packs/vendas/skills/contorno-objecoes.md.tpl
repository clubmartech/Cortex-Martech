---
tipo: skill
id: contorno-objecoes
descricao: "Responde à objeção com a matriz objeção → resposta → prova por público: entende antes de rebater, usa só prova registrada e devolve a conversa com uma pergunta."
familia: DOCUMENTAR.objecoes
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como respondo essa objeção", "o lead disse que já tem fornecedor", "objeção de preço", "objeção de tempo", "argumento contra a objeção", "prova para rebater a objeção", "o cliente quer pensar", "matriz de objeções"]
requires: executivo-vendas · matriz-objecoes
owner: {{papel "executivo"}}
origem: pack:vendas@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Executivo de Vendas** (`executivo-vendas`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e a matriz de objeções antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Executivo antes de responder.**

# Contorno de objeções — matriz por público

Objeção é informação sobre o que falta para decidir, não resistência a vencer. O método tem quatro movimentos: **acolher** (reconhecer sem concordar) → **entender** (perguntar o que está por trás) → **responder** (com a prova registrada na matriz) → **devolver** (pergunta que recoloca a conversa no próximo passo). A matriz vive em `times/{{time.slug}}/docs/matriz-objecoes.md`; esta skill a aplica e a alimenta.

## Contexto de uso

- Objeção levantada em ligação, reunião, proposta ou follow-up.
- Preparação de reunião: antecipar as objeções do público.
- Objeção nova (não está na matriz): registrar com `[PENDENTE: validar resposta]`.
- Revisão da matriz a partir de `analise-motivos-de-perda`.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| A objeção, nas palavras do cliente | sim |
| Público e papel de quem falou (decisor, usuário, influenciador) | sim |
| Produto e estágio do negócio | sim |
| O que já foi dito ou mostrado | sim |
| Canal da resposta (ao vivo, mensagem, e-mail) | sim |

A mesma objeção muda de significado por estágio: "está caro" na prospecção é pedido de contexto; na negociação é pedido de prova de valor. Sem estágio, não responder.

## Processo

1. **Classificar** a objeção numa família:

| Família | O que o cliente diz | O que costuma estar por trás |
|---|---|---|
| Preço / orçamento | "está caro", "não tenho verba" | valor não ficou claro; comparação com alternativa barata; momento |
| Status quo | "já tenho planilha / fornecedor / sistema" | custo de mudar; medo de perder o que funciona |
| Timing | "não é o momento", "ano que vem" | sem urgência; prioridade concorrente; decisor ausente |
| Autoridade | "preciso falar com…" | decisor não mapeado; contato sem poder |
| Confiança | "nunca ouvi falar", "já tentamos algo assim" | prova insuficiente; experiência ruim |
| Produto | "não faz X", "não integra com Y" | lacuna real ou desconhecimento; verificar no doc |
| Necessidade | "não vejo o problema" | fit baixo; voltar à qualificação |

2. **Abrir a matriz** na linha do público. Objeções registradas no config, por público:
{{#each publicos as pu}}   - **{{pu.nome}}** (`{{pu.slug}}`): "{{pu.objecao}}"
{{/each}}3. **Acolher + entender**: uma frase de reconhecimento e uma pergunta — "Faz sentido. Caro em relação a quê?" · "O que a planilha resolve bem hoje que você não quer perder?" · "O que precisaria acontecer para ser o momento?"
4. **Responder** com a prova da matriz (dado com fonte, caso autorizado, demonstração, garantia contratual real). Sem prova registrada: não inventar — responder com pergunta e marcar `[NECESSITA FONTE]` na matriz.
5. **Devolver** a conversa: proposta de próximo passo concreto (mostrar o cálculo, incluir o decisor, demonstração focada na lacuna).
6. **Registrar** a objeção e o resultado {{#if registro_primario.nome}}em **{{registro_primario.nome}}**{{else}}no registro definido em `cortex.config.yaml`{{/if}}; objeção nova entra na matriz com `[PENDENTE: validar resposta]` e vai ao Líder de Vendas.

### Objeção de produto

Verificar no doc `contexto/produtos/<slug>/<slug>.md` antes de responder. Lacuna confirmada → dizer que não faz e perguntar o peso disso na decisão; nunca prometer roadmap. Desconhecimento → mostrar, não argumentar.

### Objeção de preço

Nunca responder com desconto. Sequência: entender a comparação → voltar ao impacto declarado no diagnóstico → mostrar o custo de não agir com os números **dele** → só então condições (dentro do limite informado pelo usuário, `[INFORMADO PELO CLIENTE]`).

## Regras

- Nunca rebater antes de perguntar.
- Prova só da matriz ou do doc do produto; número sem fonte não é prova.
- Não desqualificar concorrente nem comparar sem fonte.
- Não prometer funcionalidade, prazo ou integração fora do doc do produto.
- Desconto não é resposta a objeção.
- Termos proibidos de {{marca_mae.nome}} ({{join marca_mae.termos_proibidos ", "}}) fora da resposta.

## Checklist

- [ ] Objeção classificada por família e estágio?
- [ ] Pergunta de entendimento antes da resposta?
- [ ] Prova da matriz, com fonte? Sem prova → pergunta + marcador?
- [ ] Resposta termina em próximo passo?
- [ ] Objeção nova registrada na matriz?
- [ ] Tom da marca; nada prometido fora do doc do produto?

## Output esperado

```
OBJEÇÃO: "[palavras do cliente]" — família: [...] — público: [...] — estágio: [...]
O que está por trás (hipótese): [...]

ACOLHER: [uma frase]
ENTENDER: [pergunta]
RESPONDER: [resposta curta + prova: fonte]
DEVOLVER: [próximo passo proposto]

Se insistir: [segunda resposta ou encerramento respeitoso]
Registro na matriz: [linha existente / nova com [PENDENTE: validar resposta]]
```

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack vendas@1.0. | {{papel "executivo"}} |
