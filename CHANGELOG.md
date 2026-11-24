# Changelog

All notable changes to homebrew-tap will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- biff: add formula (v1.16.0)
- quarry-menubar: add formula (v0.5.0)

### Changed

- ethos: bump to v5.2.2
- ethos: bump to v5.2.1
- ethos: bump to v5.2.0
- Require released Ethos v5.2.0 or later for contributor agent checks instead of
  a pinned development build.
- Migrate generated agent checks to Ethos advisory formula-edit style checks and
  blocking commit/handoff style checks; retain audit as a manual gate.
- quarry-menubar: bump to v0.6.0
- quarry-menubar: bump to v0.6.1
- quarry-menubar: bump to v0.6.2
- quarry-menubar: bump to v0.6.3
- ethos: bump to v4.8.0
- ethos: bump to v4.9.0
- ethos: bump to v4.10.0
- Vendor the gstack ethos team under `.punt-labs/ethos/` and set
  `resolution: repo-only`, so a fresh clone resolves its ethos identities
  without the retired team-registry submodule or a global store.
- quarry: bump to v3.6.0
- quarry: bump to v3.9.0
- quarry: bump to v3.9.1

### Fixed

- mcp-proxy: infer v0.1.0 from the release URLs and verify all four release
  binaries with the published SHA-256 checksums.
- ethos config resolves layered again so the engineering team, seeded pipelines and the claude leader identity resolve alongside the vendored gstack team

## [0.1.0] - 2026-03-12

### Added

- Initial formulae for mcp-proxy and quarry
- Ethos formula (v0.3.4)
