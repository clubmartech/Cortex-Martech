#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cortex.py — CLI do Cortex (somente stdlib).

Uso: python3 _cortex/cli/cortex.py <comando> [opções]
  checkup [--json]                     (pré-onboarding: máquina, ferramentas, materiais)
  doctor [--quick] [--fix] [--json] [caminho...]
  build [--first-run] [--only rotas|catalogo|wrappers|contexto|boot|interfaces]
  interfaces list|show|check [id] [--query texto] [--profile perfil] [--scope escopo] [--json]
  init [--answers x.yaml] [--rapido]
  lint --file <a.md> [--stdin]
  new skill|sub-skill|agent|doc --time <slug> --id <id> [--familia F] [--canal c] [--owner p]
  pack list | suggest | install <id> [--time s] | diff <id>
  log-use <agent|skill> <id>
  config get <caminho>
A raiz é descoberta subindo até achar `_cortex/` (ou pela env CORTEX_ROOT).
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

sys.dont_write_bytecode = True  # a base mora no Google Drive: __pycache__ viraria arquivo sincronizado em toda máquina
sys.path.insert(0, str(Path(__file__).resolve().parent))
from lib import build as _build, catalog, checks, checkup as _checkup, config as _cfg, ctx as _ctx, fm, fs, packs, render, routes as _routes, scope, telemetry, yamlmini, interfaces  # noqa: E402

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8")
    except Exception:
        pass

LAST_DOCTOR = "_cortex/.build/last-doctor.json"


def raiz():
    r = scope.descobrir_raiz(Path(__file__).resolve().parent)
    if r is None:
        print("raiz do Cortex não encontrada: rode dentro da pasta que contém `_cortex/` ou defina CORTEX_ROOT.")
        sys.exit(2)
    return r


def _rel(root, caminho):
    p = Path(caminho)
    if not p.is_absolute():
        p = Path.cwd() / p
    try:
        return os.path.relpath(p.resolve(), root).replace("\\", "/")
    except ValueError:
        return str(caminho).replace("\\", "/")


# ---------------------------------------------------------------- doctor

def imprimir_achados(ach, root=None):
    por = {"ERRO": [], "AVISO": [], "INFO": []}
    for a in ach:
        por.setdefault(a.sev, []).append(a)
    for sev in ("ERRO", "AVISO", "INFO"):
        itens = por.get(sev) or []
        if not itens:
            continue
        print("%s (%d)" % (sev, len(itens)))
        for a in itens:
            print("  [%2d] %s — %s" % (a.check, a.arquivo, a.msg))
    if not ach:
        print("✓ nenhum achado.")


def cmd_doctor(args):
    root = raiz()
    t0 = time.time()
    cfg = _cfg.carregar(root)
    quais = {1, 2, 4, 9} if args.quick else None
    caminhos = [_rel(root, c) for c in args.caminhos] if args.caminhos else None
    plano = None
    if not args.quick and cfg is not None and not caminhos:
        try:
            plano = _build.plano_gerados(root, cfg)
        except Exception as e:  # template ausente etc. — o drift vira aviso
            plano = None
            print("! não foi possível simular o build para o check de drift: %s" % e, file=sys.stderr if args.json else sys.stdout)
    ach = checks.rodar(root, cfg, quais, caminhos, plano=plano)
    corrigidos = []
    if args.fix:
        for a in ach:
            if a.fix:
                try:
                    r = a.fix(root)
                    if r:
                        corrigidos.append(r)
                except Exception as e:
                    print("! fix falhou em %s: %s" % (a.arquivo, e))
        if corrigidos:
            print("Correções aplicadas (%d):" % len(corrigidos))
            for c in corrigidos:
                print("  ✎ " + c)
            ach = checks.rodar(root, cfg, quais, caminhos, plano=plano)
    dur = time.time() - t0
    if args.json:
        print(json.dumps({"achados": [a._asdict() | {"fix": bool(a.fix)} for a in ach], "segundos": round(dur, 2)}, ensure_ascii=False, indent=1))
    else:
        imprimir_achados(ach, root)
        print("doctor%s: %d erro(s), %d aviso(s), %d info — %.2fs" % (
            " --quick" if args.quick else "", sum(a.sev == "ERRO" for a in ach),
            sum(a.sev == "AVISO" for a in ach), sum(a.sev == "INFO" for a in ach), dur))
    try:
        catalog.gravar_json(root, LAST_DOCTOR, {
            "quando": time.strftime("%Y-%m-%d %H:%M:%S"), "quick": bool(args.quick), "segundos": round(dur, 2),
            "erros": sum(a.sev == "ERRO" for a in ach), "avisos": sum(a.sev == "AVISO" for a in ach),
            "achados": [{"sev": a.sev, "arquivo": a.arquivo, "msg": a.msg, "check": a.check} for a in ach],
        })
    except Exception:
        pass
    return 1 if any(a.sev == "ERRO" for a in ach) else 0


# ---------------------------------------------------------------- build

def cmd_build(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    if cfg is None:
        print("config ausente: rode /cortex-init (ou `cortex init --answers <arquivo.yaml>`) antes do build.")
        return 1
    try:
        _build.executar(root, cfg, first_run=args.first_run, only=args.only)
    except (_build.BuildError, packs.PackError, render.TemplateError, interfaces.InterfaceError) as e:
        print("build falhou: %s" % e)
        return 1
    return 0


# ---------------------------------------------------------------- init

def cmd_init(args):
    root = raiz()
    if not args.answers:
        print("O questionário interativo é conduzido pela IA: no Claude Code use a skill `/cortex-init`;")
        print("em outra IA, siga `_cortex/onboarding/questionario.md` bloco a bloco e grave as respostas em")
        print("`cortex.config.yaml` (schema: `_cortex/onboarding/schema/cortex.config.schema.json`).")
        print("Com um arquivo de respostas pronto: python3 _cortex/cli/cortex.py init --answers <arquivo.yaml>")
        print("Exemplos: _cortex/onboarding/exemplos/*.yaml")
        return 0
    p = Path(args.answers)
    if not p.is_absolute():
        p = Path.cwd() / p
    if not p.exists():
        print("arquivo de respostas não encontrado: %s" % args.answers)
        return 1
    texto = p.read_text(encoding="utf-8-sig").replace("\r\n", "\n")
    try:
        cfg = yamlmini.load(texto)
    except yamlmini.YamlError as e:
        print("YAML inválido em %s: %s" % (args.answers, e))
        return 1
    erros = _cfg.validar(cfg, _cfg.carregar_schema(root)) + _cfg.validar_referencias(cfg)
    if erros:
        print("respostas inválidas (%d):" % len(erros))
        for e in erros:
            print("  ✗ " + e)
        return 1
    if fs.gravar(root, _cfg.ARQUIVO, texto):
        print("✎ cortex.config.yaml gravado.")
    else:
        print("cortex.config.yaml já estava igual.")
    print("build --first-run:")
    try:
        _build.executar(root, cfg, first_run=True)
    except (_build.BuildError, packs.PackError, render.TemplateError, interfaces.InterfaceError) as e:
        print("build falhou: %s" % e)
        return 1
    sug = _routes.sugeridos(root, _cfg.carregar(root) or cfg)
    if sug:
        print("packs sugeridos pelo contexto (não instalados): %s — `pack install <id> --time <slug>`"
              % ", ".join(s["id"] for s in sug))
    print("doctor%s:" % (" --quick" if args.rapido else ""))
    ns = argparse.Namespace(quick=args.rapido, fix=False, json=False, caminhos=[])
    return cmd_doctor(ns)


# ---------------------------------------------------------------- checkup

def cmd_checkup(args):
    root = raiz()
    rel = _checkup.executar(root)
    if args.json:
        print(json.dumps(rel, ensure_ascii=False, indent=2))
    else:
        print(_checkup.resumo(rel))
    return 0


# ---------------------------------------------------------------- lint

LINT_CHECKS = {3, 4, 5, 7, 9, 10, 11, 12, 13}


def lint_conteudo(root, cfg, relp, conteudo):
    """Achados dos checks 3,4,5,7,9,10 para um arquivo (conteúdo proposto)."""
    doc = catalog.Doc(relp, conteudo)
    return checks.rodar(root, cfg, LINT_CHECKS, [relp], docs_extra=[doc])


def cmd_lint(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    relp = _rel(root, args.file)
    if args.stdin:
        conteudo = sys.stdin.read()
    else:
        conteudo = fs.ler(root, relp)
        if conteudo is None:
            print("arquivo não encontrado: %s" % relp)
            return 1
    ach = lint_conteudo(root, cfg, relp, conteudo)
    for a in ach:
        print("%s [%d] %s" % (a.sev, a.check, a.msg))
    erros = sum(a.sev == "ERRO" for a in ach)
    print("lint %s: %d erro(s), %d aviso(s)" % (relp, erros, sum(a.sev == "AVISO" for a in ach)))
    return 1 if erros else 0


# ---------------------------------------------------------------- new

def cmd_new(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    if cfg is None:
        print("config ausente: rode /cortex-init antes.")
        return 1
    tipo = args.tipo
    times = [t.get("slug") for t in cfg.get("times") or []]
    if args.time not in times:
        print("time `%s` não existe no config (times: %s)" % (args.time, ", ".join(times)))
        return 1
    id_ = render.slugify(args.id)
    if fm.id_esperado(id_ + ".md") != id_:
        print("id `%s` não segue a regra §2.1 (use kebab-case sem prefixo skill-)" % id_)
        return 1
    pasta = {"skill": "skills", "sub-skill": "skills", "agent": "agents", "doc": "docs"}[tipo]
    nome = id_ + (".agent.md" if tipo == "agent" else ".md")
    dest = "times/%s/%s/%s" % (args.time, pasta, nome)
    if fs.existe(root, dest):
        print("já existe: %s" % dest)
        return 1
    docs = catalog.varrer(root)
    if any(d.id == id_ for d in docs):
        print("id `%s` já existe na base" % id_)
        return 1
    tpl_nome = {"skill": "skill.md.tpl", "sub-skill": "skill.md.tpl", "agent": "agent.md.tpl", "doc": "doc.md.tpl"}[tipo]
    tpl = fs.ler(root, "_cortex/templates/" + tpl_nome)
    if tpl is None:
        print("template ausente: _cortex/templates/" + tpl_nome)
        return 1
    time_item = next(t for t in cfg["times"] if t.get("slug") == args.time)
    owner = args.owner or (time_item.get("papeis") or ["cortex"])[0]
    if owner not in [p.get("slug") for p in cfg.get("papeis") or []]:
        print("owner `%s` não é papel do config" % owner)
        return 1
    contexto = _ctx.montar(root, cfg, docs)
    contexto.update({"time": time_item, "novo": {
        "id": id_, "tipo": tipo, "familia": args.familia or "", "canal": args.canal or "",
        "owner": owner, "time": args.time, "produto": args.produto or "todos",
    }})
    out, falt = render.render(tpl, contexto, cfg)
    fs.gravar(root, dest, out)
    print("✎ criado: %s" % dest)
    ach = lint_conteudo(root, cfg, dest, out)
    for a in ach:
        if a.sev == "ERRO":
            print("  ! %s" % a.msg)
    print("Próximo passo: preencha os `[PENDENTE: …]`, declare `requires`, e rode `python3 _cortex/cli/cortex.py build`.")
    return 0


# ---------------------------------------------------------------- pack

def cmd_pack(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    if args.acao == "suggest":
        if cfg is None:
            print("config ausente: rode /cortex-init antes.")
            return 1
        sug = _routes.sugeridos(root, cfg)
        if not sug:
            print("nenhum pack novo sugerido para este config.")
        for s in sug:
            print("%-10s %s — condição `%s` · time padrão `%s` · instale com: python3 _cortex/cli/cortex.py pack install %s --time <slug>"
                  % (s["id"], s["nome"], s["condicao"], s["time_padrao"], s["id"]))
        return 0
    if args.acao == "list":
        for p in packs.listar(root, cfg):
            marca = "✓ instalado em %s" % p["time"] if p["instalado"] else "disponível"
            if p.get("ausente"):
                marca = "✗ no config, mas ausente em _cortex/packs/"
            print("%-14s v%-5s %s — %s" % (p["id"], p["versao"], marca, p["descricao"][:90]))
        if not packs.listar(root, cfg):
            print("nenhum pack em _cortex/packs/")
        return 0
    if cfg is None:
        print("config ausente: rode /cortex-init antes.")
        return 1
    try:
        if args.acao == "install":
            r = packs.instalar(root, cfg, args.id, args.time)
            for c in r["criados"]:
                print("  ✎ " + c)
            for c in r["existentes"]:
                print("  = " + c + " (já existia; não sobrescrito)")
            for c in r["faltando"]:
                print("  ! template ausente no pack: " + c)
            print("pack `%s` instalado em times/%s · sub-famílias ativas: %s" % (
                r["pack"], r["time"], ", ".join(r["subfamilias_ativas"]) or "nenhuma"))
            print("Rode `python3 _cortex/cli/cortex.py build` para atualizar ROTAS/CATALOGO/wrappers.")
            return 0
        if args.acao == "diff":
            r = packs.diff(root, cfg, args.id, args.time)
            for c in r["divergentes"]:
                print("  ≠ " + c)
            for c in r["ausentes"]:
                print("  − " + c + " (não instalado)")
            for c in r["faltando"]:
                print("  ! template ausente no pack: " + c)
            print("pack `%s` (times/%s): %d igual(is), %d divergente(s), %d ausente(s)" % (
                r["pack"], r["time"], len(r["iguais"]), len(r["divergentes"]), len(r["ausentes"])))
            return 1 if r["divergentes"] else 0
    except packs.PackError as e:
        print("pack: %s" % e)
        return 1
    return 0


# ---------------------------------------------------------------- log-use / config

def cmd_log_use(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    telemetry.log_use(root, cfg, args.tipo, args.id)
    return 0


def cmd_config(args):
    root = raiz()
    cfg = _cfg.carregar(root)
    if cfg is None:
        print("")
        return 1
    v = _cfg.caminho(cfg, args.caminho)
    if v is None:
        return 1
    print(v if isinstance(v, str) else json.dumps(v, ensure_ascii=False))
    return 0


# ---------------------------------------------------------------- main

def cmd_interfaces(args):
    root = raiz()
    try:
        registry = interfaces.carregar(root, _cfg.carregar(root))
        if args.acao == "check":
            errors = interfaces.verificar(registry)
            result = {"ativo": registry is not None, "contratos": len(registry["byid"]) if registry else 0, "erros": errors}
        elif args.acao == "show":
            result = interfaces.mostrar(registry, args.id)
            errors = []
        else:
            result = interfaces.listar(registry, args.query, args.profile, args.scope, args.offset, args.limit)
            errors = []
        if args.json or args.acao == "show":
            print(json.dumps(result, ensure_ascii=False, indent=2))
        elif args.acao == "check":
            print("Interfaces: %d contratos, %d erro(s)%s." % (result["contratos"], len(errors), "" if registry else " — integração não configurada"))
            for error in errors: print("  ! " + error)
        else:
            print("%d contrato(s); página a partir de %d." % (result["total"], result["offset"]))
            for item in result["itens"]: print("%s [%s] — %s" % (item["id"], item["perfil"], item["quando"]))
        return 1 if errors else 0
    except interfaces.InterfaceError as e:
        if args.json: print(json.dumps({"erro": str(e)}, ensure_ascii=False))
        else: print(str(e))
        return 1


def main(argv=None):
    ap = argparse.ArgumentParser(prog="cortex", description="CLI do Cortex — documentação-para-IA.")
    sub = ap.add_subparsers(dest="cmd")

    ck = sub.add_parser("checkup", help="pré-onboarding: analisa máquina, ferramentas e materiais e sugere respostas")
    ck.add_argument("--json", action="store_true")
    ck.set_defaults(fn=cmd_checkup)

    d = sub.add_parser("doctor", help="auditoria da base (15 checks; o 15 só com o pack visual)")
    d.add_argument("--quick", action="store_true", help="só checks 1, 2, 4 e 9 (≤1 s)")
    d.add_argument("--fix", action="store_true", help="aplica as correções automáticas disponíveis")
    d.add_argument("--json", action="store_true")
    d.add_argument("caminhos", nargs="*")
    d.set_defaults(fn=cmd_doctor)

    b = sub.add_parser("build", help="regera contexto inicial, catálogo, ROTAS/AGENTS/CLAUDE/CATALOGO/boot e wrappers")
    b.add_argument("--first-run", action="store_true")
    b.add_argument("--only", choices=sorted(_build.ONLY))
    b.set_defaults(fn=cmd_build)

    i = sub.add_parser("init", help="onboarding: grava o config a partir de respostas e roda build + doctor")
    i.add_argument("--answers")
    i.add_argument("--rapido", action="store_true", help="doctor --quick no fim")
    i.set_defaults(fn=cmd_init)

    l = sub.add_parser("lint", help="checks 3,4,5,7,9,10 num único arquivo")
    l.add_argument("--file", required=True)
    l.add_argument("--stdin", action="store_true", help="conteúdo vem do stdin")
    l.set_defaults(fn=cmd_lint)

    n = sub.add_parser("new", help="cria skill | sub-skill | agent | doc num time")
    n.add_argument("tipo", choices=["skill", "sub-skill", "agent", "doc"])
    n.add_argument("--time", required=True)
    n.add_argument("--id", required=True)
    n.add_argument("--familia")
    n.add_argument("--canal")
    n.add_argument("--owner")
    n.add_argument("--produto")
    n.set_defaults(fn=cmd_new)

    p = sub.add_parser("pack", help="list | suggest | install <id> [--time s] | diff <id>")
    p.add_argument("acao", choices=["list", "suggest", "install", "diff"])
    p.add_argument("id", nargs="?")
    p.add_argument("--time")
    p.set_defaults(fn=cmd_pack)

    lu = sub.add_parser("log-use", help="registra uso de agent/skill (telemetria opcional)")
    lu.add_argument("tipo", choices=["agent", "skill"])
    lu.add_argument("id")
    lu.set_defaults(fn=cmd_log_use)

    c = sub.add_parser("config", help="get <caminho.no.config>")
    c.add_argument("acao", choices=["get"])
    c.add_argument("caminho")
    c.set_defaults(fn=cmd_config)

    it = sub.add_parser("interfaces", help="consulta contratos e componentes sob demanda, sem abrir todas as skills")
    it.add_argument("acao", choices=["list", "show", "check"])
    it.add_argument("id", nargs="?")
    it.add_argument("--query", default="")
    it.add_argument("--profile")
    it.add_argument("--scope")
    it.add_argument("--offset", type=int, default=0)
    it.add_argument("--limit", type=int, default=20)
    it.add_argument("--json", action="store_true")
    it.set_defaults(fn=cmd_interfaces)

    args = ap.parse_args(argv)
    if not args.cmd:
        ap.print_help()
        return 0
    if args.cmd == "pack" and args.acao in ("install", "diff") and not args.id:
        ap.error("pack %s exige o <id>" % args.acao)
    if args.cmd == "interfaces" and args.acao == "show" and not args.id:
        ap.error("interfaces show exige id ou nome sem ambiguidade")
    try:
        return args.fn(args)
    except fs.ForaDaRaiz as e:
        print(str(e))
        return 2


if __name__ == "__main__":
    sys.exit(main())
