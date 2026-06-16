## Context

This repo is a Claude Code plugin marketplace: pure JSON, shell scripts, and Markdown — no build step, no package manager. Plugins distribute lifecycle hooks that activate automatically for every installer. The only existing plugin, `base-skills` (v1.6.0), establishes the conventions to follow: `hooks/hooks.json` declares `"type": "command"` hooks with a `timeout`, scripts live in `hooks/scripts/`, `${CLAUDE_PLUGIN_ROOT}` resolves the plugin directory at runtime, and scripts parse the hook's JSON stdin payload with `jq` (python3 fallback) — see `plugins/base-skills/hooks/scripts/init-openspec.sh`.

The user decided in plan review: a **separate plugin named `notify`** (not part of base-skills), **banner only** (no sound), triggered on the **`Notification` hook event** (Claude waiting for permission or input). The original macOS-only scope was later revised by the user to **cross-platform** (macOS, Linux, Windows).

## Goals / Non-Goals

**Goals:**
- Anyone who installs `notify@stellarteams` automatically gets a native desktop notification when Claude needs attention — no configuration, on macOS, Linux, and Windows (Git Bash and WSL).
- No dependencies the user must install: `osascript` ships with macOS, `powershell.exe` with Windows, and `notify-send` (libnotify) is preinstalled on mainstream desktop Linux distros. Where a notifier is genuinely absent (e.g. headless Linux), the script degrades to a silent no-op.
- Pass existing CI (JSON validity, shellcheck, per-plugin version check).

**Non-Goals:**
- No Stop/SessionStart triggers, no sounds (explicitly declined in plan review).
- No installing notification tools on the user's behalf (e.g. `apt install libnotify-bin`) — absent tooling means a silent no-op, never a prompt or error.
- No changes to `base-skills` or to CI workflows.

## Decisions

1. **Standalone `notify` plugin over extending `base-skills`** — user's explicit choice; keeps notifications opt-in per plugin and independently versioned.
2. **Per-platform dispatch on `uname`, single script** — one `notify.sh` keeps the plugin's hook declaration trivial and shellcheck coverage complete:
   - `Darwin` → `osascript` (built into every macOS install; `terminal-notifier` rejected as an external dependency the marketplace cannot guarantee).
   - `Linux` → `notify-send` if on `PATH` (covers desktop distros and WSLg); otherwise, if running under WSL (`/proc/version` contains `microsoft`) and `powershell.exe` is reachable, use the Windows path below.
   - `MINGW*`/`MSYS*`/`CYGWIN*` (Git Bash on native Windows) → `powershell.exe`.
   - Anything else, or no notifier found → silent exit 0.
3. **Message passed out-of-band, never string-interpolated** — the hook payload's `message` field is arbitrary text; interpolating it into interpreted source would allow quote-breaking/injection on every platform:
   - **macOS**: AppleScript reads it from argv:
     ```sh
     osascript - "$msg" <<'EOF'
     on run argv
       display notification (item 1 of argv) with title "Claude Code"
     end run
     EOF
     ```
   - **Linux**: `notify-send -- "Claude Code" "$msg"` — plain argv; `--` stops a message starting with `-` from being parsed as an option.
   - **Windows**: the message is exported as `CLAUDE_NOTIFY_MSG` and the PowerShell snippet reads `$env:CLAUDE_NOTIFY_MSG` — the `-Command` string itself is a constant, so no payload text ever enters PowerShell source. Under WSL, `WSLENV=CLAUDE_NOTIFY_MSG/u` is prepended so the variable crosses the WSL→Windows boundary. The snippet shows a `System.Windows.Forms.NotifyIcon` balloon tip (renders as a native toast on Windows 10/11, needs no modules or App ID registration).
4. **`jq` with python3 fallback for payload parsing** — matches the established pattern in `base-skills` scripts; degrades to the default message "Claude needs your attention" when both are unavailable or `message` is empty.
5. **Always exit 0** — a notification failure must never surface as a hook error in the user's session. Notification hooks gate nothing, so the script emits no stdout.
6. **Marketplace version 1.0.4 → 1.1.0** — adding a plugin is a minor marketplace change; the plugin itself starts at 1.0.0.

## Risks / Trade-offs

- [macOS notification permissions may block banners for the host terminal app] → document in `plugins/notify/README.md` that users must allow notifications for their terminal/IDE in System Settings.
- [Headless Linux / servers / containers have no `notify-send` or no display] → silent no-op is intentional and documented; no error noise in those sessions.
- [`powershell.exe` call from WSL/Git Bash is slow (~1–2 s cold start)] → acceptable for a fire-and-forget notification; the 10 s hook timeout covers it and the hook gates nothing.
- [NotifyIcon balloon behavior varies with Windows focus-assist/do-not-disturb settings] → same constraint applies to any toast mechanism; documented in the README alongside the macOS permission note.
- [Hook payload shape could change across Claude Code versions] → script only reads the optional `message` field and falls back to a default string, so missing/renamed fields degrade gracefully rather than fail.
