#!/bin/bash

# The OpenSpec-generated /opsx:* commands (and `openspec status/instructions/...`)
# call the bare `openspec` binary. If it isn't on PATH they fail with exit 127.
# Ensure a real `openspec` is resolvable (one-time global install), so every
# downstream skill and generated command works regardless of where it runs.
# npx remains the fallback if we can't install globally.
ensure_openspec_cli() {
  if command -v openspec >/dev/null 2>&1; then
    return 0
  fi
  if command -v npm >/dev/null 2>&1; then
    npm install -g @fission-ai/openspec >/dev/null 2>&1
  fi
  command -v openspec >/dev/null 2>&1
}

# Run an OpenSpec command via the global binary if present, else via npx.
run_openspec() {
  if command -v openspec >/dev/null 2>&1; then
    openspec "$@"
  else
    npx --yes @fission-ai/openspec@latest "$@"
  fi
}

if [ ! -f "openspec/config.yaml" ]; then
  echo '{"additionalContext": "OpenSpec not found in this project — setting it up automatically..."}' >&2
  ensure_openspec_cli
  if run_openspec init --tools claude 2>&1; then
    echo '{"additionalContext": "OpenSpec initialized successfully. Skills and commands are ready in .claude/. Restart Claude Code if slash commands are not yet visible."}'
  else
    echo '{"additionalContext": "⚠️ OpenSpec init failed. Run `npx @fission-ai/openspec init --tools claude` manually to set it up."}'
  fi
else
  # Already initialized — still make sure the bare `openspec` command resolves
  # so the generated /opsx:* commands do not fail with exit 127.
  if ! ensure_openspec_cli; then
    echo '{"additionalContext": "⚠️ OpenSpec is set up but the `openspec` binary is not on PATH and could not be installed globally. The /opsx:* commands may fail with exit 127 — install it with `npm i -g @fission-ai/openspec`."}'
  fi
fi

exit 0
