# Simple-Workflow

[![docs check](https://github.com/l1987lll/Simple-Workflow/actions/workflows/check-docs.yml/badge.svg)](https://github.com/l1987lll/Simple-Workflow/actions/workflows/check-docs.yml)

A simple AI Agent workflow with customizable roles and process documents.

## Layout

| Path | What it is |
|---|---|
| [`roles/`](roles/) | Role cards agents load to act in a capacity |
| [`workflows/`](workflows/) | Main workflows and reusable sub-workflows (`workflows/subflows/`) |
| [`skills/`](skills/) | Skills that create or revise roles and workflows, or set up the kit in a consumer project |
| [`.agents/skills/`](.agents/skills/) | Committed copies of the repo's skills, plus any outside skill the repo calls, for tools that scan that path |
| [`runs/_template/`](runs/_template/) | STATUS and brief templates for a live run |
| [`project-standards/`](project-standards/) | Coding, commit, and review standards templates shipped with the kit |
| [`docs/`](docs/) | Design specs for skills |
| [`GLOSSARY.md`](GLOSSARY.md) | Shared vocabulary |
| [`OPEN_ISSUES.md`](OPEN_ISSUES.md) | Open and deferred project issues |
| [`AGENTS.md`](AGENTS.md) | Branching rules for agents working in this repo |

`skills/` is the source of truth for the skills this repo produces. After editing one, copy its folder into `.agents/skills/`.

## Skills

| Skill | What it does |
|---|---|
| [`define-role`](skills/define-role/SKILL.md) | Interviews you, then scaffolds a Role card under `roles/<slug>/` (Role-Playbook default, or Role-merged), or revises an existing card section by section |
| [`define-workflow`](skills/define-workflow/SKILL.md) | Interviews you for harness, environment, support, workflow shape, Roles, and run state, then creates or revises a main workflow or sub-workflow under `workflows/` |
| [`setup-workflow`](skills/setup-workflow/SKILL.md) | Sets up the kit in a consumer project's `.workflow/` directory (roles, process documents, run templates, project-standards templates, and Team config files) |

## Roles

Roles live in [`roles/`](roles/), one folder each, written by [`define-role`](skills/define-role/SKILL.md).

A Role is a Markdown card an agent loads to act in that capacity. The default Role-Playbook layout splits it into a stable `ROLE.md` (name, slug, purpose, boundaries, required reading) and a mutable `PLAYBOOK.md` (responsibilities, steps, checklists, handoffs, when stuck, notes). Role-merged puts both in one file. Cards stay local to their own Role: cross-Role routing is not written into them.

| Role | Purpose |
|---|---|
| [`manager`](roles/manager/ROLE.md) | Manages the other Roles for the human: assignments, priorities, and status, with one owner per piece of work |
| [`team-lead`](roles/team-lead/ROLE.md) | Clarifies tasks with the human, assigns and coordinates other Roles, and keeps work unblocked until it is done |
| [`workflow-owner`](roles/workflow-owner/ROLE.md) | Owns the project's `.workflow/` tree—process documents, Role cards, run templates, Team configs—and keeps them true as the workflow changes |
| [`research-architect`](roles/research-architect/ROLE.md) | Researches unfamiliar domains and hard design problems, and produces grounded architecture and plans without implementing code |
| [`ui-ux-designer`](roles/ui-ux-designer/ROLE.md) | Turns interface requirements into a reviewable design—layout, flows, states, visual specs—with a clickable prototype, without writing product code |
| [`developer`](roles/developer/ROLE.md) | Implements product changes across the stack—from UI through APIs and data—according to the agreed requirements |
| [`code-reviewer`](roles/code-reviewer/ROLE.md) | Reviews branch/PR changes against acceptance criteria, coding standards, commit rules, and review rules without implementing the fix |
| [`qa`](roles/qa/ROLE.md) | Tests the change as a tester or user: requirements and acceptance criteria, likely edge cases, and impact on existing features |
| [`closer`](roles/closer/ROLE.md) | Drives close-out once a task is accepted: cleanup, lessons learned, `/retro`, and human-confirmed follow-ups |
| [`assistant`](roles/assistant/ROLE.md) | Runs the human's personal chores—answers, drafts, research, reminders, local scripts, computer setup—and keeps project and business work with the project Roles |

## Workflows

Process documents live in [`workflows/`](workflows/), written by [`define-workflow`](skills/define-workflow/SKILL.md). A **main workflow** is a top-level `workflows/*.md` file; a Team selects it, and it records harness/environment pairs, support labels, conditions, Roles, routes, run state, and caveats. A **sub-workflow** is a reusable fragment under `workflows/subflows/*.md`, referenced from a `## Sub-flows` table; it records the Role order, handoff routes, and exit for the process it covers. A sub-workflow may reference another sub-workflow; every sub-workflow is reachable from a main workflow, the reference graph has no cycles, and a Team config never names one.

| Main workflow | Shape | Typical targets |
|---|---|---|
| [`workflows/main-with-subagents.md`](workflows/main-with-subagents.md) | Several main agents; `team-lead` runs the business Roles as sub-agents | Cursor + DSH (Local IDE chat) |
| [`workflows/all-main-agents.md`](workflows/all-main-agents.md) | Every Role is a main agent / bot | Grok Bot |

| Sub-workflow | Referenced by | Purpose |
|---|---|---|
| [`workflows/subflows/team-loop.md`](workflows/subflows/team-loop.md) | `main-with-subagents`, `all-main-agents` | Business loop: assignment, research, design, implementation, review, QA, close-out |
| [`workflows/subflows/review-loop.md`](workflows/subflows/review-loop.md) | `team-loop` | Bounded `developer` → `code-reviewer` cycle, at most four rounds |

In a consumer project, the [`workflow-owner`](roles/workflow-owner/ROLE.md) runs [`setup-workflow`](skills/setup-workflow/SKILL.md) with one of three intents — New install, Update install, or Add Team — plus Check only. New install creates several Teams in the current environment only where the shape can bring them up; a sub-agent install starts with one. Update install syncs the shared trees and has every Role with an installed card re-read its card and the process document—this session now, reachable bots by message, and the rest listed as pending. One `.workflow/` serves every harness on the project: `roles/`, `workflows/`, and `project-standards/` are shared, while each Team has its own `.workflow/teams/<id>.yaml` and its own runs. Agents read their bound Team config path, then the `workflow` file named inside; the config records `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness` ([OI-001](OPEN_ISSUES.md)). The copied trees include `.workflow/workflows/subflows/`; the Team config `workflow` field always names a main workflow. Role cards still point at the `workflows/` directory. Setup also copies [`project-standards/`](project-standards/) into `.workflow/project-standards/` (`CODING_STANDARDS.md`, `COMMIT_RULES.md`, `REVIEW_RULES.md`), rewrites Role Playbooks to require those paths (no separate detection or confirm step), and commits the definition changes in the `.workflow/` repository. Setup reminds the human they can add project-specific rules into those files for Roles to follow.

When the selected document is an **all-main-agents** shape (for example Grok Bot), `setup-workflow` also prepares Role bots, and it runs from the `workflow-owner` bot: it infers a **naming rule** from the current session bot's display name (and any already-created Role bots), previews names (including `workflow-owner` for **this session bot** and `team-lead` for the lead bot), asks for **shared standing instructions** (or none), then shows a **create/init plan** — whether to initialize this session bot as `workflow-owner`, and which other Role bots to create — and proceeds **only after** the human confirms that plan. Sub-agent shapes (for example Cursor / DSH) do not pre-create Role bots; they open the other main sessions instead. **Add Team** keeps the shared trees and other Team configs and creates another Team: on an all-main-agents harness, another named set of Role bots (for example `T2`) after the same naming, shared-instructions, and create/init plan confirm flow, with this-session init defaulting to no. Each new Team gets its own `.workflow/teams/<id>.yaml`.

## Runs

A **run** is one team execution of a main workflow. Copy [`runs/_template/`](runs/_template/) to `runs/<run-id>/`, fill `STATUS.md` and `brief.md`, and let `team-lead` keep STATUS updated. Product code stays on the work branch; process artifacts stay under the run folder.

## Documents

- [`GLOSSARY.md`](GLOSSARY.md) — vocabulary for Role cards and process documents
- [`OPEN_ISSUES.md`](OPEN_ISSUES.md) — open and deferred issues
- [`AGENTS.md`](AGENTS.md) — work only on a branch; do not commit directly to `develop` or `master`
- [`docs/agent-docs.md`](docs/agent-docs.md) — how to write the Role cards, Playbooks, and process documents an agent reads
- [`scripts/check-docs.ps1`](scripts/check-docs.ps1) — local check for that standard, the skill mirrors, and LF line endings
- [`docs/define-role/spec.md`](docs/define-role/spec.md) — design spec for `define-role`
- [`docs/define-workflow/spec.md`](docs/define-workflow/spec.md) — design spec for `define-workflow`
- [`docs/setup-workflow/team-config-design.md`](docs/setup-workflow/team-config-design.md) — design: Team config files
- [`docs/setup-workflow/team-config-implementation-plan.md`](docs/setup-workflow/team-config-implementation-plan.md) — implementation plan for Team configs
