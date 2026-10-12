---
tipo: skill
id: redator-comum
descricao: "Define o padrão editorial da casa — princípios de escrita, vocabulário por marca e checklist — e é aplicada direto quando o canal não tem skill própria."
familia: CRIAR
output: texto
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["princípios de escrita da casa", "checklist de revisão de copy", "palavras a evitar em copy", "tom de voz da marca no texto", "como escrever benefício antes de feature", "fórmula de headline", "nota de transparência do copy", "canal sem skill de redação"]
requires: redator
owner: {{papel "redator"}}
origem: pack:marketing@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta é a skill-mãe de redação, acionada pelo agente **Redator** (`redator`), que carrega o gate (`_cortex/kernel/gate.md`) e o brandcenter antes de passar para cá. Abrir só este arquivo pula a trava de ativação e o `BRIEFING VALIDADO`. **Volte ao Redator antes de escrever.**

# Redator comum — padrão editorial e blocos compartilhados

Fonte única do que toda skill de canal pressupõe e **não repete**: trava de ativação, pré-requisito de briefing, princípios de escrita, vocabulário por marca, palavras a evitar, estrutura de campanha, CTA e checklist de revisão. Cada skill de canal referencia esta página e acrescenta só o que é específico do formato.

## Contexto de uso

- Toda criação de copy, em qualquer canal, antes de abrir a skill do canal.
- Canal **sem skill própria** no pack (ex.: loja física, banner in-product, SMS): aplicar esta skill diretamente e declarar isso na entrega.
- Revisão, reescrita ou adaptação de texto existente entre canais.
- Dúvida sobre tom, vocabulário ou padrão editorial de uma marca.

## Briefing mínimo

Não escrever sem estes campos. Se faltar algum, perguntar antes:

| Campo | O que preencher | Por que é obrigatório |
|---|---|---|
| **Objetivo da peça** | Gerar lead / educar / engajar / converter / vender | Define estrutura, CTA e profundidade |
| **Público** | Quem lê: cargo ou perfil, dor específica e contexto | O copy é escrito para uma pessoa real; sem público, não há texto |
| **Oferta ou tema central** | O que o leitor recebe, aprende ou faz | Define o argumento principal |
| **Canal e formato** | Onde será publicado ou veiculado | Determina extensão, hierarquia e tom |
| **Estágio no funil** | Topo / meio / fundo — ou nível de consciência | Muda o grau de direitura da oferta e o CTA |
| **Origem do tráfego** | De onde vem quem vai ler | Indica quanto contexto o leitor já tem |
| **Referência ou restrição** | Copy aprovado, limite de formato, mensagem obrigatória | Evita retrabalho |

> **Regra:** se Público + Objetivo + Oferta não estiverem no briefing, não escreva. Pergunte. O público não é inferido.
> **Produto:** `produto: todos` significa "pergunte qual produto". Sem resposta, não produza. Definido o produto, abra `contexto/produtos/<slug>/<slug>.md` primeiro; filhos só se a resposta não estiver lá.

## Processo

### 1. Verificar contexto de marca e criatividade

Consultar `contexto/brandcenter/brandcenter.md` para posicionamento, tom e termos. Se o briefing nomear um produto, ler também `times/{{time.slug}}/docs/criatividade-<slug>.md` — copies que já rodaram, para calibrar tom e especificidade. Referência, não template; não bloquear a produção se o banco ainda estiver vazio.

### 2. Confirmar o briefing mínimo

Tabela acima + a tabela de campos própria da skill do canal.

### 3. Validar os critérios de sucesso

Antes do rascunho, alinhar como a entrega será avaliada: o que precisa estar presente para aprovar sem ajuste; qual critério é o mais importante (conversão, clareza, tom, dado específico, extensão, prazo); qual vence em conflito. Registrar os critérios no topo do output.

### 4. Diagnosticar o estágio de consciência

| Estágio | O leitor… | Abordagem |
|---|---|---|
| **Inconsciente** | Não sabe que tem o problema | Revelar com dado ou situação reconhecível |
| **Consciente do problema** | Sente a dor, não conhece a solução | Nomear a dor com precisão, abrir o caminho |
| **Consciente da solução** | Pesquisa opções, compara | Diferenciar com especificidade e prova |
| **Consciente do produto** | Conhece a marca, ainda não decidiu | Remover objeções, ancorar em retorno |
| **Pronto para decidir** | Precisa de um fator de fechamento | Oferta direta, urgência real, CTA sem fricção |

Quanto menos consciente, mais narrativo e educativo. Quanto mais consciente, mais direto.

### 5. Rotear para a skill do canal

Tabela de canal → skill no agente `redator`. Canal sem skill: seguir daqui e declarar.

### 6. Definir a camada estratégica

- **Big Idea** — qual é o ângulo único desta peça? Teste: dá para explicar em uma frase, para alguém de fora, de forma que a pessoa queira saber mais? Ângulo já usado em outra peça da mesma campanha não se repete.
- **Mecanismo** — o que torna a promessa crível e diferente? "O produto melhora a gestão" (sem mecanismo) × "o produto centraliza o dado de campo e escritório em um painel, sem relatório manual" (com mecanismo).
- **Lead** — tipo de abertura e loop que ela cria: história (leitor inconsciente ou consciente do problema) · dado ou provocação (consciente da solução) · problema-solução (consciente do produto) · segredo ou mecanismo (qualquer estágio).

### 7. Escrever

Aplicar os princípios abaixo desde o primeiro rascunho — não são filtro aplicado depois. Se o formato comportar dado de mercado, usar só dado com fonte; sem fonte, `[NECESSITA FONTE]`.

### 8. Revisar com o checklist

Checklist desta página + checklist da skill do canal. Conferir contra os critérios de sucesso da etapa 3.

## Tom e vocabulário por marca

O tom e os termos vêm de `cortex.config.yaml` e do brandcenter — esta página não inventa regra de marca:

{{#each marcas as m}}### {{m.nome}} (`{{m.slug}}`){{#if m.mae}} — marca-mãe{{/if}}

- **Gênero gramatical:** `{{m.genero}}` — usar o artigo correspondente em todas as ocorrências.
- **Tom:** {{join m.tom " · "}}.
{{#if m.termos_proibidos}}- **Termos proibidos:** {{join m.termos_proibidos " · "}}.
{{/if}}- **Termos preferidos:** ver `marcas[].termos_preferidos` no config e o brandcenter — aplicar a substituição em toda ocorrência.

{{/each}}
**Regras de tom comuns a todas as marcas:**

| Evitar | Preferir |
|---|---|
| "Soluções inovadoras", "transformação digital" | Nomear o problema concreto que resolve e o que muda na rotina |
| Promessa vaga | Benefício ancorado em dado ou resultado real |
| Tom condescendente ou excessivamente formal | Direto, como quem entende do assunto |
| Paralelismo retórico ("não é X, é Y") | Frases que entregam uma informação nova cada |
| Tom poético, filosófico ou motivacional | Informação com implicação prática |
| Slogan sem argumento | Frase memorável que carrega o argumento |
| Comparativo com concorrente ("o melhor", "o maior") | Especificidade do que a marca faz |

**Estrutura de frase:** cada frase cumpre uma função (fato, critério, exemplo, implicação). Frase que não muda decisão nem entendimento sai. Toda frase se conecta à anterior por causa, consequência, contraste ou sequência. **Proibição absoluta:** "não é sobre X, é sobre Y" e variações — reescrever como afirmação direta.

**Recursos expressivos:** exclamação no máximo uma por peça, nunca em headline · emojis comedidos, nunca em conteúdo institucional · gírias e abreviações proibidas · travessão é pontuação, não estilo: no máximo um por peça.

### Palavras a evitar em copy

Vale para todo texto entregue, em qualquer canal, em qualquer flexão, inclusive nos exemplos das skills:

**desbloqueie · descubra · revolucionário · que muda o jogo · nova geração · de ponta · alavanque · aproveite · maximize · otimize · simplifique · sem esforço · poderoso · inovador · sem complicação · transforme · eleve · definitivo · exclusivo · por tempo limitado · imperdível**

| Evitar | Caminho preferido |
|---|---|
| revolucionário · nova geração · de ponta · inovador · poderoso | Nomear o que faz, com dado ou exemplo |
| alavanque · maximize · otimize · eleve | Verbo concreto + resultado: reduza, aumente, acompanhe, feche |
| transforme | Descrever o que muda na operação ou na rotina |
| simplifique · sem esforço · sem complicação | Mostrar o passo ou o que deixa de existir |
| desbloqueie · descubra | Dizer o que a pessoa passa a ter ou vai encontrar |
| aproveite · imperdível | CTA com a ação específica |
| definitivo · exclusivo · por tempo limitado | Abrangência real, para quem é, data ou condição concreta |

**Regra:** escrever sem elas desde o rascunho. Se — e só se — não houver substituta (nome oficial de funcionalidade, título de evento já publicado, termo que o cliente usa no depoimento aprovado): parar, perguntar a quem pediu citando o trecho e as alternativas testadas; manter só com confirmação; registrar na Nota de transparência com `[PALAVRA DA LISTA MANTIDA — aprovada por <papel> em <data>]`.

## Princípios de escrita

- **Clareza e criatividade são condição de entrega, não alternativas.** Gerar a versão mais interessante que o argumento sustenta; cortar o que não ficou claro na revisão.
- **Benefício antes de feature.** Para cada feature, completar: "[feature], que significa que [benefício concreto para este público]". O que vem depois do "que significa que" entra no copy.
- **A cadeia "E daí?"** — perguntar três vezes até chegar à consequência prática ou financeira para quem decide. O copy mora no terceiro nível.
- **Especificidade vence generalidade.** Dado, prazo, contexto real.
- **Uma ideia por peça.**
- **Headline faz a maior parte do trabalho.** Escrever duas versões de estruturas diferentes e entregar as duas. Fórmula base: [verbo de ação] + [resultado específico] + [contraste ou prazo]. Padrões: contraste (resultado em tempo curto, não em tempo longo) · transformação (de estado ruim para estado bom) · pergunta com lacuna · dado inesperado · autoidentificação (para [perfil] que [contexto]). Headline falha quando é obscuro, não tem benefício, usa vagueza onde um dado resolveria ou conta tudo sem deixar lacuna.
- **Voz ativa, sem qualificadores** ("quase", "muito", "realmente").
- **CTA sempre presente**, mesmo em conteúdo educativo.
- **Throughline emocional:** a peça abre com tensão, cada bloco avança o argumento, acelera na direção do CTA. Sem "barriga".
- **Ferramentas criativas** (quando o briefing pedir memorabilidade ou explicar conceito técnico): analogia que clareia na hora · uma metáfora forte por peça · substância na frente e criatividade no fim · justaposição de opostos em headline.
- **Quantifique a dor.** Dor vaga parece grande demais; dor calculada parece solucionável.
- **Escreva para quem escaneia e crie fluxo para quem lê:** headline e subheadline carregam a mensagem; primeiras palavras de cada parágrafo autoexplicativas; negrito nos pontos que não podem passar; parágrafos de até três linhas; primeira frase curta; loops abertos sempre fechados.
- **Aberturas a evitar:** "No cenário atual…", "É importante destacar que…", "Neste conteúdo você vai aprender…", "Vamos explorar juntos…".
- **Fale com a pessoa, não com a empresa.** Use terceira pessoa para revelar dor sem presumir ("muitos gestores chegam ao fechamento sem visibilidade") em vez de apontar o dedo ("você está perdendo dinheiro?").
- **Afirmação de resultado exige modificador:** ajuda a, pode, permite, contribui para, reduz até, aumenta até. O modificador qualifica a promessa; não substitui o dado.
- **Gatilhos no momento certo:** autoridade (topo e meio) · prova social (meio e fundo) · especificidade (sempre) · urgência e escassez (fundo, só se reais) · pertencimento (identificação).
- **Antecipe objeções** — as objeções de cada público estão em `cortex.config.yaml › publicos[].objecao` e no doc do produto. Quanto mais fundo no funil, mais o copy precisa respondê-las.
- **Depoimento que converte:** [estado antes] + [ação] + [resultado específico] + [prazo] + [impacto]. Sem fala aprovada que sustente a peça, declarar a lacuna — nunca elogio genérico vestido de resultado.

## Estrutura de campanha e de peça

Campanha: **clareza de oferta → identificação do comprador → redução de risco com conteúdo**.
Peça: **gancho → oferta clara → identificação → prova → CTA**.

**CTA:** [verbo de ação] + [o que o leitor ganha] + [qualificador, se necessário]. Diz o que o leitor **ganha**, não o que ele **faz**: "Veja como funciona na prática" (não "Saiba mais") · "Baixe o guia completo" (não "Clique aqui") · "Garanta minha vaga" (não "Inscreva-se").

## Checklist de revisão

**Critérios de sucesso**
- [ ] A entrega atende aos critérios validados no briefing? O mais importante foi priorizado? Em conflito, a prioridade definida venceu?

**Qualidade do copy**
- [ ] Mensagem central clara nos primeiros segundos?
- [ ] Fala de benefício, não só de feature? Há especificidade (dado, resultado, contexto)?
- [ ] Depoimento, case ou número de cliente vem de fonte aprovada? Se não há, a lacuna foi declarada?
- [ ] Tom direto, sem clichê de tecnologia? Vocabulário do público do briefing?
- [ ] CTA diz o que o leitor ganha?
- [ ] Exclamação além da permitida? Mais de um travessão? Voz passiva? Qualificador fraco?
- [ ] Paralelismo retórico ou frase sem função? Duas frases seguidas sem ponte lógica?
- [ ] "Não é sobre X, é sobre Y" ou variação?
- [ ] Presume problema sem dado ou terceira pessoa?
- [ ] Afirmação de resultado tem modificador?
- [ ] Alguma palavra da lista a evitar, em qualquer flexão? (reescrever; se indispensável, perguntar antes de entregar)
- [ ] Copy genérico (robusto, navegar, potencializar, ecossistema dinâmico) sem contexto concreto?
- [ ] Abertura genérica?

**Vocabulário e marca**
- [ ] Artigo e gênero de cada marca corretos em todas as ocorrências?
- [ ] Nenhum termo proibido da marca que assina? Termos preferidos aplicados?
- [ ] Nenhum comparativo com concorrente?
- [ ] Nome de produto na grafia do config (`produtos[].nome`)?

**Kill list — cortar sem negociar**
- [ ] Seção que repete sem adicionar prova ou avanço? Transição que não conecta causa e consequência?
- [ ] Bloco que não aumenta urgência nem adiciona prova? Frase que "soa como copy" e ninguém diria?
- [ ] A peça perde momentum entre o lead e o CTA?

## Output esperado

Todo texto entregue inclui:

- **Versão principal** — copy pronto, com CTA.
- **Variação alternativa** — estrutura diferente da principal, não reescrita; para teste A/B ou outro canal.
- **Nota de transparência** — o que veio do briefing, o que veio de fonte confiável (com a fonte), o que ficou pendente; marcadores `[VALIDADO]` · `[INFORMADO PELO CLIENTE]` · `[PENDENTE DE CONFIRMAÇÃO]` · `[NECESSITA FONTE]`; palavra da lista mantida com aprovação registrada aqui.
- **Oferta de revisão anti-IA** — conforme a política do canal em `cortex.config.yaml` (`revisao_anti_ia`: `obrigatoria` ou `oferecida`); padrão da organização: `{{operacao.revisao_anti_ia_padrao}}`.

> Nenhum número, dado, case ou nome de cliente entra no output sem fonte válida. Na ausência, marcador — nunca suposição.

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack marketing@1.0. | {{papel "redator"}} |
