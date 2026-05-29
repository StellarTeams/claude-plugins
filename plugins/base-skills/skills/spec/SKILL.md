---
name: spec
description: Turn a request into a ready-to-implement spec — worktree and proposal in one command
allowed-tools: Bash(which:*), Bash(git worktree:*), Bash(git rev-parse:*), Bash(openspec:*), Bash(npx --yes @fission-ai/openspec@latest:*), Write, EnterWorktree
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

5. **Hand off to OpenSpec**:
   ```bash
   which openspec
   ```
   - If found, invoke the `OPSX: Propose` skill passing the original request as the argument.
   - If not found, run directly:
     ```bash
     npx --yes @fission-ai/openspec@latest new change "<request>"
     ```