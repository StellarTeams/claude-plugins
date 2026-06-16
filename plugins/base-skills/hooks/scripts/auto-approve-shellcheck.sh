#!/bin/bash

# PreToolUse auto-approval for shellcheck calls. This marketplace's CI lints
# every hook script, so developing plugins means running shellcheck (directly
# or via npx) constantly — and each run otherwise triggers a permission
# prompt. shellcheck only reads files and prints findings, so approving a
# pure invocation is safe.
#
# Safety: only a *pure* single shellcheck invocation is approved. Anything
# that chains or embeds other commands (&&, ||, ;, |, $(), backticks) is left
# to the normal permission prompt.

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

# Auto-approve a bare `shellcheck ...` or an npx-wrapped one
# (`npx shellcheck ...`, `npx --yes shellcheck@latest ...`).
if printf '%s' "$trimmed" | grep -Eq '^(shellcheck|npx[[:space:]]+((--yes|-y)[[:space:]]+)?shellcheck(@[^[:space:]]*)?)([[:space:]]|$)'; then
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"shellcheck call auto-approved by base-skills plugin."}}
EOF
fi

exit 0
