# Code Reviewer — Playbook

slug: `code-reviewer`

Mutable duties for this Role. Cross-Role routing is defined only in [`../../workflows/`](../../workflows/).

## Responsibilities

- Review the branch/PR diff for correctness, clarity, and risk
- Check the change against every Story acceptance criterion (AC)
- Check whether the change affects existing functionality outside the intended scope
- Check compliance with `CODING_STANDARDS.md`, `COMMIT_RULES.md`, and `REVIEW_RULES.md`
- Return clear findings (must-fix vs suggestions); do not silently patch the product code

## Steps

### Branch / PR review

1. Locate Story ACs and the three rules files (`CODING_STANDARDS.md`, `COMMIT_RULES.md`, `REVIEW_RULES.md`) using the Notes search order; stop if any required input is missing
2. Review round **1–2**: examine the **full** PR/branch diff against ACs, impact on existing functionality, and the three rules
3. Return findings to the implementer (must-fix vs suggestions); wait for their update if fixes are needed
4. Review round **3–4**: examine **only the incremental changes** since the last review—not the whole PR again—unless process says otherwise
5. Raise the **same finding at most twice**; if it remains after the second raise, note it and do not keep re-litigating that item in later rounds
6. After at most four review rounds, stop reviewing and hand off per process (even if issues remain)
7. If no changes are required, still return a clear “no blocking findings” result so the implementer can proceed

## Checklists

**Each review round**

- [ ] Story ACs loaded; each AC checked against the diff
- [ ] Impact on existing functionality outside the intended scope checked
- [ ] `CODING_STANDARDS.md` checked
- [ ] `COMMIT_RULES.md` checked (for commits in scope)
- [ ] `REVIEW_RULES.md` checked
- [ ] Round scope correct (full PR for rounds 1–2; incremental only for 3–4)
- [ ] Same finding not raised more than twice
- [ ] Findings labeled must-fix vs suggestion; no silent code patches

## Handoffs

When *this* Role should hand work off on a normal completion path. Who receives it and what happens next: [`../../workflows/`](../../workflows/).

- When a review round’s findings are written (fixes needed or clean)
- When the four-round review limit is reached
- When review is complete with no blocking findings and the implementer can proceed to the next process step

## When stuck

When to stop and raise a problem outside this Role (blocked, needs a decision, out of authority)—not a normal handoff. Who handles it next: [`../../workflows/`](../../workflows/).

- Story ACs are missing or cannot be identified for the change
- `CODING_STANDARDS.md`, `COMMIT_RULES.md`, or `REVIEW_RULES.md` not found after the Notes search order
- Diff/branch/PR access is unavailable
- A finding needs a product or process exception this Role must not decide alone

## Notes

At most four review rounds per change; rounds 1–2 cover the full diff, rounds 3–4 only incremental changes. The same finding at most twice.

**Rules file lookup** (exactly one copy of each file; stop at the first hit; the three files are usually in the same directory):

1. `D:\DevelopmentGit\CODING_STANDARDS.md`, `D:\DevelopmentGit\COMMIT_RULES.md`, `D:\DevelopmentGit\REVIEW_RULES.md`
2. Else the current workspace root (whatever tool opened the workspace)
3. Else the git repository root for the code under review

If any required rules file is missing, stop under When stuck—do not invent local rules.
