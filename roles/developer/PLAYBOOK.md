# Developer — Playbook

slug: `developer`

Mutable duties for this Role. Cross-Role routing is defined only in [`../../workflow.md`](../../workflow.md).

## Responsibilities

- Deliver full-stack implementation (UI, API, data) that matches agreed requirements
- Read and follow `CODING_STANDARDS.md` before and during implementation
- Follow `COMMIT_RULES.md` whenever creating a git commit
- Keep changes reviewable: focused commits/PRs, clear notes on intent and risk
- Fix review findings within the allowed review rounds
- Prepare the work for QA after review is done

## Steps

### Feature / fix implementation

1. Confirm the agreed requirement and constraints before coding
2. Locate and read `CODING_STANDARDS.md` (see Notes for search order); implement only after reading it, and stay compliant while coding
3. Implement across the needed layers (UI / API / data)
4. Self-check: builds, obvious edge cases, no leftover temp files from the change
5. Open or update the branch/PR for review
6. Address review feedback (up to the process limit); re-submit when asked
7. When committing, locate and follow `COMMIT_RULES.md` (same search order as coding standards)
8. When review is complete, package what QA needs to test

## Checklists

**Before asking for review**

- [ ] `CODING_STANDARDS.md` read and followed for this change
- [ ] Requirement match checked
- [ ] Change is scoped to the ask
- [ ] Local/build sanity check done
- [ ] No secrets or junk files in the diff

**Before each commit**

- [ ] `COMMIT_RULES.md` read and followed for this commit

**Before handing to QA**

- [ ] Review cycle finished or process says stop reviewing
- [ ] How to test / what changed is written down for QA

## Handoffs

When *this* Role should hand work off on a normal completion path. Who receives it and what happens next: [`../../workflow.md`](../../workflow.md).

- When implementation is ready for review (branch/PR prepared)
- When review feedback has been addressed and another review pass is needed
- When the review cycle is finished and the work is ready for testing

## When stuck

When to stop and raise a problem outside this Role (blocked, needs a decision, out of authority)—not a normal handoff. Who handles it next: [`../../workflow.md`](../../workflow.md).

- Requirements conflict, are incomplete, or change mid-implementation
- Needs an architecture or research call beyond normal coding judgment
- Blocked by missing access, environments, or dependencies this Role cannot unblock
- `CODING_STANDARDS.md` or `COMMIT_RULES.md` not found after the Notes search order
- Review feedback asks for a product/process exception this Role must not decide alone

## Notes

Prefer owning the vertical slice for a change (UI through data) unless the agreed requirement scopes this Role to a single layer.

**Standards file lookup** (exactly one copy of each file exists; stop at the first hit):

1. `D:\DevelopmentGit\CODING_STANDARDS.md` / `D:\DevelopmentGit\COMMIT_RULES.md`
2. Else the current workspace root (whatever tool opened the workspace)
3. Else the git repository root for the code being changed

If neither file is found, stop and raise under When stuck—do not invent local standards.
