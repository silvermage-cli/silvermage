# Changelog

All notable user-facing changes to Silvermage are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- _(draft changes for the next release here)_

### Changed

### Fixed

### Security

### Removed


## [0.1.2] — 2026-04-20

Silvermage v0.1.2 — two correctness fixes that land in the same release. Status-bar indicators now actually update in the background, and the agent no longer duplicates wrap-up prose after successful tool runs.

## Fixes

- **Status-bar indicators stay live between turns.** Background state changes — a new release being discovered, a background process spawning via `execute_command` with `detach: true`, remote WebSocket connection count changing — now surface in the status bar without waiting for a keypress. The render loop previously only refreshed on Key/Paste/Mouse events, so the `⚙ N`, `↑ vX.Y.Z`, and `🌐 :port (N)` indicators froze the moment a turn ended. Tick-driven redraws now fire roughly every 250 ms, enough to keep indicators responsive without flooding the terminal.
- **Preamble-nudge no longer misfires on post-tool wrap-ups.** Short assistant responses after a successful tool wave ("Wrote VOICE.md. Covers all four providers…") were being misclassified as truncated preambles, triggering a retry iteration that duplicated the synthesis text in session history and burned extra API tokens. The nudge now only fires before any tool has run this turn — which preserves its original job of catching "I'll create the files. Let me start:" with no action, while treating genuine summaries after tool execution as valid.

## Install

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Windows PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Already on v0.1.1? Run `/update` inside silvermage.
## [0.1.1] — 2026-04-20

Silvermage v0.1.1 — in-binary auto-updater. Running silvermage now tells you when a new release lands, and a single `/update` swaps the binary in place.

## What's new

- Startup check — silvermage pings the release repo once per launch (non-blocking, 24-hour cache) and notes any newer version without delaying your session.
- Status-bar indicator — an `↑ vX.Y.Z` badge appears on the right side of the status bar when an update is available. Click it to open the update modal.
- `/update` slash command — pops the update modal showing the target version, full release notes, and an Install / Cancel prompt. When silvermage is already on the latest version, it prints a clear confirmation instead of leaving you hanging; when a newer release is found, the modal opens automatically.
- In-place install — Install downloads the correct tarball for your platform, verifies the SHA256 sidecar, and swaps the binary cleanly. On Windows the locked-exe case is handled automatically. Exit and relaunch silvermage to use the new version.
- Ghost orb reacts with an "Update available" bubble the first time a new version is discovered in a session.
- Version pill under the ASCII logo on startup — left-aligned, inverted-theme colours, shows the exact version at a glance.
- Shorter command aliases: `silver`, `silv`, and `sm` are now created alongside `silvermage` by the install scripts (symlinks on Unix, copies on Windows).

## Improvements

- New `[updater]` config section — `enabled` (default on), `check_interval_hours` (default 24), and `include_prereleases` (default off) for opting into release-candidate tags.
- New CLI flag `--no-update-check` disables the startup check for a single run. Useful on flaky networks or for a fast, offline launch.
- Release tarballs ship their contents at the archive root (binary + `LICENSE` + `README.md`) for a uniform auto-update layout across targets.

## Install

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Windows PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Already on v0.1.0? Run `/update` inside silvermage.
## [0.1.0] — 2026-04-20

Silvermage v0.1.0 — first public release. A security-first, agentic CLI coding assistant in a single static binary.

## What's new

- Multi-provider support for GLM/Zhipu, OpenRouter, MiniMax, and Ollama (local). Swap providers + models mid-session with `/providers` and `/model`.
- 30+ built-in tools — file read/write with indentation-tolerant matching, command execution with sandbox + deny-list, search, web fetch, process control, and more.
- Claude Code-compatible plugin system — slash commands, hooks (file + inline), MCP servers, and skills. Browse and install via `/plugin`.
- Built-in skills for `/explore`, `/review`, `/init`, with parallel sub-agent fan-out and skill-style prompts.
- Remote terminal access via `/remote` — share a live session to a browser over Tailscale, with per-connection kick, heartbeat, rate-limited auth, and cleartext-LAN warnings.
- Plugin marketplace — browse, install, refresh, and vet plugins from multiple sources. Tab-aware navigation, search, and README rendering in the unified `/plugin` modal.
- Eleven themes — Silvermage (default), Classic Comfort, Kanagawa, Kanagawa Dragon, Catppuccin Mocha + Frappé, Solarized, light, high-contrast, and colorblind-safe. Live preview with `/theme`.
- Full MCP (Model Context Protocol) integration — add servers via template catalog or inline plugin manifests.
- Session persistence with `/resume`, named snapshots, and AI-generated topic summaries.
- Dual-tier context management — recency cache, ground-truth doc cache, per-cache budgets visible in `/context`. Manual `/compact` with AI summarisation.
- Task-list tool for session-scoped task tracking, surfaced in the system prompt.
- Status-bar indicators for background processes and remote sessions — click to open the matching modal.
- Ghost orb companion with tool-driven insights — reacts to long-running work, failures, and remote connections.
- Windows + macOS + Linux support out of the box.

## Security

- Handle-based secret vault tokenises known exact values (`$$SMSECRET:KEY$$`) at the tool-actor boundary. The AI never sees raw credentials; the shell always does.
- `.env` auto-ingestion with consent prompt at startup and silent ingest on `read_file`.
- Command deny-list for destructive operations (unbypassable, per-OS pattern matching).
- Permission modal in strict mode for stateful tools. `Ctrl+P` toggles strict / bypass.
- Real-time credential masking before output reaches the AI.
- Remote terminal auth token carried in URL fragment + WebSocket subprotocol header only, never in query strings or access logs.
- Per-peer rate limit on WebSocket auth failures.

## Install

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Windows PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Or download the tarball for your platform below and verify its `.sha256` sidecar before running.

## Platform support

| Target | Archive |
|---|---|
| Linux x86_64 (musl static) | `silvermage-x86_64-unknown-linux-musl.tar.gz` |
| Linux aarch64 (musl static) | `silvermage-aarch64-unknown-linux-musl.tar.gz` |
| macOS x86_64 (Intel) | `silvermage-x86_64-apple-darwin.tar.gz` |
| macOS aarch64 (Apple Silicon) | `silvermage-aarch64-apple-darwin.tar.gz` |
| Windows x86_64 | `silvermage-x86_64-pc-windows-msvc.zip` |

Linux musl builds run on any glibc version and on Alpine.

## First run

```sh
silvermage
```

You'll be walked through provider selection and API key entry. Keys land in `~/.config/silvermage/credentials.toml` with `chmod 600` and never touch chat history.
## [0.1.0] — YYYY-MM-DD

Initial public release.

### Added
- Interactive TUI with 11 themes (Silvermage, Classic Comfort, Kanagawa,
  Kanagawa Dragon, Catppuccin Mocha, Catppuccin Frappé, Solarized Light/Dark,
  high-contrast, colorblind-safe, dark default).
- Multi-provider AI support: GLM/Zhipu, OpenRouter, MiniMax, Ollama.
- 30+ built-in tools including file read/write, command execution with
  sandbox, search, web fetch, MCP proxy, process management.
- Claude Code-compatible plugin system: slash commands, hooks (file + inline),
  MCP servers, skills.
- Handle-based secret vault with tokenisation at the tool actor boundary.
- Session snapshots, `/resume`, AI-generated topic summaries.
- Context management: two-tier recency + doc cache, manual `/compact`,
  6-slot tracker visible in `/context`.
- Remote terminal access (`/remote`) via browser with WebSocket subprotocol
  authentication, per-connection kick, heartbeat, rate-limited auth failures.
- `/explore`, `/review`, `/init` sub-agent skills with parallel fan-out.
- Ghost orb companion with tool-driven insights and status-bar process
  indicator.

### Security
- Token never appears in URLs or access logs — carried in WebSocket
  subprotocol header from URL fragment on the client side.
- Constant-time token comparison.
- Command deny-list for destructive operations.
- Permission modal for stateful tools in strict mode.
- Credential masking before output reaches the AI.

[Unreleased]: https://github.com/silvermage-cli/silvermage/compare/v0.1.2...HEAD
[0.1.0]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.0
[0.1.1]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.1
[0.1.2]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.2
