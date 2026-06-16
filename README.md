# claude-plugins

A marketplace of Claude Code plugins by StellarTeams.

## Plugins

| Plugin | Description |
|-------------------------------------------|------------------------------------------------------------------------------------------------------|
| [**base-skills**](./plugins/base-skills/) | Git workflow and spec-driven development — commit messages, worktree + plan-mode research, and OpenSpec auto-setup |
| [**notify**](./plugins/notify/)           | Native desktop notification when Claude Code needs your attention — macOS, Linux and Windows |

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
├── base-skills/                    # Git workflow + OpenSpec integration
│   ├── .claude-plugin/plugin.json  # Plugin metadata
│   ├── skills/                     # Claude Code skills
│   └── hooks/                      # SessionStart + PreToolUse automation
└── notify/                         # Desktop notifications when Claude needs attention
    ├── .claude-plugin/plugin.json  # Plugin metadata
    └── hooks/                      # Notification hook + notify.sh script
```
