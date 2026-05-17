---
name: OpenSpec Init
description: Initialize or re-initialize OpenSpec in the current project with Claude Code integration
user-invocable: true
allowed-tools: Bash(command:*), Bash(npm:*), Bash(openspec:*), Bash(npx:*)
---

Set up OpenSpec in the current project so you can use spec-driven development with `/opsx:propose` and related commands.

**Steps**

1. Check if OpenSpec is already initialized by looking for `openspec/config.yaml`.

2. If already initialized, ask the user:
   > "OpenSpec is already set up in this project. Re-initialize and overwrite existing config?"
   - If yes, run with `--force`.
   - If no, stop and tell the user everything is already set up.

3. Check whether the `openspec` CLI is installed globally:
   ```bash
   command -v openspec
   ```
   - If found, use the global binary in step 4.
   - If not found, install it globally:
     ```bash
     npm install -g @fission-ai/openspec
     ```
     If the install fails due to permissions, fall back to `npx --yes @fission-ai/openspec@latest` for step 4 and tell the user they may want to fix npm's global prefix (e.g. via `nvm` or `npm config set prefix`) so future runs use the global binary.

4. Run initialization (use `openspec` if installed globally, otherwise `npx --yes @fission-ai/openspec@latest`):
   ```bash
   openspec init --tools claude
   ```
   (Add `--force` if the user confirmed overwrite.)

5. Confirm success and remind the user:
   - Skills and commands are now available in `.claude/`
   - Restart Claude Code if slash commands like `/opsx:propose` are not yet visible
   - Start a change with `/opsx:propose "your idea"`
