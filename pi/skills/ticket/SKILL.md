---
name: ticket
description: >-
  Ticket creation workflow — interviews the user, builds a feature plan,
  then delegates to the jira skill for actual Jira ticket creation.
---

## ticket

Use this skill to create tickets for a feature.

## When to use

- When an agent wants to plan and create a new feature ticket
- When a subagent wants to plan and create a new feature ticket
- When the user is creating a new feature

## Workflow

1. **Interview the user** — ask which Jira project, what feature they're building, and drill into every aspect until you reach a shared understanding.
2. **Present a plan** — show the ticket breakdown with titles and acceptance criteria.
3. **Get approval** — only create tickets when the user explicitly approves.
4. **Create via `jira` skill** — for the actual `jira_createJiraIssue` calls, load `skill(name="jira")`.

### IMPORTANT

- **NEVER** write any code — not even examples or snippets.
- **NEVER** install any packages or dependencies.
- **NEVER** include implementation details in the feature plan.
- **NEVER** create JSON files manually — opencode-kanban has its own internal ticket storage.
- **Delegate to `jira` skill** for all `jira_*` tool calls (get cloudId, create issue, etc.).

## Instructions

1. Load `skill(name="jira")` for Jira API access.
2. Query Jira for available projects/boards and present them to the user.
3. Ask user which Jira board they want to use.
4. Ask what feature they're building.
5. Interview user relentlessly about every aspect of the feature until you reach a shared understanding.
6. Present a plan for the feature with tickets.
7. Ask for feedback and debate the plan.
8. Create tickets in Jira ONLY when user approves — using `jira_createJiraIssue`.
