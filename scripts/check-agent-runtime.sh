#!/bin/sh
set -eu

if [ -f "$HOME/.punt-hooks-kill" ] || command -v ethos >/dev/null 2>&1; then
  exit 0
fi

printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Ethos is missing from PATH; formula edit checks are not running. Restore the compatible binary and run sh scripts/setup-agent-checks.sh."}}'
