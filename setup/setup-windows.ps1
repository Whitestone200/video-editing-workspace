# One-time setup for the Premiere Pro MCP server on Windows.
# Installs the Premiere connector panel at the version pinned in .mcp.json,
# registers a Windows-compatible Claude Code entry for this folder, and runs
# the package's local diagnostic. Safe to re-run after a version bump.
#
# Run from the repo folder:
#   powershell -NoProfile -ExecutionPolicy Bypass -File setup\setup-windows.ps1

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

function Fail($msg) { Write-Host "`n[x] $msg" -ForegroundColor Red; exit 1 }
function Step($msg) { Write-Host "`n-> $msg" -ForegroundColor Cyan }

Step 'Checking Node.js (20.19 or newer required)'
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Fail 'Node.js not found. Install the LTS version from https://nodejs.org, then re-run this script.'
}
& node -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>20||(a===20&&b>=19)?0:1)'
if ($LASTEXITCODE -ne 0) {
    Fail "Node.js $(node -v) is too old. Install the LTS version from https://nodejs.org, then re-run this script."
}
Write-Host "  Node.js $(node -v)"

$Version = (Get-Content .mcp.json -Raw | ConvertFrom-Json).mcpServers.'premiere-pro'.args |
    Where-Object { $_ -like 'premiere-pro-mcp@*' } |
    ForEach-Object { $_.Split('@')[1] }
if (-not $Version) { Fail 'Could not read the pinned premiere-pro-mcp version from .mcp.json.' }
$Pkg = "premiere-pro-mcp@$Version"
Write-Host "  Using $Pkg (pinned in .mcp.json)"

Step 'Checking that Premiere Pro is closed'
if (Get-Process -Name 'Adobe Premiere Pro' -ErrorAction SilentlyContinue) {
    Fail 'Premiere Pro is running. Quit it completely, then re-run this script.'
}

# npx.cmd avoids PowerShell execution-policy blocks on npx.ps1.
Step 'Installing the Premiere connector panel'
& npx.cmd -y $Pkg --install-cep
if ($LASTEXITCODE -ne 0) { Fail 'Connector install failed. See the output above.' }

# Claude Code on native Windows needs "cmd /c" to launch npx-based servers, so
# register a local-scope entry that overrides the shared .mcp.json for this folder.
Step 'Registering the MCP server with Claude Code for this folder'
# Run through cmd.exe so PowerShell doesn't swallow "--" or trip on stderr.
if (Get-Command claude -ErrorAction SilentlyContinue) {
    & cmd.exe /c "claude mcp remove --scope local premiere-pro >nul 2>&1"
    & cmd.exe /c "claude mcp add --scope local premiere-pro -- cmd /c npx -y $Pkg"
    if ($LASTEXITCODE -ne 0) { Fail 'Could not register the MCP server with Claude Code.' }
} else {
    Write-Host '  Claude Code not found; skipping. Install it, then re-run this script.' -ForegroundColor Yellow
}

Step 'Running the local diagnostic'
& npx.cmd -y $Pkg --doctor
if ($LASTEXITCODE -ne 0) {
    Write-Host '  (Diagnostic reported issues. Some are expected until Premiere is open with the panel running.)' -ForegroundColor Yellow
}

Write-Host @'

[ok] Setup complete.

Next:
  1. Open Premiere Pro and a test project (not live client work).
  2. Open Window > Extensions > MCP for Adobe Premiere Pro.
  3. In this folder, run: claude
  4. Send: Run verify_premiere_connection. Make no changes.
'@ -ForegroundColor Green
