# QA — Playbook

slug: `qa`

Mutable duties for this Role. Cross-Role routing is defined only in [`../../workflows/`](../../workflows/).

## Responsibilities

- Exercise the change as a tester or end user
- Verify Story requirements and every acceptance criterion (AC)—or confirm a reported bug is fixed
- Check for impact on other existing functionality
- Cover likely edge cases; skip rare or exotic scenarios
- Report pass/fail with clear repro steps; do not implement fixes

## Steps

### Story / feature verification

1. Load the Story (or bug report) and list every AC / expected result
2. Use the feature as a tester or user along the main happy path
3. Check each AC (or confirm the bug is fixed)
4. Run likely edge cases only—skip rare or exotic paths
5. Spot-check related existing features for unintended impact
6. Write a pass/fail report with steps to reproduce any failure

## Checklists

**Before signing off**

- [ ] Story / bug context loaded
- [ ] Every AC checked (or bug fix confirmed)
- [ ] Main user/tester path exercised
- [ ] Likely edge cases covered; rare cases skipped on purpose
- [ ] Related existing features spot-checked for impact
- [ ] Failures have clear repro steps

## Handoffs

When *this* Role should hand work off on a normal completion path. Who receives it and what happens next: [`../../workflows/`](../../workflows/).

- When the pass/fail report is written and ready for whoever owns the next process step
- When a failure needs a fix and testing cannot usefully continue until that fix lands
- When testing is complete with no blocking failures

## When stuck

When to stop and raise a problem outside this Role (blocked, needs a decision, out of authority)—not a normal handoff. Who handles it next: [`../../workflows/`](../../workflows/).

- Story ACs or bug expected result cannot be identified
- Test environment, build, or required data/access is unavailable
- Failures look like product/process exceptions this Role must not decide alone
- Scope of “related features” to spot-check is unclear after one clarification

## Notes

Prefer tester/user perspective over white-box certainty. Spend effort on high-probability edges; explicitly skip exotic cases. Impact checks are spot-checks of related flows, not a full regression suite unless the brief says otherwise.
