---
tipo: skill
id: acervo-visual
descricao: "Mantém o acervo visual com licença e procedência de cada item — referências aprovadas, peças próprias e imagens geradas — e gera a galeria HTML filtrável."
familia: OPERAR.acervo-visual
output: dado
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["organiza o acervo", "galeria de referências", "registra essa imagem no acervo", "qual a licença dessa imagem", "catálogo visual", "atualiza a galeria"]
requires: curador-visual
owner: {{papel "curador-visual"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo **Curador Visual** (`curador-visual`).

# Acervo visual — cada item com origem, licença e motivo

O acervo é o que a marca pode estudar e usar, separado do que não pode. O manifesto fica em `times/{{time.slug}}/docs/acervo.json` (lido pela IA); a mídia própria fica em `_assets/acervo/` e a de terceiros, quando guardada para estudo, fora do escopo da IA e nunca em peça.

## Contexto de uso

- Importar referências aprovadas pelo radar.
- Registrar peça própria publicada, foto de ensaio ou imagem gerada aprovada.
- Responder "posso usar esta imagem?" e "onde está a referência de X?".

## Processo

**1. Importar referências aprovadas.**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/acervo.py importar times/{{time.slug}}/docs/acervo.json _saida/visual/radar-<AAAA-MM-DD>/lote.triado.json
```

**2. Registrar item próprio ou gerado:** `id`, `titulo`, `tipo` (`proprio` ou `gerado`), `origem` (`proprio` ou `ia`), `licenca` (`propria` ou `gerada-ia`), `data`, `arquivo` relativo ao manifesto, `funcao`, `formato`, `tags` (`estilo`, `mood`, `cor`, `tema`). Imagem gerada leva prompt e executor.

**3. Licença.**

| Licença | Uso em peça |
|---|---|
| `propria`, `gerada-ia`, `cc0`, `dominio-publico`, `pexels`, `pixabay`, `unsplash` | livre (respeitar termos do banco) |
| `cc-by` | só com `credito` na peça |
| `so-referencia` | nunca; só estudo |
| `cc-by-sa`, `cc-by-nc`, `cc-by-nd`, `desconhecida` | recusada; fica só como registro |

**4. Hash e validação.**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/acervo.py hash times/{{time.slug}}/docs/acervo.json
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/acervo.py validar times/{{time.slug}}/docs/acervo.json
```

O validador acusa: campo obrigatório ausente, licença desconhecida, CC BY sem crédito, recusada aprovada, mídia de terceiro só-referência dentro do escopo, URL ou arquivo duplicado, sha256 divergente.

**5. Galeria.**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/acervo.py galeria times/{{time.slug}}/docs/acervo.json --saida _saida/visual/acervo.html
```

Filtros por tipo, função, estilo e licença; busca livre; cada card mostra o que observar e o que não copiar.

## Regras

- Licença primeiro; na dúvida, `desconhecida` (recusada).
- Mídia de terceiros nunca entra em peça nem dentro do escopo da IA.
- Item sem motivo (`observar`, `funcao`) é ruído: completar ou retirar.

## Output esperado

| Saída | Formato |
|---|---|
| Manifesto válido | `acervo.json` |
| Galeria | `_saida/visual/acervo.html` |
| Relatório | saída do `acervo.py validar` |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "curador-visual"}} |
