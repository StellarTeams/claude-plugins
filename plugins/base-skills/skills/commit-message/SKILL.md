---
name: Commit message
description: Create a commit message by analyzing git diffs
allowed-tools: Bash(git status:*), Bash(git diff --staged), Bash(git commit:*), Bash(git add:*)
---

## Context:

- Current git status: !`git status`
- Current git diff: !`git diff --staged`

Analyze the above staged git changes and create a commit message. Use present tense and explain "why" something has changed, not just "what" has changed.

## Commit types with emojis:
Only use the following emojis:

- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Refactoring code
- `docs:` - Documentation
- `style:` - Styling/formatting
- `test:` - Tests
- `perf:` - Performance improvement
- `chore:` - Maintenance tasks, config changes
- `build:` - Build system or dependency changes
- `ci:` - CI/CD pipeline changes
- `revert:` - Reverting a previous commit
- `security:` - Security fixes or patches
- `i18n:` - Internationalization / localization
- `wip:` - Work in progress
- `deps:` - Adding or removing dependencies
- `infra:` - Infrastructure changes
- `idea:` - Experimental or exploratory commits

## Format:
Use the following format for making the commit message:

```
<type>: <concise_description>
<optional_body_explaining_why>
```

Do NOT include any trailers, signatures, or footers. Specifically:
- No `Co-Authored-By:` line
- No `Signed-off-by:` line
- No "Generated with Claude Code" footer

## Output:

1. Show a summary of changes currently staged
2. Propose commit a message with the appropriate emoji
3. Ask for confirmation before committing

DO NOT auto-commit - wait for user approval and only commit if the user says so.
