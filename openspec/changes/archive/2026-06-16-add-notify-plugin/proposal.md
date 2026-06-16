## Why

Users step away while Claude Code works and miss the moment it stops to ask for permission or input, leaving sessions stalled. Because this marketplace distributes plugins whose hooks activate automatically on install, a plugin carrying a `Notification` lifecycle hook gives every installer attention alerts with zero per-user setup.

## What Changes

- Add a new standalone plugin `notify` (version 1.0.0) under `plugins/notify/`.
- The plugin registers a `Notification` lifecycle hook that shows a native desktop notification whenever Claude needs the user's attention — `osascript` on macOS, `notify-send` on Linux, PowerShell on Windows (Git Bash and WSL). When no supported notifier is available the hook exits silently.
- Register `notify` in the marketplace index (`.claude-plugin/marketplace.json`) and bump the marketplace version 1.0.4 → 1.1.0.
- Document the plugin in the root `README.md` table/structure and in `plugins/notify/README.md`.

## Capabilities

### New Capabilities
- `attention-notifications`: native desktop notification (macOS, Linux, Windows) delivered when Claude Code fires the `Notification` hook event (Claude is waiting for permission or input), with safe handling of arbitrary message payloads and a silent no-op when no notifier is available.

### Modified Capabilities

(none — base-skills and the existing marketplace behavior are untouched)

## Impact

- New files: `plugins/notify/.claude-plugin/plugin.json`, `plugins/notify/hooks/hooks.json`, `plugins/notify/hooks/scripts/notify.sh`, `plugins/notify/README.md`.
- Edited files: `.claude-plugin/marketplace.json` (new plugin entry, version bump), root `README.md` (plugins table, structure tree).
- No dependencies on other plugins or marketplaces; no changes to `base-skills`.
- CI: new JSON files are covered by validate.yml; `notify.sh` must pass shellcheck; new plugin starts at 1.0.0 satisfying the version-bump check.
