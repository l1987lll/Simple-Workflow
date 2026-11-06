# Simple-Workflow

A simple AI Agent workflow with customizable roles and workflows.

## Skills

Skills live in [`skills/`](skills/), one folder each with a `SKILL.md` entry point and its support files.

`skills/` is the source of truth. Every skill is also copied unchanged into [`.agents/skills/`](.agents/skills/), so AI coding tools that scan that directory discover the skills this repository defines. The copy is committed on purpose — after editing a skill, copy its folder again so the two trees stay identical.

| Skill | What it does |
|---|---|
| [`create-role`](skills/create-role/SKILL.md) | Interviews you, then scaffolds a Role card under `roles/<slug>/` in the Role-Playbook (default) or Role-merged layout |

## Documents

- [`GLOSSARY.md`](GLOSSARY.md) — the vocabulary used by Role cards
- [`docs/create-role/spec.md`](docs/create-role/spec.md) — design spec for the `create-role` skill
