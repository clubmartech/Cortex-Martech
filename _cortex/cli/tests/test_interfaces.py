"""Regressões da extensão opcional e do protocolo de gravação."""
import copy
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

CLI = Path(__file__).resolve().parents[1]
ROOT = CLI.parents[1]
sys.path.insert(0, str(CLI))
from lib import interfaces as I, build, config, ctx, fs, render, checks, catalog
EXEMPLO = ROOT/'_cortex/onboarding/exemplos/servicos-b2b-consultoria.yaml'

def config_base():
    """Config da instância; na distribuição sem config, o exemplo de onboarding."""
    cfg = config.carregar(ROOT)
    if cfg is None:
        from lib import yamlmini
        cfg = yamlmini.load(EXEMPLO.read_text(encoding='utf-8'))
    return cfg

class RegistryTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup)
        self.base=Path(self.tmp.name);self.root=self.base/'Cortex';self.root.mkdir()
        (self.base/'source.md').write_text('METHOD MUST NOT ENTER QUERY')
        (self.base/'context.md').write_text('PRIVATE CONTENT MUST NOT ENTER QUERY')
        self.cfg={'interfaces':{'ativo':True,'raiz':'..','manifesto':'registry.json'}}
        self.data={'versao':1,'componentes':{'a':{'nome':'Contexto','arquivo':'context.md','quando':'ao escrever'},'b':{'nome':'Outro','arquivo':'context.md','quando':'outro caso'}},'perfis':{'texto':{'componentes':['a']},'outro':{'componentes':['b']}},'skills':[self.skill('propria:redacao')]}
        self.save()
    def skill(self, id):
        return dict(id=id,nome='redacao',escopo='propria',perfil='texto',fonte='source.md',quando='redigir texto',entrada='briefing',saida='texto',limite='não publicar',relacoes=[])
    def save(self): (self.base/'registry.json').write_text(json.dumps(self.data))
    def load(self): self.save();return I.carregar(self.root,self.cfg)
    def test_old_config_and_disabled(self):
        self.assertIsNone(I.carregar(self.root,{}));self.assertIsNone(I.carregar(self.root,{'interfaces':{'ativo':False}}))
        self.assertEqual(I.resumo(self.root,{}),{'ativo':False})
    def test_valid_registry_and_selective_query(self):
        r=self.load()
        with patch.object(Path,'read_bytes',side_effect=AssertionError('unexpected read')),patch.object(Path,'read_text',side_effect=AssertionError('unexpected read')):
            shown=I.mostrar(r,'redacao');I.listar(r);I.indice(r)
        self.assertEqual(set(shown['componentes']),{'a'})
        self.assertNotIn('PRIVATE CONTENT',json.dumps(shown))
        self.assertEqual(I.verificar(r),[])
    def test_ambiguous_name_needs_id(self):
        self.data['skills'].append(self.skill('cortex:redacao'));r=self.load()
        with self.assertRaisesRegex(I.InterfaceError,'ambíguo'): I.mostrar(r,'redacao')
        self.assertEqual(I.mostrar(r,'cortex:redacao')['contrato']['id'],'cortex:redacao')
    def test_unknown_and_unconfigured(self):
        for registry in (None,self.load()):
            with self.assertRaises(I.InterfaceError): I.mostrar(registry,'missing')
    def test_duplicate_and_unknown_profile(self):
        original=copy.deepcopy(self.data)
        for change in ('duplicate','profile'):
            self.data=copy.deepcopy(original)
            if change=='duplicate': self.data['skills'].append(self.skill('propria:redacao'))
            else:self.data['skills'][0]['perfil']='missing'
            with self.assertRaises(I.InterfaceError):self.load()
    def test_malformed_fields(self):
        original=copy.deepcopy(self.data)
        for key,value in [('id',''),('nome',None),('escopo','unknown'),('relacoes',{}),('fonte',1)]:
            self.data=copy.deepcopy(original);self.data['skills'][0][key]=value
            with self.subTest(key=key),self.assertRaises(I.InterfaceError):self.load()
    def test_bad_components_and_edges(self):
        original=copy.deepcopy(self.data)
        for mutate in [lambda d:d['perfis']['texto'].update(componentes=[{}]),lambda d:d['skills'][0].update(relacoes=[{'skill':{}}]),lambda d:d['skills'][0].update(relacoes=[{'skill':'missing'}]),lambda d:d['skills'][0].update(relacoes=[{'skill':'propria:redacao','quando':'x','entregar':'x'}])]:
            self.data=copy.deepcopy(original);mutate(self.data)
            with self.assertRaises(I.InterfaceError):self.load()
    def test_relationship_cycle_not_expanded(self):
        self.data['skills'].append(self.skill('cortex:redacao'))
        for a,b in [(0,1),(1,0)]:self.data['skills'][a]['relacoes']=[dict(skill=self.data['skills'][b]['id'],quando='outra etapa',entregar='saída')]
        shown=I.mostrar(self.load(),'propria:redacao');self.assertEqual(len(shown['contrato']['relacoes']),1)
    def test_bad_json_version_and_config(self):
        for raw in ('broken','[]','{"versao":2}'):
            (self.base/'registry.json').write_text(raw)
            with self.assertRaises(I.InterfaceError):I.carregar(self.root,self.cfg)
        for options in ('x',{'ativo':'yes'},{'ativo':True,'raiz':'/tmp','manifesto':'x'}):
            with self.assertRaises(I.InterfaceError):I.carregar(self.root,{'interfaces':options})
    def test_missing_source_and_component(self):
        r=self.load();(self.base/'source.md').unlink();(self.base/'context.md').unlink()
        self.assertEqual(len(I.verificar(r)),3)
    def test_path_escape_and_absolute(self):
        for path in ('../outside.md','/etc/hosts','~/private'):
            self.data['skills'][0]['fonte']=path
            with self.assertRaises(I.InterfaceError):self.load()
    def test_symlink_escape(self):
        (self.base/'escape').symlink_to(self.base.parent)
        self.data['componentes']['a']['arquivo']='escape/outside'
        with self.assertRaises(I.InterfaceError):self.load()
    def test_global_is_metadata_only(self):
        s=self.data['skills'][0];s['escopo']='global';s['fonte']='skill://ambiente/redacao'
        self.assertEqual(I.verificar(self.load()),[])
    def test_pagination_and_filters_at_scale(self):
        self.data['skills']=[self.skill('propria:item-%04d'%n) for n in range(2500)]
        self.data['skills'][42].update(perfil='outro',quando='imagem')
        r=self.load();page=I.listar(r,offset=20)
        self.assertEqual(page['total'],2500);self.assertEqual(len(page['itens']),20)
        self.assertEqual(page['itens'][0]['id'],'propria:item-0020')
        self.assertEqual(I.listar(r,profile='outro',query='IMAGEM',scope='propria')['total'],1)
        self.assertEqual(I.listar(r,offset=2600)['itens'],[])
        for offset,limit in ((-1,20),(0,0),(0,201)):
            with self.assertRaises(I.InterfaceError):I.listar(r,offset=offset,limit=limit)
    def test_relocation_and_deterministic_index(self):
        first=I.indice(self.load());secondbase=self.base/'moved';shutil.copytree(self.root,secondbase/'Cortex')
        for name in ('registry.json','source.md','context.md'):shutil.copy2(self.base/name,secondbase/name)
        second=I.indice(I.carregar(secondbase/'Cortex',self.cfg));self.assertEqual(first,second)
        self.assertNotIn(str(self.base),json.dumps(second))
    def test_build_invalid_does_not_write(self):
        (self.base/'source.md').unlink()
        with self.assertRaises(build.BuildError):build.executar(self.root,self.cfg,only='interfaces',log=lambda x:None)
        self.assertEqual(list(self.root.iterdir()),[])
    def test_index_build_idempotence_and_doctor_drift(self):
        changed,removed,_=build.executar(self.root,self.cfg,only='interfaces',log=lambda x:None)
        self.assertEqual(changed,[I.INDEX]);self.assertEqual(removed,[])
        self.assertEqual(build.executar(self.root,self.cfg,only='interfaces',log=lambda x:None)[0],[])
        self.assertEqual(checks.rodar(self.root,self.cfg,quais={14}),[])
        self.data['skills'][0]['saida']='revisão';self.save()
        findings=checks.rodar(self.root,self.cfg,quais={14});self.assertEqual(findings[0].sev,'AVISO')
    def test_only_declared_external_link_is_allowed(self):
        config.gravar(self.root,self.cfg)
        text="---\ntipo: doc\nid: teste\n---\n# Teste\n`../registry.json` e `../source.md`\n"
        findings=checks.check_links(self.root,[catalog.Doc('teste.md',text)])
        self.assertEqual(len(findings),1)
        self.assertIn('../source.md',findings[0].msg)
    def test_invalid_registry_becomes_doctor_error(self):
        self.data['skills'][0]['relacoes']=[{'skill':'missing'}];self.save()
        findings=checks.rodar(self.root,self.cfg,quais={14})
        self.assertEqual(findings[0].sev,'ERRO')
    def test_failed_encoding_leaves_no_temporary_file(self):
        with self.assertRaises(UnicodeError):fs.gravar(self.root,'file',chr(0xd800))
        self.assertEqual(list(self.root.iterdir()),[])
    def test_atomic_write_preserves_previous_on_failure(self):
        p=self.root/'file';p.write_text('original');p.chmod(0o600)
        with patch('lib.fs.os.replace',side_effect=OSError('interrupted')):
            with self.assertRaises(OSError):fs.gravar(self.root,'file','changed')
        self.assertEqual(p.read_text(),'original');self.assertEqual(list(self.root.iterdir()),[p])
        self.assertTrue(fs.gravar(self.root,'file','changed'));self.assertEqual(p.stat().st_mode&0o777,0o600)
        self.assertFalse(fs.gravar(self.root,'file','changed'))

class TemplateTests(unittest.TestCase):
    def test_legacy_and_adaptive_rendering(self):
        cfg=config_base();cfg.pop('interfaces',None)
        for organization,mode in [('Organização Alfa','sempre'),('Escola Beta','sob-demanda')]:
            cfg['organizacao']['nome']=organization;cfg['sessao']['declaracao_leituras']=mode
            c=ctx.montar(ROOT,cfg)
            for name in ('AGENTS','ROTAS','boot','ABERTURA-SESSAO','CLAUDE'):
                source=(ROOT/'_cortex/templates'/f'{name}.md.tpl').read_text()
                out,missing=render.render(source,c,cfg)
                self.assertEqual(missing,[]);self.assertNotIn('{{',out)
                self.assertNotIn('Contratos entre skills',out)
                if name=='AGENTS':
                    self.assertIn(organization,out)
                    self.assertEqual('A declaração de leituras é sob demanda' in out,mode=='sob-demanda')
    def test_fresh_project_without_extension_builds_twice(self):
        with tempfile.TemporaryDirectory() as temp:
            root=Path(temp)
            shutil.copytree(ROOT/'_cortex',root/'_cortex',ignore=shutil.ignore_patterns('.build','__pycache__','tests'))
            from lib import yamlmini
            cfg=yamlmini.load(EXEMPLO.read_text(encoding='utf-8'))
            config.gravar(root,cfg)
            changed,_,_=build.executar(root,cfg,log=lambda x:None)
            self.assertTrue(changed)
            self.assertEqual(build.executar(root,config.carregar(root),log=lambda x:None)[0],[])
            self.assertFalse((root/I.INDEX).exists())
            self.assertIn(cfg['organizacao']['nome'],(root/'AGENTS.md').read_text())
    def test_schema_old_and_new_config(self):
        cfg=config_base();schema=config.carregar_schema(ROOT)
        self.assertEqual(config.validar(cfg,schema),[])
        cfg.pop('interfaces',None);cfg['sessao'].pop('declaracao_leituras',None)
        self.assertEqual(config.validar(cfg,schema),[])
        cfg['sessao']['declaracao_leituras']='unknown';self.assertTrue(config.validar(cfg,schema))

class NomenclaturaTests(unittest.TestCase):
    def test_sufixo_numerico_so_e_copia_com_irmao(self):
        from types import SimpleNamespace as NS
        with tempfile.TemporaryDirectory() as temp:
            root=Path(temp);(root/'contexto/publicos').mkdir(parents=True)
            for n in ('mulher-30-45.md','persona.md','persona-1.md'):(root/'contexto/publicos'/n).write_text('x')
            docs=[NS(caminho='contexto/publicos/'+n,isento=False) for n in ('mulher-30-45.md','persona.md','persona-1.md')]
            achados={a.arquivo for a in checks.check_nomenclatura(root,docs)}
            self.assertEqual(achados,{'contexto/publicos/persona-1.md'})

if __name__=='__main__':unittest.main()
