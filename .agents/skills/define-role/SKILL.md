---
name: define-role
description: Create or revise a Role card under roles/<slug>/ when the human wants a Role added or changed — interview for purpose, boundaries, and Playbook duties, then write the card from templates, or edit only the sections they pick in an existing card.
---

# define-role

Create a new Role card from `templates/`, or revise one under `roles/` in place. Spec, from the repo root: `docs/define-role/spec.md`. Field help: [reference.md](reference.md). Doc craft, from the repo root: `docs/agent-docs.md`.

## Hard rules

- Do not create or edit `workflow.md`
- Do not register Cursor Agents or sub-agents
- Generated Markdown is English; explain and ask in the human's language (often Chinese)
- Write the card as a doc an agent reads: follow `docs/agent-docs.md`—one action per bullet, steps before reference, every pointer naming a path that ships with the card
- Write only when the needed answers are in: a new Role needs the layout and a valid new slug; a revision needs a confirmed section pick
- A revision edits nothing before the human confirms the section pick
- Playbook answer skipped → `(none yet)` on a new card; on a revision a skipped section keeps its current text, and only a section the human clears becomes `(none yet)`
- Speaking style **default** → no `## Speaking style` heading: empty `{{SPEAKING_STYLE_SECTION}}` on a new card, heading and body deleted on a revision
- A revision changes only the picked sections; every line outside them stays byte-identical, including the layout, the slug, and the `workflow.md` / `workflows/` pointers

## Entry: new or existing

Ask once: a new Role, or a revision of an existing one?

- **New** → steps 1–7.
- **Revise** → list `roles/*/`, ask which card, then steps R1–R4. If the folder is missing, stop and ask again. The layout question is skipped and the slug stays.

## Templates (new Roles)

| Layout | Copy from |
|---|---|
| Role-Playbook | `templates/role-playbook/ROLE.md` + `PLAYBOOK.md` → `roles/<slug>/` |
| Role-merged | `templates/role-merged/ROLE.md` → `roles/<slug>/ROLE.md` |

Placeholders: `{{NAME}}` `{{SLUG}}` `{{PURPOSE}}` `{{BOUNDARIES}}` `{{SPEAKING_STYLE_SECTION}}` `{{RESPONSIBILITIES}}` `{{STEPS}}` `{{CHECKLISTS}}` `{{HANDOFFS}}` `{{WHEN_STUCK}}` `{{NOTES}}`

## Interview

Explain each step in 1–2 sentences before asking. Playbook = **one section per question**. A revision asks only the sections picked in R2 and leaves every other section alone.

### 1. Layout (new Roles only)

Explain: **Role-Playbook** keeps stable identity in `ROLE.md` and mutable duties in `PLAYBOOK.md` so duty edits do not touch identity. **Role-merged** puts both in one `ROLE.md` (stable top, Playbook below)—use when the Role is simple or fewer files are preferred.

Ask which layout. Recommend Role-Playbook.

### 2. Display name + slug

Explain: display name is human-facing; slug is the directory id (`roles/<slug>/`), lowercase with hyphens.

- New: ask for the display name, propose a slug from it, confirm or edit. Validate `^[a-z][a-z0-9-]*$`. If `roles/<slug>/` exists, stop and ask for another slug—do not write.
- Revise: ask whether the display name changes. The slug and folder stay; a different directory name means a new Role.

### 3. Purpose

Explain: one sentence for why this Role exists (not a task list).

Ask for purpose.

### 4. Boundaries

Explain: what this Role is *not* responsible for. Cross-Role routing stays in `workflow.md`.

Ask for boundaries.

### 5. Speaking style

Explain: only set this when the Role needs a fixed voice (e.g. plain Chinese with the human). Most Roles use the global default.

Ask: custom text, or **default**? Recommend default. Default → omit the section.

Custom value—`{{SPEAKING_STYLE_SECTION}}` on a new card, an inserted section on a revision:

```markdown
## Speaking style

<user text>

```

### 6a–6f. Playbook (one question each)

Before each: say what the section is for, and that *who is next* lives in `workflow.md`. On a new card skip is allowed; on a revision each of these keeps its current text unless the human changes it.

| Step | Section | Explain |
|---|---|---|
| 6a | Responsibilities | Role-local duty detail |
| 6b | Steps | Craft steps for one or more kinds of work; how *this* Role works, not who is next |
| 6c | Checklists | Execution checklists |
| 6d | Handoffs | When *this* Role should hand off on a normal completion path |
| 6e | When stuck | When to stop and raise a problem outside the Role—not a normal handoff |
| 6f | Notes | Volatile conventions |

## Write a new Role

1. Create `roles/<slug>/` from the matching templates
2. Substitute placeholders
3. Read the written files back; fix a broken list item or a stray line
4. List written paths
5. If repo-root `workflow.md` is missing, warn only—do not create it

## Revise an existing Role

### R1. Load and show the card

Read `roles/<slug>/ROLE.md`, plus `PLAYBOOK.md` when the card has one. List each changeable section with one line on what it currently says. List the pieces [reference.md](reference.md) requires that this card is missing—without editing them yet.

### R2. Pick sections

Offer the sections that can change: display name, purpose, boundaries, speaking style, the six Playbook sections, and any missing required piece. Ask which to change. If nothing is picked, report and stop.

Done when the human has confirmed the pick: every section that will change is named, and nothing else is touched.

### R3. Ask the picked sections

Run the matching questions from the interview with their explanations.

### R4. Edit in place and report

1. Replace only the body under each changed heading; keep the heading text and the spacing around it
2. Match the card's heading levels—Role-merged uses `###` for the Playbook sections
3. A name change updates the `#` title in every file of the card
4. Speaking style: insert `## Speaking style` after Purpose for a custom answer; delete the heading and its body for default
5. Copy nothing from `templates/` and substitute no placeholders
6. Read the written files back; fix a broken list item or a stray line
7. Report the changed sections and the file paths

## Completion criteria

**New Role**

- [ ] Layout confirmed
- [ ] Slug valid; `roles/<slug>/` did not already exist
- [ ] `ROLE.md` written; Role-Playbook also has `PLAYBOOK.md`
- [ ] Stable fields filled; speaking style written or omitted per rule
- [ ] All six Playbook headings present
- [ ] `workflow.md` pointers present; Role-Playbook has required `./PLAYBOOK.md` read; Role-merged stable top requires reading Playbook region below
- [ ] `workflow.md` untouched
- [ ] Written files read back; no broken list item or stray line
- [ ] Paths reported to the human

**Existing Role**

- [ ] Section pick confirmed before any edit
- [ ] Only the picked sections changed; `git diff` shows nothing else
- [ ] Layout, slug, and workflow pointers untouched
- [ ] Skipped sections untouched; cleared sections `(none yet)`
- [ ] `workflow.md` untouched
- [ ] Written files read back; no broken list item or stray line
- [ ] Changed sections and paths reported
