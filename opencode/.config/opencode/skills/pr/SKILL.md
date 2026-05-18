---
name: pr
description: Creates or updates a Pull Request with diff-based description and mermaid diagrams
---

## pr

Use this skill to create or update a Pull Request

## When to use

- When an agent wants to create a PR
- When a subagent wants to create a PR
- When the user is ready to open a PR

### IMPORTANT

- **ALWAYS** use the branch name to build the PR title
- **ALWAYS** generate a diff to build the PR description
- **ALWAYS** include mermaid diagrams:
  1. A flowchart explaining the changes
  2. A diagram showing modified files
  3. A diagram showing the app workflow
- If PR already exists, update it instead of creating a new one

## Instructions

### Step 1: Get branch and repo info

```bash
git branch --show-current
git remote get-url origin
```

### Step 2: Check if PR exists

```bash
gh pr view --json number,title,body --jq '.number' 2>/dev/null || echo "no-pr"
```

### Step 3: Generate the diff

```bash
git diff --stat origin/main...HEAD
git diff origin/main...HEAD
```

### Step 4: Build mermaid diagrams

From the diff, create three mermaid charts:

**1. Changes Flowchart:**

```mermaid
flowchart TD
    %% Build from git diff - inserted/deleted functions and files
```

**2. Modified Files:**

```mermaid
graph TD
    %% List modified files from git diff --stat
```

**3. App Workflow:**

```mermaid
sequenceDiagram
    %% Show the workflow based on changed files
```

### Step 5: Create or update PR

If no PR exists:

```bash
gh pr create --title "BRANCH_NAME" --body "DESCRIPTION_WITH_MERMAID"
```

If PR exists:

```bash
gh pr edit NUMBER --title "BRANCH_NAME" --body "DESCRIPTION_WITH_MERMAID"
```

## PR Body Template

```markdown
## Summary

<!-- One paragraph summary of changes -->

## Changes Flowchart

```mermaid
flowchart TD
    %% Dynamic content from diff
    A[Start] --> B{Changed}
    B --> C[New Flow]
    B --> D[Modified Flow]
```

## App Workflow

```mermaid
sequenceDiagram
    %% Based on changed components/apis
    participant Client
    participant API
    participant DB
    Client->>API: Request
    API->>DB: Query
    DB->>API: Response
    API->>Client: Result
```

## Diff

<details>
<summary>Full Diff</summary>

```diff
--DIFF OUTPUT--
```

</details>
```

## Verification

After creating/updating the PR, verify with:

```bash
gh pr view --web
```
