---
tipo: skill
id: documentar-funcionalidade
descricao: "Produz a ficha da funcionalidade — o que faz, para quem, como usar, limites, perguntas frequentes — que vira artigo de ajuda e fonte das outras peças."
familia: DOCUMENTAR.funcionalidade
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["documenta a funcionalidade", "ficha da funcionalidade", "escreve o artigo da central de ajuda", "como o cliente usa essa tela", "pré-requisitos e limites da funcionalidade", "perguntas frequentes da funcionalidade", "guia do produto"]
requires: documentador-produto
owner: {{papel "pm"}}
origem: pack:produto@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Documentador de Produto** (`documentador-produto`), que carrega o gate (`_cortex/kernel/gate.md`), o doc-raiz e a ficha do produto antes de passar para cá. **Volte ao Documentador de Produto antes de documentar.**

# Documentar funcionalidade — a ficha que vira artigo

A ficha responde **como o cliente usa** (procedimento, pré-requisito, regra, limite). É a fonte de release notes, aviso, artigo e post. O doc-raiz do produto responde **por que compra** — a ficha aponta para ele, não repete. Uma ficha por funcionalidade{{#if oferta:produto}}, dentro do produto e do módulo{{/if}}.

## Contexto de uso

| Situação | Formato de saída |
|---|---|
| Funcionalidade nova ou alterada, comunicada ao cliente | **Nova funcionalidade** — o que mudou, como usar |
| Processo completo com começo, meio e fim, para consulta recorrente | **Guia** — passo a passo com contexto |
| Erro ou comportamento inesperado com solução conhecida | **Corretiva com instrução** — sintoma, causa, o que fazer |

## Briefing mínimo

Produto (slug){{#if oferta:produto}} e módulo (de `produtos[].modulos`, se houver){{/if}} · **material do PM** (descrição, telas, regras, pré-requisitos) · formato (dos três acima) · estágio de liberação · quem valida.

## Processo

### Passo 1 — Confirmar o formato e o que já existe

Buscar em `CATALOGO.md` e em `times/{{time.slug}}/docs/indice-publicacoes.md`: ficha ou artigo existente é **editado**, não duplicado. Confirmar o formato com quem pediu.

### Passo 2 — Escrever os blocos da ficha

| # | Bloco | O que entra |
|---|---|---|
| 1 | **Identificação** | Produto{{#if oferta:produto}}, módulo{{/if}}, nome oficial da funcionalidade, tipo de entrega, estágio de liberação |
| 2 | **O que faz** | Uma frase, em linguagem de uso. É o título de quase todas as peças derivadas |
| 3 | **Para quem** | Área e papel que usam de fato (slugs de `publicos[]` quando couber) |
| 4 | **Como impacta na prática** | O que muda na rotina — não o que a funcionalidade faz |
| 5 | **Pré-requisitos** | Parâmetro, permissão, configuração ou contratação necessários antes |
| 6 | **Acesso** | Caminho completo de menu, em itálico, como o material traz |
| 7 | **Como usar** | Passo a passo na ordem em que acontece; um verbo por passo |
| 8 | **Regras e comportamento** | O que o sistema valida, bloqueia ou calcula |
| 9 | **Resultado esperado** | O que o cliente vê quando dá certo |
| 10 | **Limites** | O que **não** faz; para quem ainda não está disponível |
| 11 | **Perguntas frequentes** | Dúvidas previsíveis com resposta curta; fonte: atendimento, piloto, PM |
| 12 | **Telas** | Referência aos arquivos em `_assets/produtos/<slug>/<funcionalidade>/` (print, gif curto só da parte que muda, vídeo por link) |

Bloco sem material → `[PENDENTE DE CONFIRMAÇÃO: <pergunta>]`, nunca dedução.

### Passo 3 — Linguagem

Frases curtas · voz ativa · segunda pessoa quando o canal permite · nome oficial da funcionalidade, sempre o mesmo · caminho de menu em itálico · sem linguagem comercial · termos da marca (`contexto/brandcenter/brandcenter.md`).

### Passo 4 — Telas e mídia

Print só quando a imagem explica o que o texto não explica; gif curto só do trecho que mudou; vídeo por link, não embutido. Arquivos em `_assets/` (fora do escopo do scanner), nomeados `<produto>-<funcionalidade>-<n>`; a ficha referencia pelo caminho.

### Passo 5 — Revisar contra os pontos de confusão

Ler como quem nunca viu a tela: cada passo tem onde clicar? Cada regra tem o que acontece quando falha? Cada limite diz o que fazer em vez disso?

### Passo 6 — Validar, gravar, derivar

Inteiro no chat → validação do papel `{{papel "pm"}}` → gravar em `times/{{time.slug}}/docs/funcionalidade-<produto>-<nome>.md` com frontmatter de 14 campos (`tipo: doc`, `produto:` com o slug) → derivar artigo, aviso, release com a ficha como fonte → registrar a publicação em `indice-publicacoes`.

## Regras

- Tudo vem do material do PM ou do que já está documentado; nome, caminho e regra **nunca** são inferidos.
- A ficha não vende: benefício fica no doc-raiz e na `matriz-mensagens`.
- Funcionalidade em piloto leva o estágio no bloco 1 e o limite no bloco 10.
- Artigo publicado sem ficha correspondente é dívida: criar a ficha a partir dele.

## Checklist

- [ ] Formato confirmado? Ficha existente editada, não duplicada?
- [ ] Doze blocos preenchidos ou marcados?
- [ ] Caminho de menu e nome oficial como o material traz?
- [ ] Telas em `_assets/` referenciadas? Limites explícitos?
- [ ] Validação humana? Publicação registrada no índice?

## Output esperado

| Saída | Formato |
|---|---|
| Ficha de funcionalidade | doc `funcionalidade-<produto>-<nome>.md` na pasta de docs do time, doze blocos |
| Artigo de central de ajuda | texto no formato escolhido, derivado da ficha |
| Lista de pendências ao PM | tabela: bloco · pergunta · status |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack produto@1.0. | {{papel "pm"}} |
