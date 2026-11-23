#!/bin/sh
set -eu

if [ -f "$HOME/.punt-hooks-kill" ]; then
  exit 0
fi

if command -v ethos >/dev/null 2>&1 && probe=$(printf '{}' | ethos hook post-edit 2>/dev/null); then
  case "$probe" in
    *'post-edit input: tool_input.file_path is required'*) exit 0 ;;
  esac
fi

printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Ethos is missing or incompatible on PATH; formula edit checks are not running. Install Ethos v5.2.0 or later and run sh scripts/setup-agent-checks.sh."}}'
