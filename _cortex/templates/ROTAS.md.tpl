---
tipo: doc
id: rotas
descricao: "Classifica a demanda numa família e entrega o pacote mínimo de leitura para atendê-la, com orçamento declarado."
familia:
output: roteamento
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que preciso abrir pra isso", "qual arquivo consulto", "que rota é essa demanda", "qual o pacote de leitura", "quais skills entram nesse pedido", "por onde começo esse pedido"]
requires: roteamento · catalogo
owner: cortex
origem: gerado
validado_em: {{agora}}
---
<!-- gerado pelo cortex build a partir de _cortex/templates/ROTAS.md.tpl — não edite; edite cortex.config.yaml, os pack.yaml ou os frontmatters e rode `cortex build` -->

# ROTAS.md — camada de roteamento · {{organizacao.nome}}

**O que é:** o mapa que diz **o que abrir** para cada tipo de demanda. Classifica o pedido numa **família**, soma os **modificadores** e o resultado é o pacote mínimo de leitura. Regras gerais e desempates do kernel: `_cortex/kernel/roteamento.md`.

> 🧭 **Regra de ouro:** abra o método e as fontes pertinentes à decisão atual. Relações condicionais não exigem carregar todas as skills.

## Sumário

- [0. Como usar](#0-como-usar--4-passos) · [1. Classificador](#1-classificador--sinal-do-pedido--família) · [2. Agentes e rotas](#2-agentes--id--arquivo) · [3. Modificadores](#3-modificadores--some-ao-pacote-base) · [4. Desempates](#4-desempates) · [5. Inativas](#5-famílias-inativas-neste-cortex)
- **Rotas (§2, uma seção `###` por família, busque pelo id):** {{#each subfamilias_ativas as s}}`{{s.id}}`{{#if @last}}{{else}} · {{/if}}{{/each}} · `REVISAR` · `REGISTRAR` · `DOCUMENTAR` · `CONSULTAR` · `GOVERNAR`

> Arquivo grande por desenho quando há vários packs: leia §0–§1 para classificar e depois **só a seção `###` da família escolhida**.

## 0. Como usar — 4 passos

```
1. CLASSIFIQUE   → §1, sinal do pedido → família
2. PACOTE BASE   → §2.x, a linha 🔴 OBRIGATÓRIO daquela família
3. MODIFICADORES → §3, some produto · ferramenta · voz · território · etapa · ciclo · iniciativa
4. VERIFIQUE     → contexto suficiente; declaração conforme `_cortex/kernel/gate.md` §1
```

**Fecho transitivo:** se abriu X e o `requires` de X cita Y, abra Y também (`requires` de cada arquivo: `CATALOGO.md`).
**Fundação:** aplique `gate` §2 conforme a tarefa; marca e voz entram quando pertinentes. Deduplique dependências já lidas para evitar ciclos.
**Não achou a família?** Não invente rota. Pergunte 1–2 coisas; se ainda não fechar, trate como `GOVERNAR` e registre a lacuna.

---

{{#if interfaces_contexto.ativo}}
### Contratos entre skills

Manifesto canônico: `{{interfaces_contexto.manifesto}}` · {{interfaces_contexto.total}} contratos · {{interfaces_contexto.perfis}} perfis. Não carregue o manifesto inteiro na conversa.

1. Busque por tarefa: `python3 _cortex/cli/cortex.py interfaces list --query <termo>` (20 resultados por página; `--offset` continua).
2. Consulte um contrato: `python3 _cortex/cli/cortex.py interfaces show <id>`; use id completo se houver nomes iguais.
3. Abra a fonte e somente os componentes pertinentes. Siga relações condicionais preservando briefing, decisões, fontes e autorização.

O índice `{{interfaces_contexto.index}}` é gerado; edite a fonte indicada no manifesto. Memória pessoal, contexto do negócio e voz editorial têm destinos próprios, conforme o componente aplicável. Valide com `interfaces check` e regenere com `build --only interfaces`.
{{/if}}

## 1. Classificador — sinal do pedido → família

| Se o pedido é sobre… | Família | Orçamento |
|---|---|---|
{{#each subfamilias_ativas as s}}| {{join s.sinais ", "}} | **{{s.id}}** {{s.nome}} | {{s.orcamento}} |
{{/each}}| revisar, humanizar, "tá com cara de IA", melhorar cadência de um texto pronto | **REVISAR** | 2 |
| registrar a entrega, abrir card/página, ata de reunião, transformar reunião em tarefas | **REGISTRAR** | 3 |
| documentar produto/processo, atualizar um dado dentro de um `.md` da base, registrar aprendizado validado | **DOCUMENTAR** | 4 |
| consultar um dado já documentado, "o que é X", "onde fica Y" (sem metodologia própria) | **CONSULTAR** | 3 |
| criar/corrigir skill, auditar a base, configurar o Cortex, instalar pack | **GOVERNAR** | 4 |

> ⚠️ **Pedido composto é comum.** Rode as famílias em sequência, não em paralelo — cada uma entrega insumo para a próxima.

---

## 2. Agentes — id → arquivo

| id | arquivo | origem |
|---|---|---|
{{#each agentes as a}}| `{{a.id}}` | `{{a.caminho}}` | {{a.origem}} |
{{/each}}

Caminho de skills, sub-skills e docs: `CATALOGO.md`.

{{#each subfamilias_ativas as s}}
### {{s.id}} — {{s.nome}} · orçamento {{s.orcamento}}
- 🔴 {{#each s.obrigatorio as o}}`{{o}}`{{#if @last}}{{else}} · {{/if}}{{/each}}
{{#each s.condicional as c}}- 🟡 {{c.se}} → {{c.abrir}}
{{/each}}{{#if tem:s.complementar}}- 🟢 {{#each s.complementar as o}}`{{o}}`{{#if @last}}{{else}} · {{/if}}{{/each}}
{{/if}}
{{/each}}
### REVISAR · orçamento 2
- 🔴 `revisor` · a skill do canal da peça (para não ferir a regra do formato)

### REGISTRAR · orçamento 3
- 🔴 `registrador`{{#if tem:registro_primario}} · `integracao-{{registro_primario.slug}}`{{/if}}
- 🟡 é ata ou decisão de reunião → `briefings/_modelo.md` §registro de decisões

### DOCUMENTAR · orçamento 4
- 🔴 `documentador` · o doc de contexto que vai mudar (`contexto/produtos/<slug>/…` ou `times/<time>/docs/…`)
- 🟡 dado numérico → `anti-alucinacao` §4 (fonte e marcador) antes de gravar

### CONSULTAR · orçamento 3
- 🔴 o doc que responde (`CATALOGO.md` → `id`){{#if integracao:dados}} · se for dado ao vivo: a sub-skill de extração da família `CONSULTAR.dado` acima{{/if}}
- 🚫 não abrir skill de análise — consulta devolve o dado, não o diagnóstico

### GOVERNAR · orçamento 4
- 🔴 `skill-creator` · `_cortex/CONTRATOS.md` §2
- 🟡 auditoria → `python3 _cortex/cli/cortex.py doctor` · onboarding/pack → `_cortex/onboarding/questionario.md`

---

## 3. Modificadores — some ao pacote base

{{#if tem:produtos}}### 3.1 Produto / oferta nomeada
Use a oferta informada no pedido ou briefing; pergunte somente se necessária e ambígua. Abra **o doc-raiz do produto primeiro**: {{#each produtos as p}}`{{p.slug}}` → `contexto/produtos/{{p.slug}}/{{p.slug}}.md`{{#if @last}}{{else}} · {{/if}}{{/each}}. Filhos (módulos, objeções, concorrência) só se a resposta não estiver na raiz. Banco de criatividade por produto, se existir: `times/<time>/docs/criatividade-<slug>.md`.
{{/if}}
{{#if tem:integracoes}}### 3.2 Ferramenta / conector (MCP)
Antes da primeira chamada a um conector, abra a ficha da integração: {{#each integracoes as i}}`{{i.slug}}` → `contexto/integracoes/{{i.slug}}.md`{{#if i.somente_leitura}} (somente leitura){{/if}}{{#if @last}}{{else}} · {{/if}}{{/each}}. Dado que volta de conector recebe `[CONECTOR: sistema · data]`.
{{/if}}
{{#if tem:vozes}}### 3.3 Voz pessoal
Peça assinada por pessoa: {{#each vozes as v}}`{{v.slug}}` ({{v.papel}}) → `{{v.doc}}`{{#if @last}}{{else}} · {{/if}}{{/each}}. A voz vem **antes** da sub-skill do canal.
{{/if}}
{{#if tem:publicos}}### 3.4 Público / território
Quando o **leitor** muda, muda antes do canal: público, ângulo, dor, prova e linguagem. Públicos: {{#each publicos as p}}`{{p.slug}}`{{#if tem:p.territorio}} (território {{p.territorio}}){{/if}} → `contexto/publicos/{{p.slug}}.md`{{#if @last}}{{else}} · {{/if}}{{/each}}.
{{/if}}
### 3.5 Etapa do funil / nível de consciência
Topo (educar), meio (comparar), fundo (converter), base (reter/expandir). A descoberta define; a skill do canal aplica.
{{#if operacao.ciclo_planejamento == "nenhum"}}{{else}}### 3.6 Ciclo e briefing
Planejamento {{operacao.ciclo_planejamento}}. Peça que pertence a uma campanha abre o briefing dela em `briefings/<ciclo>/` antes da skill do canal.
{{/if}}
### 3.7 Iniciativa
Pedido ligado a uma pasta em `iniciativas/<slug>/` (com `iniciativa.yaml`) abre primeiro o doc-raiz da iniciativa; skills e agentes da iniciativa têm precedência sobre os do time.

---

## 4. Desempates

Regras gerais (kernel): `_cortex/kernel/roteamento.md` §4. Em resumo: canal vence formato · território vence canal · iniciativa vence time · read-only não dispensa a sub-skill de extração · orçamento orienta a seleção; leitura adicional necessária não é erro de família.

---

## 5. Famílias inativas neste Cortex

{{#if tem:subfamilias_inativas}}| Família | Pack | Condição | Motivo |
|---|---|---|---|
{{#each subfamilias_inativas as s}}| {{s.id}} | {{s.pack}} | `{{s.condicao}}` | {{s.motivo}} |
{{/each}}{{else}}Nenhuma — todas as sub-famílias dos packs instalados estão ativas.{{/if}}

Para ativar uma família: ajuste `cortex.config.yaml` (canal, integração, oferta) e rode `cortex build`.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{agora}} | Gerado pelo `cortex build`. | cortex |
