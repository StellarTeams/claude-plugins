#!/bin/bash

# Auto-initialize OpenSpec if not already set up in the current project
if [ ! -f "openspec/config.yaml" ]; then
  echo '{"additionalContext": "OpenSpec not found in this project — running `openspec init --tools claude` to set it up automatically..."}' >&2
  npx --yes @fission-ai/openspec@latest init --tools claude 2>&1
  if [ $? -eq 0 ]; then
    echo '{"additionalContext": "OpenSpec initialized successfully. Skills and commands are ready in .claude/. Restart Claude Code if slash commands are not yet visible."}'
  else
    echo '{"additionalContext": "⚠️ OpenSpec init failed. Run `npx @fission-ai/openspec init --tools claude` manually to set it up."}'
  fi
fi

exit 0
