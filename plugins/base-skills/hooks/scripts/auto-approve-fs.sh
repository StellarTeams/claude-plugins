#!/bin/bash

# PreToolUse auto-approval for Read/Write/Edit/MultiEdit calls whose target lives
# inside the current project tree. Reading and (especially) writing files in the
# project is the bread-and-butter of a coding session; this approves those so the
# model isn't stopped on every file touch. Ships with the plugin, so every
# project that installs it benefits.
#
# Safety: only files resolving *inside* the project root are approved. The root
# is $CLAUDE_PROJECT_DIR (set by Claude Code for hooks), falling back to the cwd
# from the payload. Anything outside the tree is left to the normal permission
# prompt. The containment check uses a path boundary so a sibling directory like
# <root>-evil does not match.

input=$(cat)

file_path=""
cwd=""
if command -v jq >/dev/null 2>&1; then
  file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
  cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  file_path=$(printf '%s' "$input" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("file_path",""))' 2>/dev/null)
  cwd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
fi
[ -z "$file_path" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-$cwd}"
[ -z "$root" ] && exit 0

# Resolve file_path to an absolute, normalized path. python3's abspath handles
# `..` and relative paths without requiring the file to exist (Write targets may
# not yet). Fall back to a plain join when python3 is unavailable.
abs=""
if command -v python3 >/dev/null 2>&1; then
  abs=$(FP="$file_path" CWD="$cwd" python3 -c 'import os; print(os.path.abspath(os.path.join(os.environ["CWD"], os.environ["FP"])))' 2>/dev/null)
else
  case "$file_path" in
    /*) abs="$file_path" ;;
    *)  abs="$cwd/$file_path" ;;
  esac
fi
[ -z "$abs" ] && exit 0

# Approve only when abs is the root itself or sits beneath it (boundary-aware).
case "$abs" in
  "$root"|"$root"/*)
    cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"In-project file access auto-approved by base-skills plugin."}}
EOF
    ;;
esac

exit 0
