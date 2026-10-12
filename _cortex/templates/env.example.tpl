# Cortex · {{organizacao.nome}} — variáveis locais
# Copie para `.env` (que nunca entra no git) e preencha só o que usar.

# Telemetria de uso (governanca.telemetria.ativa: {{#if governanca.telemetria.ativa}}true{{else}}false{{/if}})
# URL que recebe POST JSON {tipo, id, org, quando}; token opcional vai como Bearer.
{{default governanca.telemetria.destino_env "CORTEX_TELEMETRY_URL"}}=
CORTEX_TELEMETRY_TOKEN=

# Raiz explícita do Cortex (opcional; o CLI descobre sozinho subindo até achar `_cortex/`)
# CORTEX_ROOT=
