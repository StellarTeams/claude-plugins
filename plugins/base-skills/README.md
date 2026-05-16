# base-skills

Git workflow and spec-driven development tools for Claude Code.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| **commit-message** | Ask Claude to commit | Analyzes staged git diff and proposes a commit message with emoji prefix |
| **start-change** | `/start-change <idea>` | Creates a git branch from your idea and hands off to `/opsx:propose` |
| **openspec-init** | `/openspec-init` | Manually initialize or re-initialize OpenSpec in the current project |

## Auto-setup

When you start a Claude Code session in a project that doesn't have OpenSpec initialized, this plugin automatically runs `openspec init --tools claude` for you. No manual setup needed.

What gets created:
- `openspec/config.yaml` — spec-driven workflow config
- `.claude/skills/` and `.claude/commands/` — OpenSpec slash commands (`/opsx:propose`, etc.)

## Install

```bash
/plugin marketplace add StellarTeam/claude-base-skills
/plugin install base-skills@StellarTeam/claude-base-skills
```

## Dependencies

| Dependency | How it's handled |
|-----------|-----------------|
| **context7** | Auto-installed as a plugin dependency |
| **@fission-ai/openspec** | Auto-run via `npx` — no global install needed |
| **opsx** | Required for `start-change`. Install separately if needed |

## Usage

### Commit a change

Stage your files and ask Claude:
> "Create a commit message"

Claude will analyze the diff and propose a message like:
```
✨ feat: add user authentication via JWT
Adds login/logout endpoints and token refresh flow to support stateless auth.
```

### Start a new feature

```
/start-change Add Stripe payment support
```

This creates a branch `add-stripe-payment-support`, switches to it, and opens an OpenSpec proposal automatically.

### Re-initialize OpenSpec

If you need to reset or update your OpenSpec setup:

```
/openspec-init
```
