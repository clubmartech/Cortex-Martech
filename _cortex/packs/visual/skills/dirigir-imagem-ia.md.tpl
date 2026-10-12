---
tipo: skill
id: dirigir-imagem-ia
descricao: "Escreve o prompt-base de cada estilo, a regra de consistência de personagem e a régua de sinais de IA, e conduz a geração pelo executor autorizado."
familia: DOCUMENTAR.direcao-imagem-ia
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["prompt padrão de imagem", "gera imagem na estética da marca", "personagem consistente", "essa imagem parece IA", "prompt-base do estilo", "qual ferramenta gera imagem"]
requires: diretor-de-arte · direcao-imagem-ia
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# Direção de imagem com IA — prompt que respeita a marca

## Contexto de uso

- Etapa 3 do `kit-visual`.
- Geração de imagem para peça; personagem ou mascote recorrente; revisão de imagem gerada.

## Processo

1. **Executor.** {{#if tem:visual.executores.imagem}}Autorizado: `{{visual.executores.imagem}}`.{{else}}Sem executor definido em `visual.executores.imagem`: entregar prompt e especificação para um humano executar, e perguntar se deve ser definido.{{/if}}
2. **Prompt-base por estilo** em `direcao-imagem-ia.md`: sujeito entre colchetes; luz, câmera e composição pela `direcao-fotografica`; cor por papéis do design system (sem colar hex de referência); proporção por formato; negativo.
3. **Consistência:** folha de referência aprovada para personagem, mascote ou pessoa recorrente; descrição fixa; referência de imagem ou seed quando o executor permitir.
4. **Gerar** variações pequenas (2–4), escolher com a pessoa.
5. **Régua de sinais de IA** (seção 3 do doc) antes de qualquer uso. Arquivo de peça → `consistencia-visual`.
6. **Registrar** aprovadas no acervo com `origem: ia`, `licenca: gerada-ia`, prompt, executor e data.

## Regras

- Nunca nomear artista vivo, marca ou obra protegida como estilo.
- Pessoa real só com autorização; imagem gerada não é prova de resultado.
- Texto e imagem gerados passam por revisão humana antes de publicar.

## Output esperado

| Saída | Formato |
|---|---|
| Prompts-base e régua | `direcao-imagem-ia.md` |
| Imagens aprovadas | acervo + destino de material gerado |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
