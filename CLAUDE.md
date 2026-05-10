# homebrew-tap

The Punt Labs Homebrew tap. Distributes pre-built binaries for the Go-based tools (`ethos`, `mcp-proxy`, `quarry`) that ship as platform binaries via GitHub Releases. Users install with `brew tap punt-labs/tap && brew install <name>`.

## Identity

You are **Claude Agento** (`claude`), an agent in the Punt Labs org. Repo identity is set by `.punt-labs/ethos.yaml` with `agent: claude` and `team: engineering`. SessionStart and PreCompact hooks inject the persona; sub-agent calls match `subagent_type` to ethos identity handles.

## Standards

This project follows [Punt Labs standards](https://github.com/punt-labs/punt-kit). When this CLAUDE.md conflicts with punt-kit standards, this file wins (most specific wins).

## What This Repo Does

A Homebrew tap is a Git repository containing Ruby formula files. Each formula:

- Names the tool, version, homepage, and license
- Declares per-platform binary URLs (darwin/arm64, darwin/amd64, linux/arm64, linux/amd64)
- Pins each URL to a SHA-256 checksum
- Installs the binary into the Cellar

The formula is updated whenever the upstream tool publishes a new GitHub Release. The user-facing experience is `brew upgrade`.

## Quality Gates

```bash
brew audit --tap=punt-labs/tap          # Audit all formulae in this tap
brew install --build-from-source Formula/<name>.rb   # Local install test
brew test <name>                                      # Run formula's test block
```

A formula change is not ready to merge until `brew audit` is clean and `brew install --build-from-source` succeeds on the local platform.

## Formula Conventions

- **Versioning**: the formula version matches the upstream Git tag (`v1.2.3` → `version "1.2.3"`).
- **URL pattern**: `https://github.com/punt-labs/<repo>/releases/download/v#{version}/<binary>-<os>-<arch>.tar.gz`.
- **SHA-256**: copy from the upstream release's `checksums.txt`. Never compute locally — the canonical digest is the one published with the release.
- **License**: matches upstream (typically MIT).
- **Test block**: minimum is `system "#{bin}/<binary>", "version"` returning successfully.
- **Caveats**: only when there is a real one (e.g., a daemon needing `brew services start`). Do not use caveats as marketing.

## Update Workflow

When an upstream tool ships a new release:

1. Pull the release's `checksums.txt` from GitHub.
2. Update `Formula/<name>.rb`: bump `version`, update each platform URL, paste each platform's SHA-256.
3. Run `brew audit Formula/<name>.rb` and `brew install --build-from-source Formula/<name>.rb`.
4. Update `CHANGELOG.md` under `## [Unreleased]` with the formula change.
5. Open a PR. Wait for CI; merge after green.

## Documentation Discipline

- **CHANGELOG.md** — every formula change gets an entry under `## [Unreleased]` with the format `<tool>: bump to vX.Y.Z`. Categories: Added (new formula), Changed (version bump), Removed.
- **README.md** — update the install instructions if a new tool is tapped or the install path changes.

## Pre-PR Checklist

- [ ] `brew audit --tap=punt-labs/tap` is clean
- [ ] `brew install --build-from-source` succeeds for every platform you can test (at minimum the local one)
- [ ] CHANGELOG entry under `## [Unreleased]`
- [ ] Per-platform SHA-256 values match the upstream `checksums.txt`

## Code Review Flow

Do not merge immediately after creating a PR. Expect 2–6 review cycles before merging.

1. **Create PR** — push branch, open PR via `mcp__github__create_pull_request`.
2. **Request Copilot review** — `mcp__github__request_copilot_review`.
3. **Watch for feedback in the background** — `gh pr checks <number> --watch` in a background task. Bots can take 1–3 minutes after CI completes.
4. **Read all feedback** — `mcp__github__pull_request_read` with `get_reviews` and `get_review_comments`.
5. **Address every comment.** No "pre-existing" excuses. If a checksum is wrong, the user gets a broken install — fix it.
6. **Fix, re-push, repeat** until the latest review is uneventful.
7. **Merge via `mcp__github__merge_pull_request`** when the last review was clean.

## Ethos & Delegation

Most homebrew-tap work is direct: bump a version, paste a checksum, update a URL. The work is small and mechanical, but a wrong SHA-256 or bad URL invalidates `brew install` for every user. Pair every change with an evaluator.

Within each row, the worker and evaluator must be distinct handles. Claude is the leader, never the evaluator.

| Task type | Worker | Evaluator |
|-----------|--------|-----------|
| Formula version bump (existing tool) | `claude` (leader, direct) | `adb` (Lovelace) — release/CI awareness |
| New formula (new tool tapped) | `claude` (leader) | `kth` (Hightower) — install path / operability |
| Caveats / install messaging | `claude` (leader, direct) | `dna` (Norman) — UX, error prevention |
| README install instructions | `claude` (leader, direct) | `claudia` (Massimo) — editorial |
| Cross-platform binary verification | `claude` (leader) | `bwk` (Kernighan) — Go-side build awareness |

The full org roster is available via `ethos identity list`. Use the `docs` pipeline for formula-only changes; otherwise direct dispatch is the right shape.

## Standards References

- [Distribution](https://github.com/punt-labs/punt-kit/blob/main/standards/distribution.md)
- [Release Process](https://github.com/punt-labs/punt-kit/blob/main/standards/release-process.md)
- [GitHub](https://github.com/punt-labs/punt-kit/blob/main/standards/github.md)
