"""yamlmini — leitor/escritor do subconjunto YAML do Cortex (CONTRATOS §3).

Suporta: mapas aninhados por indentação (2 espaços), listas `- item`, listas de mapas
`- chave: valor` com continuação indentada, mapas/listas inline `{a: 1}` / `[a, b]`,
escalares (true/false/null, int, float, strings com ou sem aspas), comentários `#`.
Não suporta: âncoras, multi-documento, blocos `|`/`>`.

Se PyYAML estiver instalado, `load` usa-o (safe_load); `dump` é sempre o mini, para a
saída ser estável e independente de biblioteca.
"""
import re

try:  # opcional
    import yaml as _pyyaml  # type: ignore
except Exception:  # pragma: no cover
    _pyyaml = None


class YamlError(ValueError):
    pass


_RE_INT = re.compile(r"^[-+]?\d+$")
_RE_FLOAT = re.compile(r"^[-+]?(\d+\.\d*|\.\d+|\d+)([eE][-+]?\d+)?$")


# ---------------------------------------------------------------- utilidades

def _strip_comment(line):
    """Remove comentário `#` fora de aspas."""
    out, quote, i = [], None, 0
    while i < len(line):
        ch = line[i]
        if quote:
            out.append(ch)
            if ch == "\\" and quote == '"' and i + 1 < len(line):
                out.append(line[i + 1])
                i += 2
                continue
            if ch == quote:
                quote = None
        else:
            if ch in ('"', "'"):
                quote = ch
                out.append(ch)
            elif ch == "#" and (i == 0 or line[i - 1] in " \t"):
                break
            else:
                out.append(ch)
        i += 1
    return "".join(out).rstrip()


def _parse_quoted(s, i):
    """Lê string entre aspas a partir de s[i]. Devolve (valor, índice após a aspa)."""
    q = s[i]
    i += 1
    buf = []
    while i < len(s):
        ch = s[i]
        if q == '"' and ch == "\\" and i + 1 < len(s):
            nxt = s[i + 1]
            buf.append({"n": "\n", "t": "\t", '"': '"', "\\": "\\"}.get(nxt, "\\" + nxt))
            i += 2
            continue
        if ch == q:
            if q == "'" and i + 1 < len(s) and s[i + 1] == "'":
                buf.append("'")
                i += 2
                continue
            return "".join(buf), i + 1
        buf.append(ch)
        i += 1
    raise YamlError("string sem aspa de fechamento: " + s)


def _plain(s):
    s = s.strip()
    if s == "" or s in ("null", "~", "Null", "NULL"):
        return None
    if s in ("true", "True", "TRUE"):
        return True
    if s in ("false", "False", "FALSE"):
        return False
    if _RE_INT.match(s):
        return int(s)
    if _RE_FLOAT.match(s) and "." in s:
        try:
            return float(s)
        except ValueError:
            return s
    return s


def _parse_inline(s, i):
    """Lê um valor inline a partir de s[i]: `{...}`, `[...]`, aspas ou escalar até , ] }."""
    while i < len(s) and s[i] == " ":
        i += 1
    if i >= len(s):
        return None, i
    ch = s[i]
    if ch == "[":
        items, i = [], i + 1
        while True:
            while i < len(s) and s[i] in " \t":
                i += 1
            if i >= len(s):
                raise YamlError("lista inline sem `]`: " + s)
            if s[i] == "]":
                return items, i + 1
            val, i = _parse_inline(s, i)
            items.append(val)
            while i < len(s) and s[i] in " \t":
                i += 1
            if i < len(s) and s[i] == ",":
                i += 1
            elif i < len(s) and s[i] == "]":
                return items, i + 1
            else:
                raise YamlError("lista inline mal formada: " + s)
    if ch == "{":
        obj, i = {}, i + 1
        while True:
            while i < len(s) and s[i] in " \t":
                i += 1
            if i >= len(s):
                raise YamlError("mapa inline sem `}`: " + s)
            if s[i] == "}":
                return obj, i + 1
            if s[i] in ('"', "'"):
                key, i = _parse_quoted(s, i)
            else:
                j = i
                while j < len(s) and s[j] not in ":,}":
                    j += 1
                key = s[i:j].strip()
                i = j
            while i < len(s) and s[i] in " \t":
                i += 1
            if i < len(s) and s[i] == ":":
                i += 1
                val, i = _parse_inline(s, i)
            else:
                val = None
            obj[key] = val
            while i < len(s) and s[i] in " \t":
                i += 1
            if i < len(s) and s[i] == ",":
                i += 1
            elif i < len(s) and s[i] == "}":
                return obj, i + 1
            else:
                raise YamlError("mapa inline mal formado: " + s)
    if ch in ('"', "'"):
        return _parse_quoted(s, i)
    j = i
    while j < len(s) and s[j] not in ",]}":
        j += 1
    return _plain(s[i:j]), j


def _scalar(text):
    """Valor completo de uma linha (depois de `chave:` ou `- `)."""
    t = text.strip()
    if t == "":
        return None
    if t[0] in "[{":
        val, i = _parse_inline(t, 0)
        if t[i:].strip():
            raise YamlError("lixo após valor inline: " + t)
        return val
    if t[0] in ('"', "'"):
        val, i = _parse_quoted(t, 0)
        if t[i:].strip():
            raise YamlError("lixo após string com aspas: " + t)
        return val
    return _plain(t)


def _split_key(content):
    """`chave: valor` → (chave, valor) ou None se a linha não é par chave/valor."""
    if content.startswith(('"', "'")):
        key, i = _parse_quoted(content, 0)
        rest = content[i:].lstrip()
        if rest.startswith(":") and (len(rest) == 1 or rest[1] in " \t"):
            return key, rest[1:].strip()
        return None
    m = re.match(r"^([^\s:#\[\]{}][^:]*?)\s*:(?:\s+(.*))?$", content)
    if not m:
        if re.match(r"^[^\s:][^:]*:$", content):
            return content[:-1].strip(), ""
        return None
    return m.group(1).strip(), (m.group(2) or "").strip()


# ---------------------------------------------------------------- parser

class _Parser:
    def __init__(self, text):
        self.lines = []
        for n, raw in enumerate(text.replace("\r\n", "\n").replace("\r", "\n").split("\n"), 1):
            raw = raw.replace("\t", "  ")
            s = _strip_comment(raw)
            if not s.strip():
                continue
            indent = len(s) - len(s.lstrip(" "))
            self.lines.append((indent, s.strip(), n))
        self.i = 0

    def parse(self):
        if not self.lines:
            return {}
        indent, content, _ = self.lines[0]
        val = self._block(indent)
        if self.i < len(self.lines):
            raise YamlError("linha %d: indentação inesperada" % self.lines[self.i][2])
        return val

    def _block(self, indent):
        _, content, _ = self.lines[self.i]
        if content.startswith("- ") or content == "-":
            return self._list(indent)
        return self._map(indent)

    def _map(self, indent):
        obj = {}
        while self.i < len(self.lines):
            ind, content, n = self.lines[self.i]
            if ind < indent:
                break
            if ind > indent:
                raise YamlError("linha %d: indentação inesperada" % n)
            if content.startswith("- "):
                break
            kv = _split_key(content)
            if kv is None:
                raise YamlError("linha %d: esperava `chave: valor`: %s" % (n, content))
            key, rest = kv
            self.i += 1
            if rest == "":
                if self.i < len(self.lines):
                    ind2, c2, _ = self.lines[self.i]
                    if ind2 > indent or (ind2 == indent and c2.startswith("- ")):
                        obj[key] = self._block(ind2)
                        continue
                obj[key] = None
            else:
                obj[key] = _scalar(rest)
        return obj

    def _list(self, indent):
        items = []
        while self.i < len(self.lines):
            ind, content, n = self.lines[self.i]
            if ind < indent:
                break
            if ind > indent:
                raise YamlError("linha %d: indentação inesperada" % n)
            if not (content.startswith("- ") or content == "-"):
                break
            rest = content[2:].strip() if content != "-" else ""
            if rest == "":
                self.i += 1
                if self.i < len(self.lines) and self.lines[self.i][0] > indent:
                    items.append(self._block(self.lines[self.i][0]))
                else:
                    items.append(None)
                continue
            kv = _split_key(rest) if rest[0] not in "[{\"'" else None
            if kv is not None and not rest.startswith(('"', "'")):
                # item-mapa: reescreve a linha como `  chave: valor` em indent+2
                self.lines[self.i] = (indent + 2, rest, n)
                items.append(self._map(indent + 2))
            else:
                self.i += 1
                items.append(_scalar(rest))
        return items


def load(text):
    """Converte texto YAML (subconjunto) em dict/list/escalares."""
    if _pyyaml is not None:
        try:
            data = _pyyaml.safe_load(text)
            return _normalizar(data if data is not None else {})
        except Exception:
            pass
    return _Parser(text).parse()


def _normalizar(v):
    """PyYAML devolve date/datetime para `2026-10-03`; o Cortex trata como string."""
    import datetime as _dt
    if isinstance(v, dict):
        return {str(k): _normalizar(x) for k, x in v.items()}
    if isinstance(v, list):
        return [_normalizar(x) for x in v]
    if isinstance(v, (_dt.date, _dt.datetime)):
        return v.isoformat()[:10]
    return v


# ---------------------------------------------------------------- dump

_RE_PLAIN_OK = re.compile(r"^[A-Za-z_\u00C0-\u024F][A-Za-z0-9_\u00C0-\u024F .\-/()+]*$")


def _dump_scalar(v):
    if v is None:
        return "null"
    if v is True:
        return "true"
    if v is False:
        return "false"
    if isinstance(v, (int, float)):
        return repr(v) if isinstance(v, float) else str(v)
    s = str(v)
    if s == "":
        return '""'
    if (_RE_PLAIN_OK.match(s) and s not in ("true", "false", "null", "~", "True", "False", "Null")
            and not s.endswith((" ", ":")) and ": " not in s and " #" not in s and s[0] not in "-?"):
        return s
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def _is_scalar(v):
    return not isinstance(v, (dict, list))


def _dump_inline(v):
    if isinstance(v, dict):
        return "{" + ", ".join(_dump_scalar(k) + ": " + _dump_inline(x) for k, x in v.items()) + "}"
    if isinstance(v, list):
        return "[" + ", ".join(_dump_inline(x) for x in v) + "]"
    return _dump_scalar(v)


def _dump_block(v, indent, out):
    pad = " " * indent
    if isinstance(v, dict):
        for k, x in v.items():
            key = _dump_scalar(k)
            if isinstance(x, dict):
                if not x:
                    out.append(pad + key + ": {}")
                elif indent > 0 and all(_is_scalar(y) for y in x.values()) and len(x) <= 4:
                    out.append(pad + key + ": " + _dump_inline(x))
                else:
                    out.append(pad + key + ":")
                    _dump_block(x, indent + 2, out)
            elif isinstance(x, list):
                if not x:
                    out.append(pad + key + ": []")
                elif all(_is_scalar(y) for y in x):
                    out.append(pad + key + ": " + _dump_inline(x))
                else:
                    out.append(pad + key + ":")
                    _dump_block(x, indent + 2, out)
            else:
                out.append(pad + key + ": " + _dump_scalar(x))
    elif isinstance(v, list):
        for x in v:
            if isinstance(x, dict) and x:
                if all(_is_scalar(y) for y in x.values()) and len(x) <= 6:
                    out.append(pad + "- " + _dump_inline(x))
                else:
                    first = True
                    sub = []
                    _dump_block(x, indent + 2, sub)
                    for line in sub:
                        if first:
                            out.append(pad + "- " + line[indent + 2:])
                            first = False
                        else:
                            out.append(line)
            elif isinstance(x, (dict, list)):
                out.append(pad + "- " + _dump_inline(x))
            else:
                out.append(pad + "- " + _dump_scalar(x))
    else:
        out.append(pad + _dump_scalar(v))


def dump(obj):
    """Serializa dict/list no subconjunto YAML (estável, legível, round-trip com `load`)."""
    out = []
    if isinstance(obj, dict):
        for k, x in obj.items():
            if out and isinstance(x, (dict, list)) and x:
                out.append("")
            _dump_block({k: x}, 0, out)
    else:
        _dump_block(obj, 0, out)
    return "\n".join(out).rstrip("\n") + "\n"
