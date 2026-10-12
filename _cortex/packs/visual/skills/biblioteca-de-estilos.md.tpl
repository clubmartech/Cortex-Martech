---
tipo: skill
id: biblioteca-de-estilos
descricao: "Transforma mecanismos de referências aprovadas em 6 a 12 estilos próprios nomeados, com receita, uso, o que não copiar e peça-piloto antes de ir para produção."
familia: DOCUMENTAR.estilos-visuais
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["cria um estilo novo", "documento de estilo", "transforma essa referência em estilo", "quais estilos usar no carrossel", "receita visual da marca", "biblioteca de estilos"]
requires: diretor-de-arte · estilos-visuais
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# Biblioteca de estilos — repertório que vira jeito próprio

## Contexto de uso

- Etapa 3 do `kit-visual`.
- Formato sem estilo definido (pedido do Arquiteto de Conteúdo).
- Estilo existente que envelheceu ou foi copiado demais.

## Processo

1. Partir dos **candidatos a estilo** do `dna-visual`: mecanismo repetido em 2–3 referências de autores diferentes.
2. Para cada candidato, escrever a ficha em `estilos-visuais.md`: nome curto e próprio, ideia em uma frase, quando usar e quando não, receita (grade, hierarquia com tokens, tratamento de imagem, papéis de cor, elemento-assinatura, ritmo), o que observar, o que não copiar, ids de origem.
3. Propor à pessoa 3–6 estilos de partida, cobrindo os formatos de `visual.formatos`. Ela escolhe.
4. Produzir **uma peça-piloto** por estilo escolhido com o executor da instância e conferir com `consistencia-visual`.
5. Piloto aprovado → estilo `ativo`. Sem piloto → `rascunho` (não usar em produção).

## Regras

- Nome do estilo é da marca; nunca o nome de quem inspirou.
- Valores sempre dos tokens. Estilo que pede cor fora da paleta é sinal de que copia a referência.
- Teto de 12 estilos; acima disso, fundir ou aposentar.

## Output esperado

| Saída | Formato |
|---|---|
| Fichas de estilo | `estilos-visuais.md` |
| Peças-piloto | destino de material gerado, com link na ficha |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
