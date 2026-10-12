"""Contratos externos sob demanda; metadados compartilhados, sem copiar memória pessoal."""
import hashlib
import json
import os
from pathlib import Path

INDEX = '_cortex/.build/interfaces-index.json'
LOCAL_SCOPES = {'propria', 'externa', 'cortex'}

class InterfaceError(ValueError):
    pass


def dentro(base, value, label):
    if not isinstance(value, str) or not value.strip():
        raise InterfaceError(label + ': caminho vazio ou inválido')
    rel = Path(value)
    if rel.is_absolute() or value.startswith('~'):
        raise InterfaceError(label + ': use caminho relativo à raiz declarada')
    target = (base / rel).resolve()
    try:
        target.relative_to(base)
    except ValueError:
        raise InterfaceError(label + ': caminho sai da raiz declarada')
    return target


def carregar(root, cfg):
    options = (cfg or {}).get('interfaces')
    if options is None:
        return None
    if not isinstance(options, dict):
        raise InterfaceError('interfaces: configuração deve ser um mapa')
    if not isinstance(options.get('ativo', True), bool):
        raise InterfaceError('interfaces.ativo deve ser booleano')
    if options.get('ativo') is False:
        return None
    relative = options.get('raiz', '.')
    if not isinstance(relative, str) or Path(relative).is_absolute() or relative.startswith('~'):
        raise InterfaceError('interfaces.raiz: use caminho relativo à raiz do Cortex')
    base = (Path(root) / relative).resolve()
    path = dentro(base, options.get('manifesto'), 'interfaces.manifesto')
    try:
        raw = path.read_bytes()
        data = json.loads(raw)
    except (OSError, ValueError) as e:
        raise InterfaceError('manifesto de interfaces indisponível ou inválido: ' + str(e))
    if not isinstance(data, dict) or data.get('versao') != 1:
        raise InterfaceError('manifesto: versão suportada = 1')
    if not isinstance(data.get('skills'), list) or not isinstance(data.get('perfis'), dict) or not isinstance(data.get('componentes'), dict):
        raise InterfaceError('manifesto: skills, perfis e componentes são obrigatórios')
    byid = {}
    for skill in data['skills']:
        if not isinstance(skill, dict):
            raise InterfaceError('manifesto: cada skill deve ser um objeto')
        for key in ('id', 'nome', 'escopo', 'perfil', 'fonte', 'quando', 'entrada', 'saida', 'limite'):
            if not isinstance(skill.get(key), str) or not skill[key].strip():
                raise InterfaceError('skill: campo obrigatório inválido: ' + key)
        if skill['escopo'] not in LOCAL_SCOPES | {'global', 'plugin'}:
            raise InterfaceError(skill['id'] + ': escopo desconhecido')
        if ':' not in skill['id']:
            raise InterfaceError(skill['id'] + ': use id qualificado (escopo:nome)')
        if skill['id'] in byid:
            raise InterfaceError('id repetido: ' + skill['id'])
        if skill['perfil'] not in data['perfis']:
            raise InterfaceError(skill['id'] + ': perfil desconhecido')
        if not isinstance(skill.get('relacoes'), list):
            raise InterfaceError(skill['id'] + ': relacoes deve ser uma lista')
        byid[skill['id']] = skill
    for key, profile in data['perfis'].items():
        if not isinstance(profile, dict) or not isinstance(profile.get('componentes'), list):
            raise InterfaceError('perfil inválido: ' + key)
        for component in profile['componentes']:
            if not isinstance(component, str) or component not in data['componentes']:
                raise InterfaceError('componente desconhecido: ' + str(component))
    for key, component in data['componentes'].items():
        if not isinstance(component, dict):
            raise InterfaceError('componente inválido: ' + key)
        for field in ('nome', 'arquivo', 'quando'):
            if not isinstance(component.get(field), str) or not component[field].strip():
                raise InterfaceError('componente ' + key + ': campo inválido ' + field)
        dentro(base, component['arquivo'], 'componente ' + key)
    for skill in byid.values():
        if skill['escopo'] in LOCAL_SCOPES:
            dentro(base, skill['fonte'], skill['id'])
        for edge in skill['relacoes']:
            if not isinstance(edge, dict) or not isinstance(edge.get('skill'), str) or edge.get('skill') not in byid:
                raise InterfaceError(skill['id'] + ': destino de relação desconhecido')
            if edge['skill'] == skill['id']:
                raise InterfaceError(skill['id'] + ': passagem para si mesma')
            if not all(isinstance(edge.get(k), str) and edge[k].strip() for k in ('quando', 'entregar')):
                raise InterfaceError(skill['id'] + ': passagem sem condição ou insumo')
    return {'root': Path(root).resolve(), 'base': base, 'path': path, 'options': options,
            'data': data, 'byid': byid, 'hash': hashlib.sha256(raw).hexdigest()}


def verificar(registry):
    if registry is None:
        return []
    errors = []
    for key, item in registry['data']['componentes'].items():
        if not dentro(registry['base'], item['arquivo'], key).is_file():
            errors.append('componente ausente: ' + item['arquivo'])
    for skill in registry['byid'].values():
        if skill['escopo'] in LOCAL_SCOPES and not dentro(registry['base'], skill['fonte'], skill['id']).is_file():
            errors.append('fonte ausente: ' + skill['id'] + ' → ' + skill['fonte'])
    return errors


def listar(registry, query='', profile=None, scope=None, offset=0, limit=20):
    if offset < 0 or not 1 <= limit <= 200:
        raise InterfaceError('offset deve ser >= 0 e limit deve ficar entre 1 e 200')
    rows = []
    for s in (registry or {}).get('byid', {}).values():
        if profile and s['perfil'] != profile: continue
        if scope and s['escopo'] != scope: continue
        if query and query.casefold() not in (' '.join(s[k] for k in ('id', 'nome', 'quando'))).casefold(): continue
        rows.append({k: s[k] for k in ('id', 'nome', 'perfil', 'escopo', 'quando')})
    rows.sort(key=lambda x: x['id'])
    return {'total': len(rows), 'offset': offset, 'limit': limit, 'itens': rows[offset:offset+limit]}


def mostrar(registry, identity):
    if registry is None:
        raise InterfaceError('interfaces não configuradas neste Cortex')
    if identity in registry['byid']:
        skill = registry['byid'][identity]
    else:
        found = [s for s in registry['byid'].values() if s['nome'] == identity or s['id'].split(':')[-1] == identity]
        if len(found) != 1:
            choices = ', '.join(sorted(s['id'] for s in found))
            raise InterfaceError('nome ambíguo; use o id completo: ' + choices if found else 'interface não encontrada: ' + identity)
        skill = found[0]
    data = registry['data'];profile = data['perfis'][skill['perfil']]
    return {'raiz': registry['options'].get('raiz', '.'), 'manifesto': registry['options']['manifesto'],
            'contrato': skill, 'componentes': {k: data['componentes'][k] for k in profile['componentes']},
            'verificacao': profile.get('verificacao', ''),
            'leitura': 'Abra apenas os componentes pertinentes. As relações são condicionais; preserve briefing e autorização já dados.'}


def indice(registry):
    if registry is None: return None
    data = registry['data']
    return {'versao': 1, 'manifesto': registry['options']['manifesto'],
            'raiz': registry['options'].get('raiz', '.'), 'sha256': registry['hash'],
            'total': len(registry['byid']),
            'perfis': {key: {'total': sum(s['perfil'] == key for s in registry['byid'].values()),
                             'componentes': p['componentes']} for key, p in sorted(data['perfis'].items())},
            'skills': [{k:s[k] for k in ('id','nome','escopo','perfil')} for s in sorted(registry['byid'].values(),key=lambda s:s['id'])]}


def resumo(root, cfg):
    registry = carregar(root, cfg)
    if registry is None: return {'ativo': False}
    return {'ativo': True, 'total': len(registry['byid']), 'perfis': len(registry['data']['perfis']),
            'manifesto': os.path.relpath(registry['path'], root).replace(os.sep, '/'),
            'index': INDEX}
