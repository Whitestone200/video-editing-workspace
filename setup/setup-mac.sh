#!/usr/bin/env bash
# One-time setup for the Premiere Pro MCP server on macOS.
# Installs the Premiere connector panel at the version pinned in .mcp.json
# and runs the package's local diagnostic. Safe to re-run after a version bump.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

fail() { printf '\n✗ %s\n' "$1" >&2; exit 1; }
step() { printf '\n→ %s\n' "$1"; }

[[ "$(uname -s)" == "Darwin" ]] || fail "This script is for macOS. On Windows, run setup/setup-windows.ps1."

step "Checking Node.js (20.19 or newer required)"
command -v node >/dev/null 2>&1 || fail "Node.js not found. Install the LTS version from https://nodejs.org, then re-run this script."
node -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>20||(a===20&&b>=19)?0:1)' \
  || fail "Node.js $(node -v) is too old. Install the LTS version from https://nodejs.org, then re-run this script."
echo "  Node.js $(node -v)"

VERSION="$(node -p 'require("./.mcp.json").mcpServers["premiere-pro"].args.find(a=>a.startsWith("premiere-pro-mcp@")).split("@")[1]')"
PKG="premiere-pro-mcp@${VERSION}"
echo "  Using ${PKG} (pinned in .mcp.json)"

step "Checking that Premiere Pro is closed"
if pgrep -f "Adobe Premiere Pro" >/dev/null 2>&1; then
  fail "Premiere Pro is running. Quit it completely (Cmd+Q), then re-run this script."
fi

step "Installing the Premiere connector panel"
npx -y "$PKG" --install-cep

step "Running the local diagnostic"
npx -y "$PKG" --doctor || echo "  (Diagnostic reported issues. Some are expected until Premiere is open with the panel running.)"

cat <<EOF

✓ Setup complete.

Next:
  1. Open Premiere Pro and a test project (not live client work).
  2. Open Window > Extensions > MCP for Adobe Premiere Pro.
  3. In this folder, run: claude
     Approve the "premiere-pro" MCP server when asked.
  4. Send: Run verify_premiere_connection. Make no changes.
EOF
