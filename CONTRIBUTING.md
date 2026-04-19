# Contributing to Silvermage

Thanks for the interest. Before you start, there's one thing worth knowing:

## Source lives in a private repository

This public repository is a **distribution storefront** — it carries the
release binaries, install scripts, documentation, and issue tracker, but not
the source code. The source lives in a private repo. This is intentional
and not negotiable for now.

What that means for you:

| You want to... | How |
|---|---|
| Report a bug | [Open an issue](https://github.com/silvermage-cli/silvermage/issues/new/choose) — bug report template. |
| Request a feature | [Open an issue](https://github.com/silvermage-cli/silvermage/issues/new/choose) — feature request template. |
| Ask a usage question | [Start a discussion](https://github.com/silvermage-cli/silvermage/discussions) — tag it `q-and-a`. |
| Report a security issue | See [SECURITY.md](SECURITY.md). |
| Submit a code change | Open a feature request first. If accepted, we may invite you to the private repo — but pull requests cannot be merged from this public repo. |

## Issue etiquette

- **Search before filing.** Duplicates get closed. Upvote existing issues
  you care about.
- **Include your version** (`silvermage --version`) and platform in bug reports.
- **Minimal repro** wins. If the bug only happens with your 4 000-token
  project file, try to trim it down.
- **One issue per problem.** Don't pile three bugs + a feature request into
  a single thread.
- **No meta / off-topic threads.** "Is this project still alive?", "When
  will you add X?", roadmap-nagging — we'll close these.

## Feature request criteria

Proposals are more likely to land if they:

- Describe the **problem** before the solution.
- Explain **who needs it** and **how often**.
- Acknowledge trade-offs (binary size, runtime cost, UX complexity).
- Reference prior art if similar tools handle it.

Proposals likely to be declined:

- "Make X configurable" without a use case.
- "Parity with tool Y" without specifics on what's useful.
- Cosmetic changes that contradict the established theme system.

## Documentation improvements

Typos or clarifications to files in **this** repository (README, install
scripts, CHANGELOG) — pull requests are welcome and will be reviewed
quickly.

## Licensing

Silvermage is MIT-licensed. By filing an issue or discussion you agree your
contribution (text, reports, examples) is licensed the same way.

## Thanks

Good bug reports and thoughtful feature requests are worth a lot. We read
everything, even if we can't always respond quickly.
