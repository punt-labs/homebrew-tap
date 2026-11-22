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
support the new edit hook. Put a compatible binary on `PATH`; installing the
tap's current formula alone does not provide edit feedback.

Cloning this repository does not install Git hooks. With a compatible Ethos
binary on `PATH`, enable its local integration from this checkout:

```bash
ethos enable
```

This installs the Git pre-commit dispatcher that runs blocking style checks
on staged `Formula/*.rb` files. Handoff checks also require the matching
[Ethos Claude Code plugin](https://github.com/punt-labs/ethos#install)
and its `SubagentStop` hook. Without these local integrations, the check-set
declarations alone do not enforce commit or handoff checks.

Edit checks are advisory; commit and handoff style checks block on failure.
Tap-wide audit remains the manual gate documented in `CLAUDE.md`.
