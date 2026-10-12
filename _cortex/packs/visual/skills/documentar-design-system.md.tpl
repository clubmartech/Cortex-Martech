---
tipo: skill
id: documentar-design-system
descricao: "Fixa os tokens da marca em DTCG — cor, tipografia, espaço, raio e motion, temas claro e escuro — com contraste conferido, CSS exportado e página-amostra."
familia: DOCUMENTAR.design-system
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["cria o design system", "define os tokens da marca", "paleta e tipografia oficiais", "versão escura da marca", "exporta as variáveis CSS", "documento de system design"]
requires: diretor-de-arte · design-system
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`). Design system é fundação da marca: exige ratificação (`_cortex/kernel/governanca.md` §4).

# Design system — valores num lugar só

Os valores moram em `times/{{time.slug}}/docs/tokens.json` (formato DTCG). O `design-system.md` explica o uso. CSS, página-amostra e auditoria de peças derivam do JSON.

## Contexto de uso

- Etapa 4 do `kit-visual`, depois de estilos aprovados.
- Marca que já tem valores (manual, Figma, site): transcrever para tokens e validar.
- Ajustar contraste, criar tema escuro, acrescentar componente.

## Briefing mínimo

Estilos aprovados · valores existentes da marca (logo, cores, fontes já em uso) · formatos e telas onde o sistema roda · exigência de acessibilidade.

## Processo

1. **Partir do que existe.** Se a marca já tem cores e fontes, transcrever; não reinventar.
2. **Propor** 2 opções de paleta e par tipográfico coerentes com os estilos e o público, cada uma com justificativa. Nunca a paleta de uma referência.
3. **Gravar** no `tokens.json` depois da escolha. Aliases DTCG (`"{cor.marca.primaria}"`) para não repetir valor. Tema escuro em `$extensions.cortex.temas.escuro`; pares de contraste em `$extensions.cortex.contraste`.
4. **Validar:**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/tokens.py validar times/{{time.slug}}/docs/tokens.json
```

Barra cor não-hex, dimensão sem unidade, alias quebrado ou em ciclo e contraste abaixo do mínimo (texto 4,5:1). `null` é aviso: valor a preencher.

5. **Exportar e mostrar:**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/tokens.py exportar times/{{time.slug}}/docs/tokens.json --saida _saida/visual/tokens.css
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/tokens.py amostra times/{{time.slug}}/docs/tokens.json --saida _saida/visual/design-system.html
```

6. **Documentar** papéis de cor, tipografia, componentes e acessibilidade em `design-system.md`, sem repetir valores; ligar cada decisão ao estilo que a motivou.
7. **Ratificar** com `{{papel "diretor-de-arte"}}` e registrar no `## Histórico`. Depois, o brandcenter passa a apontar para o design system.

## Regras

- Valor só no JSON. Doc, skill e template apontam.
- Contraste abaixo do mínimo não é gravado.
- Mudança de identidade é decisão datada (no registro de decisões do projeto, se houver) e passa pelo ratificador.

## Output esperado

| Saída | Formato |
|---|---|
| Tokens válidos | `tokens.json` |
| Variáveis CSS | `_saida/visual/tokens.css` |
| Página-amostra | `_saida/visual/design-system.html` |
| Doc de uso | `design-system.md` atualizado |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
