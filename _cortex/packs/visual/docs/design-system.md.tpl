---
tipo: doc
id: design-system
descricao: "Explica o uso do sistema visual — papéis de cor, tipografia, espaço, motion, temas, contraste e componentes — com os valores só no tokens.json."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["qual é a cor da marca", "tokens da marca", "tipografia oficial", "versão escura", "componentes da marca", "regras de uso de cor"]
requires:
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Design system — {{organizacao.nome}}

> **Valores moram num lugar só:** `times/{{time.slug}}/docs/tokens.json` (formato DTCG). Este doc explica **como usar**; não repete hex nem tamanho. Quem precisa de um valor lê o JSON ou o CSS exportado. Muda pela skill `documentar-design-system`, com ratificação de `{{papel "diretor-de-arte"}}` (é fundação da marca).

## 1. Estado

| Item | Situação |
|---|---|
| Tokens | `[PENDENTE: rodar a skill documentar-design-system a partir de estilos aprovados]` |
| Contraste | conferido por `_cortex/packs/visual/scripts/tokens.py validar` (WCAG; texto ≥ 4,5:1) |
| Temas | claro `[PENDENTE]` · escuro `[PENDENTE]` |
| Exportações | CSS de variáveis e página-amostra, gerados por `tokens.py exportar` e `tokens.py amostra` |

## 2. Cor — papéis, não valores

| Papel | Uso | Não usar para |
|---|---|---|
| `cor.marca.primaria` | `[PENDENTE: botão principal, destaque de marca…]` | `[PENDENTE]` |
| `cor.marca.secundaria` | `[PENDENTE]` | `[PENDENTE]` |
| `cor.marca.destaque` | `[PENDENTE: uma informação por peça]` | `[PENDENTE: fundo, texto longo]` |
| `cor.fundo` / `cor.superficie` | fundo da página e de cartões | — |
| `cor.texto` / `cor.texto-suave` | texto principal e secundário | texto sobre cor de marca sem conferir contraste |
| `cor.borda` | divisórias e contornos | — |

## 3. Tipografia

| Papel | Token | Regra |
|---|---|---|
| Título | `tipografia.familia.titulo` | `[PENDENTE: pesos permitidos, caixa, entrelinha]` |
| Texto | `tipografia.familia.texto` | `[PENDENTE]` |
| Pesos | `tipografia.peso.*` | só os declarados; o `consistencia.py` acusa o resto |

## 4. Espaço, raio, sombra e motion

`[PENDENTE: escala de espaço em uso, raio padrão, quando há sombra, duração e curva de animação]`

## 5. Componentes

| Componente | Anatomia | Estados | Onde aparece |
|---|---|---|---|
| `[PENDENTE: botão]` | | padrão · foco · desabilitado | |
| `[PENDENTE: cartão]` | | | |

## 6. Acessibilidade

Contraste mínimo 4,5:1 para texto e 3:1 para elementos gráficos e texto grande. Foco visível. Movimento respeita `prefers-reduced-motion`. Cor nunca é o único portador de significado.

## 7. Origem das decisões

Cada decisão aponta para o estilo ou a referência que a motivou (`estilos-visuais`) e para a aprovação. A paleta de uma referência **nunca** é transportada: o DNA explica mecanismo, a marca decide valores.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
