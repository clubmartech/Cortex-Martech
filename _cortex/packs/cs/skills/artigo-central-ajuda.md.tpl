---
tipo: skill
id: artigo-central-ajuda
descricao: "Escreve ou revisa o artigo da central de ajuda no formato certo — novidade, guia ou erro conhecido — com título, passos, caminhos de tela e capturas."
familia: DOCUMENTAR.ajuda
output: documentacao
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["artigo da central de ajuda", "passo a passo para o cliente", "título do artigo de ajuda", "artigo de erro conhecido", "documentar a funcionalidade para o cliente", "capturas de tela do artigo", "revisar o artigo de ajuda", "base de conhecimento"]
requires: atendente · respostas-modelo
owner: {{papel "atendimento"}}
origem: pack:cs@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é acionada pelo agente **Atendente** (`atendente`), que carrega o gate (`_cortex/kernel/gate.md`), o brandcenter e o doc do produto antes de passar para cá. Abrir só este arquivo pula a trava de ativação. **Volte ao Atendente antes de escrever.**

# Artigo da central de ajuda

O artigo existe para que o cliente resolva sozinho — e para que o atendimento responda com um link em vez de um texto novo. Três formatos, com estruturas e públicos diferentes; escolher o formato errado é o erro mais caro (guia escrito como nota de lançamento não ensina nada). O conteúdo vem do **doc do produto** e do material de quem cuida do produto; esta skill recorta e formata — não inventa comportamento nem pesquisa.

## Contexto de uso

| Situação | Formato |
|---|---|
| Funcionalidade nova ou alterada, comunicada ao cliente | **A — Novidade** |
| Processo completo, com começo, meio e fim, para consulta recorrente | **B — Guia** |
| Erro, comportamento inesperado ou situação com solução conhecida | **C — Erro conhecido** |

Também serve para **revisar** artigo existente: preservar a estrutura quando adequada; reorganizar só quando a ordem atrapalha.

## Briefing mínimo

| Campo | Obrigatório |
|---|---|
| Formato (ou o tipo de entrega que o define) | sim — em dúvida, perguntar |
| Produto e módulo; caminho de tela | sim |
| Material de origem (doc do produto, nota de quem cuida do produto, ticket resolvido) | sim |
| Público do artigo (quem usa · quem administra) | sim |
| Pré-requisitos, versão ou configuração em que se aplica | sim, nos formatos B e C |
| Mídia disponível ou a produzir | não |

Sem material de origem, não escrever — o artigo não pode conter nada que não possa ser confirmado.

## Processo

1. **Confirmar o formato.** Se o pedido não deixa claro, perguntar; não escolher sozinho.
2. **Escrever na estrutura do formato** (abaixo), com o material de origem ao lado.
3. **Aplicar as regras de linguagem**: voz ativa, frases curtas, linguagem operacional (não comercial), nomes de menu, tela, campo e botão **exatamente** como na interface, toda ação com o caminho para executá-la, pré-requisito e regra de negócio em destaque.
4. **Especificar a mídia**: captura só onde a imagem explica o que o texto não explica; gif curto da parte da tela que muda; vídeo com link não listado. Formatação visual é do brandcenter{{#if pack:marketing}} e do agente de design do pack de marketing{{/if}}, não deste artigo.
5. **Revisar contra os pontos de confusão**: termo ambíguo · informação fora de ordem · frase longa · ação sem "como" · pré-requisito escondido · comportamento não confirmado.
6. **Marcar** o que não pôde ser confirmado — nunca preencher.
7. **Entregar para validação** de quem cuida do produto; publicação exige aprovação humana. Depois de publicado, registrar e ligar o artigo às respostas-modelo e ao ticket de origem.

### Formato A — Novidade

1. **Título** curto, com o módulo, pelo benefício (não pelo nome técnico).
2. **Problema ou dor** que a novidade atende, em uma frase — sem saudação.
3. **O que muda** e o valor prático, com as palavras-chave em negrito.
4. **Pré-requisitos** — só se houver.
5. **Como acessar e usar** — caminho de tela em itálico, passos numerados.
6. **Fecho** padrão da central (`respostas-modelo` § Central de ajuda).

### Formato B — Guia

1. **Título** com o módulo ou sistema.
2. **Caminho** no sistema e **tags**.
3. **Introdução** — objetivo e o que o guia cobre (escrever por último).
4. **Sumário**.
5. **Apresentação** — o que a funcionalidade propõe, por que importa, quando usar.
6. **Pré-requisitos** — parâmetros e configurações, em lista.
7. **Regras de uso e de negócio** — como funciona e como se comporta, com passo a passo.
8. **Considerações finais** — retoma o objetivo; canal de dúvidas.

### Formato C — Erro conhecido

1. **Título** com o erro ou situação, reduzido, e o módulo.
2. **Sintomas** — comportamentos, telas, mensagens e **códigos de erro** (é o que o cliente busca).
3. **Causa** — o que ocasiona, em linguagem técnica suficiente.
4. **Resolução** — passos. Duas travas: **sugerir cópia de segurança** antes de qualquer alteração; se for **contorno temporário**, dizer em destaque e avisar que o artigo muda quando a correção sair.
5. **Aplica-se a** — versão, configuração ou combinação.

## Regras

- Nada que não esteja no material de origem; comportamento não confirmado é marcado.
- Não alterar regra de negócio; não inventar comportamento.
- Nomes de interface exatos; caminhos em itálico.
- Linguagem operacional; sem promessa, sem adjetivo de campanha.
- Formato confirmado antes de escrever.
- Publicação só com validação humana de quem cuida do produto.

## Checklist

- [ ] Formato declarado e justificado?
- [ ] Estrutura completa, sem seção faltando?
- [ ] Caminhos e nomes idênticos à interface?
- [ ] Toda ação com o "como"? Pré-requisitos visíveis?
- [ ] Mídia indicada com especificação, só onde necessária?
- [ ] Erro conhecido: cópia de segurança e aviso de contorno?
- [ ] O não confirmado marcado, não preenchido?

## Output esperado

Artigo pronto para validação, no chat ou no registro{{#if registro_primario.nome}} ({{registro_primario.nome}}){{/if}}, com: formato e motivo no topo · estrutura completa · indicação de mídia com especificação · lista do que ficou `[PENDENTE DE CONFIRMAÇÃO]` · ticket ou entrega de origem · respostas-modelo a atualizar com o link.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack cs@1.0. | {{papel "atendimento"}} |
