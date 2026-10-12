"""wrappers — `.claude/skills/<id>/SKILL.md` e `.claude/agents/<id>.md` gerados a partir do escopo."""
import os
from pathlib import Path

from . import fs, render

SKILLS_DIR = ".claude/skills"
AGENTS_DIR = ".claude/agents"
TPL_SKILL = "_cortex/templates/skill-wrapper.tpl"
TPL_AGENT = "_cortex/templates/agent-wrapper.tpl"


def _ctx_doc(d, base_ctx):
    c = dict(base_ctx)
    c.update({
        "id": d.id, "caminho": d.caminho, "descricao": d.fm.get("descricao") or "",
        "gatilhos": d.gatilhos, "requires": d.requires, "tipo": d.tipo,
        "familia": d.fm.get("familia") or "", "owner": d.fm.get("owner") or "",
    })
    return c


def esperados(root, docs, base_ctx, cfg):
    """{caminho_relativo: conteúdo} de todos os wrappers que deveriam existir."""
    tpl_skill = fs.ler(root, TPL_SKILL)
    tpl_agent = fs.ler(root, TPL_AGENT)
    saida = {}
    for d in docs:
        if not d.id or d.isento:
            continue
        if d.tipo in ("skill", "sub-skill") and tpl_skill:
            out, _ = render.render(tpl_skill, _ctx_doc(d, base_ctx), cfg)
            saida["%s/%s/SKILL.md" % (SKILLS_DIR, d.id)] = out
        elif d.tipo == "agent" and d.fm.get("subagente") and tpl_agent:
            out, _ = render.render(tpl_agent, _ctx_doc(d, base_ctx), cfg)
            saida["%s/%s.md" % (AGENTS_DIR, d.id)] = out
    return saida


MARCA = "gerado pelo cortex build"


def _nosso(p):
    """só é órfão removível o wrapper que traz a marca do build.
    Sem isto, instalar o Cortex num projeto que já tem `.claude/skills` apaga as skills dele."""
    try:
        return MARCA in p.read_text(encoding="utf-8", errors="replace")[:3000]
    except OSError:
        return False


def existentes(root):
    """Wrappers presentes no disco e gerados pelo build (exclui `cortex-*` e o que não tem a marca)."""
    saida = []
    base = Path(root)
    sk = base / SKILLS_DIR
    if sk.is_dir():
        for d in sk.iterdir():
            if d.is_dir() and not d.name.startswith("cortex-") and (d / "SKILL.md").exists() and _nosso(d / "SKILL.md"):
                saida.append("%s/%s/SKILL.md" % (SKILLS_DIR, d.name))
    ag = base / AGENTS_DIR
    if ag.is_dir():
        for f in ag.iterdir():
            if f.is_file() and f.suffix == ".md" and not f.name.startswith("cortex-") and _nosso(f):
                saida.append("%s/%s" % (AGENTS_DIR, f.name))
    return saida


def gerar(root, docs, base_ctx, cfg, dry_run=False):
    """Grava wrappers, remove órfãos. Devolve (alterados, removidos, hashes)."""
    esp = esperados(root, docs, base_ctx, cfg)
    alterados, removidos, hashes = [], [], {}
    for relp, conteudo in esp.items():
        if not dry_run and fs.gravar(root, relp, conteudo):
            alterados.append(relp)
        elif dry_run and fs.ler(root, relp) != conteudo:
            alterados.append(relp)
        wid = relp.split("/")[2] if relp.startswith(SKILLS_DIR) else os.path.basename(relp)[:-3]
        hashes[wid] = fs.hash_texto(conteudo)
    for relp in existentes(root):
        if relp not in esp:
            removidos.append(relp)
            if not dry_run:
                fs.remover(root, relp)
                pasta = Path(root) / os.path.dirname(relp)
                if relp.startswith(SKILLS_DIR) and pasta.is_dir() and not any(pasta.iterdir()):
                    pasta.rmdir()
    return alterados, removidos, hashes
