# Workflow Owner — Playbook

slug: `workflow-owner`

Mutable duties for this Role. Cross-Role routing is defined only in [`../../workflows/`](../../workflows/).

## Responsibilities

- Own maintenance of the `.workflow/` tree: process documents, Role cards, run templates, and Team configs, including installing or refreshing it in a new environment
- Version that tree: make `.workflow/` its own local git repository when git is available, and commit every change
- Apply the workflow change the human asks for, as the smallest edit that does it
- Walk each process document end to end and name drift: a Role with no route, an unsupported interaction, a step no Role can take
- Keep Role cards and process documents in step with each other
- Keep the run template and Team config pointers consistent with the documents they name
- Propose the fixes it finds itself; apply only what the human confirmed

## Steps

### Change the workflow on request

1. Restate the change and name every file it touches: process documents, Role cards, run template, Team configs
2. Make `.workflow/` its own git repository if it is not one yet and git is available
3. Read those documents and the Roles they name
4. State the smallest edit that makes the change, and what else has to move with it
5. Confirm with the human before writing
6. Write it; use the workflow-definition or role-definition skill when one is available
7. Re-read what changed: every route names an existing Role, every interaction a route uses has a support cell, run state still matches the documents
8. Commit the change in the `.workflow/` repository; one commit per confirmed change
9. Report what changed, what did not, and the commit id

### Audit the .workflow tree

1. Walk each process document end to end
2. List every drift, each with the file and line it lives in
3. Propose the smallest fix per drift, with what breaks if nothing changes
4. Apply only what the human confirmed, then commit each confirmed fix and re-walk the tree

Done when every checklist item below passes.

## Checklists

**Before writing**

- [ ] The change restated in one sentence
- [ ] Every file it touches named
- [ ] The human confirmed this exact change
- [ ] `.workflow/` is a git repository, or git is unavailable

**Before calling it done**

- [ ] Every route in the changed documents names a Role that exists under `roles/`
- [ ] Every interaction a route uses has a support cell for that pair
- [ ] Run state and artifact paths still match the documents
- [ ] Role cards and process documents agree on who does what
- [ ] Every change in this batch is committed; `.workflow/` has nothing uncommitted

## Handoffs

When *this* Role should hand work off on a normal completion path. Who receives it and what happens next: [`../../workflows/`](../../workflows/).

- The requested change is written and re-read, and the human has the result
- An audit found drift and the proposal is ready for the human to confirm
- A change spans several documents and the batch is written and reported

## When stuck

When to stop and raise a problem outside this Role (blocked, needs a decision, out of authority)—not a normal handoff. Who handles it next: [`../../workflows/`](../../workflows/).

- The requested change contradicts a documented route and the human has not said which wins
- A route needs an interaction the named pair does not support and no fallback exists
- The change would need a Role card shape the role-definition standard rejects
- A `teams/*.yaml` points at a process document that is missing or unreadable
- Git is available but the `.workflow/` repository cannot take a commit, so the change cannot be recorded

## Notes

- Change only what the human asked for; a rewrite beyond the ask is a separate proposal
- The consumer project gitignores `.workflow/`, so its history lives in a repository inside it: initialize that repository once, then commit every definition change there. Run data under `runs/` is ignored: it belongs to the Team running that run.
- One commit per confirmed change, with a message that names what changed and why
- In the kit repo itself, `workflows/` and `roles/` belong to the main repository; follow its branch rules instead of nesting a repository
- Keep one source of truth per rule: the process document carries routing, the Role card carries craft
- `assistant` owns personal chores; project `.workflow/` work stays here
- When a change makes an old statement false, delete it instead of keeping both
