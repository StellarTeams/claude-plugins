#!/bin/bash

# PreToolUse auto-approval for project-local node_modules binaries. Running tools
# that live under the project's node_modules (tsc, biome, eslint, vitest, ...) is
# routine in a JS/TS session, and each invocation otherwise triggers a permission
# prompt. This approves a command when its *first token* is a path resolving
# inside $CLAUDE_PROJECT_DIR/node_modules. Ships with the plugin, so every project
# that installs it benefits.
#
# Safety: only a single command whose first token is an explicit path into the
# project's node_modules is approved (e.g. ./node_modules/.bin/tsc,
# node_modules/.bin/biome, or the absolute equivalent). Bare names like `tsc`,
# wrappers like `npx tsc`, and anything that chains or embeds other commands
# (&&, ||, ;, |, $(), backticks) are left to the normal permission prompt. The
# containment check uses a path boundary so a sibling like <root>-evil/node_modules
# does not match, and `..`-traversal is normalized away before the check.

input=$(cat)

cmd=""
cwd=""
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
  cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
  cwd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
fi
[ -z "$cmd" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-$cwd}"
[ -z "$root" ] && exit 0

# Trim leading whitespace.
trimmed="${cmd#"${cmd%%[![:space:]]*}"}"

# Leave anything that chains/embeds other commands to the normal prompt.
case "$trimmed" in
  *'&&'*|*'||'*|*';'*|*'|'*|*'$('*|*'`'*) exit 0 ;;
esac

# First whitespace-delimited token is the binary being invoked.
read -r token _ <<EOF
$trimmed
EOF
[ -z "$token" ] && exit 0

# Must look like a path (contains a slash); bare names like `tsc` are not matched.
case "$token" in
  */*) ;;
  *) exit 0 ;;
esac

# Resolve the token to an absolute, normalized path. python3's abspath handles
# `..` and relative paths without requiring the file to exist. Fall back to a
# plain join when python3 is unavailable.
abs=""
if command -v python3 >/dev/null 2>&1; then
  abs=$(TOK="$token" CWD="$cwd" python3 -c 'import os; print(os.path.abspath(os.path.join(os.environ["CWD"], os.environ["TOK"])))' 2>/dev/null)
else
  case "$token" in
    /*) abs="$token" ;;
    *)  abs="$cwd/$token" ;;
  esac
fi
[ -z "$abs" ] && exit 0

# Approve only when the binary sits inside the project's node_modules (boundary-aware).
case "$abs" in
  "$root"/node_modules/*)
    cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Project node_modules binary auto-approved by base-skills plugin."}}
EOF
    ;;
esac

exit 0
