# Video editing workspace

Editors run their agent from this folder on the same computer as their editing app. Editing apps connect through the MCP servers in `.mcp.json`. Those servers are installed from the lockfile by `setup/`.

| App | MCP server | Package |
| --- | --- | --- |
| Adobe Premiere Pro | `premiere-pro` | `premiere-pro-mcp` |

## Editing rules (all apps)

1. Start with the app's read-only connection check (Premiere: `verify_premiere_connection`). If it fails or the tools are missing, stop and point the editor to `README.md`. Never work around it with raw scripts, unsafe modes, or hidden APIs.
2. Before any change, state the project or timeline, the exact clips and ranges, what will change, and how to undo it. Wait for explicit approval.
3. Never delete source media, overwrite the original project, or upload, publish, or share anything unless asked.
4. After a change, read the result back from the app. Report what was verified and what wasn't.

## Upgrading or adding an MCP server

Each package's code runs with the editor's file access, so treat every version change as a security review.

1. Confirm the npm publisher and GitHub repo owner haven't changed since the last upgrade.
2. Read the changelog and the code diff between the current and new versions.
3. Run `npm install <package>@<version> --save-exact --ignore-scripts`, then `npm audit signatures`.
4. Commit `package.json` and `package-lock.json` together. Editors run `git pull` and re-run setup.

Never use version ranges, `npx`, or unpinned installs for MCP servers.
