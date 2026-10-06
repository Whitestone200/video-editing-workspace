#!/usr/bin/env bash
# Installs the locked MCP servers and editing-app connectors. Re-run after `git pull`.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

fail() { printf '\n✗ %s\n' "$1" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || fail "This setup supports macOS only."
command -v node >/dev/null 2>&1 || fail "Node.js not found. Install the LTS from https://nodejs.org and re-run."
node -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>20||(a===20&&b>=19)?0:1)' \
  || fail "Node.js $(node -v) is too old. Install the LTS from https://nodejs.org and re-run."

echo "→ Installing locked packages"
npm ci --ignore-scripts --no-audit --no-fund

echo "→ Premiere Pro connector"
if pgrep -f "Adobe Premiere Pro" >/dev/null 2>&1; then
  fail "Premiere Pro is running. Quit it (Cmd+Q) and re-run."
fi
node node_modules/premiere-pro-mcp/dist/index.js --install-cep

echo
echo "✓ Done. Open Premiere > Window > Extensions > MCP for Adobe Premiere Pro, then run \`claude\` in this folder."
