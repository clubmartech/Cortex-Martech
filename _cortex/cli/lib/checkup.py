# -*- coding: utf-8 -*-
"""Checkup pré-onboarding: analisa máquina, ferramentas e materiais existentes na pasta
para pré-preencher o questionário (`_cortex/onboarding/questionario.md`).

Só lê. Não grava fora de `_cortex/.build/checkup.json`. Nunca lê valores de variáveis de
ambiente nem conteúdo de arquivos de credencial — apenas NOMES (de variáveis, de servidores MCP).
"""
import json
import os
import platform
import re
import shutil
import subprocess
import sys
from collections import Counter
from pathlib import Path

from . import scope, fs

# ---------------------------------------------------------------- tabelas

# padrão no NOME da variável de ambiente ou do servidor MCP -> (slug, tipo, nome)
FERRAMENTAS = [
    (r"clickup", ("clickup", "registro", "ClickUp")),
    (r"notion", ("notion", "registro", "Notion")),
    (r"jira|atlassian", ("jira", "registro", "Jira")),
    (r"asana", ("asana", "registro", "Asana")),
    (r"trello", ("trello", "registro", "Trello")),
    (r"monday", ("monday", "registro", "monday.com")),
    (r"linear", ("linear", "registro", "Linear")),
    (r"supabase", ("supabase", "dados", "Supabase")),
    (r"bigquery|bq_", ("bigquery", "dados", "BigQuery")),
    (r"postgres|pg_|database_url", ("postgres", "dados", "Postgres")),
    (r"snowflake", ("snowflake", "dados", "Snowflake")),
    (r"ga4|google_analytics|analytics", ("ga4", "analytics", "Google Analytics")),
    (r"metabase", ("metabase", "analytics", "Metabase")),
    (r"hubspot", ("hubspot", "crm", "HubSpot")),
    (r"salesforce|sfdc", ("salesforce", "crm", "Salesforce")),
    (r"pipedrive", ("pipedrive", "crm", "Pipedrive")),
    (r"rd_|rdstation|rd-station|rd-crm", ("rd-station", "automacao-mkt", "RD Station")),
    (r"mailchimp", ("mailchimp", "automacao-mkt", "Mailchimp")),
    (r"activecampaign", ("activecampaign", "automacao-mkt", "ActiveCampaign")),
    (r"meta_|facebook|instagram", ("meta-business", "automacao-mkt", "Meta Business")),
    (r"n8n", ("n8n", "automacao", "n8n")),
    (r"zapier", ("zapier", "automacao", "Zapier")),
    (r"make\.com|integromat", ("make", "automacao", "Make")),
    (r"figma", ("figma", "design", "Figma")),
    (r"canva", ("canva", "design", "Canva")),
    (r"slack", ("slack", "chat", "Slack")),
    (r"teams|microsoft|graph|sharepoint|outlook", ("microsoft-365", "chat", "Microsoft 365 / Teams")),
    (r"google_workspace|gdrive|google_drive|gmail", ("google-workspace", "outro", "Google Workspace")),
    (r"whatsapp|evolution|twilio|z-api|zapi", ("whatsapp-api", "outro", "WhatsApp (API)")),
    (r"shopify|vtex|woocommerce|magento", ("ecommerce", "outro", "Plataforma de e-commerce")),
    (r"github|gitlab|bitbucket", ("git", "repositorio", "Git (hospedado)")),
]

# palavras no NOME de arquivos existentes -> bloco do questionário / pack que elas alimentam
MATERIAIS = [
    (r"brand|marca|identidade|logo|tom.?de.?voz|manual.?da.?marca", "B2 marcas e tom"),
    (r"persona|icp|publico|público|audiencia|audiência|cliente.?ideal", "B4 públicos"),
    (r"produto|product|portfolio|portfólio|catalogo|catálogo|release|roadmap|funcionalidade", "B3 oferta / pack produto"),
    (r"playbook|script|objec|objeç|proposta|pitch|prospec|cadencia|cadência|pipeline", "pack vendas"),
    (r"evento|summit|congresso|feira|webinar|palestra|ingresso|patroc", "pack eventos"),
    (r"metrica|métrica|dicionario|dicionário|schema|funil|dashboard|relatorio|relatório|kpi", "pack dados"),
    (r"ajuda|faq|suporte|onboarding|churn|nps|csat|sucesso.?do.?cliente|atendimento", "pack cs"),
    (r"campanha|briefing|email|e-mail|linkedin|instagram|newsletter|landing|anuncio|anúncio", "pack marketing"),
    (r"agents\.md|claude\.md|\.cursorrules|copilot-instructions|gemini\.md", "instruções de IA pré-existentes"),
]

PT = {"de", "que", "para", "com", "não", "uma", "como", "mais", "dos", "das", "pela", "você"}
EN = {"the", "and", "with", "that", "for", "this", "from", "your", "are", "not", "have", "which"}
ES = {"que", "para", "con", "una", "los", "las", "por", "del", "como", "más", "usted"}

TEXTO_EXT = {".md", ".txt", ".docx", ".pdf", ".pptx", ".xlsx", ".csv", ".json", ".yaml", ".yml", ".html"}


# ---------------------------------------------------------------- ambiente

def _tem(cmd):
    return shutil.which(cmd) is not None


def _git_repo(root):
    try:
        r = subprocess.run(["git", "rev-parse", "--is-inside-work-tree"], cwd=str(root),
                           capture_output=True, text=True, timeout=5)
        return r.returncode == 0 and r.stdout.strip() == "true"
    except Exception:
        return False


def ambiente(root):
    p = str(root)
    sync = [s for s in ("OneDrive", "SharePoint", "Dropbox", "Google Drive", "iCloud") if s.lower() in p.lower()]
    try:
        import yaml  # noqa: F401
        pyyaml = True
    except Exception:
        pyyaml = False
    amb = []
    if (root / ".claude").is_dir() or _tem("claude"):
        amb.append("claude-code")
    if _tem("codex") or (root / "AGENTS.md").exists():
        amb.append("codex")
    if (root / ".cursorrules").exists() or (root / ".cursor").is_dir():
        amb.append("outra")
    return {
        "sistema": "%s %s" % (platform.system(), platform.release()),
        "python": platform.python_version(),
        "python_cmd": "python" if _tem("python") else ("py" if _tem("py") else ""),
        "pyyaml": pyyaml,
        "git_instalado": _tem("git"),
        "git_repositorio": _git_repo(root) if _tem("git") else False,
        "pasta_sincronizada": sync,
        "escrita_ok": os.access(str(root), os.W_OK),
        "ambientes_detectados": amb or ["claude-code"],
        "claude_code_dir": (root / ".claude").is_dir(),
        "claude_cli": _tem("claude"),
    }


# ---------------------------------------------------------------- ferramentas (só nomes)

def _mcp_nomes(root):
    nomes = []
    candidatos = [root / ".mcp.json", root / ".claude" / "settings.json", root / ".claude" / "settings.local.json",
                  Path.home() / ".claude.json", Path.home() / ".claude" / "settings.json"]
    for c in candidatos:
        try:
            if not c.exists():
                continue
            d = json.loads(c.read_text(encoding="utf-8-sig"))
        except Exception:
            continue
        for chave in ("mcpServers", "enabledMcpjsonServers"):
            v = d.get(chave)
            if isinstance(v, dict):
                nomes += list(v.keys())
            elif isinstance(v, list):
                nomes += [str(x) for x in v]
        # projetos do ~/.claude.json guardam mcpServers por pasta
        proj = d.get("projects")
        if isinstance(proj, dict):
            for pv in proj.values():
                if isinstance(pv, dict) and isinstance(pv.get("mcpServers"), dict):
                    nomes += list(pv["mcpServers"].keys())
    return sorted(set(nomes))


def ferramentas(root):
    nomes_env = [k for k in os.environ.keys()]
    nomes_mcp = _mcp_nomes(root)
    achados = {}
    for origem, nomes in (("variável de ambiente", nomes_env), ("servidor MCP", nomes_mcp)):
        for n in nomes:
            nl = n.lower()
            for padrao, (slug, tipo, nome) in FERRAMENTAS:
                if re.search(padrao, nl):
                    ent = achados.setdefault(slug, {"slug": slug, "tipo": tipo, "nome": nome, "evidencias": [], "mcp": False})
                    ent["evidencias"].append("%s `%s`" % (origem, n))
                    if origem == "servidor MCP":
                        ent["mcp"] = True
                    break
    return {"servidores_mcp": nomes_mcp, "integracoes_candidatas": sorted(achados.values(), key=lambda x: x["slug"])}


# ---------------------------------------------------------------- materiais existentes

def _idioma(amostras):
    c = Counter()
    for t in amostras:
        for w in re.findall(r"[a-záéíóúãõâêôç]+", t.lower()):
            if w in PT:
                c["pt-BR"] += 1
            if w in EN:
                c["en"] += 1
            if w in ES:
                c["es"] += 1
    if not c:
        return "pt-BR", 0
    idioma, n = c.most_common(1)[0]
    return idioma, n


def materiais(root):
    ext = Counter()
    pistas = {}
    amostras = []
    total = 0
    grandes = []
    config_anterior = (root / "cortex.config.yaml").exists()
    for dp, dn, fn in os.walk(root):
        rel = os.path.relpath(dp, root).replace("\\", "/")
        partes = [] if rel == "." else rel.split("/")
        if partes and (partes[0] in scope.EXCLUIR_DIRS or partes[0] == "_cortex"):
            dn[:] = []
            continue
        dn[:] = [d for d in dn if d not in scope.EXCLUIR_DIRS and not d.startswith(".")]
        for f in fn:
            if f.startswith("~$"):
                continue
            total += 1
            e = os.path.splitext(f)[1].lower()
            ext[e or "(sem extensão)"] += 1
            caminho = (rel + "/" if partes else "") + f
            nome = f.lower()
            for padrao, bloco in MATERIAIS:
                if re.search(padrao, nome):
                    pistas.setdefault(bloco, []).append(caminho)
            try:
                tam = os.path.getsize(os.path.join(dp, f))
            except OSError:
                tam = 0
            if tam > 2 * 1024 * 1024 and e not in TEXTO_EXT:
                grandes.append((caminho, tam // (1024 * 1024)))
            if e in (".md", ".txt") and len(amostras) < 40 and tam < 200_000:
                try:
                    amostras.append(Path(dp, f).read_text(encoding="utf-8", errors="ignore")[:4000])
                except OSError:
                    pass
    idioma, forca = _idioma(amostras)
    return {
        "total_arquivos": total,
        "por_extensao": dict(ext.most_common(12)),
        "pistas": {k: v[:8] for k, v in pistas.items()},
        "binarios_grandes": grandes[:10],
        "idioma_detectado": idioma,
        "idioma_confianca": forca,
        "config_anterior": config_anterior,
        "texto_existente": bool(amostras),
    }


# ---------------------------------------------------------------- sugestões

def sugestoes(amb, ferr, mat):
    s = {"sessao": {"idioma": mat["idioma_detectado"], "ambiente": amb["ambientes_detectados"],
                    "gate": "declarativo+hook" if "claude-code" in amb["ambientes_detectados"] else "declarativo"},
         "governanca": {"git": bool(amb["git_repositorio"]) or bool(amb["git_instalado"] and not amb["pasta_sincronizada"])},
         "integracoes": [{"slug": i["slug"], "tipo": i["tipo"], "nome": i["nome"], "mcp": i["mcp"],
                          "registro_primario": False, "somente_leitura": i["tipo"] in ("dados", "analytics")}
                         for i in ferr["integracoes_candidatas"]],
         "packs_sugeridos": ["marketing"],
         "blocos_com_material": sorted(k for k in mat["pistas"].keys())}
    tipos = {i["tipo"] for i in ferr["integracoes_candidatas"]}
    if "dados" in tipos or "analytics" in tipos or "pack dados" in mat["pistas"]:
        s["packs_sugeridos"].append("dados")
    for bloco, pack in (("pack vendas", "vendas"), ("pack eventos", "eventos"), ("pack cs", "cs"), ("B3 oferta / pack produto", "produto")):
        if bloco in mat["pistas"] and pack not in s["packs_sugeridos"]:
            s["packs_sugeridos"].append(pack)
    if "crm" in tipos and "vendas" not in s["packs_sugeridos"]:
        s["packs_sugeridos"].append("vendas")
    registros = [i for i in s["integracoes"] if i["tipo"] == "registro"]
    if len(registros) == 1:
        registros[0]["registro_primario"] = True
    return s


def alertas(amb, ferr, mat):
    a = []
    if not amb["python_cmd"]:
        a.append("Python não está no PATH: os hooks do Claude Code chamam `python`. Instale ou ajuste `.claude/settings.json`.")
    if amb["pasta_sincronizada"]:
        a.append("Pasta sincronizada por %s: arquivos gerados podem criar cópias de conflito. Prefira um repositório git ou mantenha `_cortex/.build/` fora da sincronização." % ", ".join(amb["pasta_sincronizada"]))
    if not amb["escrita_ok"]:
        a.append("Sem permissão de escrita na pasta.")
    if mat["binarios_grandes"]:
        a.append("%d binário(s) acima de 2 MB na pasta: mova para `_assets/` (fora do escopo) para não pesar a base." % len(mat["binarios_grandes"]))
    if "instruções de IA pré-existentes" in mat["pistas"] and not mat["config_anterior"]:
        a.append("Já existem instruções de IA (%s): o build do Cortex gera `AGENTS.md`/`CLAUDE.md` — leia o conteúdo atual antes e migre o que for regra da casa para `contexto/` ou para uma skill." % ", ".join(mat["pistas"]["instruções de IA pré-existentes"][:3]))
    if mat["config_anterior"]:
        a.append("Já existe `cortex.config.yaml`: o onboarding vai oferecer revisar blocos em vez de recomeçar.")
    if not amb["pyyaml"]:
        a.append("PyYAML ausente: o Cortex usa o leitor próprio (`yamlmini`); mantenha o config no subconjunto descrito em `_cortex/CONTRATOS.md` §3.")
    return a


# ---------------------------------------------------------------- execução

def executar(root):
    root = Path(root)
    amb = ambiente(root)
    ferr = ferramentas(root)
    mat = materiais(root)
    rel = {"ambiente": amb, "ferramentas": ferr, "materiais": mat,
           "sugestoes": sugestoes(amb, ferr, mat), "alertas": alertas(amb, ferr, mat)}
    fs.gravar(root, "_cortex/.build/checkup.json", json.dumps(rel, ensure_ascii=False, indent=2))
    return rel


def resumo(rel):
    amb, ferr, mat, sug = rel["ambiente"], rel["ferramentas"], rel["materiais"], rel["sugestoes"]
    linhas = ["# Checkup pré-onboarding", ""]
    linhas.append("**Máquina:** %s · Python %s (`%s`) · PyYAML %s · git %s%s · pasta %s" % (
        amb["sistema"], amb["python"], amb["python_cmd"] or "ausente", "sim" if amb["pyyaml"] else "não",
        "instalado" if amb["git_instalado"] else "ausente", " (repositório)" if amb["git_repositorio"] else "",
        ("sincronizada por " + ", ".join(amb["pasta_sincronizada"])) if amb["pasta_sincronizada"] else "local"))
    linhas.append("**Ambientes de IA detectados:** %s" % ", ".join(amb["ambientes_detectados"]))
    if ferr["servidores_mcp"]:
        linhas.append("**Servidores MCP configurados (nomes):** %s" % ", ".join(ferr["servidores_mcp"][:20]))
    if ferr["integracoes_candidatas"]:
        linhas.append("**Integrações candidatas (B6):** " + " · ".join(
            "%s (%s; %s)" % (i["nome"], i["tipo"], i["evidencias"][0]) for i in ferr["integracoes_candidatas"]))
    else:
        linhas.append("**Integrações candidatas (B6):** nenhuma detectada — perguntar no bloco B6.")
    linhas.append("**Materiais na pasta:** %d arquivo(s); idioma provável %s%s" % (
        mat["total_arquivos"], mat["idioma_detectado"], "" if mat["texto_existente"] else " (sem texto para analisar)"))
    for bloco, arqs in sorted(mat["pistas"].items()):
        linhas.append("- %s ← %s" % (bloco, ", ".join("`%s`" % a for a in arqs[:4])))
    linhas.append("**Packs sugeridos:** %s" % ", ".join(sug["packs_sugeridos"]))
    if rel["alertas"]:
        linhas.append("")
        linhas.append("**Alertas:**")
        for a in rel["alertas"]:
            linhas.append("- " + a)
    linhas.append("")
    linhas.append("Relatório completo: `_cortex/.build/checkup.json`. O `/cortex-init` usa estas sugestões para pré-preencher B0, B6, B9 e B10; confirme cada uma com a pessoa — detecção é pista, não resposta.")
    return "\n".join(linhas)
