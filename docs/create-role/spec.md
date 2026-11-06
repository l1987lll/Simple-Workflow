# create-role — Design Spec

Date: 2026-11-06  
Status: approved

## Intent

Provide a project skill `create-role` that interviews the human and scaffolds a **Role card** under `roles/<slug>/`. Role cards are Markdown for agents to load later. This spec covers the skill only—not the six business roles and not `workflow.md` content.

## Decisions

| Decision | Choice |
|---|---|
| Artifact | Markdown Role card (not a Cursor Agent binding) |
| Skill location | `skills/create-role/` in this repo |
| Skill mirror | Byte-identical copy under `.agents/skills/create-role/` so AI coding tools discover it |
| Packaging | Skill + template files (no scaffold script) |
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
  docs/create-role/spec.md
  workflow.md                 # out of scope for create-role (link only)
  roles/<slug>/
    ROLE.md
    PLAYBOOK.md               # Role-Playbook only
  skills/create-role/         # source of truth
    SKILL.md
    reference.md
    templates/
      role-playbook/ROLE.md
      role-playbook/PLAYBOOK.md
      role-merged/ROLE.md
  .agents/skills/create-role/ # byte-identical mirror for AI coding tool discovery
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

Explain each question in 1–2 sentences before asking. Playbook sections are **one question each**.

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

Do not write files until layout and identity answers needed for paths are confirmed (at minimum layout + slug before create; prefer completing the interview then writing once).

## SKILL.md behavior

- `name`: `create-role`
- `disable-model-invocation: true`
- Read `templates/` always; read `reference.md` when field semantics need clarification
- Follow the interview order and explanation duty
- Replace template placeholders; omit speaking-style heading when default
- Completion criteria: layout confirmed; slug valid and directory new; files written; stable fields present; six Playbook headings present; `workflow.md` pointers present; Playbook required-read pointer present for Role-Playbook; `workflow.md` untouched; paths reported to human

## reference.md

- Layout name map (aligned with `GLOSSARY.md`)
- What belongs / does not belong in each Playbook section (especially Handoffs vs When stuck)
- One tiny fictional filled example (not the real six business roles)

## Out of scope

- Creating or editing `workflow.md`
- Defining the six business roles (Team Lead, Architect/Research, Developer, Code Reviewer, QA, closer)
- Cursor Agent / subagent registration
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

Copy from `templates/role-playbook/` or `templates/role-merged/` into `roles/<slug>/`, substitute the placeholders above, apply speaking-style omission rule. No scaffold script in v1.
