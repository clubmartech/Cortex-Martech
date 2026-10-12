---
tipo: doc
id: direcao-imagem-ia
descricao: "Define como a marca gera imagem com IA — executor autorizado, prompt-base por estilo, consistência de personagem e régua de sinais de IA antes de publicar."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["prompt padrão de imagem", "gerar imagem na estética da marca", "personagem consistente", "imagem parece IA", "qual ferramenta gera imagem", "prompt-base do estilo"]
requires:
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

# Direção de imagem com IA — {{organizacao.nome}}

> Preenchida pela skill `dirigir-imagem-ia`. Executor autorizado: {{default visual.executores.imagem "[PENDENTE: qual ferramenta gera imagem; sem definição, a skill entrega o prompt e a especificação para um humano executar]"}}. Nenhuma outra ferramenta gera imagem da marca sem aprovação.

## 1. Prompt-base por estilo

| Estilo (`estilos-visuais`) | Prompt-base (sujeito entra entre colchetes) | Proporções | Negativo |
|---|---|---|---|
| `[PENDENTE]` | `[PENDENTE]` | | |

Regras do prompt: descrever luz, câmera e composição pela `direcao-fotografica`; cor pelos papéis do design system, sem colar hex de referência; nunca nomear artista vivo, marca ou obra protegida como estilo.

## 2. Consistência

Personagem, mascote ou pessoa recorrente: folha de referência aprovada, descrição fixa e seed ou referência de imagem quando o executor permitir. Pessoa real só com autorização registrada.

## 3. Régua de sinais de IA (antes de publicar)

- [ ] Mãos, dentes, olhos e texto na imagem conferidos.
- [ ] Sem brilho plástico, simetria perfeita ou fundo genérico de banco.
- [ ] Luz coerente entre sujeito e cenário; sombras na mesma direção.
- [ ] Objetos do nicho corretos (equipamento, uniforme, lugar).
- [ ] Nada de logo, marca d'água ou assinatura de terceiros.
- [ ] Cores dentro da paleta (`consistencia.py` quando houver arquivo de peça).

## 4. Registro

Toda imagem gerada aprovada entra no acervo (`acervo.json`) com `origem: ia`, `licenca: gerada-ia`, prompt, executor e data.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
