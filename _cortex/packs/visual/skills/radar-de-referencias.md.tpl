---
tipo: skill
id: radar-de-referencias
descricao: "Busca referências do nicho nas fontes certas e entrega um lote triado com link, autor, licença, o que observar e o que não copiar, pronto para a pessoa aprovar."
familia: ANALISAR.referencias-visuais
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["busca referências de", "referências visuais do nicho", "monta um moodboard", "o que os melhores do nicho fazem", "inspiração visual para", "descobre perfis de referência"]
requires: curador-visual · fontes-de-referencia
owner: {{papel "curador-visual"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo **Curador Visual** (`curador-visual`). Volte a ele para carregar fontes, acervo e regras de uso.

# Radar de referências — do nicho ao lote triado

O radar responde "o que vale estudar para este formato, neste nicho" com **menos e melhores** referências, cada uma com procedência. Ordem de busca: fontes próprias da pessoa → fontes do nicho aprovadas → catálogo sugerido. O script não navega nem baixa nada; quem busca é a IA ou a pessoa, pelo navegador ou por API, dentro das regras de cada fonte.

## Contexto de uso

- Início do `kit-visual` (etapa 1) ou estilo novo que pede repertório.
- Formato novo (ex.: primeiro vídeo vertical) sem referência no acervo.
- Descobrir perfis, marcas e canais do nicho para o registro de fontes.

## Briefing mínimo

Formato(s) e canal · público · o que a peça precisa resolver · referências que a pessoa já tem · o que ela não quer ver · nicho (`visual.nicho`, `visual.termos_nicho`).

## Processo

**1. Vocabulário.** Partir de `visual.nicho`, `visual.termos_nicho` e `organizacao.segmento`. Expandir em pt e en: termos do nicho, cenas típicas, objetos, emoções, e **anti-clichês** (o que todo mundo do nicho já faz). Ex.: para uma escola de esqui, "aula de esqui em família, luz de fim de tarde" entra; "pódio" e "esporte radical genérico" ficam como anti-clichê.

**2. Plano.**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/radar.py plano times/{{time.slug}}/docs/fontes-de-referencia.md --termos "termo 1; termo 2"
```

Gera `plano.md`, `plano.json` e `lote.json` vazio em `_saida/visual/radar-<AAAA-MM-DD>/`.

**3. Descoberta do nicho (quando pedido).** Buscar na web perfis, marcas, canais e publicações referência do segmento. Propor à pessoa uma lista curta com motivo; **só os aprovados** entram em `fontes-de-referencia.md` com `origem: nicho`.

**4. Busca.** Seguir o plano. Fonte com login ou termos restritivos: navegação assistida, guardar link e análise, sem raspagem e sem baixar mídia para o acervo de uso. API (bancos livres, vídeo): chave pelo cofre ou variável de ambiente.

**5. Ficha por referência** em `lote.json`: `url`, `titulo`, `autor`, `fonte`, `tipo`, `formato`, `licenca`, `tags`, `mecanismos` (o que faz funcionar, em termos próprios), `observar`, `nao_copiar` e notas 0–3 em seis critérios:

| Critério | 0 | 3 |
|---|---|---|
| `aderencia` ao nicho e público | outro mundo | o público se reconhece |
| `execucao` | amadora | referência de ofício |
| `distancia_cliche` | o que todos fazem | caminho próprio |
| `aplicabilidade` aos formatos | não cabe | cabe sem adaptação forçada |
| `licenca` | desconhecida | livre ou estudo claro |
| `atualidade` | datada | atual sem ser moda passageira |

**6. Triagem.**

```bash
{{default sessao.python "python3"}} _cortex/packs/visual/scripts/radar.py triar _saida/visual/radar-<AAAA-MM-DD>/lote.json --anteriores <lotes anteriores .triado.json>
```

Aplica nota mínima (10 de 18), licença, URL repetida, no máximo 3 por autor, cotas por tipo e saturação (nenhum mecanismo novo frente aos lotes anteriores = parar).

**7. Aprovação.** Mostrar `lote.triado.md`. Marcar `decisao: aprovado` **só** no que a pessoa aprovou. Depois, `acervo-visual` importa.

## Regras

- Inspirar sem copiar; referência é estudo, não peça.
- Sem raspagem em massa, sem download de mídia de terceiros para peça, sem marca d'água ou handle alheio.
- Lote pequeno e diverso vale mais que lote grande; saturou, parou.
- Triagem não é aprovação.

## Output esperado

| Saída | Formato |
|---|---|
| Plano de busca | `plano.md` + `plano.json` |
| Lote triado para aprovação | `lote.triado.md` + `lote.triado.json` |
| Fontes novas do nicho | proposta para `fontes-de-referencia.md`, aprovada |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "curador-visual"}} |
