# base-skills

Git workflow and spec-driven development tools for Claude Code.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| **commit-message** | Ask Claude to commit | Analyzes staged git diff and proposes a `<type>:` prefixed commit message |
| **spec** | `/spec <idea>` | Creates a git worktree from your idea, researches the change in plan mode for your approval, then hands off to `/opsx:propose` |
| **openspec-init** | `/openspec-init` | Manually initialize or re-initialize OpenSpec in the current project |
| **coding-guidelines** | Loaded by `/spec`, or on request | Behavioral guidelines that curb common LLM coding mistakes — surgical changes, simplicity, verifiable success criteria |

## Hooks

This plugin ships automation that runs without any manual setup:

**SessionStart**
- **OpenSpec auto-init** — when you start a session in a project without OpenSpec, runs `openspec init --tools claude` for you. Creates `openspec/config.yaml` and the `/opsx:*` slash commands in `.claude/`.
- **Commit convention** — injects the `<type>:` commit-message convention into context so commits follow it even when the skill isn't explicitly invoked.

**PreToolUse**
- **guard-git** — intercepts any automatic `git commit` / `git push` and turns it into an explicit confirmation prompt, keeping a human in the loop.
- **auto-approve-openspec** — auto-approves pure `openspec` / `npx @fission-ai/openspec` calls so the spec/propose flow runs uninterrupted.

## Install

```bash
/plugin marketplace add StellarTeams/claude-plugins
/plugin install base-skills@stellarteams
```

## Dependencies

| Dependency | How it's handled |
|-----------|-----------------|
| **context7** | Auto-installed as a plugin dependency |
| **@fission-ai/openspec** | Auto-run via `npx` (or global install) — no manual setup needed; provides the `/opsx:*` commands |

## Usage

### Commit a change

Stage your files and ask Claude:
> "Create a commit message"

Claude will analyze the diff and propose a message like:
```
feat: add user authentication via JWT
Adds login/logout endpoints and token refresh flow to support stateless auth.
```

### Start a new feature

```
/spec Add Stripe payment support
```

This runs the full spec flow:

1. Creates a worktree at `../my-repo-add-stripe-payment-support` on a new branch, leaving your current working tree untouched.
2. Initializes OpenSpec in the worktree if it isn't already.
3. **Enters plan mode** to research the change against the codebase, then presents a plan for you to **review and approve**.
4. Feeds the approved plan to `/opsx:propose`, which authors `proposal.md`, `design.md`, and `tasks.md`.
5. Offers to open the worktree in WebStorm or Zed.

### Re-initialize OpenSpec

If you need to reset or update your OpenSpec setup:

```
/openspec-init
```
