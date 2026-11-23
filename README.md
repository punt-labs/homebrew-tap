# Punt Labs Homebrew Tap

Homebrew formulae for [Punt Labs](https://github.com/punt-labs) tools.

## Install

```bash
brew tap punt-labs/tap
```

## Available Formulae

| Formula | Description | Install |
|---------|-------------|---------|
| `biff` | CLI communication tool for software engineers — wall, write, talk, finger | `brew install punt-labs/tap/biff` |
| `ethos` | Identity binding for humans and AI agents | `brew install punt-labs/tap/ethos` |
| `mcp-proxy` | Lightweight proxy bridging MCP stdio to shared daemon processes | `brew install punt-labs/tap/mcp-proxy` |
| `quarry` | Local semantic search engine | `brew install punt-labs/tap/quarry` |
| `quarry-menubar` | macOS menu bar app for Quarry document search | `brew install punt-labs/tap/quarry-menubar` |

### Quarry Daemon

Quarry includes a service definition. After installing:

```bash
brew services start quarry
```

This starts `quarry serve` on port 8420 at login, with automatic restart on crash.

## Contributor checks

The agent check policy requires an Ethos build containing DES-085 (`post-edit`
and staged checks), such as upstream commit `f4f884f`, until the next release.
Released v5.1.1 and the v4.13.0 binary currently shipped by this tap do not
support the new edit hook. Installing the tap's current formula alone does
not provide edit feedback. With Go and Make installed, build the compatible
version in a separate checkout (choose an unused destination):

```bash
git clone https://github.com/punt-labs/ethos.git "$HOME/ethos-agent-checks"
git -C "$HOME/ethos-agent-checks" checkout --detach f4f884fb07e6a0c7381bc9c3cd05a84191a597e1
make -C "$HOME/ethos-agent-checks" build
export PATH="$HOME/ethos-agent-checks:$PATH"
```

Keep that directory ahead of the tap-installed binary on `PATH` in every
contributor and agent shell until a compatible release is installed.

Cloning this repository does not install Git hooks. With a compatible Ethos
binary on `PATH`, enable its local integration from this checkout:

```bash
sh scripts/setup-agent-checks.sh
```

The setup script checks command exit status and real post-edit execution,
rejects missing or older binaries, runs `ethos enable`, and verifies and executes
the installed Git pre-commit dispatcher. Ordinary
commits then run blocking style checks on staged `Formula/*.rb` files. Run
setup once per clone and again when upgrading Ethos; existing Git hooks are
chained by Ethos rather than replaced. Handoff checks also require the matching
[Ethos Claude Code plugin](https://github.com/punt-labs/ethos#install)
and its `SubagentStop` hook. Without these local integrations, the check-set
declarations alone do not enforce commit or handoff checks.

Edit checks are advisory; commit and handoff style checks block on failure.
Tap-wide audit remains the manual gate documented in `CLAUDE.md`.

Run contributor setup before using the generated agents, not just before
committing. Their generated commands fail open, with no fallback style check:
if `ethos` disappears from `PATH`, no edit feedback is available. Restore the
compatible binary and rerun setup. A separate repository PostToolUse hook emits
an advisory if Ethos leaves `PATH`, so missing-binary feedback does not depend
on Ethos itself. The explicit `~/.punt-hooks-kill` switch silences both hooks.
Only `Formula/*.rb` receives edit feedback. Shell, YAML, and Makefile edits no
longer invoke `make check`: this tap has no Makefile or `check` target, so that
old hook only failed on those edits. Check shell changes with `shellcheck`.

The generated skill references require both plugin namespaces,
`ethos:baseline-ops` and `ethos-dev:baseline-ops`; make the corresponding
Ethos and development-plugin installations available in Claude Code before
using these agents, following the upstream plugin setup instructions.
The binary setup script does not install Claude Code plugins.

The registry scopes this repository to `engineering`, but the project explicitly
selects `team: gstack` to retain its existing six generated gstack agents.

Agent regeneration uses team-registry identities, personalities, teams and
writing styles, with the global role defaults deployed by `ethos seed`.
The registry-only `qa-engineer` and `product-lead` roles supplement those
defaults. Do not replace seeded roles with `team/roles` symlinks: those are
different role definitions and would remove safety/output sections and
change tool grants. The committed agents reflect these layered inputs, not
the team repository's role definitions alone.
