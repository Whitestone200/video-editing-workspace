# Video editing workspace

This repo connects Claude to Adobe Premiere Pro through the `premiere-pro` MCP server (`premiere-pro-mcp`, pinned in `.mcp.json`). Editors run Claude Code from this folder on the same computer as Premiere.

## Working in Premiere

1. Start every session with `verify_premiere_connection` and make no changes until it passes.
2. If the `premiere-pro` tools are missing or the check fails, stop and point the editor to the Troubleshooting section of `README.md`. Don't work around it with raw scripts, unsafe modes, or hidden APIs.
3. Inspect before you edit. Before any change to a timeline, sequence, project item, caption, export, or media file, state:
   - the project and sequence you'll touch
   - the exact clips, tracks, and time ranges
   - what will change and how to undo it

   Then wait for explicit approval.
4. Stay inside the project and sequence the editor named. Never delete source media, overwrite the original project, upload, publish, or share anything unless asked.
5. After an approved change, read the result back from Premiere. Report what was done, what was verified, and what is still unverified. A command being accepted doesn't mean the edit is correct.

## Maintaining this repo

- To upgrade the server, change the version in `.mcp.json` only. The setup scripts read it from there. Then tell editors to re-run their setup script, which updates the Premiere panel to match.
- Use the npm package `premiere-pro-mcp`, not `adobe-premiere-pro-mcp`. That is a different project that installs a command with the same name.
