# Punt Labs Homebrew Tap

Homebrew formulae for [Punt Labs](https://github.com/punt-labs) tools.

## Install

```bash
brew tap punt-labs/tap
```

## Available Formulae

| Formula | Description | Install |
|---------|-------------|---------|
| `mcp-proxy` | Lightweight proxy bridging MCP stdio to shared daemon processes | `brew install punt-labs/tap/mcp-proxy` |
| `quarry` | Local semantic search engine | `brew install punt-labs/tap/quarry` |

### Quarry Daemon

Quarry includes a service definition. After installing:

```bash
brew services start quarry
```

This starts `quarry serve` on port 8420 at login, with automatic restart on crash.
