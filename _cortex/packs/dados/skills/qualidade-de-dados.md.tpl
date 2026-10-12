---
tipo: skill
id: qualidade-de-dados
descricao: "Audita a qualidade da base — duplicados, campos obrigatórios, validade, de-para de cargo e segmento — e propõe o tratamento com registro e prevenção."
familia: OPERAR.qualidade-dados
output: registro
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["deduplicar os registros", "campos obrigatórios vazios", "de-para de cargo", "padronizar segmento", "auditoria da qualidade da base", "registro com dado inválido", "qualidade do dado do CRM"]
requires: analista-dados
owner: {{papel "analista-dados"}}
origem: pack:dados@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista de Dados** (`analista-dados`), que carrega o gate (`_cortex/kernel/gate.md`) e a ficha da fonte antes de passar para cá. Esta é a única skill do pack que pode resultar em **escrita** — e ela acontece pela pessoa, nunca pelo agente. **Volte ao Analista de Dados antes de auditar.**

# Qualidade de dados

Métrica ruim quase sempre nasce de dado ruim: duplicado conta duas vezes, campo vazio some do recorte, cargo escrito de dez jeitos vira dez segmentos. Esta skill **audita** (read-only), **propõe** o tratamento com a lista exata do que muda, e **documenta** o que foi feito e como evitar a reentrada. A alteração na fonte é executada por quem tem permissão, com a lista aprovada.

## Contexto de uso

- Antes de disparo, relatório, cohort ou atribuição.
- Depois de importação, migração ou integração nova.
- Auditoria periódica (por ciclo: {{operacao.ciclo_planejamento}}).

## Briefing mínimo

Fonte (slug de `integracoes[]`{{#if integracao:crm}}; CRM{{/if}}{{#if integracao:automacao-mkt}}; automação de marketing{{/if}}{{#if integracao:dados}}; base de dados{{/if}}) · entidade (contato, empresa, negócio) · campos obrigatórios segundo o negócio · taxonomias oficiais (cargo, segmento, origem — `taxonomia-origens`) · quem executa alterações.

## Processo

### Passo 1 — Exportar e auditar (read-only)

Via `consultar-metrica` ou export: volume total · duplicados por chave natural (e-mail normalizado, documento, telefone) e por chave composta (nome + empresa) · campos obrigatórios vazios (% por campo) · valores inválidos (e-mail sem formato, data impossível, telefone curto) · valores fora da taxonomia (cargo, segmento, origem) com contagem · registros de teste e internos.

### Passo 2 — Categorizar

| Categoria | Critério | Tratamento proposto |
|---|---|---|
| Duplicado | mesma chave natural | mesclar, mantendo o registro mais completo e o histórico; regra de qual sobrevive escrita |
| Inválido | formato impossível | corrigir se há fonte; senão, marcar e excluir de métricas |
| Incompleto | obrigatório vazio | enriquecer (fonte declarada) ou marcar |
| Fora da taxonomia | valor não mapeado | de-para (Passo 3) |
| Teste ou interno | padrão conhecido | excluir de métricas pela regra oficial, não apagar |
| Desengajado | sem interação há `[PENDENTE: período]` | protocolo de reativação antes de qualquer descarte (Redator do pack marketing) |

### Passo 3 — De-para de cargo e segmento

Tabela: valor cru → valor oficial · regra (contém, igual, começa com) · desde quando. Grupos de cargo por **papel na compra** (decide, influencia, usa, opera) quando a taxonomia for para análise. Valor sem correspondência → "outro" visível, não forçado.

### Passo 4 — Propor e aprovar

Lista exata do que muda: registros afetados (ids anonimizados no chat), ação, antes → depois. Apresentar inteiro no chat; aprovação do papel `{{papel "analista-dados"}}` e do dono da fonte. **Nada é executado pelo agente.**

### Passo 5 — Executar (pela pessoa) e documentar

Quem tem permissão aplica a lista. Registro em `times/{{time.slug}}/docs/qualidade-<fonte>-<AAAA-MM>.md` ou no destino{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}: data · fonte · categoria · quantidade · regra usada · quem executou. Mesclagens e exclusões são **reversíveis** quando a fonte permite; quando não, exportar antes.

### Passo 6 — Prevenir reentrada

Validação no formulário ou na importação (campo obrigatório, formato) · de-para aplicado na entrada · regra de exclusão de teste na fonte · auditoria no ciclo. Registrar na ficha da fonte.

## Regras

- O agente audita, propõe e documenta; **não altera** a fonte.
- Nenhum registro é apagado sem exportação prévia e aprovação; "excluir de métricas" é preferível a "apagar".
- Dados sensíveis ({{join governanca.dados_proibidos_em_prompt ", "}}) não saem da fonte; listas no chat são anonimizadas.
- De-para não reescreve o valor cru: o cru é preservado em campo próprio ou no histórico.
- Desengajado passa por reativação antes de descarte.

## Checklist

- [ ] Auditoria read-only com números por categoria e `[CONECTOR: fonte · data]`?
- [ ] Regra de sobrevivência de duplicado escrita? De-para com regra e vigência?
- [ ] Lista exata aprovada antes de qualquer execução?
- [ ] Exportação prévia? Registro do que foi feito?
- [ ] Prevenção de reentrada definida e anotada na ficha da fonte?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório de auditoria | tabela: categoria · quantidade · % · exemplos anonimizados |
| Lista de tratamento | tabela: registro · ação · antes → depois |
| De-para | tabela: cru → oficial · regra · vigência |
| Registro da execução | data · fonte · categoria · quantidade · quem |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack dados@1.0. | {{papel "analista-dados"}} |
