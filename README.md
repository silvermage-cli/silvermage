# Silvermage

Security-first, agentic CLI coding assistant written in Rust.

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

![Silvermage demo](assets/silvermage-demo.gif)

## What it is

Silvermage is a terminal-native AI coding assistant. Drops into any project,
reads and writes files, runs tools, and talks to the AI provider of your
choice. Built in Rust as a single static binary — fast startup, no runtime
dependencies, no Node / Python prerequisite.

## Highlights

- **Multi-provider** — GLM/Zhipu, OpenRouter, MiniMax, Ollama (local).
  Swap providers + models mid-session.
- **30+ built-in tools** — file read/write, command execution with a sandbox,
  search, web fetch, MCP proxy, process management, and more.
- **Security posture** — command deny-list, credential masking before the AI
  ever sees output, handle-based secret vault, permission modal for stateful
  tools in strict mode.
- **Context management** — EMA-calibrated token estimator, two-tier
  recency + doc cache, manual `/compact`, 6-slot context tracker visible in
  `/context`.
- **Plugin system** — Claude Code-compatible: slash commands, hooks (file and
  inline), MCP servers, skills. Browse + install via `/plugin`.
- **Remote terminal** — share a live session to a browser over Tailscale
  (or LAN with explicit warnings). Per-connection kick, heartbeat, auth via
  WebSocket subprotocol.
- **Themes** — 11 built-in including Silvermage, Classic Comfort, Kanagawa,
  Catppuccin (Mocha / Frappé), Solarized, high-contrast, colorblind-safe.
  `/theme` previews live.
- **Sessions** — named snapshots, `/resume`, AI-generated topic summaries,
  dual-summary reviewer.

## Platform support

| OS | Architecture | Target triple |
|---|---|---|
| Linux | x86_64 | `x86_64-unknown-linux-musl` |
| Linux | aarch64 | `aarch64-unknown-linux-musl` |
| macOS | x86_64 (Intel) | `x86_64-apple-darwin` |
| macOS | aarch64 (Apple Silicon) | `aarch64-apple-darwin` |
| Windows | x86_64 | `x86_64-pc-windows-msvc` |

Linux builds are musl-static — they run on any glibc version and on Alpine.

## Install

### Unix (Linux / macOS)

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Installs to `~/.local/bin/silvermage`. Override with
`SILVERMAGE_INSTALL_DIR=/somewhere/else`.

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Installs to `$env:LOCALAPPDATA\Programs\silvermage`.

### Manual

Grab the matching tarball from the
[releases page](https://github.com/silvermage-cli/silvermage/releases), extract
the `silvermage` binary, and place it anywhere on your `PATH`. Verify the
SHA256 sidecar before trusting the binary.

## Quick start

```sh
silvermage
```

On first run you'll be walked through provider selection and API key entry.
Credentials are stored in `~/.config/silvermage/credentials.toml` with
`chmod 600` and never written to chat history.

Once you're in, a few commands to know:

- `/help` — all commands
- `/providers` — configure or switch AI provider
- `/init` — bootstrap project context (generates `AGENTS.md`)
- `/plugin` — browse + install plugins
- `/theme` — pick a theme with live preview
- `/remote` — open a browser-accessible session
- `/context` — see what's consuming your context window

## Configuration

Config lives under the XDG base dirs:

| Path | Purpose |
|---|---|
| `~/.config/silvermage/config.toml` | main config |
| `~/.config/silvermage/credentials.toml` | API keys (chmod 600) |
| `~/.config/silvermage/mcp.json` | MCP server definitions |
| `~/.config/silvermage/plugins/` | installed plugins |
| `~/.config/silvermage/hooks/` | user hooks |
| `~/.local/share/silvermage/sessions/` | session snapshots |
| `~/.local/share/silvermage/logs/` | tracing logs |
| `~/.cache/silvermage/models.json` | cached provider model list (24h TTL) |

Project context: `AGENTS.md` (or `CLAUDE.md`) at the project root is
auto-loaded read-only.

## Links

- [Changelog](CHANGELOG.md) — release history
- [Issues](https://github.com/silvermage-cli/silvermage/issues) — bug reports, feature requests
- [Discussions](https://github.com/silvermage-cli/silvermage/discussions) — Q&A, usage tips
- [Security policy](SECURITY.md) — how to report vulnerabilities
- [Contributing](CONTRIBUTING.md) — how to help (issues welcome; source lives in a private repo)

## License

Silvermage is distributed under the [MIT License](LICENSE).
