---
tipo: skill
id: consistencia-visual
descricao: "Audita peça ou lote contra o sistema visual — cores, fontes e pesos fora dos tokens, contraste, sinais de IA e marca d'água — e devolve o que corrigir."
familia: REVISAR.consistencia-visual
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["essa peça está na marca", "confere as cores da arte", "audita o lote visual", "fonte errada na peça", "revisão visual antes de publicar", "a imagem parece IA"]
requires: diretor-de-arte · design-system
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# Consistência visual — a peça segue o sistema?

## Contexto de uso

- Antes de publicar peça ou lote; depois de gerar pilotos; quando "algo parece fora".

## Processo

1. **Automático** (peças em HTML, CSS ou SVG):

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/consistencia.py times/{{time.slug}}/docs/tokens.json <peças…>
```

Acusa cor fora da paleta (tolerância por canal RGB), família tipográfica e peso não declarados. Para PNG, JPG e vídeo, a conferência é visual.

2. **Visual**, peça a peça: estilo declarado e respeitado · hierarquia legível no celular · contraste de texto sobre imagem · área segura · régua de sinais de IA (`direcao-imagem-ia.md` §3) · nenhum logo, marca d'água ou handle de terceiro · crédito presente quando a licença pede.
3. **Relatório:** por peça, o que corrigir, em ordem de gravidade (bloqueia publicação · corrigir · sugestão).

## Regras

- Achado que bloqueia: contraste insuficiente em texto, mídia sem licença, marca de terceiro, sinal evidente de IA.
- Revisão automática não substitui o olhar humano antes de publicar.

## Output esperado

| Saída | Formato |
|---|---|
| Relatório de consistência | lista por peça, com gravidade |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
