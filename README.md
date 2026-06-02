# claude-plugins

A marketplace of Claude Code plugins by StellarTeam.

## Plugins

| Plugin | Description |
|-------------------------------------------|------------------------------------------------------------------------------------------------------|
| [**base-skills**](./plugins/base-skills/) | Git workflow and spec-driven development — commit messages, worktree + plan-mode research, and OpenSpec auto-setup |

## Install

```bash
/plugin marketplace add StellarTeam/claude-plugins
```

Then install a specific plugin:

```bash
/plugin install base-skills@StellarTeam/claude-plugins
```

## Structure

```
plugins/
└── base-skills/                    # Git workflow + OpenSpec integration
    ├── .claude-plugin/plugin.json  # Plugin metadata
    ├── skills/                     # Claude Code skills
    └── hooks/                      # SessionStart + PreToolUse automation
```
