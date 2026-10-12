"""checks — os 14 checks do doctor/lint. Cada achado é (severidade, arquivo, mensagem, fix|None, check)."""
import os
import re
import unicodedata
from collections import namedtuple
from pathlib import Path

from . import catalog, config as _cfg, fm, fs, routes, scope, wrappers, interfaces

Achado = namedtuple("Achado", "sev arquivo msg fix check")
ERRO, AVISO, INFO = "ERRO", "AVISO", "INFO"
ORIGENS = {"kernel", "gerado", "gerado-inicial", "time"}
RE_ORIGEM_PACK = re.compile(r"^pack:[a-z0-9\-]+@[\w.\-]+$")
RAIZES = ("_cortex/", "contexto/", "times/", "iniciativas/", "briefings/", "_saida/", "_assets/", "_arquivo/", ".claude/")
EXTENSOES = (".md", ".html", ".py", ".js", ".yaml", ".yml", ".json", ".xlsx", ".docx", ".tpl", ".txt", ".csv")
LINK_MD = re.compile(r"\[([^\]\n]*)\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
EM_CRASE = re.compile(r"`([^`\n]+)`")
BLOCO_CODIGO = re.compile(r"^```.*?^```[ \t]*$", re.S | re.M)
PLACEHOLDER = re.compile(r"[{}<>*\[\]]|\.\.\.|…")
PROTOCOLO = re.compile(r"^(https?:|mailto:|tel:|ftp:|#|www\.|@)")
DOMINIO = re.compile(r"\.(com|br|io|net|org|dev|app)\b")
REMISSAO = re.compile(
    r"`?([A-Za-z0-9_\-.]+\.md)`?[ ,:—–-]{0,4}\(?[ ]?(?:se[çc][ãa]o[s]?[ ]+)?"
    r"(§[ ]?\d+(?:\.\d+)*(?:[ ]*(?:[/,]|e|a|at[ée]|–|—)[ ]*§?[ ]?\d+(?:\.\d+)*)*)")
NUM_EM_REMISSAO = re.compile(r"\d+(?:\.\d+)*")
NOME_SECAO = re.compile(r"\A[ ]*\(([A-ZÀ-Ú][^,§()\n]{2,60})\)")
CABECALHO_NUM = re.compile(r"^(#{1,6})[ ]*(?:[^\w\n]+[ ]*)?(\d+(?:\.\d+)*)[.)]?[ ]+(.+)$", re.M)
CABECALHO_QUALQUER = re.compile(r"^(#{1,6})[ ]+(.+)$", re.M)
SEGREDOS = [
    (re.compile(r"(?i)\b(api[_\-]?key|secret|token|senha|password|passwd)\s*[:=]\s*[\"']?[A-Za-z0-9_\-/+.]{12,}"), "credencial em texto"),
    (re.compile(r"(?i)\bbearer\s+[A-Za-z0-9\-_.=]{16,}"), "token bearer"),
    (re.compile(r"\bsk-[A-Za-z0-9_\-]{16,}"), "chave `sk-…`"),
    (re.compile(r"(?i)x-log-token\s*[:=]\s*\S+"), "x-log-token"),
    (re.compile(r"(?i)https?://[^\s)`'\"]*(hooks\.slack\.com|discord(app)?\.com/api/webhooks|/webhook[s]?/)[^\s)`'\"]*"), "URL de webhook"),
    (re.compile(r"(?i)https?://[^\s)`'\"]*[?&](token|key|api_key|apikey|secret)=[^\s)`'\"&]{8,}"), "URL com credencial"),
]
NOMES_GENERICOS = {"SKILL.md", "pack.yaml", "iniciativa.yaml", ".env", ".env.example", ".gitignore",
                   "settings.json", "VERSION", "manifest.json", "catalogo.json", "boot.md",
                   "last-doctor.json", "README.md", "cortex.config.yaml", "cortex.py", "questionario.md"}


def _sem_acento(s):
    return "".join(c for c in unicodedata.normalize("NFD", s.lower()) if not unicodedata.combining(c))


def _sem_codigo(texto):
    return BLOCO_CODIGO.sub("", texto)


def _corta_historico(corpo):
    m = re.search(r"^##+ *Hist[óo]rico\b.*$", corpo, re.M)
    return corpo[: m.start()] if m else corpo


# ---------------------------------------------------------------- 1 estrutura

def check_estrutura(root):
    ach = []
    base = Path(root)
    if not (base / "_cortex" / "kernel").is_dir() or not any((base / "_cortex" / "kernel").glob("*.md")):
        ach.append(Achado(ERRO, "_cortex/kernel/", "kernel ausente: a pasta `_cortex/kernel/` não tem os docs de fundação (reinstale o Cortex)", None, 1))
    for p in scope.PASTAS_OBRIGATORIAS:
        if not (base / p).is_dir():
            ach.append(Achado(ERRO if p.startswith("_cortex") else AVISO, p + "/", "pasta obrigatória ausente (rode `build`)", _fix_mkdir(root, p), 1))
    if not (base / "_cortex" / "kernel" / "VERSION").exists():
        ach.append(Achado(ERRO, "_cortex/kernel/VERSION", "arquivo VERSION do kernel ausente", None, 1))
    claude = base / ".claude"
    if claude.is_dir():
        for f in claude.rglob("*.md"):
            relp = scope.rel(root, f)
            partes = relp.split("/")
            ok = (len(partes) == 4 and partes[1] == "skills" and partes[3] == "SKILL.md") or \
                 (len(partes) == 3 and partes[1] == "agents")
            if not ok:
                ach.append(Achado(ERRO, relp, "`.md` canônico dentro de `.claude/` fora dos wrappers — mova para `times/` ou `contexto/`", None, 1))
    return ach


def _fix_mkdir(root, p):
    def fix():
        fs.mkdir(root, p)
        return "pasta criada: " + p
    return fix


# ---------------------------------------------------------------- 2 config

def check_config(root, cfg):
    ach = []
    if cfg is None:
        ach.append(Achado(ERRO, "cortex.config.yaml", "config ausente: rode /cortex-init (ou `cortex init --answers <arquivo.yaml>`)", None, 2))
        return ach
    schema = _cfg.carregar_schema(root)
    if schema is None:
        ach.append(Achado(AVISO, _cfg.SCHEMA, "schema ausente — validação estrutural pulada", None, 2))
    else:
        for e in _cfg.validar(cfg, schema):
            ach.append(Achado(ERRO, "cortex.config.yaml", e, None, 2))
    for e in _cfg.validar_referencias(cfg):
        ach.append(Achado(ERRO, "cortex.config.yaml", e, None, 2))
    disponiveis = routes.packs_disponiveis(root)
    for p in cfg.get("packs") or []:
        pid = p.get("id") if isinstance(p, dict) else p
        if pid not in disponiveis:
            ach.append(Achado(ERRO, "cortex.config.yaml", "pack `%s` não existe em _cortex/packs/" % pid, None, 2))
    if _cfg.status_onboarding(cfg) != "complete":
        ach.append(Achado(AVISO, "cortex.config.yaml", "onboarding `%s` — conclua com /cortex-init" % _cfg.status_onboarding(cfg), None, 2))
    return ach


# ---------------------------------------------------------------- 3 frontmatter

def check_frontmatter(docs, cfg, vocab, ids_base, ativas):
    """`docs` = Docs a checar; `ids_base` = todos os ids da base; vocab = vocabulários."""
    ach = []
    cfg = cfg or {}
    esperados = catalog.ids_esperados(docs) if docs else {}
    familias_kernel = set(_cfg.ORDEM_FAMILIAS)
    ids_vistos = {}
    por_gatilho = {}
    for d in docs:
        if d.isento:
            continue
        a = d.caminho
        if d.bloco is None:
            ach.append(Achado(ERRO, a, "sem frontmatter (14 campos, CONTRATOS §2)", None, 3))
            continue
        for e in d.erros:
            ach.append(Achado(ERRO, a, "frontmatter: " + e, None, 3))
        f = d.fm
        faltam = [c for c in fm.CAMPOS if c not in f]
        if faltam:
            ach.append(Achado(ERRO, a, "faltam campos: " + ", ".join(faltam), _fix_reordenar(d), 3))
        extras = [k for k in f if k not in fm.CAMPOS and k != "subagente"]
        if extras:
            ach.append(Achado(AVISO, a, "campos fora do padrão: " + ", ".join(extras), None, 3))
        ordem = [k for k in fm.ordem_campos(d.bloco) if k in fm.CAMPOS]
        if not faltam and ordem != fm.CAMPOS:
            ach.append(Achado(ERRO, a, "campos fora da ordem fixa (§2)", _fix_reordenar(d), 3))
        tipo = f.get("tipo", "")
        if tipo not in fm.TIPOS:
            ach.append(Achado(ERRO, a, "`tipo: %s` inválido (agent | skill | sub-skill | doc | pack)" % tipo, None, 3))
        if f.get("subagente") and tipo != "agent":
            ach.append(Achado(AVISO, a, "`subagente` só vale para `tipo: agent`", None, 3))
        did = f.get("id") or ""
        if not did:
            ach.append(Achado(ERRO, a, "`id` vazio", None, 3))
        else:
            esp = esperados.get(a, {fm.id_esperado(a)})
            if did not in esp:
                ach.append(Achado(ERRO, a, "`id: %s` ≠ esperado `%s` (regra §2.1)" % (did, sorted(esp)[0]), None, 3))
            if did in ids_vistos:
                ach.append(Achado(ERRO, a, "`id: %s` duplicado (também em %s)" % (did, ids_vistos[did]), None, 3))
            ids_vistos.setdefault(did, a)
        desc = f.get("descricao") or ""
        if not desc:
            ach.append(Achado(ERRO, a, "`descricao` vazia", None, 3))
        elif len(desc) > 160:
            ach.append(Achado(ERRO, a, "`descricao` com %d caracteres (máx. 160)" % len(desc), None, 3))
        m = re.search(r"^descricao:[ \t]*(.*)$", d.bloco, re.M)
        if m and desc and fm.precisa_aspas(desc) and not m.group(1).strip().startswith("\""):
            ach.append(Achado(ERRO, a, "`descricao` precisa de aspas duplas (contém `:`, `#`, `[`… ou começa com número)", _fix_reordenar(d), 3))
        familia = f.get("familia") or ""
        if familia and familia not in vocab["familia"]:
            if familia.split(".")[0] in familias_kernel:
                ach.append(Achado(AVISO, a, "`familia: %s` não está ativa neste config (sub-família inativa ou pack não instalado)" % familia, None, 3))
            else:
                ach.append(Achado(ERRO, a, "`familia: %s` desconhecida" % familia, None, 3))
        out = f.get("output") or ""
        if out not in fm.OUTPUTS:
            ach.append(Achado(ERRO, a, "`output: %s` fora do vocabulário do kernel" % out, None, 3))
        for campo, chave in (("canal", "canal"), ("ferramenta", "ferramenta"), ("publico", "publico")):
            for v in fm.multivalor(f.get(campo)):
                if v not in vocab[chave]:
                    ach.append(Achado(ERRO, a, "`%s: %s` não existe no config (%s)" % (campo, v, ", ".join(vocab[chave]) or "vazio"), None, 3))
        for v in fm.multivalor(f.get("produto")):
            if v not in vocab["produto"]:
                ach.append(Achado(ERRO, a, "`produto: %s` não existe no config (use um slug de produtos[] ou `todos`)" % v, None, 3))
        g = f.get("gatilhos")
        if not isinstance(g, list):
            ach.append(Achado(ERRO, a, "`gatilhos` deve ser lista (inline `[\"a\", \"b\"]` ou bloco `- a`)", None, 3))
            g = []
        elif len(g) < 3 and did != "claude":
            ach.append(Achado(AVISO, a, "só %d gatilho(s) — recomendado ≥3 frases" % len(g), None, 3))
        for gat in g:
            chave = (tipo, str(gat).strip().lower())
            if chave in por_gatilho and por_gatilho[chave] != a:
                ach.append(Achado(AVISO, a, "gatilho \"%s\" colide com %s (mesmo tipo `%s`)" % (gat, por_gatilho[chave], tipo), None, 3))
            por_gatilho.setdefault(chave, a)
        for r in d.requires:
            if r not in ids_base:
                ach.append(Achado(ERRO, a, "`requires` aponta para id inexistente: `%s`" % r, None, 3))
            elif r == did:
                ach.append(Achado(AVISO, a, "`requires` aponta para si mesmo", None, 3))
        owner = f.get("owner") or ""
        if owner not in vocab["owner"]:
            ach.append(Achado(ERRO, a, "`owner: %s` não é papel do config (%s) — nunca nome de pessoa" % (owner, ", ".join(vocab["owner"])), None, 3))
        origem = f.get("origem") or ""
        if origem not in ORIGENS and not RE_ORIGEM_PACK.match(origem):
            ach.append(Achado(ERRO, a, "`origem: %s` inválida (kernel | pack:<id>@<versao> | gerado | gerado-inicial | time)" % origem, None, 3))
        val = f.get("validado_em") or ""
        if not fm.RE_DATA.match(val):
            ach.append(Achado(ERRO, a, "`validado_em: %s` fora do formato AAAA-MM-DD" % val, None, 3))
        if tipo in fm.SECOES_OBRIGATORIAS:
            faltas = [s for s in fm.secoes_faltantes(tipo, d.corpo) if s != "Histórico"]
            if faltas:
                ach.append(Achado(ERRO, a, "seções obrigatórias ausentes (§2.4): " + " · ".join("## " + s for s in faltas), None, 3))
    return ach


def _fix_reordenar(d):
    def fix(root=None):
        if root is None:
            return None
        novo = fm.montar(d.fm) + d.corpo
        if fs.gravar(root, d.caminho, novo):
            return "frontmatter reescrito na ordem fixa: " + d.caminho
        return None
    return fix


# ---------------------------------------------------------------- 4 placeholders

def check_placeholders(docs):
    ach = []
    for d in docs:
        if d.isento:
            continue
        corpo_sem_codigo = re.sub(r"`[^`\n]*`", "", _sem_codigo(d.texto))
        sev = ERRO if d.grupo in ("contexto", "raiz", "kernel") else AVISO
        n = len(re.findall(r"\{\{|\}\}", corpo_sem_codigo))
        if n:
            ach.append(Achado(sev, d.caminho, "%d marcador(es) `{{`/`}}` não renderizado(s)" % n, None, 4))
        pend = re.findall(r"\[PENDENTE:[^\]]*\]", _sem_codigo(d.texto))
        if pend:
            ach.append(Achado(AVISO, d.caminho, "%d campo(s) `[PENDENTE: …]` a preencher" % len(pend), None, 4))
    return ach


# ---------------------------------------------------------------- 5 links

class IndiceDisco:
    def __init__(self, root):
        self.root = Path(root)
        self.reais, self.por_caixa, self.por_nome = set(), {}, {}
        for dp, dn, fn in os.walk(self.root):
            dn[:] = [x for x in dn if x not in (".git", "node_modules", "__pycache__")]
            relp = scope.rel(root, dp)
            relp = "" if relp == "." else relp
            for d in dn:
                p = (relp + "/" + d) if relp else d
                self.reais.add(p)
                self.por_caixa.setdefault(p.lower(), p)
            for f in fn:
                p = (relp + "/" + f) if relp else f
                self.reais.add(p)
                self.por_caixa.setdefault(p.lower(), p)
                self.por_nome.setdefault(f.lower(), []).append(p)
        self._secoes = {}

    def secoes_de(self, relp):
        if relp in self._secoes:
            return self._secoes[relp]
        texto = fs.ler(self.root, relp) or ""
        _, corpo = fm.separar(texto)
        corpo = _sem_codigo(_corta_historico(corpo))
        secoes, atual = {}, None
        for m in CABECALHO_QUALQUER.finditer(corpo):
            nivel, titulo = len(m.group(1)), m.group(2).strip()
            num = CABECALHO_NUM.match(m.group(0))
            if num:
                atual = num.group(2)
                secoes.setdefault(atual, []).append(num.group(3).strip())
            elif atual and nivel > 1:
                secoes[atual].append(titulo)
        self._secoes[relp] = secoes
        return secoes


def _e_caminho(bruto):
    s = bruto.strip()
    if not s or " " in s or PLACEHOLDER.search(s) or PROTOCOLO.match(s) or DOMINIO.search(s):
        return False
    if "/" in s:
        return True
    return s.endswith(EXTENSOES)


def _crase_vale(bruto, indice):
    s = bruto.strip().replace("\\", "/")
    if s.startswith(("../", "./")) or s.startswith(RAIZES):
        return True
    nucleo = s.rstrip("/")
    seg = [x for x in nucleo.split("/") if x]
    if len(seg) >= 2:
        return nucleo.endswith(EXTENSOES) or s.endswith("/")
    if len(seg) == 1 and s.endswith("/"):
        return seg[0] not in scope.EXCLUIR_DIRS and not any(p.split("/")[-1] == seg[0] for p in indice.reais)
    return False


def _candidatos(origem_dir, bruto):
    alvo = bruto.split("#")[0].split("?")[0].replace("\\", "/")
    alvo = re.split(r"\s+§", alvo)[0].strip()
    if not alvo:
        return []
    cands = []

    def soma(c):
        c = os.path.normpath(c).replace("\\", "/")
        if c.startswith("./"):
            c = c[2:]
        if c not in cands:
            cands.append(c)
    if alvo.startswith("/"):
        soma(alvo.lstrip("/"))
        return cands
    soma(os.path.join(origem_dir, alvo) if origem_dir else alvo)
    partes = origem_dir.split("/") if origem_dir else []
    if len(partes) >= 2 and partes[0] in ("times", "iniciativas"):
        soma(os.path.join(partes[0], partes[1], alvo))
    soma(alvo)
    return cands


def check_links(root, docs, indice=None):
    ach = []
    # Só o manifesto explicitamente configurado pode atravessar a raiz do Cortex.
    # Não amplia a permissão de leitura dos demais links do documento.
    external_manifest = None
    try:
        registry = interfaces.carregar(root, _cfg.carregar(root))
        if registry is not None:
            external_manifest = registry['path']
    except interfaces.InterfaceError:
        pass  # check 14 reporta a causa; o link continua inválido

    indice = indice or IndiceDisco(root)
    for d in docs:
        if d.isento:
            continue
        corpo = _sem_codigo(_corta_historico(d.corpo))
        origem_dir = os.path.dirname(d.caminho)
        vistos = set()
        refs = [(m.group(2), "link") for m in LINK_MD.finditer(corpo)]
        refs += [(m.group(1), "crase") for m in EM_CRASE.finditer(corpo)]
        for bruto, forma in refs:
            bruto = bruto.strip()
            if (bruto, forma) in vistos:
                continue
            vistos.add((bruto, forma))
            if not _e_caminho(bruto):
                continue
            if forma == "crase" and not _crase_vale(bruto, indice):
                continue
            norm = bruto.replace("\\", "/")
            if re.match(r"^(\./|\.\./)*_arquivo/.+", norm):
                ach.append(Achado(ERRO, d.caminho, "ponteiro para `%s` — `_arquivo/` nunca é fonte" % bruto, None, 5))
                continue
            if norm.startswith(("_cortex/.build/", "_saida/", "_assets/")) or norm.rstrip("/") in ("_arquivo", "_saida", "_assets"):
                continue  # fora do escopo: artefatos de build, material gerado e binários
            if "/" not in norm.rstrip("/"):
                nome = norm.rstrip("/")
                if nome in NOMES_GENERICOS or not nome.endswith(".md"):
                    continue
                if nome.lower() not in indice.por_nome:
                    ach.append(Achado(AVISO, d.caminho, "`%s` não existe em lugar nenhum da base" % bruto, None, 5))
                continue
            cands = _candidatos(origem_dir, norm)
            if external_manifest is not None and any((Path(root) / c).resolve() == external_manifest for c in cands):
                continue
            if not cands or any(c in indice.reais for c in cands):
                continue
            alt = next((indice.por_caixa[c.lower()] for c in cands if c.lower() in indice.por_caixa), None)
            if alt:
                ach.append(Achado(ERRO, d.caminho, "`%s`: caixa errada — no disco é `%s` (quebra em Git/Linux)" % (bruto, alt), None, 5))
            else:
                base = os.path.basename(cands[-1]).lower()
                outros = indice.por_nome.get(base, [])
                dica = (" — existe em `%s`" % outros[0]) if len(outros) == 1 else ""
                ach.append(Achado(ERRO, d.caminho, "`%s` aponta para arquivo inexistente%s" % (bruto, dica), None, 5))
        # remissões §N
        for m in REMISSAO.finditer(corpo):
            basename, bruto = m.group(1), m.group(2)
            cands = indice.por_nome.get(basename.lower(), [])
            if len(cands) != 1 or cands[0] == d.caminho:
                continue
            secoes = indice.secoes_de(cands[0])
            if not secoes:
                continue
            for num in NUM_EM_REMISSAO.findall(bruto):
                if num not in secoes:
                    prox = sorted(secoes, key=lambda s: (len(s), s))[:10]
                    ach.append(Achado(ERRO, d.caminho, "remissão `%s §%s`: o alvo não tem §%s (tem: %s)" % (basename, num, num, " ".join("§" + s for s in prox)), None, 5))
                    continue
                nome = NOME_SECAO.match(corpo[m.end():])
                if not nome:
                    continue
                citado = _sem_acento(nome.group(1))
                reais_ = " ".join(_sem_acento(t) for t in secoes[num])
                palavras = [p for p in re.findall(r"\w{4,}", citado) if p not in ("secao", "fonte")]
                if palavras and not any(p in reais_ for p in palavras):
                    ach.append(Achado(AVISO, d.caminho, "remissão `%s §%s (%s)`: §%s do alvo é \"%s\"" % (basename, num, nome.group(1), num, secoes[num][0]), None, 5))
    return ach


# ---------------------------------------------------------------- 6 rotas

def check_rotas(root, cfg, ativas, por_id, docs, consumido):
    ach = []
    roteados = routes.ids_roteados(ativas)
    for s in ativas:
        arq = "%s/%s/pack.yaml" % (routes.PACKS_DIR, s["pack"])
        for o in s["obrigatorio"]:
            if o not in por_id:
                ach.append(Achado(ERRO, arq, "sub-família `%s` ativa exige `%s`, que não existe na base (rode `pack install %s`)" % (s["id"], o, s["pack"]), None, 6))
        for c in s["complementar"]:
            if "{" in c:  # padrão por item (ex.: criatividade-{produto}): basta existir um id com o prefixo
                pref = c.split("{")[0]
                if not any(i.startswith(pref) for i in por_id):
                    ach.append(Achado(AVISO, arq, "sub-família `%s`: nenhum arquivo com prefixo `%s` (complementar `%s`)" % (s["id"], pref, c), None, 6))
                continue
            if c not in por_id:
                ach.append(Achado(AVISO, arq, "sub-família `%s`: complementar `%s` não existe" % (s["id"], c), None, 6))
        for c in s["condicional"]:
            a = str(c.get("abrir") or "")
            if "{" in a and not a.startswith("§"):  # padrão por item, ex.: ficha-produto-{produto}
                pref = a.split("{")[0]
                if not any(i.startswith(pref) for i in por_id):
                    ach.append(Achado(AVISO, arq, "sub-família `%s`: condicional abre `%s`, sem arquivo com prefixo `%s`" % (s["id"], a, pref), None, 6))
                continue
            if a and not a.startswith("§") and a not in por_id:
                ach.append(Achado(AVISO, arq, "sub-família `%s`: condicional abre `%s`, que não existe" % (s["id"], a), None, 6))
    for d in docs:
        if d.isento or not d.id:
            continue
        if d.tipo == "agent" and d.id not in roteados and not consumido.get(d.id):
            ach.append(Achado(AVISO, d.caminho, "agente `%s` não aparece em nenhuma rota ativa nem em `requires`" % d.id, None, 6))
        if d.tipo in ("skill", "sub-skill") and d.id not in roteados and not consumido.get(d.id):
            ach.append(Achado(AVISO, d.caminho, "skill órfã: `%s` não está em rota ativa nem é `requires` de ninguém" % d.id, None, 6))
    return ach


# ---------------------------------------------------------------- 7 tamanho

def check_tamanho(docs, limites):
    ach = []
    aviso = (limites or {}).get("aviso_kb") or 35
    erro = (limites or {}).get("erro_kb") or 60
    for d in docs:
        if d.bytes > erro * 1024:
            ach.append(Achado(ERRO, d.caminho, "%.1f KB > limite de erro (%d KB) — divida o arquivo" % (d.kb, erro), None, 7))
        elif d.bytes > aviso * 1024:
            ach.append(Achado(AVISO, d.caminho, "%.1f KB > %d KB — rota deve apontar seção, não arquivo" % (d.kb, aviso), None, 7))
            if not re.search(r"^## *Sum[áa]rio", d.corpo, re.M):
                ach.append(Achado(ERRO, d.caminho, "arquivo > %d KB exige `## Sumário` com âncoras" % aviso, None, 7))
    return ach


# ---------------------------------------------------------------- 8 drift

def check_drift(root, cfg, docs, manifest, plano=None):
    ach = []
    if not manifest:
        ach.append(Achado(INFO, catalog.MANIFEST, "sem manifesto — rode `build` para habilitar a detecção de drift", None, 8))
        return ach
    ids = manifest.get("ids") or {}
    for d in docs:
        if d.isento or not d.id or d.id not in ids:
            continue
        m = ids[d.id]
        if m.get("caminho") != d.caminho:
            continue
        mudou = fm.hash_fm(d.bloco) != m.get("hash_fm") or fm.hash_headings(d.corpo) != m.get("hash_headings")
        if mudou and (d.fm.get("validado_em") or "") == (m.get("validado_em") or "") and not scope.eh_gerado(root, d.caminho):
            ach.append(Achado(AVISO, d.caminho, "frontmatter/seções mudaram desde o último build, mas `validado_em` não — atualize o `## Histórico`", None, 8))
    for wid, h in (manifest.get("wrappers") or {}).items():
        relp = "%s/%s/SKILL.md" % (wrappers.SKILLS_DIR, wid)
        if not fs.existe(root, relp):
            relp = "%s/%s.md" % (wrappers.AGENTS_DIR, wid)
        atual = fs.ler(root, relp)
        if atual is None or fs.hash_texto(atual) != h:
            ach.append(Achado(ERRO, relp, "wrapper desatualizado ou ausente — rode `build`", None, 8))
    if plano:
        for dest, conteudo in plano["saidas"].items():
            atual = fs.ler(root, dest)
            if atual is None:
                ach.append(Achado(AVISO, dest, "arquivo gerado ausente — rode `build`", None, 8))
            elif _normaliza_data(atual, conteudo) != atual:
                ach.append(Achado(AVISO, dest, "gerado desatualizado em relação ao template/config — rode `build`", None, 8))
        for relp, conteudo in plano["wrappers"].items():
            if fs.ler(root, relp) != conteudo:
                ach.append(Achado(ERRO, relp, "wrapper desatualizado — rode `build`", None, 8))
    return ach


def _normaliza_data(atual, novo):
    """Ignora diferença que é só a data de geração (`validado_em: {{agora}}`)."""
    m = re.search(r"^validado_em:\s*(\d{4}-\d{2}-\d{2})", atual, re.M)
    n = re.search(r"^validado_em:\s*(\d{4}-\d{2}-\d{2})", novo, re.M)
    if m and n and m.group(1) != n.group(1):
        return novo.replace(n.group(1), m.group(1))
    m = re.search(r"boot da sessão \((\d{4}-\d{2}-\d{2})\)", atual)
    n = re.search(r"boot da sessão \((\d{4}-\d{2}-\d{2})\)", novo)
    if m and n and m.group(1) != n.group(1):
        return novo.replace(n.group(1), m.group(1))
    return novo


# ---------------------------------------------------------------- 9 segurança

def check_seguranca(root, docs, limites, so_docs=False):
    ach = []
    for d in docs:
        for rx, rot in SEGREDOS:
            m = rx.search(d.texto)
            if m:
                ach.append(Achado(ERRO, d.caminho, "segurança: %s em texto (`%s…`) — remova e rotacione a credencial" % (rot, m.group(0)[:24]), None, 9))
    if so_docs:
        return ach
    mb = (limites or {}).get("binario_mb") or 2
    for relp in scope.arquivos_todos(root):
        if relp.lower().endswith(".md"):
            continue
        try:
            tam = (Path(root) / relp).stat().st_size
        except OSError:
            continue
        if tam > mb * 1024 * 1024:
            ach.append(Achado(AVISO, relp, "binário de %.1f MB no escopo — mova para `_assets/`" % (tam / 1024 / 1024), None, 9))
    if fs.existe(root, ".env"):
        gi = fs.ler(root, ".gitignore") or ""
        if not re.search(r"^\s*\.env\s*$", gi, re.M):
            ach.append(Achado(ERRO, ".env", "`.env` presente e não ignorado no `.gitignore`", None, 9))
    return ach


# ---------------------------------------------------------------- 10 histórico

def check_historico(docs):
    ach = []
    for d in docs:
        if d.isento or d.bloco is None or d.id == "claude":
            continue  # CLAUDE.md é atalho ≤30 linhas por desenho (CONTRATOS §8), sem Histórico
        data, tem = fm.primeira_data_historico(d.corpo)
        if not tem:
            ach.append(Achado(ERRO, d.caminho, "falta a seção `## Histórico` (tabela | Data | O que mudou | Papel |)", _fix_historico(d), 10))
            continue
        val = d.fm.get("validado_em") or ""
        if data is None:
            ach.append(Achado(AVISO, d.caminho, "`## Histórico` sem linha de data (AAAA-MM-DD)", None, 10))
        elif data != val:
            ach.append(Achado(ERRO, d.caminho, "1ª data do Histórico (%s) ≠ `validado_em` (%s)" % (data, val), _fix_validado(d, data), 10))
    return ach


def _fix_historico(d):
    def fix(root=None):
        if root is None:
            return None
        val = d.fm.get("validado_em") or ""
        novo = d.texto.rstrip("\n") + "\n\n## Histórico\n\n| Data | O que mudou | Papel |\n|---|---|---|\n| %s | Seção de histórico adicionada pelo `doctor --fix`. | %s |\n" % (val, d.fm.get("owner") or "")
        fs.gravar(root, d.caminho, novo)
        return "Histórico adicionado: " + d.caminho
    return fix


def _fix_validado(d, data):
    def fix(root=None):
        if root is None:
            return None
        novo = re.sub(r"^validado_em:.*$", "validado_em: " + data, d.texto, count=1, flags=re.M)
        fs.gravar(root, d.caminho, novo)
        return "validado_em ← %s em %s" % (data, d.caminho)
    return fix


# ---------------------------------------------------------------- orquestração

# ---------------------------------------------------------------- 11 nomenclatura

_NOME_OK = re.compile(r"^[a-z0-9]+(?:[-.][a-z0-9]+)*$")
_NOMES_FIXOS = {"AGENTS.md", "CLAUDE.md", "ROTAS.md", "CATALOGO.md", "ABERTURA-SESSAO.md", "README.md",
                "CONTRATOS.md", "MELHORIAS-APLICADAS.md", "VERSION", "SKILL.md", "_modelo.md"}
_SUSPEITO = re.compile(r"\(\d+\)|\.bak|~\$|c[oó]pia|conflito", re.I)
# `nome-1.md` só é cópia quando `nome.md` existe ao lado; `publico-30-45.md` é nome legítimo.
_SUFIXO_NUM = re.compile(r"^(.+)-\d+\.md$")


def check_nomenclatura(root, docs):
    """Nomes de arquivo e pasta no escopo: kebab-case, sem acento, sem espaço, sem `(1)`, `.bak`, `-1.md`, `~$`."""
    ach = []
    vistos = set()
    for d in docs:
        if d.isento:
            continue
        partes = d.caminho.split("/")
        for i, parte in enumerate(partes):
            chave = "/".join(partes[: i + 1])
            if chave in vistos:
                continue
            vistos.add(chave)
            eh_arquivo = i == len(partes) - 1
            base = parte[:-3] if parte.endswith(".md") else parte
            base = base[:-6] if base.endswith(".agent") else base
            if parte in _NOMES_FIXOS:
                continue
            if base.startswith("_") and _NOME_OK.match(base[1:] or "x"):
                continue
            m = _SUFIXO_NUM.match(parte) if eh_arquivo else None
            irmao = m and (Path(root) / "/".join(partes[:-1]) / (m.group(1) + ".md")).exists()
            if eh_arquivo and (_SUSPEITO.search(parte) or irmao):
                ach.append(Achado(AVISO, d.caminho, "nomenclatura: `%s` parece cópia/duplicata (sufixo de conflito, `(1)`, `.bak`, `-1`)" % parte, None, 11))
                continue
            if not _NOME_OK.match(base):
                motivo = "espaço, acento ou maiúscula" if re.search(r"[A-ZÀ-ÿ ]", parte) else "caractere fora de kebab-case"
                ach.append(Achado(AVISO, d.caminho, "nomenclatura: `%s` fora do padrão kebab-case (%s); renomeie e ajuste o `id`" % (parte, motivo), None, 11))
    return ach


# ---------------------------------------------------------------- 12 duplicatas

def check_duplicatas(docs):
    """Arquivos com o mesmo corpo (ignorando frontmatter e espaços) ou com o mesmo `id`."""
    ach = []
    por_corpo, por_id = {}, {}
    for d in docs:
        if d.isento:
            continue
        corpo = re.sub(r"\s+", " ", d.corpo or "").strip()
        if len(corpo) > 200:
            por_corpo.setdefault(fs.hash_texto(corpo), []).append(d.caminho)
        if d.id:
            por_id.setdefault(d.id, []).append(d.caminho)
    for h, arqs in por_corpo.items():
        if len(arqs) > 1:
            ach.append(Achado(AVISO, arqs[0], "duplicata: corpo idêntico a %s — mantenha um e aponte o outro por `requires`" % ", ".join("`%s`" % a for a in arqs[1:]), None, 12))
    for i, arqs in por_id.items():
        if len(arqs) > 1:
            ach.append(Achado(ERRO, arqs[0], "id `%s` repetido em %s — o id é único na base (CONTRATOS §2.1)" % (i, ", ".join("`%s`" % a for a in arqs[1:])), None, 12))
    return ach


# ---------------------------------------------------------------- 13 encoding

_MOJIBAKE = re.compile("Ã[\u0080-¿]|Â[\u0080-¿]|�")


def check_encoding(root, docs):
    """UTF-8 sem BOM, quebras LF, sem mojibake (texto UTF-8 lido como cp1252)."""
    ach = []
    for d in docs:
        try:
            bruto = (Path(root) / d.caminho).read_bytes()
        except OSError:
            continue
        if bruto.startswith(b"\xef\xbb\xbf"):
            ach.append(Achado(AVISO, d.caminho, "encoding: BOM UTF-8 no início do arquivo — grave como UTF-8 sem BOM", _fix_bom(root, d.caminho), 13))
        if b"\r\n" in bruto:
            ach.append(Achado(AVISO, d.caminho, "encoding: quebras CRLF — grave com LF (o build e os hooks gravam assim)", _fix_crlf(root, d.caminho), 13))
        try:
            bruto.decode("utf-8")
        except UnicodeDecodeError:
            ach.append(Achado(ERRO, d.caminho, "encoding: o arquivo não é UTF-8 válido", None, 13))
            continue
        if _MOJIBAKE.search(d.texto or ""):
            ach.append(Achado(AVISO, d.caminho, "encoding: texto com acentos corrompidos (mojibake, ex.: `Ã©`) — reabra como UTF-8 e regrave", None, 13))
    return ach


def _fix_bom(root, relp):
    def f():
        p = Path(root) / relp
        b = p.read_bytes()
        if b.startswith(b"\xef\xbb\xbf"):
            p.write_bytes(b[3:])
            return True
        return False
    return f


def _fix_crlf(root, relp):
    def f():
        p = Path(root) / relp
        b = p.read_bytes()
        if b"\r\n" in b:
            p.write_bytes(b.replace(b"\r\n", b"\n"))
            return True
        return False
    return f


def rodar(root, cfg, quais=None, caminhos=None, docs_extra=None, plano=None):
    """Roda os checks pedidos (todos por padrão). `caminhos` limita os checks por arquivo."""
    quais = set(quais or range(1, 15))
    if caminhos:  # doctor <arquivo…> / lint: só os checks por arquivo
        quais -= {1, 2, 6, 14}
    ach = []
    docs_todos = catalog.varrer(root)
    if docs_extra:
        por = {d.caminho: d for d in docs_todos}
        for d in docs_extra:
            por[d.caminho] = d
        docs_todos = sorted(por.values(), key=lambda x: x.caminho)
    if caminhos:
        alvo = set(c.replace("\\", "/") for c in caminhos)
        docs = [d for d in docs_todos if d.caminho in alvo]
    else:
        docs = docs_todos
    ids_base = {d.id for d in docs_todos if d.id and not d.isento}
    ativas, inativas, _ = ([], [], []) if cfg is None else routes.subfamilias(root, cfg)
    vocab = _cfg.vocabularios(cfg, routes.vocabulario_familia(ativas))
    limites = ((cfg or {}).get("governanca") or {}).get("limites") or {}
    _, _, _, por_id = catalog.montar(root, cfg, docs_todos)
    consumido = {}
    for d in por_id.values():
        for r in d.requires:
            consumido.setdefault(r, []).append(d.id)

    if 1 in quais:
        ach += check_estrutura(root)
    if 2 in quais:
        ach += check_config(root, cfg)
    if 3 in quais:
        ach += check_frontmatter(docs, cfg, vocab, ids_base, ativas)
    if 4 in quais:
        ach += check_placeholders(docs)
    if 5 in quais:
        ach += check_links(root, docs)
    if 6 in quais and cfg is not None:
        ach += check_rotas(root, cfg, ativas, por_id, docs, consumido)
    if 7 in quais:
        ach += check_tamanho(docs, limites)
    if 8 in quais and cfg is not None:
        ach += check_drift(root, cfg, docs, catalog.ler_manifest(root), plano)
    if 9 in quais:
        ach += check_seguranca(root, docs, limites, so_docs=bool(caminhos))
    if 10 in quais:
        ach += check_historico(docs)
    if 11 in quais:
        ach += check_nomenclatura(root, docs)
    if 12 in quais:
        ach += check_duplicatas(docs_todos if not caminhos else docs)
    if 13 in quais:
        ach += check_encoding(root, docs)
    if 14 in quais:
        try:
            registry = interfaces.carregar(root, cfg)
            for error in interfaces.verificar(registry):
                ach.append(Achado(ERRO, "cortex.config.yaml", error, None, 14))
            if registry is not None:
                import json
                expected = interfaces.indice(registry)
                try:
                    actual = json.loads(fs.ler(root, interfaces.INDEX) or "null")
                except ValueError:
                    actual = None
                if actual != expected:
                    ach.append(Achado(AVISO, interfaces.INDEX, "índice de interfaces ausente ou desatualizado; rode build --only interfaces", None, 14))
        except interfaces.InterfaceError as e:
            ach.append(Achado(ERRO, "cortex.config.yaml", str(e), None, 14))
    ordem = {ERRO: 0, AVISO: 1, INFO: 2}
    ach.sort(key=lambda a: (ordem.get(a.sev, 9), a.check, a.arquivo, a.msg))
    return ach
