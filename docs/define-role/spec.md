# define-role — Design Spec

Date: 2026-11-06  
Revised: 2026-11-15  
Status: approved

## Intent

Provide a project skill `define-role` that interviews the human and either creates a Role card under `roles/<slug>/` or revises an existing one in place. Role cards are Markdown for agents to load later. This spec covers the skill only—not the six business roles and not `workflow.md` content.

## Decisions

| Decision | Choice |
|---|---|
| Artifact | Markdown Role card (not a Cursor Agent binding) |
| Skill location | `skills/define-role/` in this repo |
| Skill mirror | Byte-identical copy under `.agents/skills/define-role/` so AI coding tools discover it |
| Packaging | Skill + template files (no scaffold script) |
| Entries | One skill, two entries: a new Role, or a revision of an existing one |
| Revise granularity | The human picks sections; only those sections change |
| Revise invariants | Layout, slug, and workflow pointers are never rewritten |
| Revision source | The card in `roles/`, never the templates |
| Default layout | **Role-Playbook** (`ROLE.md` + `PLAYBOOK.md`) |
| Alternate layout | **Role-merged** (one `ROLE.md`, stable top + Playbook bottom) |
| Cross-Role routing | Only in `workflow.md`; skill links to it, never creates/edits it |
| Doc language | English in generated files; interview may be Chinese |
| Speaking style | Ask; if human chooses default, omit the section entirely |
| Former "Escalation" | Section title **When stuck** |

## Repository layout (after skill exists)

```
WorkFlow/
  GLOSSARY.md
  docs/define-role/spec.md
  workflow.md                 # out of scope for define-role (link only)
  roles/<slug>/
    ROLE.md
    PLAYBOOK.md               # Role-Playbook only
  skills/define-role/         # source of truth
    SKILL.md
    reference.md
    templates/
      role-playbook/ROLE.md
      role-playbook/PLAYBOOK.md
      role-merged/ROLE.md
  .agents/skills/define-role/ # byte-identical mirror for AI coding tool discovery
```

## ROLE.md (stable)

Required:

- Display name
- slug (directory id)
- Purpose (one sentence; why the Role exists, not a task list)
- Boundaries (what this Role is *not* responsible for)
- Process pointer to repo-root `workflow.md`
- If Role-Playbook: mandatory Playbook pointer requiring `./PLAYBOOK.md` before acting on mutable duties
- If Role-merged: mandatory note in the stable top that the agent must read the `## Playbook` region below before acting on mutable duties

Optional:

- Speaking style — only when human does not choose default

Must not define how Roles interact or the end-to-end pipeline.

## Playbook sections (mutable)

Used in `PLAYBOOK.md` or under `## Playbook` in Role-merged. Every section keeps its heading; skipped answers become `(none yet)`.

| Section | Meaning |
|---|---|
| Responsibilities | Role-local duty detail |
| Steps | Craft steps for one or more kinds of work; how *this* Role works, not who is next |
| Checklists | Execution checklists |
| Handoffs | When *this* Role should hand work off (normal completion path); routing detail in `workflow.md` |
| When stuck | When to stop and raise a problem outside the Role (blocked, needs a decision, out of authority)—not normal handoff; routing in `workflow.md` |
| Notes | Volatile conventions |

Both the Role document and the Playbook (or merged Playbook region) point at `workflow.md`.

## Interview (ordered)

Explain each question in 1–2 sentences before asking. Playbook sections are **one question each**. The entry question picks the mode.

### New Role

1. Layout — explain Role-Playbook vs Role-merged; default Role-Playbook  
2. Display name + slug — propose slug from name; validate `^[a-z][a-z0-9-]*$`; refuse if `roles/<slug>/` exists  
3. Purpose  
4. Boundaries  
5. Speaking style — custom vs **default** (recommended); default → omit section  
6a. Responsibilities (skip allowed)  
6b. Steps (skip allowed)  
6c. Checklists (skip allowed)  
6d. Handoffs (skip allowed)  
6e. When stuck (skip allowed)  
6f. Notes (skip allowed)  
7. Write files from templates, list paths; if `workflow.md` is missing, warn only—do not create it  

Do not write files until layout and slug are confirmed (prefer completing the interview then writing once).

### Revise an existing Role

R1. **Load** — read `roles/<slug>/ROLE.md` and `PLAYBOOK.md` when present; list each section with what it currently says; list required pieces the card is missing  
R2. **Pick** — offer the sections plus any missing required piece; ask which to change; nothing picked → report and stop  
R3. **Ask** — run the matching interview questions for the picked sections only; a skipped section keeps its current text; a cleared section becomes `(none yet)`  
R4. **Edit in place** — replace only the picked section bodies; a name change updates the `#` title in every file; speaking style is inserted or deleted as a section; copy no template text and substitute no placeholders; report changed sections and paths  

## Revision rules

- Only the picked sections change; every other line of every file stays byte-identical
- The card's layout, slug, and `workflow.md` / `workflows/` pointers are kept as they are
- A different slug or a converted layout is a different card, not a revision
- `(none yet)` is written only for a section the human clears, never for one they skip
- Existing cards may predate the templates (the six business Roles point at `workflows/`); keeping their pointers takes precedence over template conformance

## SKILL.md behavior

- `name`: `define-role`
- `disable-model-invocation: true`
- `description` names both entries (human-facing: create or revise)
- Read `templates/` for a new Role only; read `reference.md` for field semantics and required pieces
- Follow the interview order and explanation duty; a revision asks only the picked sections
- New Role: replace template placeholders; omit the speaking-style heading when default
- Revise: edit the existing card in place; keep everything outside the picked sections
- Completion criteria split by entry: new (files written, six Playbook headings, pointers present) and revise (pick confirmed first, only picked sections differ, pointers untouched)

## reference.md

- Layout name map (aligned with `GLOSSARY.md`)
- What belongs / does not belong in each Playbook section (especially Handoffs vs When stuck)
- Required pieces of an existing card, for the revise entry
- One tiny fictional filled example (not the real six business roles)

## Out of scope

- Creating or editing `workflow.md`
- Defining the six business roles (Team Lead, Architect/Research, Developer, Code Reviewer, QA, closer)
- Cursor Agent / subagent registration
- Renaming a Role directory, or converting Role-Playbook ↔ Role-merged
- Who assigns work to QA, who runs cleanup, who triggers `/retro` (process-document concerns)

## Template placeholders

| Token | Replaced with |
|---|---|
| `{{NAME}}` | Display name |
| `{{SLUG}}` | slug |
| `{{PURPOSE}}` | Purpose sentence |
| `{{BOUNDARIES}}` | Boundaries text |
| `{{SPEAKING_STYLE_SECTION}}` | Full Markdown section including heading, or empty string when default |
| `{{RESPONSIBILITIES}}` | Body or `(none yet)` |
| `{{STEPS}}` | Body or `(none yet)` |
| `{{CHECKLISTS}}` | Body or `(none yet)` |
| `{{HANDOFFS}}` | Body or `(none yet)` |
| `{{WHEN_STUCK}}` | Body or `(none yet)` |
| `{{NOTES}}` | Body or `(none yet)` |

## Implementation approach

Creating a Role copies `templates/role-playbook/` or `templates/role-merged/` into `roles/<slug>/`, substitutes the placeholders above, and applies the speaking-style omission rule. Revising edits the files already in `roles/<slug>/` in place and uses no templates. No scaffold script.

The templates still point at `workflow.md`; OI-006 tracks that mismatch with OI-001, which fixes the process pointer at `workflows/`.
