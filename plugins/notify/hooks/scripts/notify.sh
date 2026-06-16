#!/bin/bash

# Notification hook: shows a native desktop notification when Claude Code
# needs the user's attention (waiting for permission or input).
#
# Platform dispatch: osascript on macOS, notify-send on Linux (incl. WSLg),
# powershell.exe on Windows (Git Bash, or WSL without notify-send). When no
# notifier is available this is a silent no-op — a Notification hook gates
# nothing, so it must never emit stdout or surface an error into the session.

input=$(cat)

msg=""
if command -v jq >/dev/null 2>&1; then
  msg=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  msg=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("message") or "")' 2>/dev/null)
fi
[ -z "$msg" ] && msg="Claude needs your attention"

# The message is arbitrary text from the hook payload. It is only ever handed
# to a notifier out-of-band — argv for osascript/notify-send, an environment
# variable for PowerShell — never interpolated into interpreted source, so it
# cannot inject script code or options.

notify_windows() {
  # shellcheck disable=SC2016 # PowerShell must expand $env:..., not bash
  CLAUDE_NOTIFY_MSG="$msg" WSLENV="CLAUDE_NOTIFY_MSG/u:${WSLENV:-}" \
    powershell.exe -NoProfile -Command '
      Add-Type -AssemblyName System.Windows.Forms, System.Drawing
      $n = New-Object System.Windows.Forms.NotifyIcon
      $n.Icon = [System.Drawing.SystemIcons]::Information
      $n.Visible = $true
      $n.BalloonTipTitle = "Claude Code"
      $n.BalloonTipText = $env:CLAUDE_NOTIFY_MSG
      $n.ShowBalloonTip(5000)
      Start-Sleep -Seconds 4
      $n.Dispose()
    ' >/dev/null 2>&1
}

case "$(uname)" in
  Darwin)
    osascript - "$msg" >/dev/null 2>&1 <<'EOF'
on run argv
  display notification (item 1 of argv) with title "Claude Code"
end run
EOF
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send -- "Claude Code" "$msg" >/dev/null 2>&1
    elif grep -qi microsoft /proc/version 2>/dev/null \
      && command -v powershell.exe >/dev/null 2>&1; then
      notify_windows
    fi
    ;;
  MINGW* | MSYS* | CYGWIN*)
    if command -v powershell.exe >/dev/null 2>&1; then
      notify_windows
    fi
    ;;
esac

exit 0
