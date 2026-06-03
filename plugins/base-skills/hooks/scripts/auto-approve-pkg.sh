#!/bin/bash

# PreToolUse auto-approval for pnpm / bun calls. Working in a JS/TS project means
# running these constantly (install, run, build, test, dev, dlx, ...), and each
# one otherwise triggers a permission prompt. This auto-approves them so the
# inner-loop stays uninterrupted. Ships with the plugin, so every project that
# installs it benefits.
#
# Safety: only a *pure* single pnpm/bun invocation is approved. Anything that
# chains or embeds other commands (&&, ||, ;, |, $(), backticks) is left to the
# normal permission prompt. The separate `pnpx`/`bunx` binaries are intentionally
# NOT matched here — only the `pnpm` and `bun` binaries are (which still covers
# `pnpm dlx ...` and `bun x ...`).

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

# Auto-approve a bare `pnpm ...` or `bun ...` call (any subcommand).
if printf '%s' "$trimmed" | grep -Eq '^(pnpm|bun)([[:space:]]|$)'; then
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"pnpm/bun call auto-approved by base-skills plugin."}}
EOF
fi

exit 0
