#!/bin/bash

# SessionStart hook: print the commit-message convention to stdout.
# For SessionStart hooks, Claude Code adds stdout to the session context, so the
# convention is always present when commits are drafted — even if the
# commit-message skill itself isn't explicitly invoked. This injects context;
# it does not block or force any tool call.

cat <<'EOF'
When creating any git commit in this repository, follow this commit-message convention:
- Format: `<type>: <concise description>`, optionally followed by a body explaining WHY.
- Allowed types: feat, fix, refactor, docs, style, test, perf, chore, build, ci, revert, security, i18n, wip, deps, infra, idea.
- Use present tense; explain why, not just what.
- Do NOT add trailers/footers: no Co-Authored-By, no Signed-off-by, no "Generated with Claude Code".
- Propose the message and wait for user approval before committing.
EOF

exit 0
