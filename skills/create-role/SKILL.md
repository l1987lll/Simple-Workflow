---
name: create-role
description: Scaffold a Markdown Role card under roles/<slug>/ using Role-Playbook or Role-merged templates.
disable-model-invocation: true
---

# create-role

Interview the human, then scaffold a Role card from `templates/`. Spec, from the repo root: `docs/create-role/spec.md`. Field help: [reference.md](reference.md).

## Hard rules

- Do not create or edit `workflow.md`
- Do not register Cursor Agents or subagents
- Generated Markdown is English; explain and ask in the human's language (often Chinese)
- Write files once after the interview (need layout + valid new slug before create)
- Skipped Playbook answers → `(none yet)` (keep the heading)
- Speaking style **default** → replace `{{SPEAKING_STYLE_SECTION}}` with empty string (no heading)

## Templates

| Layout | Copy from |
|---|---|
| Role-Playbook | `templates/role-playbook/ROLE.md` + `PLAYBOOK.md` → `roles/<slug>/` |
| Role-merged | `templates/role-merged/ROLE.md` → `roles/<slug>/ROLE.md` |

Placeholders: `{{NAME}}` `{{SLUG}}` `{{PURPOSE}}` `{{BOUNDARIES}}` `{{SPEAKING_STYLE_SECTION}}` `{{RESPONSIBILITIES}}` `{{STEPS}}` `{{CHECKLISTS}}` `{{HANDOFFS}}` `{{WHEN_STUCK}}` `{{NOTES}}`

Custom speaking style value for `{{SPEAKING_STYLE_SECTION}}`:

```markdown
## Speaking style

<user text>

```

## Interview

Explain each step in 1–2 sentences before asking. Playbook = **one section per question**.

### 1. Layout (default Role-Playbook)

Explain: **Role-Playbook** keeps stable identity in `ROLE.md` and mutable duties in `PLAYBOOK.md` so duty edits do not touch identity. **Role-merged** puts both in one `ROLE.md` (stable top, Playbook below)—use when the Role is simple or fewer files are preferred.

Ask which layout. Recommend Role-Playbook.

### 2. Display name + slug

Explain: display name is human-facing; slug is the directory id (`roles/<slug>/`), lowercase with hyphens.

Ask for the display name. Propose a slug from it. Confirm or edit.

Validate: `^[a-z][a-z0-9-]*$`. If `roles/<slug>/` exists, stop and ask for another slug—do not write.

### 3. Purpose

Explain: one sentence for why this Role exists (not a task list).

Ask for purpose.

### 4. Boundaries

Explain: what this Role is *not* responsible for. Cross-Role routing stays in `workflow.md`.

Ask for boundaries.

### 5. Speaking style

Explain: only set this when the Role needs a fixed voice (e.g. plain Chinese with the human). Most Roles use the global default.

Ask: custom text, or **default**? Recommend default. Default → omit the section.

### 6a–6f. Playbook (one question each; skip allowed)

Before each: say what the section is for, that skip is allowed, and that *who is next* lives in `workflow.md`.

| Step | Section | Explain |
|---|---|---|
| 6a | Responsibilities | Role-local duty detail |
| 6b | Steps | Craft steps for one or more kinds of work; how *this* Role works, not who is next |
| 6c | Checklists | Execution checklists |
| 6d | Handoffs | When *this* Role should hand off on a normal completion path |
| 6e | When stuck | When to stop and raise a problem outside the Role—not a normal handoff |
| 6f | Notes | Volatile conventions |

### 7. Write and report

1. Create `roles/<slug>/` from the matching templates
2. Substitute placeholders
3. List written paths
4. If repo-root `workflow.md` is missing, warn only—do not create it

## Completion criteria

- [ ] Layout confirmed
- [ ] Slug valid; `roles/<slug>/` did not already exist
- [ ] `ROLE.md` written; Role-Playbook also has `PLAYBOOK.md`
- [ ] Stable fields filled; speaking style written or omitted per rule
- [ ] All six Playbook headings present
- [ ] `workflow.md` pointers present; Role-Playbook has required `./PLAYBOOK.md` read; Role-merged stable top requires reading Playbook region below
- [ ] `workflow.md` untouched
- [ ] Paths reported to the human
