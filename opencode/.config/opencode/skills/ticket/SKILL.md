---
name: ticket
description: Creates a ticket for a feature
---

## ticket

use this skill to create tickets for a feature

## When to use

- When an agent wants to create a new feature
- When a subagent wants to create a new feature
- When the user is creating a new feature

### IMPORTANT

- **NEVER** write any code — not even examples or snippets
- **NEVER** install any packages or dependencies  
- **NEVER** include implementation details in the feature plan
- **NEVER** create JSON files manually — opencode-kanban has its own internal ticket storage

## Instructions

1. Query Jira for available projects/boards and present them to the user
2. Ask user which Jira board they want to use
3. Ask what feature they're building
4. Interview user relentlessly about every aspect of the feature until we reach a shared understanding
5. Present a plan for the feature with tickets
6. Ask for feedback and debate the plan
7. Create tickets in Jira ONLY when user approves
