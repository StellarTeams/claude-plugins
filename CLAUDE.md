# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code **plugin marketplace** maintained by StellarTeam. It publishes plugins that users install via `/plugin marketplace add StellarTeam/claude-plugins`. There is no build step, no test runner, and no package manager — everything is JSON, shell scripts, and Markdown.

## Plugin structure

Each plugin lives under `plugins/<name>/` and must contain:

- `.claude-plugin/plugin.json` — plugin metadata (name, version, description, dependencies)
- `skills/<skill-name>/SKILL.md` — one file per skill; frontmatter declares `name`, `description`, `allowed-tools`, and optionally `user-invocable: true`
- `hooks/hooks.json` — declares `SessionStart` (or other lifecycle) hooks that run shell commands automatically
- `hooks/scripts/` — shell scripts called by hooks

The top-level `.claude-plugin/marketplace.json` is the marketplace index: it lists every plugin in this repo with its `source` path and `dependencies`.

## Key conventions

**Skills (`SKILL.md`)** — The frontmatter `allowed-tools` field is a whitelist of tools the skill may use (e.g. `Bash(git diff --staged)`). Skills that should be user-invocable via a slash command need `user-invocable: true`. The body is the prompt Claude receives when the skill is triggered.

**Hooks (`hooks.json`)** — `${CLAUDE_PLUGIN_ROOT}` expands to the plugin's root directory at runtime. Hooks use `"type": "command"` with a `timeout` in seconds. Output written to stderr with `{"additionalContext": "..."}` format surfaces a message to Claude.

**Plugin dependencies** — declared in both `plugin.json` and `marketplace.json`. Cross-marketplace dependencies (e.g. `context7@claude-plugins-official`) are allowed only for marketplaces listed in `allowCrossMarketplaceDependenciesOn`.

## CI

- **Release** (`release.yml`) — runs on the 1st of each month (and manually); calls the shared `StellarTeams/GHA.workflows` changelog workflow. No secrets required.
- **Notify** (`notify.yml`) — posts to Slack when a PR merges to `main`. Requires `SLACK_BOT_TOKEN` and `SLACK_CHANNEL_ID` secrets.

## Adding a new plugin

1. Create `plugins/<name>/` with `.claude-plugin/plugin.json`, `skills/`, and (if needed) `hooks/`.
2. Register it in `.claude-plugin/marketplace.json` under `"plugins"`.
3. Document it in the root `README.md` table and in `plugins/<name>/README.md`.

## Adding a skill to an existing plugin

1. Create `plugins/<plugin>/skills/<skill-name>/SKILL.md` with correct frontmatter.
2. If the skill needs to run on session start, add a hook entry to `hooks/hooks.json`.