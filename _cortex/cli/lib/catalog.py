"""catalog — varre o escopo e monta manifest.json / catalogo.json (CONTRATOS §8)."""
import datetime
import json
from pathlib import Path

from . import fm, fs, scope

BUILD_DIR = "_cortex/.build"
MANIFEST = BUILD_DIR + "/manifest.json"
CATALOGO = BUILD_DIR + "/catalogo.json"
TOKENS_POR_BYTE = 3.6


class Doc:
    """Um .md do escopo com frontmatter já lido."""
    __slots__ = ("caminho", "texto", "bloco", "corpo", "fm", "erros", "bytes", "grupo", "isento")

    def __init__(self, caminho, texto):
        self.caminho = caminho
        self.texto = texto
        self.bloco, self.corpo = fm.separar(texto)
        self.fm, self.erros = fm.parse_com_erros(self.bloco)
        self.bytes = len(texto.encode("utf-8"))
        self.grupo = scope.grupo(caminho)
        self.isento = scope.eh_isento(caminho)

    @property
    def id(self):
        return (self.fm or {}).get("id") or None

    @property
    def tipo(self):
        return (self.fm or {}).get("tipo") or ""

    @property
    def requires(self):
        return fm.multivalor((self.fm or {}).get("requires"))

    @property
    def gatilhos(self):
        g = (self.fm or {}).get("gatilhos")
        return [str(x) for x in g] if isinstance(g, list) else fm.multivalor(g)

    @property
    def kb(self):
        return round(self.bytes / 1024, 1)

    @property
    def tokens(self):
        return int(self.bytes / TOKENS_POR_BYTE)


def varrer(root, caminhos=None):
    """Lista de Doc do escopo (ou só dos caminhos pedidos)."""
    docs = []
    for relp in (caminhos or scope.arquivos_md(root)):
        try:
            texto = fs.ler(root, relp)
        except Exception:
            continue
        if texto is None:
            continue
        docs.append(Doc(relp, texto))
    return docs


def ids_esperados(docs):
    """Mapa caminho → id esperado, com sufixo de escopo quando o nome colide (§2.1 regra 4)."""
    base = {d.caminho: fm.id_esperado(d.caminho) for d in docs}
    contagem = {}
    for v in base.values():
        contagem[v] = contagem.get(v, 0) + 1
    saida = {}
    for d in docs:
        b = base[d.caminho]
        saida[d.caminho] = {b} if contagem[b] == 1 else {b, b + "-" + fm.escopo_de(d.caminho)}
    return saida


def montar(root, cfg, docs=None):
    """Devolve (catalogo: lista, manifest: dict, ancoras: lista, por_id: dict)."""
    docs = docs if docs is not None else varrer(root)
    aviso_kb = (((cfg or {}).get("governanca") or {}).get("limites") or {}).get("aviso_kb") or 35
    por_id = {}
    for d in docs:
        if d.id and not d.isento and d.id not in por_id:
            por_id[d.id] = d
    consumido = {i: [] for i in por_id}
    for d in por_id.values():
        for r in d.requires:
            if r in consumido and d.id not in consumido[r]:
                consumido[r].append(d.id)
    catalogo, ancoras, ids = [], [], {}
    for d in sorted(por_id.values(), key=lambda x: x.caminho):
        ancora = d.bytes > aviso_kb * 1024
        catalogo.append({
            "id": d.id, "tipo": d.tipo, "caminho": d.caminho, "kb": d.kb, "tokens": d.tokens,
            "familia": d.fm.get("familia") or "", "requires": d.requires,
            "consumido_por": sorted(consumido.get(d.id, [])), "ancora": ancora, "grupo": d.grupo,
        })
        if ancora:
            ancoras.append({"id": d.id, "kb": d.kb, "secoes": fm.headings(d.corpo)})
        ids[d.id] = {
            "caminho": d.caminho, "tipo": d.tipo, "familia": d.fm.get("familia") or "",
            "bytes": d.bytes, "hash_fm": fm.hash_fm(d.bloco), "hash_headings": fm.hash_headings(d.corpo),
            "hash_conteudo": fm.hash_conteudo(d.texto), "validado_em": d.fm.get("validado_em") or "",
            "requires": d.requires, "gatilhos": d.gatilhos,
        }
    manifest = {"ids": ids, "wrappers": {}, "gerado_em": datetime.date.today().isoformat()}
    return catalogo, manifest, ancoras, por_id


def totais(catalogo):
    kb = round(sum(r["kb"] for r in catalogo), 1)
    tokens = sum(r["tokens"] for r in catalogo)
    return kb, tokens


def ler_manifest(root):
    try:
        t = fs.ler(root, MANIFEST)
        return json.loads(t) if t else None
    except Exception:
        return None


def gravar_json(root, relp, obj):
    return fs.gravar(root, relp, json.dumps(obj, ensure_ascii=False, indent=1, sort_keys=False) + "\n")
