---
tipo: skill
id: dna-visual
descricao: "Lê o mecanismo de uma referência aprovada — composição, luz, tipografia, cor como observação, ritmo e efeito — separando o que estudar do que nunca copiar."
familia: ANALISAR.dna-visual
output: analise
canal:
ferramenta:
produto: todos
publico:
gatilhos: ["extrai o estilo dessa referência", "o que faz essa peça funcionar", "DNA visual", "engenharia reversa do visual", "analisa essa imagem de referência", "decompõe essa referência"]
requires: diretor-de-arte
owner: {{papel "diretor-de-arte"}}
origem: pack:visual@1.0
validado_em: {{hoje}}
---

> **Chegou aqui direto?** Esta skill é conduzida pelo **Diretor de Arte** (`diretor-de-arte`).

# DNA visual — mecanismo, não cópia

Explica **por que** uma referência funciona, em termos que a marca pode reaproveitar com os próprios valores. A saída alimenta `biblioteca-de-estilos` e `documentar-design-system`.

## Contexto de uso

- Referências aprovadas no radar (etapa 2 do `kit-visual`).
- "O que tem nessa peça que a gente gosta?" antes de criar um estilo.

## Processo

Para cada referência aprovada (id do `acervo.json`), preencher:

| Dimensão | O que registrar |
|---|---|
| Composição | grade, respiro, ponto focal, hierarquia, proporção usada |
| Tipografia | classe (serifa, grotesca, mono), contraste de pesos, caixa, entrelinha — sem nomear para copiar |
| Cor | **observação**: temperatura, contraste, quantos tons, papel do acento. Nunca vira valor da marca |
| Luz e imagem | tipo de luz, lente aparente, tratamento, pessoas e pose |
| Ritmo | em sequência (carrossel, vídeo): abertura, progressão, fechamento, densidade por tela |
| Efeito | movimento, textura, 3D, partículas — e o custo de produzir |
| Mecanismo central | a frase que explica por que funciona |
| Para a marca | como aplicar com os tokens e a voz da marca |
| Não copiar | layout exato, imagem, ilustração, frase, logo, assinatura visual |

Ferramentas opcionais, quando instaladas: extração de design DNA e engenharia reversa de prompt a partir de imagem. **Vetado** para referência de terceiros: buscar ou baixar o arquivo original de alta resolução para reaproveitar.

Ao fim, agrupar mecanismos repetidos entre referências de **autores diferentes**: são candidatos a estilo.

## Regras

- A cor observada nunca é transportada; a marca decide valores.
- Mecanismo visto em um autor só é idiossincrasia, não estilo.
- Separar o que foi visto do que foi inferido.

## Output esperado

| Saída | Formato |
|---|---|
| Ficha de DNA por referência | tabela acima, registrada no campo `observar` do acervo ou em nota do kit |
| Candidatos a estilo | lista de mecanismos repetidos, com ids de origem |

## Histórico

| Data | O que mudou | Papel |
|---|---|---|
| {{hoje}} | Instanciado do pack visual@1.0. | {{papel "diretor-de-arte"}} |
