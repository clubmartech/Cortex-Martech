"""Utilidades compartilhadas dos scripts do pack visual. Só stdlib; reaproveita a lib do kernel."""
import json
import os
import re
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
CLI = AQUI.parents[2] / "cli"          # _cortex/cli
sys.path.insert(0, str(CLI))

from lib import config as _cfg, fs, yamlmini  # noqa: E402

BLOCO_YAML = re.compile(r"^```ya?ml[ \t]*\n(.*?)^```[ \t]*$", re.S | re.M)


def raiz(inicio=None):
    """Raiz do Cortex: `CORTEX_ROOT` ou a primeira pasta acima que contém `_cortex/`."""
    env = os.environ.get("CORTEX_ROOT")
    if env:
        return Path(env).resolve()
    p = Path(inicio or os.getcwd()).resolve()
    for c in [p, *p.parents]:
        if (c / "_cortex").is_dir():
            return c
    return AQUI.parents[3]


def config(root=None):
    return _cfg.carregar(root or raiz()) or {}


def ler_json(caminho):
    with open(caminho, encoding="utf-8") as f:
        return json.load(f)


def gravar_json(caminho, obj):
    """Gravação atômica (mesmo protocolo do kernel)."""
    caminho = Path(caminho)
    caminho.parent.mkdir(parents=True, exist_ok=True)
    fs.gravar(caminho.parent, caminho.name, json.dumps(obj, ensure_ascii=False, indent=2) + "\n")


def gravar_texto(caminho, texto):
    caminho = Path(caminho)
    caminho.parent.mkdir(parents=True, exist_ok=True)
    fs.gravar(caminho.parent, caminho.name, texto)


def yaml_do_md(caminho):
    """Primeiro bloco ```yaml``` de um `.md` (registro de fontes, por exemplo)."""
    texto = Path(caminho).read_text(encoding="utf-8")
    m = BLOCO_YAML.search(texto)
    if not m:
        raise ValueError("%s não tem bloco ```yaml```" % caminho)
    return yamlmini.load(m.group(1)) or {}


def obter(d, caminho, padrao=None):
    atual = d
    for parte in caminho.split("."):
        if not isinstance(atual, dict) or parte not in atual:
            return padrao
        atual = atual[parte]
    return atual
