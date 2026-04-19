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

[Unreleased]: https://github.com/silvermage-cli/silvermage/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.0
