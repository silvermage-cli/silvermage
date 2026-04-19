# Security Policy

## Reporting a Vulnerability

If you believe you've found a security issue in Silvermage, please report it
privately — do **not** open a public issue.

### Preferred channel

[GitHub Security Advisories](https://github.com/silvermage-cli/silvermage/security/advisories/new)
— click "Report a vulnerability". This gives us a private thread plus a
CVE-ready workflow if a fix needs disclosure.

### Fallback

Email **kestalkayden2@gmail.com** with the subject line
`[silvermage security] <short summary>`. Encrypt with PGP if you want — ask
for the key and we'll share it out-of-band.

## What to include

- Silvermage version (`silvermage --version`).
- Platform + architecture.
- Steps to reproduce.
- The impact you observed or expect.
- Whether the issue is already public, and if so where.

## Our commitment

- We'll acknowledge receipt within **72 hours**.
- We'll send an initial assessment within **7 days** of acknowledgement.
- We'll coordinate a disclosure timeline with you. Default is
  **90 days from the initial report** or earlier if a fix is ready.
- We'll credit you in the release notes and advisory unless you ask us not to.

## Scope

In-scope:

- The `silvermage` binary and installers distributed from
  [silvermage-cli/silvermage](https://github.com/silvermage-cli/silvermage).
- The remote-terminal server (`/remote`) and its WebSocket auth.
- Credential handling, secret vault, and command sandbox.
- Plugin, hook, and MCP loading paths.

Out of scope:

- Vulnerabilities in third-party AI providers or their APIs.
- Social-engineering scenarios that require a privileged local attacker.
- Theoretical weaknesses in TLS stacks or OS primitives.
- Denial-of-service via content the user explicitly supplied to an AI
  provider.

## Safe harbor

Good-faith security research — testing against your own local installation
— is welcome. We won't pursue legal action for research that avoids data
destruction, respects user privacy, and stops once a vulnerability is
confirmed.
