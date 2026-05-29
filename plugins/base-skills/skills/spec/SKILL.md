---
name: spec
description: Turn a request into a ready-to-implement spec — worktree and proposal in one command
allowed-tools: Bash(test:*), Bash(git worktree:*), Bash(git rev-parse:*), Bash(npx --yes @fission-ai/openspec@latest:*), Bash(open:*), Bash(code:*), Bash(webstorm:*), Bash(idea:*), Bash(cursor:*), Write, EnterWorktree
user-invocable: true
---

Start a new feature or bugfix by creating a branch and proposing a change in one step.

**Skills**

Always load and follow the `coding-guidelines` skill before generating spec.

**Steps**

1. **Get the request** from `$ARGUMENTS`. If empty, use the **AskUserQuestion tool** to ask:
   > "What feature or bugfix do you want to work on?"

2. **Derive the branch name** from the request:
   - kebab-case the request meaningful summary for branch name
   - Keep it under 50 characters
   - Example: "Add support to XXX service" → `add-support-to-xxx-service`

3. **Create a worktree for the branch** using two separate Bash calls (never combine into one shell pipeline — avoids the command substitution permission prompt):

   ```bash
   # Call 1 — get repo root path
   git rev-parse --show-toplevel
   # Extract the project name from the last path component (no shell command needed)
   # Call 2 — create the worktree
   git worktree add ../<project>-<branch-name> -b <branch-name>
   ```

   - If the branch or worktree already exists, append `-2` (or increment the suffix) and retry once.
   - Report both the worktree path and branch name to the user: `"Created worktree at '../<project>-<branch-name>' on branch '<branch-name>'"`

4. **Switch into the new worktree** using the `EnterWorktree` tool with the worktree path from step 3.

5. **Open the worktree in the IDE** so the editor follows the new branch. An IDE window is bound to the folder it opened and cannot be relocated, so this opens the worktree as a **new window** on the new branch — the user's original window stays on `main` and they can close it. Use whichever launcher is available (a JetBrains/VS Code CLI launcher on `PATH`, else macOS `open`), passing the worktree path from step 3:

   ```bash
   # Try a CLI launcher first (JetBrains: webstorm/idea; VS Code: code; Cursor: cursor)
   webstorm <worktree-path>
   # macOS fallback if no launcher is on PATH (adjust the app name to the installed IDE):
   open -na "WebStorm.app" --args <worktree-path>
   ```

   - Pick the command matching the user's IDE; don't run several. If none works, just print the worktree path and tell the user to open it manually.

6. **Ensure OpenSpec is initialized in the worktree.** The SessionStart hook only initializes OpenSpec in the directory the session started in; a freshly created worktree does **not** inherit it (no `.claude/` commands, no `openspec/config.yaml`). Check and initialize if missing:

   ```bash
   test -f openspec/config.yaml || npx --yes @fission-ai/openspec@latest init --tools claude
   ```

7. **Hand off to OpenSpec Propose.** Invoke the `OPSX: Propose` skill (the `/opsx:propose` command) passing the original request as the argument. It scaffolds the change **and** authors `proposal.md`, the spec deltas, and `tasks.md` — this is what produces the ready-to-implement spec.

   - If the `/opsx:propose` command/skill isn't yet available (it is loaded from `.claude/` at startup, so a worktree initialized mid-session may not expose it until a restart), tell the user to restart Claude Code in the worktree, then run `/opsx:propose "<request>"`.
   - Do **not** fall back to `npx … new change`: that only scaffolds an empty change and never writes the proposal content.