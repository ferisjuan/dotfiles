---
name: commit
description: makes a commit
---

## ticket

Use this skill to make a commit

## When to use

- When an agent wants to commit code
- When a subagent wants to commit code
- When the user to commit code

### IMPORTANT

- **ALWAYS** prefix the commit message with the branch code in brackets, followed by the type and a colon. Format: `[{branch-code}] {type}: title` (e.g., `[RED-5] feat: add login form`)
- **ALWAYS** use one of these types: `feat`, `bug`, `chore`, `docs`, `test`, `refactor`, `style`, `ci`, `perf`
- **Always** include the `JIRA ticket ID` in the commit body
- **Always** include the `JIRA ticket summary` in the commit body
- **Always** include a short and descriptive commit message

## Instructions

1. Use `git commit` to make a commit
