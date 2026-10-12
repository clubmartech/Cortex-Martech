---
tipo: skill
id: operar-base
descricao: "Limpa a base de contatos antes de disparar ou enriquecer e gera UTMs padronizadas em massa, validadas contra a classificação de canal da organização."
familia: OPERAR.base
output: dado
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["limpar a base", "taxa de bounce alta", "contatos duplicados", "higiene da base", "gera as URLs com UTM", "UTM em massa", "padronizar o rastreamento", "preparar a base para o disparo"]
requires: analista
owner: {{papel "analista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Analista** (`analista`), que carrega o gate (`_cortex/kernel/gate.md`) e a definição de funil e origem antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Analista antes de operar.**

# Operar base — limpeza de contatos e UTMs em massa

Duas operações sobre a infraestrutura de marketing: **(A) limpeza da base** — identificar e tratar contato inválido, duplicado, desengajado ou mal segmentado antes de enriquecer ou disparar; **(B) UTMs em massa** — gerar lotes de URLs rastreadas com nomenclatura padronizada, sem gerar UTM que o sistema de classificação de canal não reconheça.

Integrações disponíveis: {{#if integracao:crm}}CRM{{/if}}{{#if integracao:crm and integracao:automacao-mkt}} · {{/if}}{{#if integracao:automacao-mkt}}automação de marketing{{/if}} (ver `integracoes[]` no config).

## Contexto de uso

**Limpeza:** antes de enriquecimento ou importação de nova fonte · bounce acima do limite da organização · abertura caindo sem explicação · higiene preventiva periódica.
**UTMs:** campanhas e canais do período · validar UTMs já criadas · padronizar rastreamento entre áreas.

## Briefing mínimo

**Limpeza:** base ou produto (a limpeza é por produto, não da base inteira) · export ou acesso à base · histórico de campanhas para medir engajamento · critério de desengajamento por produto (do histórico; sem ele, `[PENDENTE DE CONFIRMAÇÃO]`).
**UTMs:** URL de destino · canal/medium · plataforma ou detalhe · nome da campanha (reutilizar o já registrado) · produto · identificador do canal (palavra-chave, ID de anúncio, dia da régua) · **convenção ativa** da organização (ver A.1).

## Processo

### A. Limpeza da base

**1. Exportar e auditar** — marcar: hard bounce · e-mail inválido (formato, domínio inexistente) · duplicado (mesmo e-mail em vários registros) · sem engajamento no período de desengajamento do produto · domínio descartável · cargo ou empresa "teste" · contatos internos da organização.

**2. Categorizar e agir**

| Categoria | Ação |
|---|---|
| Hard bounce | Remover da base ativa; lista de exclusão permanente |
| E-mail inválido | Mover para lista de inválidos |
| Duplicado | Mesclar; manter o registro com mais dados |
| Desengajado | Mover para lista de reativação; fora dos disparos regulares |
| Teste ou falso | Remover |
| Interno | Lista própria, fora dos disparos de mercado |

**3. Executar na plataforma** — segmentação por "abertura = 0 + criado há mais de X" para desengajados; export e deduplicação por e-mail; tag de bounce a partir do relatório de campanha.

**4. Documentar** antes de qualquer remoção: quantidade por categoria, data, critério.

**5. Prevenir reentrada** — lista de exclusão para bounces; validação de e-mail no formulário; cadência de limpeza recorrente.

**Protocolo de reativação antes de descartar** (via Estrategista + Redator): e-mail de reativação com assunto de urgência real ou curiosidade → aguardar uma semana; quem abriu volta à lista ativa → material relevante para quem não abriu → quem não abriu nada vai para "reativação falhou" e sai dos disparos.

**Regras:** nunca deletar sem arquivar cópia (mover para lista inativa) · bounce excluído automaticamente de todo disparo · desengajado passa por reativação antes do descarte · limpeza por produto · critério de desengajamento vem do histórico de abertura do produto, registrado em `benchmarks-canal`.

### B. UTMs em massa

**A.1 Confirmar a convenção ativa** — duas fontes de verdade, nenhuma suposição: (1) a função ou regra que classifica canal nos relatórios da organização{{#if integracao:dados}} (na base integrada){{/if}} — define quais valores de `utm_source` e `utm_medium` são reconhecidos; (2) a planilha ou registro de UTMs já em produção — define a **posição** de cada campo e os valores fechados. Documento escrito desatualiza sem aviso; em dúvida, testar contra as duas.

**Estrutura de referência** (adaptar à convenção da organização):
```
[URL]?utm_source=[medium]_[plataforma-detalhe]&utm_medium=[medium]&utm_campaign=[nome-simples]&utm_content=[produto ou marca]&utm_term=[estágio]-[público]-[identificador do canal]
```
- `utm_source`: sempre `[medium]_[detalhe]`, minúsculo, sem espaço — nunca só o nome da plataforma isolado, senão o lead cai em "desconhecido" no relatório.
- `utm_medium`: valor simples (cpc, email, social, display, organic, referral…), igual ao prefixo do source.
- `utm_campaign`: nome simples da campanha ou régua; reutilizar o já registrado; sem código de estágio ou público.
- `utm_content`: produto ({{#each produtos as p}}`{{p.slug}}` {{/each}}) ou `marca` para institucional.
- `utm_term`: estágio + público + identificador do canal (palavra-chave em busca · ID do anúncio em social pago · data ou dia da régua em e-mail · sem sufixo nos demais). Código de estágio ou público desconhecido → **reutilizar o da campanha de referência; nunca inventar** — perguntar.

**A.2 Montar a tabela de entrada** — uma linha por URL: destino · medium · detalhe · campanha · produto · estágio · público · identificador.

**A.3 Gerar** — volume pequeno: tabela via IA com a convenção colada no prompt; volume médio ou grande: planilha com fórmula (coluna final travada); validação de UTMs existentes: listar as que não batem com nenhum prefixo reconhecido, as fora da higiene (maiúscula, espaço, acento, campanha com código) e as com campo obrigatório ausente — com a versão corrigida de cada.

**A.4 Validar antes de usar** — source bate com prefixo reconhecido · tudo minúsculo · sem espaço, sem acento ou caractere especial · URL abre · campanha simples · term no formato · parâmetros aparecem na ferramenta de analytics após o clique de teste.

**A.5 Registrar no log central** antes de ativar: destino, URL com UTM, campanha, responsável, data, status.

**Exceções:** URL com parâmetro próprio → `&` em vez de `?` · campanha com mais de um público → uma UTM por público · produto fora da lista → pedir inclusão na convenção antes de criar · UTM muito longa → reduzir o nome, nunca abreviar produto ou medium · campanha encerrada → "encerrada" no log, URL não reutilizada · nunca reutilizar UTM de campanha anterior em campanha nova.

## Checklist

- [ ] Limpeza: por produto? cópia arquivada antes de remover? quantidades e critério documentados? reativação antes do descarte?
- [ ] UTMs: convenção confirmada contra as duas fontes? source com prefixo reconhecido? campanha simples, term no formato, código reutilizado e não inventado?
- [ ] Tudo minúsculo, sem espaço ou acento? URL testada? Log atualizado?
- [ ] Nenhum dado sensível exposto na saída?

## Output esperado

| Saída | Formato |
|---|---|
| Relatório de limpeza | tabela: contatos por categoria removida, data, critério |
| Base limpa | CSV ou segmentação na plataforma |
| Lista de reativação | tag ou segmentação |
| Tabela de UTMs geradas | planilha: destino · source · medium · campaign · content · term · URL final |
| Relatório de validação | lista de UTMs problemáticas + versões corrigidas |
| Log de campanhas | aba de log atualizada |

Destino: registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}} ou planilha operacional do time — nunca a documentação.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "analista"}} |
