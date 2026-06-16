## 1. Plugin scaffold

- [x] 1.1 Create `plugins/notify/.claude-plugin/plugin.json` — name `notify`, version `1.0.0`, description, category `productivity`, no dependencies
- [x] 1.2 Create `plugins/notify/hooks/hooks.json` registering the `Notification` event running `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/notify.sh` with a 10s timeout

## 2. Notification script

- [x] 2.1 Create `plugins/notify/hooks/scripts/notify.sh` skeleton: parse `message` from stdin JSON with jq (python3 fallback, default "Claude needs your attention"); dispatch on `uname`; always exit 0, no stdout
- [x] 2.2 macOS branch (`Darwin`): show banner via injection-safe `osascript - "$msg"` argv pattern
- [x] 2.3 Linux branch (`Linux`): use `notify-send -- "Claude Code" "$msg"` when on `PATH`; when absent under WSL (`/proc/version` contains `microsoft`) and `powershell.exe` is reachable, fall through to the Windows branch; otherwise exit 0 silently
- [x] 2.4 Windows branch (`MINGW*`/`MSYS*`/`CYGWIN*`, or WSL fall-through): export message as `CLAUDE_NOTIFY_MSG` (prepend `WSLENV=CLAUDE_NOTIFY_MSG/u` under WSL) and show a NotifyIcon balloon via a constant `powershell.exe -NoProfile -Command` string that reads `$env:CLAUDE_NOTIFY_MSG`
- [x] 2.5 Verify `shellcheck plugins/notify/hooks/scripts/notify.sh` passes clean

## 3. Marketplace registration & docs

- [x] 3.1 Add `notify` entry to `.claude-plugin/marketplace.json` (source `./plugins/notify`, category `productivity`, no dependencies) and bump marketplace version 1.0.4 → 1.1.0
- [x] 3.2 Create `plugins/notify/README.md` — what it does, install command, platform support table (macOS/Linux/Windows incl. WSL), macOS terminal notification-permission note, Windows focus-assist note, headless-Linux no-op note
- [x] 3.3 Add `notify` row to root `README.md` plugins table and structure tree

## 4. Verification

- [x] 4.1 Validate all tracked JSON files with jq (mirrors CI validate.yml)
- [x] 4.2 Manual end-to-end on this machine (macOS): `echo '{"hook_event_name":"Notification","message":"test alert"}' | bash plugins/notify/hooks/scripts/notify.sh` shows a "Claude Code" banner; empty/garbage input exits 0 silently; message with quotes/backslashes/leading `-` renders verbatim
- [x] 4.3 Simulate other platforms locally: stub `uname`/`command -v` in a test harness to verify the Linux branch builds the exact `notify-send -- …` argv, the Windows branch passes the message only via `CLAUDE_NOTIFY_MSG`, and the no-notifier path exits 0 with no output (real Linux/Windows verification deferred to those machines)
