#!/usr/bin/env bash
set -euo pipefail

# build the server config file from template
echo "Creating /data/serverconfig.txt from template."
eval "echo \"$(< /terraria-server/serverconfig.tmpl)\"" > /data/serverconfig.txt

# run the terraria server in a wrapper that catches sigterm
echo "Running terraria server."
exec game-docker-wrapper -k "exit" -- /terraria-server/TerrariaServer \
    -x64 \
    -config /data/serverconfig.txt \
    "$@"
