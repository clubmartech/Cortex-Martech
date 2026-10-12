"""Regressões da instalação dentro de um projeto existente (CONTRATOS §13)."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unicodedata
import unittest

CLI = Path(__file__).resolve().parents[1]
ROOT = CLI.parents[1]
sys.path.insert(0, str(CLI))
from lib import build, config, scope, wrappers, yamlmini

EXEMPLO = ROOT/'_cortex/onboarding/exemplos/servicos-b2b-consultoria.yaml'


class ProjetoHospedeiro(unittest.TestCase):
    """Projeto com camada própria e o Cortex numa subpasta com acento no caminho."""
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.proj = Path(self.tmp.name)/'Área do Projeto'
        self.root = self.proj/'AI'/'Cortex'
        shutil.copytree(ROOT/'_cortex', self.root/'_cortex', ignore=shutil.ignore_patterns('.build', '__pycache__', 'tests'))
        shutil.copytree(ROOT/'.claude', self.root/'.claude')
        (self.proj/'AI'/'Negocio').mkdir(parents=True)
        (self.proj/'AI'/'Negocio'/'oferta.md').write_text('oferta', encoding='utf-8')
        (self.root/'.claude'/'skills'/'skill-do-projeto').mkdir(parents=True)
        (self.root/'.claude'/'skills'/'skill-do-projeto'/'SKILL.md').write_text('---\nname: skill-do-projeto\n---\n', encoding='utf-8')
        (self.root/'CLAUDE.md').write_text('# escrito à mão\n', encoding='utf-8')
        (self.root/'acervo').mkdir(); (self.root/'acervo'/'Nota Solta.md').write_text('x', encoding='utf-8')
        self.cfg = yamlmini.load(EXEMPLO.read_text(encoding='utf-8'))
        self.cfg['projeto'] = {'raiz': '../..'}
        self.cfg['escopo'] = {'excluir': ['acervo']}
        config.gravar(self.root, self.cfg)
        build.executar(self.root, self.cfg, first_run=True, log=lambda x: None)

    def test_build_preserva_o_que_e_do_projeto(self):
        self.assertTrue((self.root/'.claude/skills/skill-do-projeto/SKILL.md').exists())
        self.assertEqual((self.root/'CLAUDE.md').read_text(encoding='utf-8'), '# escrito à mão\n')
        self.assertFalse(scope.eh_gerado(self.root, 'CLAUDE.md'))
        self.assertTrue(scope.eh_gerado(self.root, 'AGENTS.md'))

    def test_escopo_excluir_tira_pasta_do_scanner(self):
        self.assertFalse(any(p.startswith('acervo/') for p in scope.arquivos_md(self.root)))

    def test_ponteiro_para_o_projeto_resolve(self):
        from lib import checks
        self.assertTrue(checks._existe_fora_da_raiz(self.root, 'contexto', 'AI/Negocio/oferta.md', 'crase'))
        self.assertFalse(checks._existe_fora_da_raiz(self.root, 'contexto', 'AI/Negocio/nao-existe.md', 'crase'))

    def test_hook_nega_gerado_com_caminho_nfd(self):
        alvo = unicodedata.normalize('NFD', str(self.root/'ROTAS.md'))
        env = dict(os.environ, CLAUDE_PROJECT_DIR=str(self.root))
        entrada = json.dumps({'tool_name': 'Edit', 'tool_input': {'file_path': alvo, 'old_string': 'a', 'new_string': 'b'}})
        r = subprocess.run([sys.executable, str(self.root/'.claude/hooks/pre_tool_use.py')], input=entrada,
                           capture_output=True, text=True, env=env, cwd=str(self.root))
        self.assertIn('"deny"', r.stdout)


if __name__ == '__main__':
    unittest.main()
