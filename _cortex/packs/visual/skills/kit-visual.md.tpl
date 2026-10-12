---
tipo: skill
id: kit-visual
descricao: "Leva do nicho ao sistema visual em sete etapas — radar, DNA, estilos, design system, acervo, mapa e pilotos — com aprovação humana onde a marca é decidida."
familia: PLANEJAR.kit-visual
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o kit visual", "cria a identidade visual do zero", "recria a estética da marca", "do nicho ao design system", "onboarding visual da marca", "sistema visual completo"]
requires: diretor-de-arte
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`), que carrega o gate, a marca e a governança. Volte a ele se a marca ainda não estiver aberta.

# Kit visual — do nicho ao sistema, com poucos comandos

Encadeia as skills do pack numa ordem que evita retrabalho: primeiro repertório, depois mecanismo, depois decisão, por fim documentação e pilotos. Cada etapa grava seu estado; interromper não perde trabalho e nenhuma etapa reabre decisão já aprovada.

## Contexto de uso

- Marca nova, reposicionamento visual ou instância nova do Cortex que precisa de sistema visual.
- Refazer uma etapa isolada: "refaz o radar", "atualiza o design system".

## Briefing mínimo

`visual.nicho`, `visual.publico_visual` e `visual.formatos` no `cortex.config.yaml` (se faltarem, rodar o bloco B11 de `_cortex/onboarding/questionario.md`) · fontes próprias da pessoa · executores disponíveis (`visual.executores`) · prazo e o que já existe (logo, fontes, fotos).

## Processo

Estado em `_saida/visual/kit-<AAAA-MM-DD>/estado.md`: etapa atual, decisões aprovadas com data, pendências. Ler antes de começar; atualizar ao fim de cada etapa.

| Etapa | Skill | Saída | Aprovação humana |
|---|---|---|---|
| 1. Radar | `radar-de-referencias` | lote triado com fichas | **Sim** — aprova, veta, favorita |
| 2. DNA | `dna-visual` | mecanismo de cada aprovada | não |
| 3. Estilos e direções | `biblioteca-de-estilos`, `dirigir-fotografia`, `dirigir-imagem-ia`{{#if canal:youtube or canal:instagram or canal:tiktok or canal:linkedin}}, `dirigir-video`{{/if}} | 3–6 estilos, direções em rascunho | **Sim** — escolhe estilos, confirma direções |
| 4. Design system | `documentar-design-system` | `tokens.json` válido, CSS, página-amostra | **Sim, antes de gravar** — ratificação |
| 5. Acervo | `acervo-visual` | acervo com licenças e galeria | não |
| 6. Mapa | `mapear-conteudo` | mapa com lacunas | **Sim** |
| 7. Pilotos | executores da instância (pack marketing ou ferramentas próprias) | 1 peça por formato | **Sim**, e revisão humana antes de publicar |

Regras de condução:

1. **Uma etapa por rodada.** Ao fim, mostrar em 3–5 linhas o que foi decidido e o que vem a seguir.
2. **Aprovação explícita** nas etapas marcadas. Silêncio não é aprovação.
3. **Saturação:** se o radar indicar saturado, não rodar outra rodada; seguir para o DNA.
4. **Verificação no fim:** `tokens.py validar`, `acervo.py validar`, `consistencia.py` nos pilotos e `cortex.py doctor` (check 15).

## Output esperado

| Saída | Onde |
|---|---|
| Estado do kit | `_saida/visual/kit-<data>/estado.md` |
| Fontes, acervo, estilos, direções, design system, mapa | `times/{{time.slug}}/docs/` |
| Galeria e página-amostra | `_saida/visual/` |
| Pilotos | destino de material gerado (`governanca.md` §8) |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
