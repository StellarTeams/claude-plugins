---
name: spec
description: Turn a request into a ready-to-implement spec — worktree and proposal in one command
allowed-tools: Bash(git worktree:*), Bash(git rev-parse:*), Bash(basename:*), Write
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

3. **Create a worktree for the branch**:

   ```bash
   project=$(basename $(git rev-parse --show-toplevel))
   git worktree add ../${project}-<branch-name> -b <branch-name>
   ```

   - If the branch or worktree already exists, append `-2` (or increment the suffix) and retry once.
   - Report both the worktree path and branch name to the user: `"Created worktree at '../<project>-<branch-name>' on branch '<branch-name>'"`

4. **Hand off to OpenSpec** — invoke `OPSX: Propose` command passing the original request as the argument so it generates the proposal, design, and tasks automatically.