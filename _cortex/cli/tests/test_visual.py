"""Pack visual: scripts (tokens, acervo, radar, consistência), instalação e check 15."""
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

CLI = Path(__file__).resolve().parents[1]
ROOT = CLI.parents[1]
SCRIPTS = ROOT / "_cortex/packs/visual/scripts"
sys.path.insert(0, str(CLI))
sys.path.insert(0, str(SCRIPTS))
from lib import build, checks, config, packs, yamlmini  # noqa: E402
import acervo as A  # noqa: E402
import consistencia as C  # noqa: E402
import radar as R  # noqa: E402
import tokens as T  # noqa: E402

EXEMPLO = ROOT / "_cortex/onboarding/exemplos/varejo-b2c-moda.yaml"


def tokens_ok():
    t = json.loads(json.dumps(T.ESQUELETO))
    c = t["cor"]
    for k, v in {"primaria": "#5b2eff", "destaque": "#ffb800"}.items():
        c["marca"][k]["$value"] = v
    c["marca"]["secundaria"]["$value"] = "{cor.marca.primaria}"
    for k, v in {"fundo": "#ffffff", "superficie": "#f4f4f6", "texto": "#111111", "texto-suave": "#5c5c66", "borda": "#e0e0e0"}.items():
        c[k]["$value"] = v
    t["tipografia"]["familia"]["titulo"]["$value"] = "Work Sans"
    t["tipografia"]["familia"]["texto"]["$value"] = ["Work Sans", "system-ui"]
    t["tipografia"]["tamanho"]["titulo"]["$value"] = "40px"
    t["raio"]["padrao"]["$value"] = "12px"
    return t


class Tokens(unittest.TestCase):
    def test_contraste_wcag(self):
        self.assertAlmostEqual(T.contraste("#000000", "#ffffff"), 21.0, places=2)
        self.assertAlmostEqual(T.contraste("#777777", "#ffffff"), 4.48, places=2)

    def test_valido_e_alias(self):
        erros, avisos = T.validar(tokens_ok())
        self.assertEqual((erros, avisos), ([], []))
        self.assertIn("--cor-marca-secundaria: #5b2eff;", T.css(tokens_ok()))

    def test_erros(self):
        t = tokens_ok()
        t["cor"]["texto-suave"]["$value"] = "#999999"
        t["cor"]["borda"]["$value"] = "{cor.nao-existe}"
        t["raio"]["padrao"]["$value"] = "12"
        erros, _ = T.validar(t)
        self.assertTrue(any("contraste" in e for e in erros))
        self.assertTrue(any("inexistente" in e for e in erros))
        self.assertTrue(any("unidade" in e for e in erros))

    def test_ciclo_e_tema_escuro(self):
        t = tokens_ok()
        t["cor"]["fundo"]["$value"] = "{cor.superficie}"
        t["cor"]["superficie"]["$value"] = "{cor.fundo}"
        self.assertTrue(any("ciclo" in e for e in T.validar(t)[0]))
        t = tokens_ok()
        t["$extensions"]["cortex"]["temas"] = {"escuro": {"cor.fundo": "#0b0b10", "cor.texto": "#1a1a1a"}}
        self.assertTrue(any("escuro" in e for e in T.validar(t)[0]))

    def test_esqueleto_so_avisa(self):
        erros, avisos = T.validar(T.ESQUELETO)
        self.assertEqual(erros, [])
        self.assertTrue(avisos)


class Acervo(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)

    def item(self, **kw):
        it = {"id": "a", "titulo": "t", "tipo": "referencia", "origem": "terceiro", "licenca": "so-referencia",
              "data": "2026-10-12", "url": "https://ex.com/a", "observar": "luz", "aprovado": True}
        it.update(kw)
        return it

    def test_regras_de_licenca(self):
        m = {"itens": [self.item(), self.item(id="b", url="https://ex.com/b", licenca="cc-by"),
                       self.item(id="c", url="https://ex.com/c", licenca="cc-by-nc"),
                       self.item(id="d", url="https://www.ex.com/a/")]}
        erros, _ = A.validar(m, self.base, self.base)
        texto = " | ".join(erros)
        self.assertIn("b: CC BY exige", texto)
        self.assertIn("c: licença `cc-by-nc` é recusada", texto)
        self.assertIn("d: mesma URL", texto)

    def test_midia_de_terceiro_no_escopo(self):
        (self.base / "_cortex").mkdir()
        (self.base / "times").mkdir()
        (self.base / "times" / "x.jpg").write_bytes(b"x")
        m = {"itens": [self.item(url=None, arquivo="times/x.jpg")]}
        erros, _ = A.validar(m, self.base, self.base)
        self.assertTrue(any("dentro do escopo" in e for e in erros))

    def test_importar_so_aprovados(self):
        m = A.vazio()
        lote = {"lote": "l1", "itens": [{"url": "https://ex.com/a", "decisao": "aprovado"},
                                        {"url": "https://ex.com/b", "decisao": "candidato"}]}
        self.assertEqual(A.importar(m, lote), 1)
        self.assertEqual(A.importar(m, lote), 0)
        self.assertIn("ex.com", A.galeria(m))


class Radar(unittest.TestCase):
    def notas(self, v):
        return {c: v for c in R.CRITERIOS}

    def test_triagem(self):
        lote = {"itens": [
            {"id": "1", "url": "https://x/1", "autor": "a", "tipo": "foto", "licenca": "cc0", "mecanismos": ["m1"], "notas": self.notas(3)},
            {"id": "2", "url": "https://x/2", "autor": "b", "tipo": "foto", "licenca": "desconhecida", "notas": self.notas(3)},
            {"id": "3", "url": "https://x/3", "autor": "c", "tipo": "web", "licenca": "cc0", "notas": self.notas(1)},
            {"id": "4", "url": "https://x/1/", "autor": "d", "tipo": "web", "licenca": "cc0", "notas": self.notas(3)},
            {"id": "5", "url": "https://x/5", "autor": "e", "tipo": "web", "licenca": "cc0", "notas": {"aderencia": 3}}]}
        t = R.triar(lote)
        d = {i["id"]: i["decisao"] for i in t["itens"]}
        self.assertEqual(d, {"1": "candidato", "2": "descartado", "3": "descartado", "4": "descartado", "5": "descartado"})
        self.assertFalse(t["resumo"]["saturado"])
        self.assertTrue(R.triar(lote, anteriores=[t])["resumo"]["saturado"])

    def test_limite_por_autor(self):
        lote = {"itens": [{"id": str(i), "url": "https://x/%d" % i, "autor": "mesmo", "tipo": "foto", "licenca": "cc0",
                           "notas": self.notas(2 + (i % 2))} for i in range(5)]}
        t = R.triar(lote, por_autor=3)
        self.assertEqual(sum(i["decisao"] == "candidato" for i in t["itens"]), 3)

    def test_plano_prioriza_proprias_e_veta(self):
        cfg = {"visual": {"nicho": "escola de esqui", "fontes_proprias": [{"url": "https://insta/x"}], "fontes_vetadas": ["b"]}}
        reg = {"fontes": [{"id": "a", "como_buscar": "https://a/s/{q}", "origem": "sugerida"},
                          {"id": "b", "como_buscar": "https://b?q={q}", "origem": "sugerida"},
                          {"id": "c", "acesso": "pago", "como_buscar": "manual", "origem": "sugerida"}]}
        p = R.plano(cfg, reg)
        self.assertEqual(p["consultas"][0]["origem"], "propria")
        self.assertEqual({c["fonte"] for c in p["consultas"]}, {"propria-1", "a"})
        self.assertIn("https://a/s/escola%20de%20esqui", [c["url"] for c in p["consultas"]])


class Consistencia(unittest.TestCase):
    def test_peca_fora_dos_tokens(self):
        with tempfile.TemporaryDirectory() as temp:
            peca = Path(temp) / "p.html"
            peca.write_text('<p style="color:#5b2eff;background:#ff0000;font-family:Arial, Comic Sans MS;font-weight:800">x</p>')
            achados = C.auditar(tokens_ok(), [peca])
            tipos = sorted(a["tipo"] for a in achados)
            self.assertEqual(tipos, ["cor", "fonte", "peso"])


class PackInstalado(unittest.TestCase):
    def test_instala_build_e_check15(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            shutil.copytree(ROOT / "_cortex", root / "_cortex", ignore=shutil.ignore_patterns(".build", "__pycache__", "tests"))
            cfg = yamlmini.load(EXEMPLO.read_text(encoding="utf-8"))
            cfg["visual"] = {"nicho": "moda contemporânea", "pessoas_reais": True, "formatos": ["feed"]}
            config.gravar(root, cfg)
            build.executar(root, cfg, first_run=True, log=lambda x: None)
            cfg = config.carregar(root)
            r = packs.instalar(root, cfg, "visual", "marca")
            self.assertIn("times/marca/docs/tokens.json", r["criados"])
            build.executar(root, config.carregar(root), log=lambda x: None)
            cfg = config.carregar(root)
            erros = [a for a in checks.rodar(root, cfg) if a.sev == "ERRO"]
            self.assertEqual(erros, [], [a.msg for a in erros])
            (root / "times/marca/docs/tokens.json").write_text(json.dumps(dict(tokens_ok(), cor=dict(tokens_ok()["cor"], fundo={"$type": "color", "$value": "#121212"}))))
            achados = checks.rodar(root, cfg, quais={15})
            self.assertTrue(any(a.sev == "ERRO" and "contraste" in a.msg for a in achados))


if __name__ == "__main__":
    unittest.main()
