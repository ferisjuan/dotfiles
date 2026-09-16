---
name: opencode-kanban-cli
description: Documents the opencode-kanban CLI contract and provides correct command patterns for task/category operations.
---

# opencode-kanban-cli

Use this skill to run `opencode-kanban` commands correctly and avoid common argument mistakes.

## When to use

- The user asks how to use `opencode-kanban` from terminal scripts.
- The user hits CLI parsing errors (`--project`, `--id`, selector conflicts).
- The user needs ready-to-copy command examples for task/category workflows.

## Important: No project create command

There is **NO** `project create` command in the CLI. You cannot create a project from the terminal.
- If a project doesn't exist, the CLI returns `PROJECT_NOT_FOUND`.
- You MUST create the project manually in the TUI (`opencode-kanban`) first.
- Only then can you use the CLI for task/category operations.

## Instructions

1. Start by applying these global CLI rules:
   - For all non-TUI commands, `--project <PROJECT>` is required.
   - `--project` and `--json` are global and can appear before or after subcommands.
   - **The project must already exist**, otherwise the CLI returns `PROJECT_NOT_FOUND`.

2. Use command groups exactly as follows:
   - `task list [--repo <REPO>] [--category-id <UUID> | --category-slug <SLUG>] [--archived]`
   - `task create --title <TEXT> --branch <BRANCH> --repo <REPO> [--category-id <UUID> | --category-slug <SLUG>]`
   - `task move --id <TASK_ID_OR_PREFIX> (--category-id <UUID> | --category-slug <SLUG>)`
   - `task show --id <TASK_ID_OR_PREFIX>`
   - `task archive --id <TASK_ID_OR_PREFIX>`
   - `category list`
   - `category create --name <TEXT> [--slug <SLUG>]`
   - `category update --id <CATEGORY_ID> [--name <TEXT>] [--slug <SLUG>] [--position <N>]`
   - `category delete --id <CATEGORY_ID>`

3. Follow selector semantics precisely:
   - Category destination selectors are mutually exclusive: use exactly one of `--category-id` or `--category-slug` when required.
   - `task move` requires one category selector.
   - `task show`, `task move`, and `task archive` accept full UUID or unique short ID prefix from table output (for example `e11ad40a`).
   - `--repo` accepts either a repo name or the repo path (matching registered repos).

4. Be explicit about `task create` behavior:
   - It performs the same creation workflow as TUI: validates branch, resolves base branch, fetches/checks base, creates git worktree, creates tmux session, then persists task runtime metadata.
   - If any step fails, it rolls back created artifacts (task row, tmux session, worktree) when possible.

5. Prefer these validated examples:

```bash
# Global flags can be placed after subcommands
opencode-kanban task list --project test --json

# Create task with full workflow (worktree + tmux session + metadata)
opencode-kanban task create --project test --title "Refactor parser" --branch feature/refactor-parser --repo /path/to/repo --category-slug todo

# Move using short task id prefix from table output
opencode-kanban task move --project test --id e11ad40a --category-slug in-progress

# Show categories as pretty table
opencode-kanban category list --project test
```

1. If user reports an error, map it quickly:
   - `PROJECT_REQUIRED` -> missing `--project`
   - `PROJECT_NOT_FOUND` -> project DB does not exist yet
   - `UNIQUE_CONSTRAINT` on create -> duplicate `(repo, branch)`
   - `TASK_ID_AMBIGUOUS` -> provide longer task id prefix
   - `CATEGORY_SELECTOR_CONFLICT` -> both category selectors were provided

## Jira Integration

There is no `jira sync` command. To import Jira tickets into opencode-kanban:

1. Use Jira MCP to query issues from your board:

   ```
   jira_searchJiraIssuesUsingJql (jql: "project = BULK AND status != Done")
   ```

2. Check if the opencode-kanban project exists (use `--json` for machine parsing):

   ```
   opencode-kanban category list --project BULK --json
   ```

   - If you get `PROJECT_NOT_FOUND`, ask the user for authorization to create the project.

3. For each Jira issue, create a task using the CLI:

   ```
   opencode-kanban task create --project BULK --title "BULK-123: Fix login bug" --branch fix/login-bug --repo /path/to/repo --category-slug todo
   ```

4. Include the Jira key (e.g., `BULK-123`) in the title for traceability.

**Example workflow:**

```bash
# Check if project exists (if not, ask user to create it)
opencode-kanban category list --project BULK --json

# List categories to find the right slug
opencode-kanban category list --project BULK --json

# Create task from Jira issue (note: you must have the repo registered)
opencode-kanban task create --project BULK --title "BULK-42: Add user profile page" --branch feature/user-profile --repo myrepo --category-slug todo
```

**IMPORTANT:** There is no `project create` command. Projects must be created in the TUI (`opencode-kanban`) first.

1. Verify the category (column) exists before creating tasks:

   ```
   opencode-kanban category list --project BULK --json
   ```

   - Check the output for the desired `--category-slug` (e.g., `todo`, `in-progress`, `done`)
   - If the desired category doesn't exist, ask the user for authorization to create it via TUI or use `category create`:

     ```
     opencode-kanban category create --project BULK --name "To Do" --slug todo
     ```

**Full workflow:**

```bash
# 1. Check if project exists
opencode-kanban category list --project BULK --json

# 2. List categories to find slugs (or create missing ones)
opencode-kanban category list --project BULK --json

# 3. Create task in correct category
opencode-kanban task create --project BULK --title "BULK-42: Add user profile" --branch feature/user-profile --repo myrepo --category-slug todo
```

