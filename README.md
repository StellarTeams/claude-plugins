# claude-plugins

A marketplace of Claude Code plugins by StellarTeams.

## Plugins

| Plugin | Description |
|-------------------------------------------|------------------------------------------------------------------------------------------------------|
| [**base-skills**](./plugins/base-skills/) | Git workflow and spec-driven development — commit messages, worktree + plan-mode research, and OpenSpec auto-setup |

## Install

```bash
/plugin marketplace add StellarTeams/claude-plugins
```

Then install a specific plugin:

```bash
/plugin install base-skills@stellarteams
```

## Structure

```
plugins/
└── base-skills/                    # Git workflow + OpenSpec integration
    ├── .claude-plugin/plugin.json  # Plugin metadata
    ├── skills/                     # Claude Code skills
    └── hooks/                      # SessionStart + PreToolUse automation
```
