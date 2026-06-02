---
name: spec
description: Turn a request into a ready-to-implement spec — worktree and proposal in one command
allowed-tools: Bash(test:*), Bash(git worktree:*), Bash(git rev-parse:*), Bash(npx --yes @fission-ai/openspec@latest:*), Bash(open:*), Bash(webstorm:*), Bash(zed:*), Write, Read, Grep, Glob, EnterWorktree, EnterPlanMode, ExitPlanMode, AskUserQuestion
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

   - **Do not ask about opening an editor here.** Switching the session into the worktree is *not* the moment to prompt for WebStorm/Zed — that is step 8, and only after the spec exists. Proceed straight to step 5.

5. **Ensure OpenSpec is initialized in the worktree.** The SessionStart hook only initializes OpenSpec in the directory the session started in; a freshly created worktree does **not** inherit it (no `.claude/` commands, no `openspec/config.yaml`). Check and initialize if missing:

   ```bash
   test -f openspec/config.yaml || npx --yes @fission-ai/openspec@latest init --tools claude
   ```

6. **Research the change in plan mode.** Before generating any spec, use plan mode to ground the proposal in the actual codebase and get the user's sign-off on the approach:

   - Call **`EnterPlanMode`** (the user consents to entering plan mode).
   - Explore the worktree with `Read` / `Grep` / `Glob` to understand existing patterns, the concrete files the change will touch, and any relevant constraints. Follow the already-loaded `coding-guidelines` skill — search for existing functions, utilities, and patterns to reuse **before** proposing new code.
   - Write the researched plan to the plan file named in the plan-mode system message (under `~/.claude/plans/`). Capture what `/opsx:propose` will need downstream: **the problem/context, the proposed approach, the concrete files to change, and how to verify** — so the same plan serves as both the user-facing approval artifact and the input to propose.
   - Call **`ExitPlanMode`** so the user reviews and approves the plan. Their approval authorizes the propose/artifact-writing that follows.

7. **Hand off to OpenSpec Propose, fed by the approved plan.** Invoke the `OPSX: Propose` skill (the `/opsx:propose` command) passing the original request as the change name/description. Ground its artifact authoring in the **approved plan** from step 6 (it is already in context; the plan file under `~/.claude/plans/` is also available to re-read) so that `proposal.md`, the spec deltas, and `tasks.md` are derived from the researched plan rather than the bare one-line request — this is what produces the ready-to-implement spec.

   - If the `/opsx:propose` command/skill isn't yet available (it is loaded from `.claude/` at startup, so a worktree initialized mid-session may not expose it until a restart), tell the user to restart Claude Code in the worktree, then run `/opsx:propose "<request>"`.
   - Do **not** fall back to `npx … new change`: that only scaffolds an empty change and never writes the proposal content.

8. **As the final step — and only after step 7 has produced the spec — ask the user whether to open the worktree in an editor.** This must be the *last* thing the skill does. Do not run this prompt earlier in the flow (in particular, not during or right after the worktree switch in step 4); if the spec from step 7 does not yet exist, you are too early. The spec is already generated and you're already switched into the worktree — this is purely about opening an editor window. Do **not** launch anything automatically. The **only** way to ask is the **AskUserQuestion tool** — wait for the user to select an option:
   - **Don't open** — leave editors as-is; just keep working in this session
   - **WebStorm** — open the worktree in WebStorm
   - **Zed** — open the worktree in Zed

   **Never prompt from the shell.** Do not use `read` / `read -p` (or any other shell prompt) to ask this — `read` is not in `allowed-tools`, and `read -p` silently fails under the user's zsh: there `-p` means "read from a coprocess", so it errors with `read: -p: no coprocess` and falls straight through without ever asking (this is the exact bug that made earlier runs skip this step). Always use the AskUserQuestion tool.

   An editor window is bound to the folder it opened and cannot be relocated, so opening launches the worktree as a **new window** on the new branch — the user's original window stays on `main` and they can close it. Based on the answer, run the matching launcher with the worktree path from step 3:

   ```bash
   # WebStorm (JetBrains CLI launcher; macOS fallback if not on PATH):
   webstorm <worktree-path> || open -na "WebStorm.app" --args <worktree-path>
   # Zed (CLI launcher; macOS fallback if not on PATH):
   zed <worktree-path> || open -na "Zed.app" --args <worktree-path>
   ```

   - Run only the launcher for the chosen editor; if the user picked "Don't open", skip the launch. If the launcher fails, print the worktree path and tell the user to open it manually.