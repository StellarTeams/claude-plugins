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

# OpenSpec migrates pre-profile installs to an explicit "custom" profile that
# freezes the then-current core workflow set, so workflows added to core later
# (e.g. `sync` in 1.6) never reach `openspec update`. When the custom set is
# exactly that old core set it's a migration artifact, not a user choice —
# switch to the dynamic "core" profile so updates pick up new workflows.
# A deliberately customized set (anything else) is left untouched.
upgrade_openspec_profile() {
  command -v openspec >/dev/null 2>&1 || return 0
  [ "$(openspec config get profile 2>/dev/null)" = "custom" ] || return 0
  workflows=$(openspec config get workflows 2>/dev/null | tr -d '][" ' | tr ',' '\n' | sort | paste -sd, -)
  [ "$workflows" = "apply,archive,explore,propose" ] || return 0
  openspec config profile core >/dev/null 2>&1 || true
}

# Does this project actually have the generated Claude Code integration?
# OpenSpec records nothing about configured tools in openspec/config.yaml — the
# CLI infers them from the generated files themselves, which its own init adds
# to .gitignore. So a fresh clone of a project that committed openspec/config.yaml
# has the config but none of the skills/commands, and `openspec update` then
# exits 0 with "No configured tools found" and regenerates nothing, leaving the
# /opsx:* commands permanently missing. Detect that state and re-init instead.
claude_tools_present() {
  [ -d ".claude/commands/opsx" ] || [ -n "$(find .claude/skills -maxdepth 1 -name 'openspec-*' -print -quit 2>/dev/null)" ]
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
upgrade_openspec_profile

if [ ! -f "openspec/config.yaml" ] || ! claude_tools_present; then
  ensure_openspec_cli
  # Keep init's own banner off stdout — this hook's stdout must be the JSON
  # object below and nothing else, or Claude Code cannot parse it.
  if run_openspec init --tools claude >/dev/null 2>&1; then
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
