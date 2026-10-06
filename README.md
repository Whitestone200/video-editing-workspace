# Video Editing Workspace

A public repository for video editors at [Hireline.com](https://hireline.com) to use with their agent to help edit their videos.

Everything runs locally, so your agent and editing app must be on the same computer. Agent rules are in [AGENTS.md](AGENTS.md).

## Requirements

A Mac, [Node.js](https://nodejs.org) 20.19+, and [Claude Code](https://code.claude.com/docs/en/setup).

## Adobe Premiere Pro

Connects through [premiere-pro-mcp](https://github.com/leancoderkavy/premiere-pro-mcp).

### Setup

1. Clone this repo and `cd` into it.
2. Quit Premiere Pro, then run `bash setup/premiere/mac.sh`.
3. Open Premiere and a test project, then open **Window > Extensions > MCP for Adobe Premiere Pro**.
4. Run `claude` from this folder and approve the `premiere-pro` server.
5. Send: `Run verify_premiere_connection. Make no changes.`

**Updating:** quit Premiere, `git pull`, and re-run `bash setup/premiere/mac.sh`.

**Problems?** Make sure you ran `claude` from this folder, Premiere has a project open, and the panel is open. Then re-run setup. In Claude, `/mcp` shows whether the server is connected.
