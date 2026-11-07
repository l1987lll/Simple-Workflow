# Simple-Workflow

A simple AI Agent workflow with customizable roles and process documents.

## Layout

| Path | What it is |
|---|---|
| [`roles/`](roles/) | Role cards agents load to act in a capacity |
| [`workflows/`](workflows/) | Process documents (how Roles collaborate) |
| [`skills/`](skills/) | Skills that create or revise roles and workflows |
| [`.agents/skills/`](.agents/skills/) | Committed copy of `skills/` for tools that scan that path |
| [`runs/_template/`](runs/_template/) | STATUS and brief templates for a live run |
| [`docs/`](docs/) | Design specs for skills |
| [`GLOSSARY.md`](GLOSSARY.md) | Shared vocabulary |
| [`OPEN_ISSUES.md`](OPEN_ISSUES.md) | Open and deferred project issues |
| [`AGENTS.md`](AGENTS.md) | Branching rules for agents working in this repo |

`skills/` is the source of truth. After editing a skill, copy its folder into `.agents/skills/` so the two trees stay identical.

## Skills

| Skill | What it does |
|---|---|
| [`create-role`](skills/create-role/SKILL.md) | Interviews you, then scaffolds a Role card under `roles/<slug>/` (Role-Playbook default, or Role-merged) |
| [`define-workflow`](skills/define-workflow/SKILL.md) | Interviews you for harness, environment, support, workflow shape, and run state, then creates or revises a process document under `workflows/` |

## Roles

Roles live in [`roles/`](roles/), one folder each, written by [`create-role`](skills/create-role/SKILL.md).

A Role is a Markdown card an agent loads to act in that capacity. The default Role-Playbook layout splits it into a stable `ROLE.md` (name, slug, purpose, boundaries, required reading) and a mutable `PLAYBOOK.md` (responsibilities, steps, checklists, handoffs, when stuck, notes). Role-merged puts both in one file. Cards stay local to their own Role: cross-Role routing is not written into them.

| Role | Purpose |
|---|---|
| [`team-lead`](roles/team-lead/ROLE.md) | Clarifies tasks with the human, assigns and coordinates other Roles, and keeps work unblocked until it is done |
| [`research-architect`](roles/research-architect/ROLE.md) | Researches unfamiliar domains and hard design problems, and produces grounded architecture and plans without implementing code |
| [`developer`](roles/developer/ROLE.md) | Implements product changes across the stack—from UI through APIs and data—according to the agreed requirements |
| [`code-reviewer`](roles/code-reviewer/ROLE.md) | Reviews branch/PR changes against acceptance criteria, coding standards, commit rules, and review rules without implementing the fix |
| [`qa`](roles/qa/ROLE.md) | Tests the change as a tester or user: requirements and acceptance criteria, likely edge cases, and impact on existing features |
| [`closer`](roles/closer/ROLE.md) | Drives close-out once a task is accepted: cleanup, lessons learned, `/retro`, and human-confirmed follow-ups |

## Workflows

Process documents live in [`workflows/`](workflows/), written by [`define-workflow`](skills/define-workflow/SKILL.md). They record harness/environment pairs, support labels, conditions, Role participation, routes, run state, and caveats.

| Document | Shape | Typical targets |
|---|---|---|
| [`workflows/main-with-subagents.md`](workflows/main-with-subagents.md) | One main agent (`team-lead`); other Roles as sub-agents | Cursor + DSH (Local IDE chat) |
| [`workflows/all-main-agents.md`](workflows/all-main-agents.md) | Every Role is a main agent / bot | Grok Bot |

Which file a given harness should load is still open ([OI-001](OPEN_ISSUES.md)); Role cards currently point at the `workflows/` directory.

## Runs

A **run** is one team execution of a process document. Copy [`runs/_template/`](runs/_template/) to `runs/<run-id>/`, fill `STATUS.md` and `brief.md`, and let `team-lead` keep STATUS updated. Product code stays on the work branch; process artifacts stay under the run folder.

## Documents

- [`GLOSSARY.md`](GLOSSARY.md) — vocabulary for Role cards and process documents
- [`OPEN_ISSUES.md`](OPEN_ISSUES.md) — open and deferred issues
- [`AGENTS.md`](AGENTS.md) — work only on a branch; do not commit directly to `develop` or `master`
- [`docs/create-role/spec.md`](docs/create-role/spec.md) — design spec for `create-role`
- [`docs/define-workflow/spec.md`](docs/define-workflow/spec.md) — design spec for `define-workflow`
