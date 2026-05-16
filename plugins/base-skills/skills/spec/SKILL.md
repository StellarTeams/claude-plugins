---
name: spec
description: Turn a request into a ready-to-implement spec — branch and proposal in one command
allowed-tools: Bash(openspec:*), Bash(git switch:*), Write
user-invocable: true
---

Start a new feature or bugfix by creating a branch and proposing a change in one step.

**Steps**

1. **Get the request** from `$ARGUMENTS`. If empty, use the **AskUserQuestion tool** to ask:
   > "What feature or bugfix do you want to work on?"

2. **Derive the branch name** from the request:
   - Lowercase the request summary
   - Replace spaces, slashes, and special characters with `-`
   - Collapse consecutive `-` into one and strip leading/trailing `-`
   - Keep it under 50 characters
   - Example: "Add support to XXX service" → `add-support-to-xxx-service`

3. **Create and switch to the branch**:
```bash
   git switch -c <branch-name>
```
- If the branch already exists, append `-2` (or increment the suffix) and retry once.
- Report the branch name to the user: `"Switched to branch '<branch-name>'"`

4. **Hand off to OpenSpec** — invoke `/opsx:propose` passing the original request as the argument so it generates the proposal, design, and tasks automatically. Do not repeat what opsx:propose will ask; just pass the request through.
   If OpenSpec is not available, tell the user: "OpenSpec is required. Install it with `npm install -g @fission-ai/openspec@latest`." and stop.