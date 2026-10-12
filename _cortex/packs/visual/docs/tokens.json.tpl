{
  "$description": "Design tokens da marca — preencher a partir da direção aprovada (skill documentar-design-system). null = a preencher.",
  "cor": {
    "marca": {
      "primaria": {
        "$type": "color",
        "$value": null
      },
      "secundaria": {
        "$type": "color",
        "$value": null
      },
      "destaque": {
        "$type": "color",
        "$value": null
      }
    },
    "fundo": {
      "$type": "color",
      "$value": null
    },
    "superficie": {
      "$type": "color",
      "$value": null
    },
    "texto": {
      "$type": "color",
      "$value": null
    },
    "texto-suave": {
      "$type": "color",
      "$value": null
    },
    "borda": {
      "$type": "color",
      "$value": null
    }
  },
  "tipografia": {
    "familia": {
      "titulo": {
        "$type": "fontFamily",
        "$value": null
      },
      "texto": {
        "$type": "fontFamily",
        "$value": null
      }
    },
    "peso": {
      "regular": {
        "$type": "fontWeight",
        "$value": 400
      },
      "destaque": {
        "$type": "fontWeight",
        "$value": 600
      }
    },
    "tamanho": {
      "corpo": {
        "$type": "dimension",
        "$value": "16px"
      },
      "titulo": {
        "$type": "dimension",
        "$value": null
      }
    }
  },
  "espaco": {
    "1": {
      "$type": "dimension",
      "$value": "4px"
    },
    "2": {
      "$type": "dimension",
      "$value": "8px"
    },
    "3": {
      "$type": "dimension",
      "$value": "16px"
    },
    "4": {
      "$type": "dimension",
      "$value": "24px"
    },
    "5": {
      "$type": "dimension",
      "$value": "40px"
    }
  },
  "raio": {
    "padrao": {
      "$type": "dimension",
      "$value": null
    }
  },
  "motion": {
    "duracao": {
      "$type": "duration",
      "$value": "200ms"
    },
    "curva": {
      "$type": "cubicBezier",
      "$value": [
        0.2,
        0,
        0,
        1
      ]
    }
  },
  "$extensions": {
    "cortex": {
      "contraste": [
        {
          "frente": "cor.texto",
          "fundo": "cor.fundo",
          "minimo": 4.5
        },
        {
          "frente": "cor.texto-suave",
          "fundo": "cor.fundo",
          "minimo": 4.5
        },
        {
          "frente": "cor.texto",
          "fundo": "cor.superficie",
          "minimo": 4.5
        }
      ],
      "temas": {}
    }
  }
}
