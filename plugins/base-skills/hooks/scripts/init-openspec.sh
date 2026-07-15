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

# Keep an already-installed `openspec` on the latest version. Updates go
# through the package manager that owns the binary (npm/pnpm/yarn/bun) and are
# throttled to once a day via a stamp file, so session start stays fast and
# works offline.
update_openspec_cli() {
  bin=$(command -v openspec) || return 0

  stamp="${TMPDIR:-/tmp}/claude-openspec-update-check"
  if [ -f "$stamp" ] && [ -n "$(find "$stamp" -mtime -1 2>/dev/null)" ]; then
    return 0
  fi
  touch "$stamp"

  case "$bin" in
    */pnpm/*) pnpm add -g @fission-ai/openspec@latest >/dev/null 2>&1 ;;
    */.bun/*) bun add -g @fission-ai/openspec@latest >/dev/null 2>&1 ;;
    */yarn/* | */.yarn/*) yarn global add @fission-ai/openspec@latest >/dev/null 2>&1 ;;
    *) npm install -g @fission-ai/openspec@latest >/dev/null 2>&1 ;;
  esac
  return 0
}

# Run an OpenSpec command via the global binary if present, else via npx.
run_openspec() {
  if command -v openspec >/dev/null 2>&1; then
    openspec "$@"
  else
    npx --yes @fission-ai/openspec@latest "$@"
  fi
}

update_openspec_cli

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
  # Keep this project's generated .claude skills/commands in sync with the CLI.
  # `openspec update` is a no-op when files are already up to date, and the CLI
  # update above is throttled globally, so this is what carries a new CLI
  # version into each project's instruction files.
  run_openspec update >/dev/null 2>&1 || true
fi

exit 0
