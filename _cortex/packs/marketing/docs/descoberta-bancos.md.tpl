---
tipo: doc
id: descoberta-bancos
descricao: "Lista os bancos de perguntas por canal e tarefa que a descoberta do kernel usa antes de liberar produção — só os blocos dos canais ativos."
familia:
output: nenhum
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que perguntar antes de produzir", "perguntas obrigatórias do briefing", "banco de perguntas do canal", "não sei o que informar no briefing", "quais perguntas fazer antes da peça"]
requires:
owner: {{papel "estrategista"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

# Bancos de perguntas por tarefa — pack marketing

Complementa `_cortex/kernel/descoberta.md`, que define o protocolo (classificar a tarefa → carregar o banco + núcleo anti-genérico → perguntar em uma rodada agrupada, com opções → no máximo +1 rodada → `BRIEFING VALIDADO`). Esta página traz **o banco de cada tarefa do pack**, só para os canais ativos em `cortex.config.yaml`.

**Campos em negrito são obrigatórios** (não produzir sem). Sempre somar o núcleo anti-genérico do kernel: ângulo em uma frase · prova concreta · a única coisa que não pode faltar · o que não pode aparecer · referência de tom · nível de consciência · restrições.

**Produto da demanda:** `produto: todos` significa "pergunte qual". Sem resposta, não produzir. Opções:
{{#each produtos as p}}- **{{p.nome}}** (`{{p.slug}}`, {{p.tipo}})
{{/each}}
**Marca que assina ou divulga:**
{{#each marcas as m}}- **{{m.nome}}** (`{{m.slug}}`)
{{/each}}

**Isenção:** consulta read-only (dado já documentado, dúvida de marca) não roda descoberta.

## Campanha (planejamento)

**Objetivo de negócio + KPI** · **público** (slug de `publicos[]`) · **produto** · **marca que assina e que divulga** · janela e prazo · orçamento · canais pretendidos (entre os ativos em `canais[]` do config) · oferta central · etapa do funil · o que define sucesso · restrições · há diagnóstico anterior?

## Design / arte

**Marca ou produto da peça** · **formato e canal** (slide, banner, social, in-app, evento) · **objetivo** · há co-branding ou endosso? · referências visuais · onde o texto entra (vem do Redator) · quem aprova a arte.

## Análise

**Período** · **canal(is)** · **pergunta de negócio / decisão que depende disso** · recorte (produto, origem) · métricas de interesse · fonte do dado ({{#if integracao:dados}}base integrada ou {{/if}}export do usuário).

{{#if canal:email}}## E-mail

**Produto** · **base** (mercado × clientes) · **público** · **objetivo e etapa do fluxo** (primeiro envio, repique, novo argumento, conversão; lançamento, nova abordagem, prova social; convite, confirmação, lembrete, gravação) · benefício em destaque · dado ou resultado disponível · nome do remetente (fixo) · link do CTA · tipo (conversão, material rico, evento).

{{/if}}{{#if canal:landing-page}}## Landing page

**Objetivo** (contato, inscrição, download, venda) · **público** (cargo ou perfil + dor) · **oferta ou tema** · **CTA e para onde converte** · tipo (demonstração, material rico, evento) · prova disponível · integração de formulário · restrições visuais · canal de origem do tráfego.

{{/if}}{{#if canal:linkedin}}## LinkedIn

**Objetivo** (comentários, salvamentos, mensagens, awareness) · **é na voz de uma pessoa?** (qual{{#if tem:vozes}} — há doc de voz?{{/if}}) · **ângulo ou ponto de vista** · dado ou experiência real que sustenta · formato (texto, carrossel, vídeo) · CTA.

{{/if}}{{#if canal:instagram}}## Instagram

**Objetivo** · **público** · **mensagem central única** · formato (ou a skill decide) · gancho pretendido · prova ou dado · CTA · há identidade ou arte definida? · para vídeo: **mecanismo** (como funciona, não só o resultado).

{{/if}}{{#if canal:tiktok}}## TikTok

**Objetivo** · **público** · **mensagem central única** · **mecanismo** · formato de abertura (texto na tela, fala, trend) · áudio (original ou da plataforma) · CTA de comentário ou salvamento · a conta pode nomear o produto?

{{/if}}{{#if canal:comunidade}}## Comunidade

**Formato** (post, evento, novidade de produto) · **tema ou dado central** · ângulo ou provocação · CTA · evento: data, horário, modalidade, convidado, temas, perfil indicado, link · novidade: material do dono do produto, **quem assina**.

{{/if}}{{#if canal:whatsapp}}## WhatsApp{{#if canal:sms}} e SMS{{/if}}

**Objetivo** (convite, confirmação, material, agendamento, reengajamento) · **base ou segmento** · **ação esperada** · contexto (o contato já conhece o quê? o que fez?) · tom (formal × conversacional) · link com UTM.

{{/if}}{{#if canal:sms and not canal:whatsapp}}## SMS

**Objetivo** · **base ou segmento** · **ação esperada** · contexto do contato · link curto com UTM · remetente.

{{/if}}{{#if canal:midia-paga}}## Mídia paga

**Plataforma** (Meta, Google Search, PMax, LinkedIn) · **objetivo** · **público** · oferta · estágio do funil · variações desejadas · restrições de formato e limite de caracteres · página de destino · modo (criação × iteração — com dados).

{{/if}}{{#if canal:youtube}}## Vídeo

**Tipo** (case, material rico, podcast, demonstração) · **objetivo** · **público** · mecanismo central · fontes e números com origem · porta-voz ou apresentador · duração-alvo · para demonstração: **produto, funcionalidade, passo a passo real**.

{{/if}}{{#if canal:newsletter}}## Newsletter

**Notícias ou temas da semana** (3 a 5, com link ou resumo) · **destaque principal** · **citação de especialista** (aspas exatas + crédito) · **indicadores** com fonte · **agenda** (3 a 5 eventos) · imagens sugeridas · versões por canal pedidas.

{{/if}}## Pauta e conteúdo editorial

**Objetivo do conteúdo** · **produto ou território** · **canal** · é na voz de uma pessoa? · ângulo editorial · prova ou dado para ancorar.

{{#if modelo_comercial:B2B}}## Conta-alvo (ABM)

**Conta** (nome) · **objetivo** (abrir, expandir, reativar, reunião) · **tier** · momento da conta · produto(s) de interesse · o que já se sabe · stakeholders conhecidos · contexto comercial{{#if integracao:crm}} (CRM){{/if}}.

{{/if}}{{#if modelo_comercial:B2B2C}}## Conta-alvo e parceiros

**Conta ou parceiro** · **objetivo** · **tier** · momento · produto(s) · o que já se sabe · contatos conhecidos · contexto comercial.

{{/if}}{{#if oferta:evento}}## Evento

**Objetivo** (lead, awareness, ativação) · **tema e formato** · **produto ou segmento** · **data e meta numérica** · palestrantes · canais de divulgação · follow-up previsto · reaproveitamento.

{{/if}}{{#if canal:eventos and not oferta:evento}}## Evento

**Objetivo** · **tema e formato** (online, presencial, feira) · **produto ou segmento** · **data e meta numérica** · palestrantes · canais de divulgação · logística · follow-up previsto.

{{/if}}## Produto / posicionamento

**Produto** · **perfil ou cargo do público** · **objetivo** (educar, converter, abrir conta) · canal de destino · contexto (objeção, lançamento, comparação).

## Saída

Ao final da rodada, consolidar no cartão `BRIEFING VALIDADO` do kernel (`_cortex/kernel/descoberta.md`) e só então liberar a produção. Marcadores: `[VALIDADO]` · `[INFORMADO PELO CLIENTE]` · `[PENDENTE DE CONFIRMAÇÃO]` · `[NECESSITA FONTE]`.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "estrategista"}} |
