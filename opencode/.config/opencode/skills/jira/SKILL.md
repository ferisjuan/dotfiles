---
name: jira
description: >-
  Jira integration for the orchestrator and all subagents. Use when:
  - Fetching a Jira ticket (jira_getJiraIssue)
  - Adding comments to a Jira ticket (jira_addCommentToJiraIssue)
  - Creating Jira tickets (jira_createJiraIssue)
  - Searching Jira issues (jira_searchJiraIssuesUsingJql)
  - Updating Jira issues (jira_editJiraIssue)
  - Transitioning Jira issues (jira_transitionJiraIssue)
  - Getting project metadata (jira_getVisibleJiraProjects)
  - Accessing Atlassian resources to get cloudId

  NOTE: discovery/ticket agent has its own dedicated skill at `skills/ticket/SKILL.md`.
  This skill is for READ/WRITE operations on existing tickets.
---

## Jira MCP Server

The Jira MCP server is available as the `jira` tool namespace. All Jira operations
use the `jira_*` tools documented in the system prompt.

### Getting the cloudId

Before any Jira operation, you need the cloudId. Use `jira_getAccessibleAtlassianResources`:

```typescript
jira_getAccessibleAtlassianResources() → { id, url, name }
```

Use the `id` field as `cloudId` for all other Jira tools.

---

## Reading a Jira Ticket

### Step 1: Get cloudId

```typescript
jira_getAccessibleAtlassianResources() 
// Returns: { id: "2a6b1170-...", url: "https://ferisjuan.atlassian.net", name: "ferisjuan" }
```

### Step 2: Fetch the ticket

```typescript
jira_getJiraIssue({
  cloudId: "2a6b1170-...",  // From step 1
  issueIdOrKey: "BULK-56",
  fields: ["summary", "description", "status", "issuetype", "priority", "labels", "assignee", "reporter", "created", "updated"],
})
```

### What to read from a Jira ticket

| Field | When to use |
|-------|-------------|
| `summary` | Branch name, commit prefix, plan title |
| `description` | Full technical requirements, acceptance criteria, subtasks |
| `status` | To check if it's "To Do", "In Progress", "Done" |
| `issuetype` | Task, Story, Bug, Epic — affects workflow |
| `priority` | High/Medium/Low — affects task prioritization |
| `labels` | Billing, eps, regulatory, rips — context for scope |
| `assignee` | Who is responsible |
| `reporter` | Who created it |
| `created` / `updated` | Age of ticket |

### Ticket Content Structure

A well-formed Jira ticket for development should contain:

```
## Summary
One-line description of the feature

## Business Context
Why this matters for users/business

## Technical Requirements
### Specific field requirements
### Integration points
### Data models

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2
```

---

## Adding Comments to a Jira Ticket

```typescript
jira_addCommentToJiraIssue({
  cloudId: "2a6b1170-...",
  issueIdOrKey: "BULK-56",
  commentBody: "## Dev Huddle Findings\n\n### Architecture\n...",
  contentFormat: "markdown",
})
```

**Best practices for comments:**
- Use markdown for structured content
- Include code blocks, tables, and headers for readability
- Link to plan.md, ADR, and PR on the branch
- Add "Status:" section noting if planning/implementation/deferred

---

## Creating a Jira Ticket

```typescript
jira_createJiraIssue({
  cloudId: "2a6b1170-...",
  projectKey: "BULK",
  issueTypeName: "Task",
  summary: "RIPS Generation System",
  description: "## Summary\n\nImplement RIPS...",
  assignee_account_id: "5ba15e1564a35f4858f0f6c0",  // Optional
  additional_fields: {
    labels: ["billing", "rips"],
    priority: { name: "High" },
  },
})
```

### Issue Types

| Type | Use for |
|------|---------|
| Task | Small, distinct pieces of work |
| Story | User-facing feature |
| Bug | Defect fix |
| Epic | Large feature spanning multiple sprints |

---

## Updating a Jira Ticket

```typescript
jira_editJiraIssue({
  cloudId: "2a6b1170-...",
  issueIdOrKey: "BULK-56",
  fields: {
    summary: "Updated summary",
    description: "Updated description",
    // Or transition to a status:
  },
})
```

### Transitioning Status

```typescript
jira_getTransitionsForJiraIssue({
  cloudId: "2a6b1170-...",
  issueIdOrKey: "BULK-56",
})

// Then:
jira_transitionJiraIssue({
  cloudId: "2a6b1170-...",
  issueIdOrKey: "BULK-56",
  transition: { id: "31" },  // From getTransitions response
})
```

---

## Searching Jira

```typescript
jira_searchJiraIssuesUsingJql({
  cloudId: "2a6b1170-...",
  jql: "project = BULK AND status = 'In Progress' ORDER BY updated DESC",
  maxResults: 20,
  fields: ["key", "summary", "status", "assignee"],
})
```

### Common JQL Patterns

| JQL | Purpose |
|-----|---------|
| `project = BULK AND status = 'To Do'` | Backlog |
| `project = BULK AND assignee = currentUser()` | My tickets |
| `project = BULK AND labels IN ('rips', 'billing')` | By label |
| `project = BULK AND issuetype = Epic` | Epics |
| `project = BULK ORDER BY updated DESC` | Recently updated |

---

## Jira Convention: Ticket Language

**All Jira tickets MUST be written in English.** If a ticket is in Spanish (or any other language), ask the user to rewrite it in English before proceeding with dev-huddle.

**Why:** The dev-huddle agent reads the ticket directly. Subagents may not handle non-English content correctly.

---

## Jira Convention: Ticket Key Prefix

Each project has a Jira prefix. Check `{projectPath}/AGENTS.md` for the prefix.

For this project (`bulkya`): **BULK-** prefix (e.g., `BULK-55`, `BULK-44`)

---

## When to Update Jira

### During Dev Huddle
- After creating plan.md and ADR, add a comment to the Jira ticket with:
  - Architecture decisions
  - Data model changes
  - Files to create/modify
  - Research items still needed
  - Link to PR

### After PR Merge
- Transition ticket to "Done" if fully implemented
- Add comment summarizing what was done

### When Priorities Change
- Add comment explaining why implementation is deferred
- Link to the planning PR

---

## Parent/Child Relationships

Many tickets are part of an Epic. When fetching, check for:
- `parent` field in the issue response
- `jira_getJiraIssue` returns `parent` if it's a subtask

### Creating Subtasks

```typescript
jira_createJiraIssue({
  cloudId: "...",
  projectKey: "BULK",
  issueTypeName: "Subtask",
  summary: "Implement Invoice model",
  parent: "BULK-56",  // Parent ticket key
})
```

---

## Labels Convention

Common labels for this project:
- `billing` — invoicing, payments
- `eps` — EPS-related features
- `regulatory` — compliance (RIPS, DIAN, etc.)
- `rips` — RIPS generation
- `fhir` — FHIR-related
- `clinic-history` — clinic history features

Labels help with searching and understanding scope.

---

## Orchestrator: Jira Workflow

1. **Session start**: Ask user for Jira ticket number
2. **Confirm prefix**: Verify it's the correct project prefix (e.g., BULK-)
3. **Invoke dev-huddle** with the ticket number — dev-huddle reads Jira FIRST, then vault, then creates plan + ADR + product docs
4. **Update Jira**: Add comment with architecture findings
5. **After PR**: Update ticket status, add PR link

---

## Vault-Second Workflow (dev-huddle agent)

**After querying Jira, read vault context to inform the plan:**

1. Read `bulkya-vault/reference/PROJECT_SUMMARY.md` — tech stack, key files, conventions
2. Read `bulkya-vault/reference/KEY_PATTERNS.md` — must-follow patterns (dense)
3. Read `bulkya-vault/reference/CURRENT_WORK.md` — active tickets, blockers
4. Read `bulkya-vault/adr/README.md` — index of all ADRs
5. Search `bulkya-vault/adr/` for related ADRs (grep for keywords from ticket title)
6. Read relevant existing ADRs to understand prior decisions
7. Update `bulkya-vault/product/happy-path.md` if the feature introduces a new user scenario
8. Update `bulkya-vault/product/market.md` if the feature affects target segments

**Why:** Jira tells you WHAT to build; the vault tells you HOW and what's already been decided.

---

## Dev Huddle Agent: Jira Usage

The dev-huddle agent receives the ticket number from the orchestrator and MUST:

**Step 1 — Call `jira_getJiraIssue` FIRST** to understand what to build:
- Summary (for branch name, plan title)
- Description (for context and requirements)
- Acceptance criteria (for plan.md criteria)
- Subtasks (for task breakdown)
- Labels (for scope understanding)

**Step 2 — Read vault context SECOND** (see "Vault-Second Workflow" above):
- This prevents re-solving solved problems
- Surfaces blockers from active work
- Ensures pattern consistency

**Step 3 — Include Jira ticket key in:**
   - Branch name: `BULK-56-rips-generation-system`
   - Commit messages: `feat(56): ...`
   - PR title: `BULK-56 ...`
   - ADR: `adr-bulk-56-rips-generation-system.md`

---

## Discovery Agent: Jira Usage

The discovery/ticket agent has its own skill at `skills/ticket/SKILL.md`.

For creating NEW tickets (not reading existing ones), use that skill.

---

## Self-Enhancement Log

### 2026-07-24 — Orchestrator must get explicit approval before creating Jira tickets

- **Decision:** User explicitly directed to skip ticket creation and just commit/PR the planning work. The orchestrator should not create Jira tickets without explicit user approval.
- **Rule:** When user says "skip ticket" or "just commit", do not create any Jira tickets. Only update/comment on existing tickets.
- **Applies to:** global | orchestrator | all agents
