#!/bin/sh
set -eu

if ! command -v ethos >/dev/null 2>&1; then
  echo 'agent checks require a compatible ethos binary on PATH; see README.md' >&2
  exit 1
fi

for hook in post-edit pre-commit; do
  if ! ethos hook "$hook" --help 2>/dev/null | grep -Fq "ethos hook $hook"; then
    echo "ethos lacks hook $hook; build the pinned contributor version in README.md" >&2
    exit 1
  fi
done

ethos enable
hook=$(git rev-parse --git-path hooks/pre-commit)
if [ ! -x "$hook" ] || ! grep -Fq 'ethos hook pre-commit' "$hook"; then
  echo 'ethos pre-commit dispatcher was not installed; inspect your Git hooks setup' >&2
  exit 1
fi
echo 'agent checks ready: ordinary git commits invoke the Ethos pre-commit dispatcher'
