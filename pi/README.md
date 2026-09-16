# Pi Subagents & Skills

This directory contains pi subagent and skill definitions, adapted from the opencode config in `~/dotfiles/opencode/.config/opencode/`.

## Structure

```
pi/
├── agents/           # Symlink: ~/.pi/agent/agents/
│   ├── orchestrator.md
│   ├── dev-huddle.md
│   ├── develop.md
│   ├── review.md
│   ├── test.md
│   ├── archivist.md
│   ├── discovery.md
│   └── documenter.md
├── skills/          # Symlink: ~/.pi/agent/skills/
│   ├── commit/
│   ├── jira/
│   ├── opencode-kanban-cli/
│   ├── pr/
│   ├── recaptcha/
│   └── ticket/
└── README.md
```

## Installation with Stow

**Note:** This package lives outside `~/.config`, so you must specify the target explicitly:

```bash
cd ~/dotfiles
stow --target=$HOME/.pi/agent -v pi
```

This creates:
```
~/.pi/agent/agents/ -> ~/dotfiles/pi/agents/
~/.pi/agent/skills/ -> ~/dotfiles/pi/skills/
```

## Subagents

| Agent | Purpose |
|-------|---------|
| `orchestrator` | Coordinates workflow: dev-huddle → develop → review → test → PR |
| `dev-huddle` | Create execution plan from Jira ticket and initialize ADR |
| `develop` | Implement plan with human-in-the-loop approval |
| `review` | Check implementation against plan (SOLID, YAGNI, DRY, security) |
| `test` | Run test suite (unit, integration, E2E) |
| `archivist` | Memory specialist - manages ADRs and knowledge graph |
| `discovery` | Discuss next features, create tickets |
| `documenter` | Document functions/components without modifying code |

## Skills

| Skill | Purpose |
|-------|---------|
| `commit` | Commit workflow - conventional commits, hook handling, staging policy |
| `jira` | Jira integration - read/write tickets, comments, transitions, JQL |
| `opencode-kanban-cli` | Kanban CLI - task/category operations, project management |
| `pr` | Pull request - create/update PRs with mermaid diagrams |
| `recaptcha` | Google reCAPTCHA Enterprise integration for TanStack Start |
| `ticket` | Ticket creation - interview user, create Jira tickets |

## Stow Notes

- Stow creates symlinks by default.
- After stow, verify:
  - `ls -la ~/.pi/agent/agents/`
  - `ls -la ~/.pi/agent/skills/`
