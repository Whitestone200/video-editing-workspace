# Video editing workspace

Editors run their agent from this folder on the same computer as their editing app. Editing apps connect through the MCP servers in `.mcp.json`. Those servers are installed from the lockfile by `setup/`.

| App | MCP server | Package |
| --- | --- | --- |
| Adobe Premiere Pro | `premiere-pro` | `premiere-pro-mcp` |

## Editing rules (all apps)

1. Start with the app's read-only connection check (Premiere: `verify_premiere_connection`). If it fails or the tools are missing, stop and point the editor to `README.md`. Never work around it with raw scripts, unsafe modes, or hidden APIs.
2. Never delete source media, overwrite the original project, or upload, publish, or share anything unless asked.
