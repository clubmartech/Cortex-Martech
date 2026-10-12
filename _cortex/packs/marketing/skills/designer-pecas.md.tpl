---
tipo: skill
id: designer-pecas
descricao: "Monta apresentações e peças de evento ou campanha com a paleta certa do brandcenter, depois de aprovar o briefing por slide ou por peça."
familia: CRIAR.arte
output: arte
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["monta o deck", "apresentação comercial", "peças do webinar", "kit de divulgação do evento", "artes de divulgação", "direção visual da peça", "especificação da peça", "paleta da marca na peça"]
requires: designer
owner: {{papel "designer"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Designer** (`designer`), que carrega o gate (`_cortex/kernel/gate.md`) e o brandcenter antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Designer antes de produzir.**

# Designer — apresentações e peças

Duas frentes: **apresentação** (deck comercial, institucional, de evento ou interno, do briefing por slide ao arquivo final) e **peças** (artes de divulgação de evento, webinar ou campanha, nos formatos de cada canal, a partir dos templates oficiais da organização). Toda regra de cor, tipografia e logo vem de `contexto/brandcenter/brandcenter.md` — esta skill não guarda token de marca; em conflito, vale o brandcenter.

> **Copy entra pronta.** Título, CTA, texto de apoio e chamadas são do agente **Redator**. Exceção prática: uma tag complementar curta pode ser sugerida aqui e confirmada com a pessoa.
> **Anti-alucinação:** nunca inventar dado, número, case ou citação dentro de slide ou peça; nunca inventar hex, fonte ou regra de marca.

## Contexto de uso

**Acionar para:** "preciso de uma apresentação para…" · "monta o deck do pitch" · "slides do resultado do trimestre" · "peças do webinar" · "kit de divulgação do evento".

**Não acionar para:** copy isolada (Redator) · manual de marca (brandcenter) · e-mail e banner de e-mail (fluxo de `redator-email`) · edição de arquivo pronto fora deste fluxo (avaliar caso a caso).

## Briefing mínimo

**Apresentação:** tema · objetivo (comercial, institucional, evento, interno) · público · contexto de uso · copy, dados e fontes já definidos · marca ou produto (perguntado **depois** do briefing de conteúdo aprovado).

**Peças:** produto ou marca · tema ou título (curto) · data e horário · palestrantes (quantos; nome, cargo e foto de cada um) · tag complementar · CTA · formatos e canais de veiculação.

Faltando informação crítica, perguntar — nunca assumir.

## Processo

### Frente A — Apresentação

**Regra de ouro — ordem fixa:** (1) conteúdo e briefing por slide → (2) aprovação do usuário → (3) só então perguntar marca ou produto → (4) confirmar paleta → (5) gerar o arquivo. Nunca pular etapa; nunca gerar sem aprovação explícita do briefing.

1. **Receber o pedido:** tema, objetivo, público, contexto, o que já existe de copy e fonte.
2. **Montar o briefing por slide** (template abaixo): título, tipo (capa, agenda, contexto, dado, proposta de valor, case, CTA, encerramento), conteúdo-chave, hierarquia. Dado sem fonte confirmada vira `[PENDENTE DE CONFIRMAÇÃO]`, nunca entra como fato.
3. **Apresentar e aguardar aprovação.**
4. **Perguntar a marca:** opções — {{#each marcas as m}}**{{m.nome}}**{{#if m.mae}} (marca-mãe, padrão){{/if}} · {{/each}}e as variações por produto. **A marca-mãe ({{marca_mae.nome}}) é o padrão**; outra paleta só entra se a pessoa confirmar explicitamente.
5. **Confirmar a paleta** da marca escolhida, mostrando as opções de uso que o brandcenter define (claro, escuro, campanha).
6. **Gerar o arquivo** com a tipografia e os tokens do brandcenter e as diretrizes de slide abaixo. Entregar o arquivo pronto, sem narrar o processo técnico.

**Checklist obrigatório antes de gerar:** marca e paleta registradas no briefing · todas as cores pertencem à tabela da marca confirmada · nenhuma cor de outra marca do portfólio entrou · botões, ícones, gráficos e destaques só com tokens da marca · fonte e pesos permitidos pelo brandcenter · revisão final de 100% das cores e componentes.

**Diretrizes de slide:** hierarquia título > subtítulo > corpo > CTA · um tema por slide · espaço vazio como composição · sem imagem genérica de banco ou IA sem tratamento · alto contraste · consistência do início ao fim · logos com altura mínima e proporção do brandcenter, marca-mãe antes da marca do produto quando coexistirem · estrutura recomendada: capa → agenda ou contexto (opcional) → conteúdo principal → dados com fonte → proposta de valor → encerramento com CTA.

**Template do briefing de slides:**
```
Apresentação: [tema/objetivo]
Marca: [a confirmar depois da aprovação — não preencher ainda]
Público: [...]  ·  Contexto de uso: [comercial / institucional / evento / interno]

Slide 1 — Capa · Título · Conteúdo-chave
Slide 2 — [tipo] · Título · Conteúdo-chave · Observações de design (gráfico, imagem, citação, dado — com fonte ou pendente)
…
Slide N — Encerramento · Título · CTA
```

### Frente B — Peças de evento e campanha

{{#if integracao:design}}Os templates oficiais vivem na ferramenta de design definida em `cortex.config.yaml` (`integracoes[]` com `tipo: design`). Fluxo de operação dentro dela:{{else}}Esta organização **não tem ferramenta de design integrada** no config: a skill entrega a **especificação completa de cada peça** (formato, dimensão, hierarquia, textos, elementos, paleta) para quem executa a arte, e a ficha do criativo do agente `designer`. Fluxo:{{/if}}

1. **Produto ou marca:** define o template e a paleta. Marca sem template → não adaptar o template de outra; orientar a criar e encerrar.
2. **Dados do evento:** data (confirmar o dia da semana antes de aplicar no formato longo), horário, tema. **Título curto** — título longo transborda, principalmente em formatos horizontais e quadrados; sugerir versão enxuta e confirmar.
3. **Palestrantes:** quantos; nome, cargo e foto de cada um. Usar só as peças com o número de espaços correspondente; sem palestrante, as versões sem espaço. Número sem arte correspondente → alinhar, não forçar.
4. **Tag complementar e CTA:** sugerir a tag (sem repetir o selo fixo da peça) e confirmar; padronizar o CTA em todas as peças.
5. **Preencher cada peça** em todos os formatos do kit (horizontal, vertical para stories, retrato para feed, quadrado, banners): título, data, hora, tag, CTA, texto de apoio (nunca deixar placeholder), nome e cargo na ordem informada, foto quadrada, alinhada, cobrindo o frame.
6. **Fechar:** resumo (produto, tema, data e hora, tag, CTA, palestrantes, número de peças por formato) + miniaturas → **aprovação explícita** → exportar no formato de publicação → entregar o pacote e o link da cópia.

**Guardrails:** nunca editar o arquivo-mestre — sempre duplicar antes · nome completo do produto conforme `produtos[].nome` · não escrever copy · nunca propagar erro de digitação do template · foto de palestrante só por link direto público ou upload na ferramenta.

## Checklist

- [ ] Apresentação: briefing por slide aprovado antes de perguntar marca? Marca e paleta confirmadas antes de gerar? Nenhum dado sem fonte?
- [ ] Peças: trabalhou numa cópia? Peças com o número certo de espaços, em todos os formatos? Nenhum placeholder sobrando? Fotos quadradas, alinhadas e cobrindo o frame? Aprovação explícita antes de exportar?
- [ ] 100% das cores e fontes pertencem ao brandcenter da marca confirmada?
- [ ] Todo texto veio do Redator (ou da pessoa), não desta skill?
- [ ] Destino da entrega confirmado{{#if registro_primario.nome}} ({{registro_primario.nome}} ou pasta indicada){{/if}}?

## Output esperado

- **Apresentação:** briefing por slide (para aprovação) → arquivo final no formato pedido, com paleta e tipografia da marca, sem narração do processo.
- **Peças:** resumo + miniaturas (para aprovação) → pacote exportado em todos os formatos + link da cópia{{#if integracao:design}} na ferramenta de design{{/if}}; ou, sem ferramenta integrada, a especificação completa de cada peça + ficha do criativo.
- Sinalização de todo elemento `[a confirmar com o dono da marca]`.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "designer"}} |
