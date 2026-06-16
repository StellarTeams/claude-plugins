# notify

Shows a native desktop notification whenever Claude Code needs your attention — when it stops to ask for permission or waits for your input. Step away from the terminal without leaving your session stalled.

No configuration: install it and the `Notification` hook is active.

## Install

```bash
/plugin marketplace add StellarTeams/claude-plugins
/plugin install notify@stellarteams
```

## Platform support

| Platform | Mechanism | Notes |
|----------|-----------|-------|
| **macOS** | `osascript` banner | Built in — nothing to install |
| **Linux (desktop, WSLg)** | `notify-send` (libnotify) | Preinstalled on mainstream desktop distros |
| **Windows (Git Bash)** | PowerShell toast | Built in — nothing to install |
| **Windows (WSL)** | `notify-send` if present, else PowerShell toast | Built in — nothing to install |
| **Headless Linux / other** | — | Silent no-op, never an error |

## Notes

- **macOS**: if no banner appears, allow notifications for your terminal/IDE (e.g. Terminal, iTerm2, WebStorm) under **System Settings → Notifications**.
- **Windows**: focus assist / do-not-disturb can suppress the toast, as with any notification.
- **Headless or unsupported environments**: the hook exits silently — it never adds error noise to your session.

## How it works

`hooks/hooks.json` registers the `Notification` lifecycle event, which runs `hooks/scripts/notify.sh`. The script reads the hook's JSON payload from stdin, extracts the `message` field (falling back to "Claude needs your attention"), and dispatches to the platform notifier. The message is passed out-of-band (argv or an environment variable) so arbitrary payload text can never inject script code.
