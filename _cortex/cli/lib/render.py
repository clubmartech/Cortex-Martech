"""render — motor de template do Cortex (CONTRATOS §7).

Tokenizer + parser recursivo. Blocos `{{#if}}…{{else}}…{{/if}}` e `{{#each lista as x}}…{{/each}}`
aninham livremente. Helpers: upper lower join len default slug hoje papel marca_mae registro_primario.
Valor ausente vira "" e é registrado em `Render.faltantes`.
"""
import datetime
import re
import unicodedata

from . import config as _cfg

HELPERS = {"upper", "lower", "join", "len", "default", "slug", "hoje", "papel", "marca_mae", "registro_primario"}


class TemplateError(ValueError):
    pass


# ---------------------------------------------------------------- tokenizer

def _tokenizar(texto):
    """Lista de ('text', s) | ('tag', conteúdo)."""
    tokens, i, n = [], 0, len(texto)
    buf = []
    while i < n:
        if texto.startswith("\\{{", i):
            buf.append("{{")
            i += 3
            continue
        if texto.startswith("{{", i):
            fim = texto.find("}}", i + 2)
            if fim == -1:
                raise TemplateError("`{{` sem `}}` perto de: " + texto[i:i + 40])
            if buf:
                tokens.append(("text", "".join(buf)))
                buf = []
            tokens.append(("tag", texto[i + 2:fim].strip()))
            i = fim + 2
            continue
        buf.append(texto[i])
        i += 1
    if buf:
        tokens.append(("text", "".join(buf)))
    return tokens


# ---------------------------------------------------------------- parser

def _parse(tokens, i=0, fechos=()):
    """Devolve (nós, índice, fecho_encontrado)."""
    nos = []
    while i < len(tokens):
        kind, val = tokens[i]
        if kind == "text":
            nos.append(("text", val))
            i += 1
            continue
        if val.startswith("!"):
            i += 1
            continue
        if val.startswith("#if "):
            cond = val[4:].strip()
            then, i, fecho = _parse(tokens, i + 1, ("else", "/if"))
            senao = []
            if fecho == "else":
                senao, i, fecho = _parse(tokens, i, ("/if",))
            if fecho != "/if":
                raise TemplateError("`{{#if %s}}` sem `{{/if}}`" % cond)
            nos.append(("if", cond, then, senao))
            continue
        if val.startswith("#each "):
            m = re.match(r"^#each\s+(\S+)\s+as\s+([A-Za-z_]\w*)\s*$", val)
            if not m:
                raise TemplateError("sintaxe inválida: {{%s}} (use `#each lista as x`)" % val)
            corpo, i, fecho = _parse(tokens, i + 1, ("/each",))
            if fecho != "/each":
                raise TemplateError("`{{%s}}` sem `{{/each}}`" % val)
            nos.append(("each", m.group(1), m.group(2), corpo))
            continue
        if val in fechos:
            return nos, i + 1, val
        if val in ("else", "/if", "/each"):
            raise TemplateError("`{{%s}}` sem bloco aberto" % val)
        nos.append(("var", val))
        i += 1
    if fechos:
        raise TemplateError("bloco não fechado: esperava " + " ou ".join("{{%s}}" % f for f in fechos))
    return nos, i, None


def compilar(texto):
    return _parse(_tokenizar(texto))[0]


# ---------------------------------------------------------------- avaliação

def slugify(s):
    s = unicodedata.normalize("NFD", str(s or ""))
    s = "".join(c for c in s if not unicodedata.combining(c)).lower()
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s


def _args(expr):
    """Separa `join x ", "` em ['join', 'x', '", "'] respeitando aspas."""
    return [m.group(0) for m in re.finditer(r'"(?:[^"\\]|\\.)*"|\'[^\']*\'|\S+', expr)]


def _lit(tok):
    if len(tok) >= 2 and tok[0] == tok[-1] and tok[0] in "\"'":
        return tok[1:-1].replace('\\"', '"').replace("\\n", "\n")
    return None


class Render:
    def __init__(self, contexto, cfg=None):
        self.base = contexto or {}
        self.cfg = cfg if cfg is not None else contexto
        self.faltantes = []
        self.escopos = []

    # -- lookup
    def _lookup(self, path):
        partes = path.split(".")
        primeiro = partes[0]
        for esc in reversed(self.escopos):
            if primeiro in esc:
                cur = esc[primeiro]
                break
        else:
            if primeiro in self.base:
                cur = self.base[primeiro]
            else:
                return None, False
        for parte in partes[1:]:
            if isinstance(cur, dict):
                if parte not in cur:
                    return None, False
                cur = cur[parte]
            elif isinstance(cur, list) and parte.isdigit() and int(parte) < len(cur):
                cur = cur[int(parte)]
            else:
                return None, False
        return cur, True

    def valor(self, path):
        v, ok = self._lookup(path)
        return v

    def _resolver_cond(self, expr):
        v, ok = self._lookup(expr)
        return v if ok else None

    # -- expressões
    def avaliar(self, expr):
        toks = _args(expr)
        if not toks:
            return ""
        nome = toks[0]
        if nome in HELPERS:
            return self._helper(nome, toks[1:], expr)
        lit = _lit(nome)
        if lit is not None:
            return lit
        v, ok = self._lookup(nome)
        if not ok or v is None:
            self.faltantes.append(nome)
            return ""
        return v

    def _arg(self, tok):
        lit = _lit(tok)
        if lit is not None:
            return lit
        v, ok = self._lookup(tok)
        if not ok:
            self.faltantes.append(tok)
        return v

    def _helper(self, nome, args, expr):
        if nome == "hoje":
            return self.base.get("agora") or datetime.date.today().isoformat()
        if nome == "marca_mae":
            return _cfg.marca_mae(self.cfg)
        if nome == "registro_primario":
            return _cfg.registro_primario(self.cfg)
        if nome == "default":  # valor ausente é o caso de uso: não registra faltante
            a0 = _lit(args[0]) if args and _lit(args[0]) is not None else (self.valor(args[0]) if args else None)
            alt = self._arg(args[1]) if len(args) > 1 else ""
            return a0 if _cfg.truthy(a0) else alt
        a0 = self._arg(args[0]) if args else None
        if nome == "upper":
            return _texto(a0).upper()
        if nome == "lower":
            return _texto(a0).lower()
        if nome == "slug":
            return slugify(_texto(a0))
        if nome == "len":
            return len(a0) if isinstance(a0, (list, dict, str)) else 0
        if nome == "join":
            sep = self._arg(args[1]) if len(args) > 1 else ", "
            if isinstance(a0, dict):
                return _texto(sep).join("%s → %s" % (k, v) for k, v in a0.items())
            if isinstance(a0, list):
                return _texto(sep).join(_texto(x) for x in a0)
            return _texto(a0)
        if nome == "default":
            alt = self._arg(args[1]) if len(args) > 1 else ""
            return a0 if _cfg.truthy(a0) else alt
        if nome == "papel":
            pedido = _texto(a0)
            time = self.valor("time") or {}
            papeis = time.get("papeis") or [] if isinstance(time, dict) else []
            if pedido in papeis:
                return pedido
            if papeis:
                return papeis[0]
            todos = [p.get("slug") for p in (self.cfg or {}).get("papeis") or []]
            return pedido if pedido in todos else (todos[0] if todos else pedido)
        raise TemplateError("helper desconhecido: " + nome)

    def condicao(self, expr):
        return _cfg.avaliar_condicao(expr, self.cfg, self._resolver_cond)

    # -- render
    def render_nos(self, nos, out):
        for no in nos:
            t = no[0]
            if t == "text":
                out.append(no[1])
            elif t == "var":
                out.append(_texto(self.avaliar(no[1])))
            elif t == "if":
                self.render_nos(no[2] if self.condicao(no[1]) else no[3], out)
            elif t == "each":
                lista = self.avaliar(no[1])
                if isinstance(lista, dict):
                    lista = [{"chave": k, "valor": v} for k, v in lista.items()]
                if not isinstance(lista, list):
                    lista = []
                n = len(lista)
                for idx, item in enumerate(lista):
                    self.escopos.append({no[2]: item, "@index": idx, "@first": idx == 0, "@last": idx == n - 1})
                    try:
                        self.render_nos(no[3], out)
                    finally:
                        self.escopos.pop()

    def render(self, texto):
        out = []
        self.render_nos(compilar(texto), out)
        return "".join(out)


def _texto(v):
    if v is None:
        return ""
    if v is True:
        return "true"
    if v is False:
        return "false"
    if isinstance(v, list):
        return ", ".join(_texto(x) for x in v)
    if isinstance(v, dict):
        return ""
    return str(v)


def render(texto, contexto, cfg=None):
    """Atalho: devolve (saída, faltantes)."""
    r = Render(contexto, cfg)
    return r.render(texto), r.faltantes
