# Multi-Agent Orchestrator

## Workflow
dev-huddle → develop → review → test → PR

## Communication Pattern
All subagents communicate ONLY with the orchestrator. Never talk to each other.

```
Human ←→ Orchestrator ←→ Agent
```

## Orchestrator

**orchestrator** (ses_2000a588bffe59r2JydnLoiq6W)
- General orchestrator that coordinates all subagents
- Asks user for Jira ticket number
- Runs dev-huddle to create plan.md
- Runs develop with human-in-the-loop at each step
- Runs review, writes issues to plan.md if any
- Loops develop → review until clean
- Runs test
- Creates PR
- After workflow completion (PR created), deletes the {projectPath}/plan.md file

## Subagents

**dev-huddle** (ses_200088095ffeQ2lRaItp6aKkya)
- Receives Jira ticket number and project path from orchestrator
- Queries Jira using jira_getJiraIssue
- Creates {projectPath}/plan.md with:
  - Ticket summary
  - Implementation tasks (no code)
  - Acceptance criteria
- Reports completion to orchestrator

**develop** (ses_2000867b3ffeaqamdmj2GDwlIK)
- Receives task from orchestrator (one at a time)
- Before first task: checks out main, pulls latest, creates feature branch using ticket number and title
- Workflow for each task:
  1. Shows human what will be done
  2. Waits for user approval before executing
  3. Implements the task after approval
  4. Commits changes excluding plan.md
  5. Reports completion to orchestrator
- If issues encountered, reports to orchestrator

**Branch naming:** `{TICKET_NUMBER}-{slugified-title}` (e.g., `PROJ-123-fix-login-issue`)

**review** (ses_200087438ffegptQC05LUZh5PK)
- Receives plan.md path and project path from orchestrator
- Reads plan.md
- Reviews implemented code against plan
- Reports: REVIEW_CLEAN or REVIEW_ISSUES with list
- Does NOT fix issues, only reports

**test** (ses_20008df9bffeil2wtp0CJuft7b)
- Receives project path from orchestrator
- Finds test framework (package.json, pyproject.toml, etc.)
- Runs tests
- Reports: TEST_PASS or TEST_FAIL with details
- After successful tests, commits changes excluding plan.md

## Plan File
Location: {projectPath}/plan.md
- **Note:** plan.md is a temporary workflow artifact and must never be committed to the repository.

Format:
```markdown
# Plan: [TICKET_NUMBER]

## Summary
[Ticket description]

## Tasks
1. Task one
2. Task two

## Acceptance Criteria
- Criteria 1
- Criteria 2

## Review Issues (populated by review agent)
## Test Results (populated by test agent)
```

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service -- even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer -- your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and the user's question, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and the user's full question (not single words)
4. Answer using the fetched docs
<!-- context7 -->
