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


## [0.2.1] — 2026-06-19

Review now maps the blast radius of every confirmed finding, research stops cutting deep investigations short, and the review verification summary is now honest.

## What's new

- Review now maps the **blast radius** of every confirmed finding — callers and dependents that could break, plus sibling spots in the *same change* that share the flaw — shown as an `Impact:` block under the finding. Most useful on wide diffs and shared-contract changes, where the ripple isn't obvious by eye.

## Fixes

- Research no longer cuts deep investigations short. A thorough sweep that needed more passes was being force-summarized early ("iteration limit reached") and losing coverage; the ceiling is now generous (and configurable).
- Review's verification summary is now honest — it counts only findings a skeptic actually confirmed and labels the rest "kept unverified," instead of reporting every surviving finding as verified.
- Review's blast-radius mapping runs only on genuinely-confirmed findings, never on ones whose verifier failed.

## Improvements

- Wider research fan-out by default — more parallel investigators, so multi-part questions finish in fewer waves.
- Research feature toggles (concern surfacing, deepening, anchor-check, the verify budget) and the explorer iteration ceilings are now tunable from `/config` and the config file.
## [0.2.0] — 2026-06-19

Silvermage gains deep multi-agent research and review, a major fix for compaction on large-context models, and a broad security and reliability hardening pass.

## What's new

- Add `/research` — a deep, parallel investigation: it breaks a question into independent slices, explores them concurrently, and merges the results into one coherent, citation-anchored map. It then surfaces concrete concerns, each adversarially verified, and maps the blast radius of confirmed high-severity ones.
- Add `/review` — an adversarial code review where every finding is re-challenged by a skeptic (Is it reachable? Is it intentional? Would the fix actually change a test?) before it is shown, so dead-code and by-design false positives are dropped and severities are right-sized.
- Surface live progress for both pipelines — each slice and each finding reports what it is doing, in place under the tool.
- Run either on the model's own judgment mid-task, or on demand via the slash command.

## Fixes

- Fix compaction on large-context models — it now runs on the main model, so it can actually summarize conversations that grow toward the model's full window instead of silently failing on big sessions.
- Keep partial command output when a command times out or is cancelled, instead of discarding the diagnostics.
- Recover from a provider error mid-turn instead of dropping the turn.
- Make edits to binary files revertible, and roll back partially-applied multi-file renames when one of them fails.
- Prevent a timed-out terminal command from leaving an orphaned process running.
- Fix a crash when truncating summaries that contain multi-byte characters.

## Security

- Close a server-side request forgery hole in web fetch — redirects and DNS rebinding are re-validated against the safety rules, and fetched content is scanned for credentials before the model sees it.
- Strengthen the dangerous-command guard — it now catches quoted paths, full-path and long-form `rm`, and destructive commands hidden after a pipe or `&`.
- Apply the `.git` write protection across every file-writing tool, and block path-traversal exfiltration through git-history queries.
- Time-bound external tool-server calls so one unresponsive server cannot stall the rest.

## Improvements

- Anchor-check `/explore` results — citations that do not point at a real file and line are flagged, so hallucinated references are caught.
- Run quick side tasks like session naming on a faster, current-generation model tier.
- Widen research's parallel fan-out and rein in runaway explorers and over-long concern lists.
- Lower the overhead of credential masking.
## [0.1.14] — 2026-06-18

Context limits now scale to your model's window — big-context models keep far more in mind automatically — plus a fix for sub-agent replies that cut off mid-answer.

## What's new
- Scale context budgets to the active model automatically. On large-context models (the 1M-token GLM and MiniMax tiers), silvermage now keeps far more of your recent work and documentation verbatim instead of compressing it early, and scales down safely on smaller models — no manual tuning.
- Add per-provider budget overrides for setups that need different limits (e.g. a smaller-window OpenRouter model).

## Fixes
- Fix sub-agent replies (task / code review) truncating mid-answer and re-running — long syntheses now complete in one pass.

## Improvements
- Let sub-agents manage their own context on deep tasks: they gather broadly, then trim already-used file reads while keeping their findings, so long reviews and explorations don't choke.
## [0.1.13] — 2026-06-17

A reliability release: fewer wrong edits and read/write loops, safer file operations, and a terminal scroll fix.

## Fixes
- Fix the mouse wheel sometimes scrolling your command history instead of the conversation after switching windows or resizing the terminal.
- Fix symbol and outline reads returning only a function's signature for Python and for code with braces inside strings or comments — a frequent cause of edit-retry loops.
- Fix code search ignoring directory glob patterns such as `src/**/*.rs`.

## Improvements
- Prevent low-confidence fuzzy edits from silently landing in the wrong place — the editor now asks for a line hint or a re-read instead of guessing.
- Make directory deletion reversible — folders are snapshotted before removal so they can be restored.
- Prevent data loss when moving a file onto an existing one by snapshotting the destination first.
- Report when code search skips unreadable or binary files, so a partial search isn't mistaken for no matches.
- Guide reading of very large files toward targeted range and outline reads.
## [0.1.12] — 2026-06-13

Newly added models now show up automatically after an update.

## Improvements

- The model list refreshes itself whenever you update Silvermage, so models added in a new release (like GLM-5.2) appear immediately — no need to clear any cache by hand. Works the same on Linux, macOS, and Windows.
## [0.1.11] — 2026-06-13

Adds the new GLM-5.2 model.

## What's new

- **GLM-5.2** is now available in the GLM provider, with a 1M-token context window.
## [0.1.10] — 2026-06-02

A hotfix release focused on Windows: self-update, bash mode, and form input all work correctly now, plus a copy-button fix.

## Fixes

- **Windows self-update now works.** Updates previously failed with "Compression method not supported" — the Windows `.zip` could not be unpacked. Note: because the fix ships *inside* the updater, Windows users on an older version need to download this release manually once; auto-update works from here on.
- **Windows bash mode can be enabled.** Pressing `!` to enter bash mode did nothing on Windows; it now toggles as expected.
- **Windows Ollama setup accepts full URLs.** Shifted characters (`:`, uppercase, etc.) were dropped while typing, so addresses like `http://host:11434` couldn't be entered. Fixed.
- **Copy buttons grab the right text.** When a memory was saved at the end of a turn, the synthesis/all copy could capture the memory note instead of the actual answer. It now copies the real synthesis.
## [0.1.9] — 2026-06-02

New MiniMax M3 models, a quick-stash shortcut for your draft input, and a move to the Apache 2.0 license.

## What's new

- Add **MiniMax M3** and **MiniMax M3 Highspeed** to the MiniMax provider.
- Stash your in-progress input with **Ctrl+S** and bring it back later. A ghost-orb indicator shows when a draft is held and restores it on submit.

## Fixes

- Copy buttons now stay scoped to their own message, so you copy the right reply — and the substantive answer is preferred when copying.

## Improvements

- Surface GLM-4.5 ahead of GLM-4.7 in the model list.
- Time-box the stash indicator bubble to 10 seconds so it no longer lingers on screen.

## Licensing

- Silvermage now ships under the **Apache License 2.0** (previously MIT), with a `NOTICE` file covering attribution. Both are included in every download.
## [0.1.7] — 2026-04-23

Hotfix: `/update` now actually works.

## Fixes

- Fix in-binary auto-update. Release archives shipped with leading `./` on every path (`./silvermage`, `./README.md`, `./LICENSE`), which caused `self_update` to report `Could not find the required path in the archive: "silvermage"`. `/update` has been silently broken since v0.1.0 — v0.1.5's error-chain surfacing is what made the underlying bug visible. This release repacks archives with bare paths. From v0.1.6 onward `/update` works cleanly to v0.1.7+.

## Upgrading from v0.1.6 or earlier

`/update` cannot pull this release on the affected builds (they are the broken ones). Reinstall once:

```sh
curl -fsSL https://silvermage.com/install.sh | sh
```

From v0.1.7 forward, `/update` auto-upgrades as intended.
## [0.1.6] — 2026-04-23

Stability-focused release. Fixes a long-session crash affecting MiniMax, GLM, and any other OpenAI-spec provider, plus the recent streaming polish for MiniMax.

## Fixes

- Stop long sessions from failing with "tool id not found" 400 errors. After enough turns, recency-cached tool results could outlive the old assistant message that declared them, leaving orphan tool_call_ids on the wire that spec-conformant providers (MiniMax, GLM, OpenAI) reject. The history compressor now keeps each assistant and its tool results together, and a post-compression validator strips anything that still slips through. Affects all providers, not just MiniMax.
- Render one thinking bubble and one response bubble per turn, even when MiniMax interleaves reasoning mid-synthesis. Previously the UI fragmented the response into many small bubbles as reasoning and content events alternated — now each phase has its own bubble that grows in place.
- Remove the blank line that appeared above MiniMax responses after the thinking phase ended.

## Improvements

- Smooth MiniMax output with an adaptive pacer. Standard MiniMax variants flush SSE frames a line or two at a time, which rendered as jerky bursts. The pacer drip-feeds characters at a rate matched to the source's measured throughput, producing typewriter-style output without growing lag.
- Eliminate duplicate thinking output on MiniMax. The provider now requests `reasoning_split: true` so thinking arrives in its own structured field instead of as `<think>...</think>` tags embedded in content.
- Surface the MiniMax highspeed tier in the model picker: MiniMax M2.5 Highspeed, M2.7 Highspeed, and M2.1 Lightning now appear after the standard variants. These already stream smoothly, so they skip the pacer.

## Install

```sh
curl -fsSL https://silvermage.com/install.sh | sh
```

Already installed? Run `/update` inside silvermage, or pick up the new binary from [silvermage.com/downloads](https://silvermage.com/downloads).
## [0.1.5] — 2026-04-22

Four targeted fixes for modal interaction during streaming and for the update flow itself.

## Fixes

- Stop aborting the AI when you close a modal mid-stream. Opening a modal (like `/model`) while the assistant is still working now lets you press Esc to dismiss the modal without interrupting the in-flight response. Esc only cancels the stream when no modal is open.
- Prevent MiniMax streams from occasionally gluing adjacent words together. Standalone whitespace deltas in the response are no longer silently dropped while `<think>` tags are being parsed.
- Close the update modal automatically when an install fails. Previously a failed `/update` left the modal stuck on "installing…" and the error message was hidden underneath — you had to press Esc to see what happened.
- Surface the actual reason when an update fails. Instead of a vague "Update failed: perform update", the message now shows the full error chain (network issue, checksum mismatch, etc.) so you can tell why the install didn't go through.

## Install

```sh
curl -fsSL https://silvermage.com/install.sh | sh
```

Already installed? Run `/update` inside silvermage, or pick up the new binary from [silvermage.com/downloads](https://silvermage.com/downloads).
## [0.1.4] — 2026-04-22

Silvermage v0.1.4 — four UX fixes: confirm modals that fit small terminals, an `/update` that doesn't lock you out, a `/clear` that actually clears, and breathing room between tool output and the spinner.

## Fixes

- **Confirm modals stay readable in small terminals.** The yes/no modal (shown for `.env` ingest consent, secret delete, remote stop, and a few others) used to size itself as a percentage of the terminal height. In a quartered Arch window — or any split-terminal layout — that percentage collapsed to a handful of rows, dropping the yes/no buttons and hint off the bottom with no way to scroll. The modal is now sized by its actual content, buttons + hint are pinned to the bottom so they're always visible, and a ▲/▼ marker appears on the right edge when prompt text is clipped so you can scroll with ↑/↓.
- **`/update` no longer locks the terminal on install.** Pressing Enter in the update modal used to surface the stuck behaviour several of you hit: keys bled into the chat input and the session became unresponsive until you killed and relaunched silvermage. The underlying cause was a duplicate confirmation prompt inside the update library reading stdin while the TUI already held it. The modal's Install click is now the only confirmation required — the install runs cleanly and your keyboard keeps working.
- **`/clear` actually clears.** It used to wipe the visible chat and the conversation history sent to the provider, but left stale telemetry behind — the status bar kept showing tokens from cleared turns, `/context` still showed conversation slots populated, and the ghost orb's wake-from-AFK recap could quote a chat that no longer existed. Those four signals now reset together. Project-scoped state (memories, alignments, input history) and startup-fixed context slots are preserved.
- **Tool output no longer collides with the spinner line.** While a turn was streaming, a bottom-pinned tool call bubble would touch the spinner row directly with no gap, which made the UI feel cramped and sometimes hard to read. A one-row breathing space now sits between the chat scrollback and the spinner whenever a turn is in flight.

## Install

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Windows PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Already on v0.1.3? Run `/update` inside silvermage.
## [0.1.3] — 2026-04-20

Silvermage v0.1.3 — startup now opens with a themed boot receipt that shows what loaded (hooks, memories, plugins, skills, project snapshots, MCP servers) so you can see at a glance what came up and what didn't.

## What's new

- **Startup boot receipt.** Under the version pill, silvermage now prints a 6-step checklist that shows each subsystem coming online — hooks, memories, plugins, skills, project snapshots, and MCP servers — with a live spinner that flips to a green ✓ and the loaded count as each one resolves. MCP reports its real progress; the rest reveal on a short staggered timer so the panel reads as a rhythm instead of a flash. A pink→blue "✨ Ready." capper lands once every step is done; if any step failed (e.g. an MCP server wouldn't start), the capper switches to a warning variant and the failing line shows `✗` with a count.
- **Welcome line reads above the receipt.** The greeting now sits directly under the version pill and above the boot checklist — the greeting leads, the checklist follows, and the first-run quick-start panel (when shown) lands last.

## Install

```sh
curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
```

Windows PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex
```

Already on v0.1.2? Run `/update` inside silvermage.
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

[Unreleased]: https://github.com/silvermage-cli/silvermage/compare/v0.2.1...HEAD
[0.1.0]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.0
[0.1.1]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.1
[0.1.2]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.2
[0.1.3]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.3
[0.1.4]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.4
[0.1.5]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.5
[0.1.6]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.6
[0.1.7]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.7
[0.1.9]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.9
[0.1.10]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.10
[0.1.11]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.11
[0.1.12]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.12
[0.1.13]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.13
[0.1.14]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.1.14
[0.2.0]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.2.0
[0.2.1]: https://github.com/silvermage-cli/silvermage/releases/tag/v0.2.1
