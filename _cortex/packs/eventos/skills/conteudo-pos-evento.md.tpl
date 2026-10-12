---
tipo: skill
id: conteudo-pos-evento
descricao: "Transforma gravações, falas e resultados da edição em pacote de conteúdo — cortes, artigos, e-mails, cases — com a lista de peças a pedir ao marketing."
familia: CRIAR.pos-evento
output: plano
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["o que fazer com o conteúdo do evento", "cortes das palestras da edição", "case a partir do evento", "e-mail de agradecimento aos participantes", "artigo a partir da palestra", "lista de peças do pós-evento", "pesquisa de satisfação da edição", "o conteúdo da edição não pode morrer"]
requires: produtor-evento · regras-comunicacao-evento
owner: {{papel "eventos"}}
origem: pack:eventos@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Produtor de evento** (`produtor-evento`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e `regras-comunicacao-evento` antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Produtor antes de produzir.**

# Conteúdo pós-evento

Multiplica o investimento da edição: um dia de palco vira semanas de conteúdo, sem perder fidelidade ao que foi dito. Entrega a **matriz de derivação** (1 evento → N peças) e um briefing curto por peça, prontos para quem escreve e desenha. Não escreve as peças.

## Contexto de uso

- Primeiros dias depois do evento, com gravação ou transcrição em mãos.
- Gargalo de pauta com gravações subutilizadas.
- Entrega de contrapartidas pós-evento ao patrocinador.
- Alimentar a esquenta da próxima edição.

**Não acionar para:** escrever a peça ({{#if pack:marketing}}sub-skill do canal no pack marketing{{else}}papel de redação{{/if}}) · diagnóstico do ciclo (`analisar-ciclo-evento`) · follow-up comercial de leads{{#if pack:marketing}} (`planejar-evento` §5, pack marketing){{/if}}.

## Briefing mínimo

| Entrada | Obrigatório | Observação |
|---|---|---|
| Gravação ou transcrição | sim | Sem fonte confiável, **não** parafrasear de memória |
| Speakers com cargo e autorização de uso | sim | Para atribuir falas e publicar imagem |
| Objetivo do reaproveitamento | sim | Autoridade, demanda, esquenta da próxima edição, entrega a patrocinador |
| Pesquisa de satisfação (campos abertos) | recomendado | Única fonte de depoimento; número não vira copy |
| Canais ativos e dono | sim | Lista abaixo |
| Perguntas quentes do dia | recomendado | Do `run-of-show`; viram pauta |

## Processo

### 1. Destilar
Trechos com potencial editorial: fala ou paráfrase fiel · contexto · ângulo · público · status. Registrar na iniciativa (`docs/destilado-<evento>-<ano>.md`) — é a única coisa que entra na documentação; as peças não.

### 2. Montar a matriz de derivação
| Peça derivada | Canal | Quando vale | Quem executa |
|---|---|---|---|
{{#if canal:instagram}}| Corte curto vertical | instagram | Frase de impacto ou demonstração | {{#if pack:marketing}}`redator-instagram`{{else}}redação{{/if}} |
{{/if}}{{#if canal:tiktok}}| Corte curto vertical | tiktok | Bastidor, série numerada | {{#if pack:marketing}}`redator-instagram`{{else}}redação{{/if}} |
{{/if}}{{#if canal:youtube}}| Palestra completa ou trecho longo | youtube | Conteúdo com valor de busca | {{#if pack:marketing}}`roteiro-video`{{else}}redação{{/if}} |
{{/if}}{{#if canal:linkedin}}| Post de insight ou carrossel | linkedin | Tese forte de speaker | {{#if pack:marketing}}`redator-linkedin`{{else}}redação{{/if}} |
{{/if}}{{#if canal:email}}| E-mail de agradecimento + gravação · e-mail para ausentes | email | Até poucos dias depois | {{#if pack:marketing}}`redator-email`{{else}}redação{{/if}} |
{{/if}}{{#if canal:newsletter}}| Bloco na newsletter | newsletter | Insight que conversa com a edição | {{#if pack:marketing}}`newsletter`{{else}}redação{{/if}} |
{{/if}}{{#if canal:comunidade}}| Post e thank-you na comunidade | comunidade | Continuidade da conversa | {{#if pack:marketing}}`redator-comunidade`{{else}}redação{{/if}} |
{{/if}}{{#if canal:whatsapp}}| Mensagem de agradecimento e gravação | whatsapp | Base de inscritos | {{#if pack:marketing}}`redator-whatsapp`{{else}}redação{{/if}} |
{{/if}}{{#if canal:landing-page}}| Página da gravação ou do case | landing-page | Captura de quem não foi | {{#if pack:marketing}}`redator-lp`{{else}}redação{{/if}} |
{{/if}}{{#if canal:midia-paga}}| Anúncio com corte ou depoimento | midia-paga | Esquenta da próxima edição | {{#if pack:marketing}}`redator-midia-paga`{{else}}redação{{/if}} |
{{/if}}| Artigo ou case escrito | blog ou site | Tema com busca; cliente que falou no palco | redação |
| Relatório de entrega ao patrocinador | interno | Contrapartidas com evidência | `captar-patrocinio` |
| Álbum e vídeo-resumo | todos | Esquenta da próxima edição | {{#if pack:marketing}}`designer`{{else}}design{{/if}} |

### 3. Priorizar
Três a cinco derivações de maior impacto por menor esforço. Demonstração prática e falas de autoridade primeiro; e-mail de agradecimento e gravação são **obrigatórios e imediatos**.

### 4. Briefar cada peça
Trecho-fonte · ângulo · público · canal · voz (speaker ou marca){{#if tem:vozes}} — voz pessoal da organização segue `contexto/vozes/` (§3.3){{/if}} · CTA · dado liberado (via `kit-comunicacao-evento`). Encaminhar aos handoffs do Produtor.

### 5. Pesquisa de satisfação
Enviar nos primeiros dias; campos abertos geram depoimento (com autorização); números ficam internos (`regras-comunicacao-evento` §2). Perguntas sobre a próxima edição alimentam `planejar-edicao-evento`.

### 6. Fechar o loop
Marcar o destilado como "trabalhado" só quando a peça for publicada. O que for aprendizado de conteúdo vai para a iniciativa.

## Regras

- Nunca atribuir fala à pessoa errada; nunca usar trecho fora de contexto; nunca reproduzir trecho longo — extrair e reescrever na voz do canal.
- Número dito no palco só vira conteúdo com fonte válida; senão `[NECESSITA FONTE]`.
- Imagem e fala de speaker só com autorização registrada.
- Peças vão para o registro ou pasta da campanha, nunca para a documentação.

## Checklist

- [ ] Destilado registrado na iniciativa com fonte?
- [ ] Matriz por canal ativo com executor?
- [ ] Prioridades definidas; agradecimento e gravação já pedidos?
- [ ] Briefing por peça com dado liberado pelo kit?
- [ ] Pesquisa enviada; depoimentos com autorização?
- [ ] Relatório de entrega ao patrocinador aberto?

## Output esperado

- **Destilado** (entrada na iniciativa).
- **Matriz de derivação** (peça × canal × prioridade × executor).
- **Lista de pedidos de peça** com briefing curto cada.
- **Plano da pesquisa** e **fila de depoimentos** a autorizar.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack eventos@1.0. | {{papel "eventos"}} |
