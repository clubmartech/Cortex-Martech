---
tipo: doc
id: modelo-iniciativa-evento
descricao: "Explica como abrir a pasta de uma edição de evento em iniciativas/ — o que vai no iniciativa.yaml, quais arquivos nascem lá e o que fica no time."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["como abro a pasta da edição", "o que vai no iniciativa.yaml do evento", "como crio a iniciativa do evento", "onde fica a edição deste ano", "nova edição do evento, por onde começo", "estrutura da pasta da iniciativa de evento"]
requires:
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

# Modelo de iniciativa de evento — {{organizacao.nome}}

> Cada **edição** de um evento é uma iniciativa: pasta própria em `iniciativas/<evento>-<ano>/`, com `iniciativa.yaml` e a ficha preenchida. O `build` detecta a pasta e liga o modificador **§3.7 iniciativa** do `ROTAS.md`: toda demanda que cita a edição passa a carregar a ficha dela antes de qualquer skill. O que é **modelo** (ficha vazia, regras, skills) fica em `times/{{time.slug}}/`; o que é **da edição** (datas, lotes, speakers, patrocinadores, análises) fica na iniciativa.

## 1. Quando abrir

- Ao decidir que haverá uma edição — tipicamente de oito a dez meses antes de evento presencial com bilheteria; menos para online.
- **Antes** de configurar plataforma de venda, abrir cotas de patrocínio ou convidar speaker: tudo isso referencia a ficha.
- Uma pasta por edição. Edição regional, pocket ou série paralela do mesmo evento é outra iniciativa, com outra ficha (`regras-comunicacao-evento` §5).

## 2. Estrutura da pasta

```
iniciativas/<evento>-<ano>/
├── iniciativa.yaml                 # obrigatório — lido pelo build
├── ficha-<evento>-<ano>.md         # cópia preenchida de times/{{time.slug}}/docs/ficha-edicao.md
├── docs/                           # opcional: metas-e-canais, plano de divulgação, aprendizados
└── skills/                         # opcional: sub-skill específica da edição (ex.: série de conteúdo)
```

Nome de arquivo único na base (sufixo `<evento>-<ano>`), porque o `id` deriva do nome (`CONTRATOS.md` §2.1). Material gerado (planilha, deck, peça) **não** entra aqui — vai para o registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou para `_saida/`.

## 3. `iniciativa.yaml`

```yaml
slug: <evento>-<ano>          # igual ao nome da pasta; kebab-case, sem acento
nome: "<Nome oficial do evento> <ano>"
inicio: AAAA-MM-DD            # abertura do ciclo (ou da esquenta)
fim: AAAA-MM-DD               # data do evento ou fim do pós-evento
oferta: <slug>                # produtos[].slug da oferta tipo evento{{#each produtos as p}}{{#if p.tipo == "evento"}} — ex.: {{p.slug}}{{/if}}{{/each}}
time: {{time.slug}}           # times[].slug que é dono da edição
```

| Campo | Regra |
|---|---|
| `slug` | Único entre iniciativas; vira sufixo dos arquivos da pasta |
| `nome` | Grafia oficial de `regras-comunicacao-evento` §6 + ano |
| `inicio` / `fim` | Datas reais; o build usa para marcar a iniciativa como ativa, futura ou encerrada |
| `oferta` | Precisa existir em `produtos[]` com `tipo: evento`; se o evento ainda não é oferta, cadastrar antes |
| `time` | Time que instalou o pack eventos (`{{time.slug}}`) |

## 4. Passo a passo

1. Confirmar a oferta em `cortex.config.yaml › produtos[]` (`tipo: evento`); criar se faltar e rodar `cortex build`.
2. Criar a pasta e o `iniciativa.yaml` (acima).
3. Copiar `times/{{time.slug}}/docs/ficha-edicao.md` para `ficha-<evento>-<ano>.md`, trocar o `id`, `origem: time`, `validado_em` de hoje e a primeira linha do Histórico.
4. Preencher a ficha com o Produtor (`planejar-edicao-evento` entrega janelas, escada e cortesias; `captar-patrocinio` e `curadoria-speakers` alimentam §8 e §9).
5. Rodar `cortex build` — a iniciativa aparece no `ROTAS.md` §3.7 e o `doctor` passa a validar os arquivos dela.
6. Registrar a abertura no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}.

## 5. Ao encerrar a edição

- `analisar-ciclo-evento` produz o diagnóstico; o que for aprendizado validado vai para `docs/aprendizados-<evento>-<ano>.md` na iniciativa{{#if pack:marketing}} e, se for faixa de canal, para `benchmarks-canal` do pack marketing{{/if}}.
- A ficha **não** é apagada: vira histórico da edição e base de comparação para a próxima.
- A próxima edição nasce de uma pasta nova, não da edição anterior editada.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
