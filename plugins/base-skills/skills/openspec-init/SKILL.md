---
name: openspec-init
description: Initialize or re-initialize OpenSpec in the current project with Claude Code integration
user-invocable: true
allowed-tools: Bash(npx:*)
---

Set up OpenSpec in the current project so you can use spec-driven development with `/opsx:propose` and related commands.

**Steps**

1. Check if OpenSpec is already initialized by looking for `openspec/config.yaml`.

2. If already initialized, ask the user:
   > "OpenSpec is already set up in this project. Re-initialize and overwrite existing config?"
   - If yes, run with `--force`.
   - If no, stop and tell the user everything is already set up.

3. Run initialization:
   ```bash
   npx --yes @fission-ai/openspec@latest init --tools claude
   ```
   (Add `--force` if the user confirmed overwrite.)

4. Confirm success and remind the user:
   - Skills and commands are now available in `.claude/`
   - Restart Claude Code if slash commands like `/opsx:propose` are not yet visible
   - Start a change with `/opsx:propose "your idea"`
