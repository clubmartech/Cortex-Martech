---
tipo: doc
id: direcao-fotografica
descricao: "Define como a marca fotografa — luz, lente, enquadramento, pessoas, cenários, pós e o que nunca fotografar — para ensaio, banco e imagem gerada."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como a marca fotografa", "guia de fotografia", "padrão das fotos", "ensaio da marca", "que tipo de foto usar", "foto de equipe"]
requires:
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Direção fotográfica — {{organizacao.nome}}

> Vale para ensaio próprio, foto de banco e imagem gerada. Preenchida pela skill `dirigir-fotografia` a partir de estilos aprovados. {{#if visual.pessoas_reais}}**Esta marca tem pessoas reais na comunicação:** retrato, autorização de uso de imagem e consistência de aparência são obrigatórios.{{else}}`[PENDENTE: a marca usa pessoas reais (fundador, equipe, clientes)? Isso muda retrato e autorização]`{{/if}}

## 1. Intenção

Quem precisa se reconhecer na foto: {{default visual.publico_visual "[PENDENTE: público visual]"}}. O que a foto deve fazer sentir: `[PENDENTE]`.

## 2. Luz

| Situação | Luz | Evitar |
|---|---|---|
| Retrato | `[PENDENTE: direção, tamanho aparente da fonte, contraste]` | `[PENDENTE]` |
| Produto ou objeto | `[PENDENTE]` | `[PENDENTE]` |
| Ambiente e cena | `[PENDENTE: horário, natural ou artificial]` | `[PENDENTE]` |

## 3. Câmera e enquadramento

Lente e distância por tipo de plano · altura de câmera · proporções por formato (feed, stories, site, e-mail) · área segura para texto. `[PENDENTE]`

## 4. Pessoas, pose e ação

Naturalidade antes de pose · direção do olhar · gesto que mostra a tarefa real · diversidade coerente com o público · nada de pessoa real gerada sem autorização. `[PENDENTE]`

## 5. Cenários e objetos

`[PENDENTE: onde a marca vive; objetos que identificam o nicho; o que tirar de cena]`

## 6. Pós-produção

Cor coerente com os tokens (sem transportar paleta de referência) · pele natural · grão e nitidez · sem filtro de app. `[PENDENTE]`

## 7. Nunca

`[PENDENTE: clichês do nicho a evitar, situações de risco, marcas de terceiros visíveis]` · marca d'água ou handle alheio · foto de banco reconhecível como banco quando o assunto é a própria marca.

## 8. Shot list base

| # | Plano | Uso | Formato |
|---|---|---|---|
| 1 | `[PENDENTE]` | | |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
