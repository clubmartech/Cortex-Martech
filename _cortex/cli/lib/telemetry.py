"""telemetry — registro de uso opcional (POST JSON; falha sempre silenciosa)."""
import datetime
import json
import os
import re
import urllib.request

from . import fs


def ler_env(root):
    """Lê `.env` da raiz (KEY=valor, sem exportar) + variáveis de ambiente do processo."""
    env = {}
    texto = fs.ler(root, ".env") or ""
    for linha in texto.split("\n"):
        linha = linha.strip()
        if not linha or linha.startswith("#") or "=" not in linha:
            continue
        k, _, v = linha.partition("=")
        env[k.strip()] = v.strip().strip("\"'")
    for k in ("CORTEX_TELEMETRY_URL", "CORTEX_TELEMETRY_TOKEN"):
        if os.environ.get(k):
            env[k] = os.environ[k]
    return env


def log_use(root, cfg, tipo, id_, timeout=3):
    """Envia {tipo, id, org, quando}. Devolve True se enviou; nunca levanta exceção."""
    try:
        tele = ((cfg or {}).get("governanca") or {}).get("telemetria") or {}
        if not tele.get("ativa"):
            return False
        env = ler_env(root)
        url = env.get(tele.get("destino_env") or "CORTEX_TELEMETRY_URL") or env.get("CORTEX_TELEMETRY_URL")
        if not url or not re.match(r"^https?://", url):
            return False
        corpo = json.dumps({
            "tipo": tipo, "id": id_,
            "org": ((cfg or {}).get("organizacao") or {}).get("slug") or "",
            "quando": datetime.datetime.now().isoformat(timespec="seconds"),
        }).encode("utf-8")
        req = urllib.request.Request(url, data=corpo, method="POST")
        req.add_header("Content-Type", "application/json")
        token = env.get("CORTEX_TELEMETRY_TOKEN")
        if token:
            req.add_header("Authorization", "Bearer " + token)
        with urllib.request.urlopen(req, timeout=timeout):
            pass
        return True
    except Exception:
        return False
