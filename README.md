# Simple-Workflow

A simple AI Agent workflow with customizable roles and workflows.

## Skills

Skills live in [`skills/`](skills/), one folder each with a `SKILL.md` entry point and its support files.

`skills/` is the source of truth. Every skill is also copied unchanged into [`.agents/skills/`](.agents/skills/), so AI coding tools that scan that directory discover the skills this repository defines. The copy is committed on purpose — after editing a skill, copy its folder again so the two trees stay identical.

| Skill | What it does |
|---|---|
| [`create-role`](skills/create-role/SKILL.md) | Interviews you, then scaffolds a Role card under `roles/<slug>/` in the Role-Playbook (default) or Role-merged layout |

## Roles

Roles live in [`roles/`](roles/), one folder each, written by the [`create-role`](skills/create-role/SKILL.md) skill.

A Role is a Markdown card that an agent loads to act in that capacity. The default Role-Playbook layout splits it into a stable `ROLE.md` (name, slug, purpose, boundaries, required reading) and a mutable `PLAYBOOK.md` (responsibilities, steps, checklists, handoffs, when stuck, notes); the skill also offers a Role-merged layout that puts both in one file. Cards stay local to their own Role: cross-Role routing is not written into them.

| Role | Purpose |
|---|---|
| [`team-lead`](roles/team-lead/ROLE.md) | Clarifies tasks with the human, assigns and coordinates other Roles, and keeps work unblocked until it is done |
| [`research-architect`](roles/research-architect/ROLE.md) | Researches unfamiliar domains and hard design problems, and produces grounded architecture and plans without implementing code |
| [`developer`](roles/developer/ROLE.md) | Implements product changes across the stack—from UI through APIs and data—according to the agreed requirements |
| [`code-reviewer`](roles/code-reviewer/ROLE.md) | Reviews branch/PR changes against acceptance criteria, coding standards, commit rules, and review rules without implementing the fix |
| [`qa`](roles/qa/ROLE.md) | Tests the change as a tester or user: requirements and acceptance criteria, likely edge cases, and impact on existing features |
| [`closer`](roles/closer/ROLE.md) | Drives close-out once a task is accepted: cleanup, lessons learned, `/retro`, and human-confirmed follow-ups |

## Documents

- [`GLOSSARY.md`](GLOSSARY.md) — the vocabulary used by Role cards
- [`docs/create-role/spec.md`](docs/create-role/spec.md) — design spec for the `create-role` skill
