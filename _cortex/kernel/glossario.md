---
tipo: doc
id: glossario
descricao: "Explica as siglas de marketing, vendas e IA usadas na base e os termos próprios do Cortex, sem duplicar regra de nenhum outro arquivo."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que significa essa sigla", "o que quer dizer ICP", "o que é ABM", "o que é um pack no Cortex", "o que é orçamento de rota", "o que é o kernel", "o que é um marcador de incerteza"]
requires:
owner: cortex
origem: kernel
validado_em: 2026-10-03
---

# glossario.md — Siglas e termos (não duplica regras)

**O que é:** definição das siglas do dia a dia de marketing, vendas e IA, e dos termos próprios do Cortex, que não estão explicados em nenhum outro arquivo da fundação. **Quando usar:** quando bater dúvida sobre uma sigla ou um termo da casa. Para gênero de marca e termos proibidos ou preferidos, a fonte única é `contexto/brandcenter/brandcenter.md`. Para marcadores de incerteza, respostas-padrão e o que nunca inventar, a fonte única é `_cortex/kernel/anti-alucinacao.md`. Siglas do setor da organização (índices, normas, entidades) vivem no pack ou em `contexto/` — não aqui.

---

## 1. Marketing e funil

- **ICP** = Ideal Customer Profile (perfil de cliente ideal) · **JTBD** = Jobs To Be Done (o "trabalho" que a pessoa contrata a oferta para fazer) · **ABM** = Account-Based Marketing (marketing por conta-alvo) · **persona** = retrato do público (cargo, dor, objeção), definido em `publicos[]` do `cortex.config.yaml`.
- **MQL / SQL** = lead qualificado por marketing / por vendas · **HR** = Hand Raising (lead que pediu contato comercial ativamente) · **lead** = contato identificado · **funil** = topo (consciência) · meio (consideração) · fundo (decisão).
- **CTA** = Call To Action (chamada para ação) · **LP** = landing page · **UTM** = parâmetros de rastreio de origem na URL · **A/B** = teste de duas variações.
- **KPI** = indicador-chave · **CAC** = custo de aquisição de cliente · **LTV** = valor do cliente ao longo do tempo · **ROI / ROAS** = retorno sobre investimento / sobre gasto em mídia · **CPL / CPA** = custo por lead / por aquisição · **CTR** = taxa de clique · **CRM** = sistema de gestão de relacionamento e pipeline.
- **prova social** = evidência de terceiros (case, depoimento, número de clientes) — só a aprovada conta (`anti-alucinacao.md` §3) · **brandcenter** = a fonte única de marca, tom e linguagem (`contexto/brandcenter/brandcenter.md`).

## 2. IA e conectores

- **LLM** = modelo de linguagem (a IA que lê esta base) · **prompt** = a instrução enviada ao modelo · **contexto / janela de contexto** = tudo o que o modelo tem aberto numa resposta; **token** = unidade de medida desse espaço (nesta base, ~3,6 bytes de pt-BR por token).
- **alucinação** = afirmação sem fonte apresentada como fato; o protocolo que a impede é `anti-alucinacao.md`.
- **MCP / conector** = canal pelo qual a IA consulta ou altera um sistema externo (registro, integração de dados, automação). Toda integração tem ficha em `contexto/integracoes/<slug>.md`; a primeira chamada da sessão já é "entrega" para o gate.
- **hook** = script que o ambiente roda sozinho em certos eventos (`SessionStart`, antes de ler ou gravar arquivo). O Cortex usa hooks para injetar a fundação e bloquear gravação indevida (`_cortex/CONTRATOS.md` §9).
- **sub-agente** = agente que o ambiente pode rodar em paralelo, com contexto próprio (`subagente: true` no frontmatter).

## 3. Termos do Cortex

| Termo | Significado |
|---|---|
| **Cortex** | o ecossistema de documentação-para-IA: kernel + contexto + packs + arquivos gerados |
| **kernel** | a camada fixa, mantida pelo projeto, em `_cortex/kernel/`: gate, anti-alucinação, governança, descoberta, roteamento, skill-creator, os agentes de base e este glossário. Nunca sobrescrita pelo `build`; nunca editada pelo time |
| **contexto** | a camada da organização: `cortex.config.yaml` + `contexto/**` (organização, marcas, produtos, públicos, integrações, vozes). O `init` gera; o time edita |
| **pack** | conjunto instalável de agentes, skills e docs para um tipo de time (ex.: marketing), em `_cortex/packs/<id>/`, instanciado em `times/<time>/`. Traz as sub-famílias e os bancos de descoberta por canal |
| **time** | a instância de um pack para um time real (`times/<time>/`), dono dos arquivos instanciados |
| **iniciativa** | unidade com docs, skills e agente próprios, recorrente, em `iniciativas/<slug>/` com `iniciativa.yaml` |
| **gate / trava** | o contrato de ativação (`gate.md`): nada é produzido antes da linha `LIDOS:` |
| **LIDOS:** | a primeira linha de toda resposta — declara agente, skill e fundação abertos |
| **fundação** | os arquivos que todo agente carrega: brandcenter + anti-alucinação + governança + gate. **Completa** (padrão) ou **leve** (só para quem registra entrega pronta) |
| **desafio de premissa** | a postura crítica antes de aceitar o pedido, calibrada em plena / leve / mínima (`gate.md` §1.1) |
| **descoberta** | a entrevista em bloco que levanta o briefing mínimo (`descoberta.md`), conduzida pelo Entrevistador |
| **BRIEFING VALIDADO ✅** | o cartão efêmero de chat que libera a produção em criação e estratégia |
| **família** | a classe de pedido no roteamento: CRIAR · PLANEJAR · ANALISAR · CONSULTAR · OPERAR · REVISAR · REGISTRAR · DOCUMENTAR · GOVERNAR. **Sub-família** (`FAMILIA.sub`) vem do pack |
| **rota / pacote base** | a lista de arquivos a abrir para uma família: a linha "obrigatório" de `ROTAS.md` §2 |
| **modificador** | o que se soma ao pacote base conforme o pedido: produto, ferramenta, voz, território, etapa, ciclo/briefing, iniciativa (`roteamento.md` §4) |
| **orçamento** | o número máximo de arquivos abertos por família. Estourar é sinal de rota errada; abrir a menos é pior que abrir a mais |
| **fecho transitivo** | se abriu X e o `requires` de X cita Y, abra Y também |
| **requires** | o campo do frontmatter que lista os ids que precisam estar abertos junto; numa skill, começa pelo agente que a roteia |
| **gatilho** | frase que a pessoa diria e que aciona um arquivo (`gatilhos` no frontmatter). Frase, não palavra |
| **id** | a chave única de todo arquivo, derivada do nome (`CONTRATOS.md` §2.1) |
| **owner / papel** | quem responde por um arquivo — sempre um slug de `papeis[]`, nunca pessoa; quem ocupa o papel está em `contexto/organizacao.md` |
| **origem** | de onde o arquivo veio: `kernel` · `pack:<id>@<versao>` · `gerado` · `gerado-inicial` · `time` |
| **marcador** | a etiqueta de incerteza num trecho: `[VALIDADO]` · `[INFORMADO PELO CLIENTE]` · `[PENDENTE DE CONFIRMAÇÃO]` · `[NECESSITA FONTE]` · `[BUSCADO: fonte]` · `[CONECTOR: sistema · data]` |
| **registro primário** | o sistema onde a entrega é registrada (card, tarefa, página): a integração com `registro_primario: true` em `cortex.config.yaml` |
| **integração de dados** | a integração com `tipo: dados` — a fonte viva de métricas e funil, consultada via conector |
| **material gerado** | o que sai de uma demanda (peça, análise, plano). Nunca entra na base; vai para o registro, `_saida/<AAAA-MM>/` ou o chat (`governanca.md` §8) |
| **build / doctor / lint** | os comandos do CLI: `cortex build` gera `AGENTS.md`, `CLAUDE.md`, `ROTAS.md`, `CATALOGO.md` e wrappers; `cortex doctor` roda os gates da base; `cortex lint --file` valida um arquivo |
| **arquivo gerado** | arquivo com `origem: gerado` e marcador na primeira linha — nunca editado à mão; edita-se a fonte e roda-se `cortex build` |
| **`_arquivo/`** | onde vai o que saiu de uso. Nunca lido como fonte |
| **ciclo** | o período de planejamento (`operacao.ciclo_planejamento`), que nomeia as pastas de `briefings/<ciclo>/` |

---

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| 2026-10-03 | Versão inicial do kernel, derivada e genericizada da base de origem. | cortex |
