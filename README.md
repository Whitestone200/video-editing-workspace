# Video Editing Workspace

A public repository for video editors at [Hireline.com](https://hireline.com) to use with their agent to help edit their videos.

Clone this repo, run one setup script, and Claude can inspect and edit your Adobe Premiere Pro projects. It works through [MCP for Adobe Premiere Pro](https://github.com/leancoderkavy/premiere-pro-mcp), an open-source, MIT-licensed MCP server. The version this team uses is pinned in [`.mcp.json`](.mcp.json).

## How it works

Everything runs on your computer. Nothing goes through a cloud server.

```text
Claude Code ──▶ premiere-pro MCP server ──▶ temp folder ──▶ Premiere panel ──▶ Premiere Pro
(this folder)   (started from .mcp.json)    (local files)   (installed by setup)
```

This means:

- Claude, the MCP server, and Premiere must all run on the **same computer**.
- It won't work from Claude on the web or a cloud session. Run Claude Code locally in this folder.

## Requirements

- macOS or Windows
- Adobe Premiere Pro 2020–2026
- [Node.js](https://nodejs.org) 20.19 or newer (the LTS version is fine)
- [Claude Code](https://code.claude.com/docs/en/setup)
- Git, to clone this repo

## Setup (one time per computer)

**1. Clone this repo.**

```bash
git clone https://github.com/whitestone200/video-editing-workspace.git
cd video-editing-workspace
```

**2. Quit Premiere Pro completely.**

**3. Run the setup script for your OS.**

macOS (Terminal):

```bash
bash setup/setup-mac.sh
```

Windows (PowerShell):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File setup\setup-windows.ps1
```

The script:

- checks your Node.js version
- installs the Premiere panel at the pinned version
- runs a diagnostic
- on Windows only, registers the server with Claude Code. Windows needs a slightly different launch command than the one in `.mcp.json`.

**4. Open the panel in Premiere.**

1. Open Premiere Pro and a **test project**. Don't use live client work for your first run.
2. Choose **Window > Extensions > MCP for Adobe Premiere Pro**.

**5. Start Claude in this folder.**

```bash
claude
```

When Claude asks whether to use the `premiere-pro` MCP server from `.mcp.json`, approve it.

**6. Verify the connection.** Send this as your first message:

```text
Run verify_premiere_connection. Make no changes.
```

Once it passes, try a read-only question:

```text
What is my current Premiere project and active sequence? Do not make changes.
```

You're set up.

## Working safely

[`CLAUDE.md`](CLAUDE.md) tells Claude to check the connection first, show a plan before any edit, and wait for your approval. You should still:

- **Save a copy of the project** before letting Claude edit it.
- **Scope your requests.** Name the sequence, clips, and what must not change, and say whether exports are allowed.
- **Ask for a plan first.** For example: *"Inspect the active sequence and propose a rough cut of the interview clips. Don't edit anything yet."*
- **Check the result in Premiere yourself.** A command being accepted doesn't mean the edit is right. Cmd/Ctrl+Z works as usual.

## Updating

Whoever maintains this repo bumps the version in `.mcp.json` and pushes. Everyone else then:

1. Quits Premiere.
2. Runs `git pull`.
3. Re-runs the setup script for their OS, which updates the Premiere panel to match.
4. Restarts Claude Code.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Claude has no Premiere tools | Start `claude` from this folder. Run `/mcp` and check that `premiere-pro` is listed and connected. If you declined it earlier, run `claude mcp reset-project-choices` and restart Claude. |
| Panel isn't under Window > Extensions | Quit Premiere fully, re-run the setup script, then reopen Premiere. |
| `verify_premiere_connection` fails | Make sure a project is open, the panel is open, and Premiere and Claude are on the same computer. Then run `npx -y premiere-pro-mcp@<version from .mcp.json> --doctor` for a local diagnostic. |
| Setup says Node.js is too old | Install the current LTS from [nodejs.org](https://nodejs.org) and re-run setup. |
| Windows: server fails to start | Re-run `setup\setup-windows.ps1`. It registers the Windows launch command (`cmd /c npx …`) for this folder. |

For anything else, see the upstream [troubleshooting guide](https://premiere-pro-mcp.com/docs/troubleshooting/) or [issues](https://github.com/leancoderkavy/premiere-pro-mcp/issues).

## Using Claude Desktop instead

1. Run the setup script anyway. It installs the Premiere panel.
2. Download the `.mcpb` bundle that matches the version in `.mcp.json` from the [upstream releases](https://github.com/leancoderkavy/premiere-pro-mcp/releases).
3. In Claude Desktop, choose **Settings > Extensions > Advanced settings > Install Extension**, select the bundle, and restart Claude Desktop.

Claude Desktop doesn't read this repo's `CLAUDE.md`. Follow the [Working safely](#working-safely) rules yourself.

## Uninstall

Quit Premiere, then run:

```bash
npx -y premiere-pro-mcp@<version from .mcp.json> --uninstall-cep
```

Delete this folder when you're done. On Windows, also run `claude mcp remove --scope local premiere-pro` from this folder first.

> **Note:** Install `premiere-pro-mcp`, not `adobe-premiere-pro-mcp`. They are different projects that install a command with the same name.
