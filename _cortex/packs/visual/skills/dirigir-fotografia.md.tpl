---
tipo: skill
id: dirigir-fotografia
descricao: "Escreve a direção fotográfica da marca e a shot list de um ensaio — luz, câmera, enquadramento, pose, cenário e pós — coerente com estilos e público."
familia: DOCUMENTAR.direcao-fotografica
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["direção de fotografia da marca", "shot list do ensaio", "como fotografar para a marca", "briefing para o fotógrafo", "escolher foto de banco", "padrão das fotos"]
requires: diretor-de-arte · direcao-fotografica
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# Direção fotográfica — luz, câmera e gente de verdade

## Contexto de uso

- Etapa 3 do `kit-visual`.
- Briefing de ensaio (fotógrafo próprio ou contratado) ou critério para escolher foto de banco.
- Base da `direcao-imagem-ia`: o prompt descreve luz e câmera por esta direção.

## Processo

1. Ler o público visual, os estilos aprovados e o DNA das referências de foto.
2. Preencher `direcao-fotografica.md`: intenção, luz por situação (retrato, objeto, cena), câmera e enquadramento por formato com área segura para texto, pessoas e pose, cenários e objetos do nicho, pós-produção coerente com os tokens, lista do que nunca fotografar.
3. Para ensaio: shot list com plano, uso, formato e prioridade; separar o que precisa de pessoa real (autorização de uso de imagem) do que é objeto ou cena.
4. Para banco: critérios de escolha e de recusa (cara de banco, cliché do nicho, marca de terceiro visível).
5. Se houver skills de fotografia, iluminação e pose instaladas na instância, usá-las como método de detalhe.

## Regras

- Pessoa real só com autorização registrada; nunca gerar rosto de pessoa real sem ela.
- A cor da pós segue os tokens, nunca a referência.
- Naturalidade antes de pose; o gesto mostra a tarefa real do público.

## Output esperado

| Saída | Formato |
|---|---|
| Direção fotográfica | `direcao-fotografica.md` |
| Shot list do ensaio | tabela no briefing do ensaio |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
