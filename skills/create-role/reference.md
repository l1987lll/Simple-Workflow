# create-role reference

Read this when a field's meaning is unclear. Vocabulary matches repo-root `GLOSSARY.md`.

## Layout names

| Name | Files | When to use |
|---|---|---|
| **Role-Playbook** (default) | `ROLE.md` + `PLAYBOOK.md` | Stable identity separate from mutable duties |
| **Role-merged** | `ROLE.md` only | Simple Role or fewer files preferred |

Do not describe layouts to the human as only "one document / two documents" without the names and explanation above.

## What goes where

| Place | Belongs | Does not belong |
|---|---|---|
| `ROLE.md` stable | name, slug, purpose, optional speaking style, boundaries, required-reading pointers | Pipeline steps, who talks to whom |
| Playbook | Responsibilities, craft Steps, Checklists, when *this* Role hands off or is stuck, Notes | How the other Role works; full routing |
| `workflow.md` | End-to-end flow; cross-Role assignment and routing | (owned outside this skill) |

## Handoffs vs When stuck

- **Handoffs** — normal “I'm done with my part; work should leave this Role.”
- **When stuck** — abnormal stop: blocked, contradictory requirements, needs a decision, out of authority. Not the happy-path handoff.

Both sections may say *when*; neither defines *who next*—that is `workflow.md`.

## Placeholders

`{{NAME}}` `{{SLUG}}` `{{PURPOSE}}` `{{BOUNDARIES}}` `{{SPEAKING_STYLE_SECTION}}` `{{RESPONSIBILITIES}}` `{{STEPS}}` `{{CHECKLISTS}}` `{{HANDOFFS}}` `{{WHEN_STUCK}}` `{{NOTES}}`

`{{SPEAKING_STYLE_SECTION}}` is either empty or a full section:

```markdown
## Speaking style

<custom text>

```

(include the trailing newline so the following `## Boundaries` stays spaced).

Skipped Playbook bodies: `(none yet)`.

## Tiny example (fictional)

Display name `Night Watch`, slug `night-watch`, Role-Playbook, speaking style default (omitted).

**Purpose:** Watch overnight build logs and file clear failure notes.

**Boundaries:** Does not change product code or assign human owners.

**Responsibilities:** Scan failed jobs; summarize cause class; leave a note for the next Role.

**Steps:** (1) Open CI failures for the watched branch. (2) Classify flake vs real break. (3) Write a short note.

**Checklists:** `- [ ] Failure link captured` / `- [ ] Flake vs break labeled`

**Handoffs:** After the note is written for a real break.

**When stuck:** Logs inaccessible or failure type unclear after one pass.

**Notes:** `(none yet)`
