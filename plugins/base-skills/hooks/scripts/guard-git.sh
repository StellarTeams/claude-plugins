#!/bin/bash

# PreToolUse guard for Bash calls. Claude must never push automatically: any
# `git push` is intercepted and turned into an explicit confirmation prompt, so
# a human is always in the loop before anything leaves the machine. Ships with
# the plugin, so every project that installs it gets the same protection.
#
# `git commit` is intentionally NOT intercepted. Commits are local and
# reversible, and a hook can't tell a user-requested commit from a model-
# initiated one. Commits are instead governed by the behavioral commit-
# convention instruction (propose the message, wait for approval), so commits
# the user asks for run without friction while the model still never commits on
# its own.

input=$(cat)

# Pull the command string out of the PreToolUse payload. Prefer a real JSON
# parser; fall back to scanning the raw payload if none is available.
cmd=""
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
fi
[ -z "$cmd" ] && cmd="$input"

# Match `git push` as the subcommand, allowing global options like `-C <dir>`
# or `-c key=val` between `git` and the subcommand.
if printf '%s' "$cmd" | grep -Eq '\bgit\b([[:space:]]+-[Cc][[:space:]]*[^[:space:]]+)*[[:space:]]+push\b'; then
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"This plugin blocks automatic git push. Claude must not push on its own — approve here only if you explicitly intend this push."}}
EOF
  exit 0
fi

exit 0
