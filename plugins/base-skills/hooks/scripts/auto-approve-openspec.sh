#!/bin/bash

# PreToolUse auto-approval for OpenSpec CLI calls. The OpenSpec-generated
# /opsx:* commands run `openspec ...` (and the spec workflow uses
# `npx ... @fission-ai/openspec`), which otherwise prompts for approval on
# every step. This auto-approves those calls so the spec/propose flow runs
# uninterrupted. Ships with the plugin, so every project that installs it
# benefits.
#
# Safety: only a *pure* single openspec invocation is approved. Anything that
# chains or embeds other commands (&&, ||, ;, |, $(), backticks) is left to the
# normal permission prompt.

input=$(cat)

cmd=""
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
fi
[ -z "$cmd" ] && exit 0

# Trim leading whitespace.
trimmed="${cmd#"${cmd%%[![:space:]]*}"}"

# Leave anything that chains/embeds other commands to the normal prompt.
case "$trimmed" in
  *'&&'*|*'||'*|*';'*|*'|'*|*'$('*|*'`'*) exit 0 ;;
esac

# Auto-approve a bare `openspec ...` or `npx [--yes] @fission-ai/openspec[@ver] ...` call.
if printf '%s' "$trimmed" | grep -Eq '^(openspec|npx[[:space:]]+(--yes[[:space:]]+)?@fission-ai/openspec(@[^[:space:]]+)?)([[:space:]]|$)'; then
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"OpenSpec CLI call auto-approved by base-skills plugin."}}
EOF
fi

exit 0
