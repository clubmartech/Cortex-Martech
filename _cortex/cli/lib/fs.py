"""fs — leitura/gravação segura: só dentro da raiz, UTF-8 sem BOM, `\n`, grava só se o hash mudou."""
import hashlib
import os
import tempfile
from pathlib import Path


class ForaDaRaiz(RuntimeError):
    pass


def _abs(root, rel):
    root = Path(root).resolve()
    p = (root / rel).resolve() if not Path(rel).is_absolute() else Path(rel).resolve()
    a, b = str(p), str(root)
    if os.name == "nt":
        a, b = a.lower(), b.lower()
    if not (a == b or a.startswith(b + os.sep)):
        raise ForaDaRaiz("recusado: `%s` está fora da raiz do Cortex" % rel)
    return p


def ler(root, rel, default=None):
    p = _abs(root, rel)
    if not p.exists():
        return default
    return p.read_text(encoding="utf-8-sig").replace("\r\n", "\n")


def hash_texto(texto):
    return hashlib.sha256(texto.encode("utf-8")).hexdigest()[:16]


def gravar(root, rel, conteudo):
    """Grava `conteudo` em root/rel. Devolve True se o arquivo mudou (ou foi criado)."""
    p = _abs(root, rel)
    conteudo = conteudo.replace("\r\n", "\n")
    if p.exists():
        atual = p.read_bytes()
        if atual == conteudo.encode("utf-8"):
            return False
    p.parent.mkdir(parents=True, exist_ok=True)
    temp = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", newline="\n", dir=p.parent,
                                         prefix="." + p.name + ".", delete=False) as fh:
            temp = Path(fh.name)
            fh.write(conteudo)
        temp.chmod(p.stat().st_mode & 0o777 if p.exists() else 0o644)
        os.replace(temp, p)
    finally:
        if temp is not None and temp.exists(): temp.unlink()
    return True


def remover(root, rel):
    p = _abs(root, rel)
    if p.exists():
        p.unlink()
        return True
    return False


def existe(root, rel):
    try:
        return _abs(root, rel).exists()
    except ForaDaRaiz:
        return False


def mkdir(root, rel):
    p = _abs(root, rel)
    if not p.exists():
        p.mkdir(parents=True, exist_ok=True)
        return True
    return False
