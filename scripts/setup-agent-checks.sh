#!/bin/sh
set -eu

enabling=0
on_exit() {
  status=$?
  if [ "$status" -ne 0 ] && [ "$enabling" -eq 1 ]; then
    echo 'setup failed after enable began; Ethos may already be enabled and hooks or guides may have changed; inspect the output and retry after fixing the error' >&2
  fi
}
trap on_exit 0

if ! command -v ethos >/dev/null 2>&1; then
  echo 'agent checks require a compatible ethos binary on PATH; see README.md' >&2
  exit 1
fi

for hook in post-edit pre-commit; do
  if ! help=$(ethos hook "$hook" --help); then
    echo "ethos hook $hook --help failed; build the pinned contributor version in README.md" >&2
    exit 1
  fi
  if ! printf '%s\n' "$help" | grep -Fq "ethos hook $hook"; then
    echo "ethos lacks hook $hook; build the pinned contributor version in README.md" >&2
    exit 1
  fi
done

if ! probe=$(printf '{}' | ethos hook post-edit); then
  echo 'ethos post-edit execution failed; no integration was installed' >&2
  exit 1
fi
if ! printf '%s\n' "$probe" | grep -Fq 'post-edit input: tool_input.file_path is required'; then
  echo 'ethos post-edit did not return the expected advisory; no integration was installed' >&2
  exit 1
fi

enabling=1
ethos enable
hook=$(git rev-parse --git-path hooks/pre-commit)
if [ ! -x "$hook" ] || ! grep -Fq "_cap=\$(\"\$ethos_bin\" hook pre-commit;" "$hook"; then
  echo 'ethos pre-commit dispatcher was not installed; inspect your Git hooks setup' >&2
  exit 1
fi
"$hook"
echo 'agent checks ready: ordinary git commits invoke the Ethos pre-commit dispatcher'
