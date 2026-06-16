# attention-notifications

## Requirements

### Requirement: Notification hook is registered by the notify plugin
The `notify` plugin SHALL declare a `Notification` lifecycle hook in `plugins/notify/hooks/hooks.json` that runs `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/notify.sh` with a timeout, so the hook activates automatically for every installer with no configuration.

#### Scenario: Plugin installed
- **WHEN** a user installs `notify@stellarteams` and Claude Code fires the `Notification` event
- **THEN** Claude Code executes `notify.sh` from the plugin's `hooks/scripts/` directory

### Requirement: Native notification shown when Claude needs attention
`notify.sh` SHALL display a native desktop notification titled "Claude Code", with the body taken from the hook payload's `message` field, using the platform's built-in mechanism: `osascript` on macOS, `notify-send` on Linux, and `powershell.exe` on Windows (Git Bash) and under WSL when `notify-send` is unavailable.

#### Scenario: Payload contains a message (macOS)
- **WHEN** the script receives `{"hook_event_name":"Notification","message":"Claude needs your permission to use Bash"}` on stdin where `uname` is `Darwin`
- **THEN** a macOS banner titled "Claude Code" appears with that message as the body

#### Scenario: Payload contains a message (Linux desktop)
- **WHEN** the same payload arrives where `uname` is `Linux` and `notify-send` is on `PATH`
- **THEN** a libnotify notification titled "Claude Code" appears with that message as the body

#### Scenario: Payload contains a message (Windows)
- **WHEN** the same payload arrives under Git Bash (`uname` is `MINGW*`/`MSYS*`/`CYGWIN*`), or under WSL without `notify-send` but with `powershell.exe` reachable
- **THEN** a Windows notification titled "Claude Code" appears with that message as the body

#### Scenario: Payload message is missing or empty
- **WHEN** the script receives a payload with no usable `message` field (or unparseable input)
- **THEN** the notification appears with the fallback body "Claude needs your attention"

### Requirement: Message content is handled safely
The script SHALL pass the payload message to the platform notifier out-of-band — argv for `osascript` (with the AppleScript source constant) and `notify-send` (after a `--` option terminator), and an environment variable read via `$env:` for PowerShell (with the `-Command` string constant) — never by interpolating it into interpreted source, so arbitrary message content cannot inject script code or options.

#### Scenario: Message contains quotes and script syntax
- **WHEN** the payload message contains characters such as `"`, `\`, `$`, a leading `-`, or AppleScript/PowerShell keywords
- **THEN** the notification displays the text verbatim and no injected code or option parsing executes on any platform

### Requirement: Silent no-op when no notifier is available and on failures
The script SHALL exit 0 without output when no supported notification mechanism exists on the host (e.g. headless Linux without `notify-send`, unrecognized `uname`), and SHALL exit 0 even if notification delivery fails, so the hook never surfaces errors into the user's session.

#### Scenario: No notifier available
- **WHEN** the script runs where no supported notifier can be found (e.g. `uname` is `Linux` with no `notify-send` and no WSL `powershell.exe`, or an unrecognized platform)
- **THEN** it exits 0 with no output and no notification attempt

### Requirement: Plugin is published in the marketplace
The marketplace index `.claude-plugin/marketplace.json` SHALL list the `notify` plugin with source `./plugins/notify`, and the plugin SHALL carry its own version (starting at 1.0.0) in `plugins/notify/.claude-plugin/plugin.json`.

#### Scenario: Marketplace listing
- **WHEN** a user runs `/plugin install notify@stellarteams` after adding the StellarTeams marketplace
- **THEN** the plugin installs from `plugins/notify/` and its hooks become active
