# Review loop

A reusable, bounded implementation-review cycle. A `developer` hands a reviewable branch/PR to the coordinator, `code-reviewer` reviews it, and the cycle repeats until a round has no blocking findings or four rounds complete. The main workflow that reaches this sub-workflow owns harness pairs, support labels, conditions, and run state; this file owns the Role order, handoffs, and exit.

## Entry

- `developer` has a reviewable branch/PR and has written its handoff artifact under the run folder.
- `team-lead` has recorded the `developer` instance, its path ownership, and the artifact path in `STATUS.md`.
- `code-reviewer` has not yet reviewed this branch/PR in this cycle.

## Roles

- `developer` — implements the change and addresses review findings
- `code-reviewer` — reviews each round and writes findings
- `team-lead` — coordinator; dispatches, resumes, counts rounds, and writes `STATUS.md`

## Sub-flows

(none)

## Flow

1. `team-lead` starts the cycle by dispatching `code-reviewer` with the branch/PR and the artifact path.
2. `code-reviewer` reviews the change and writes findings under `review/`.
3. `code-reviewer` hands its findings to `team-lead`.
4. If findings need fixes, `team-lead` resumes `developer` with the findings; `developer` addresses them and hands back to `team-lead`.
5. `team-lead` resumes `code-reviewer` for the next round and repeats steps 2–4.
6. Stop when a round has no blocking findings, or when the fourth round completes.

## Routes

### `developer` handoff

| When | Next | Interaction |
|---|---|---|
| Implementation ready for review (branch/PR prepared) | `team-lead` (then `code-reviewer`) | message + artifact |
| Review feedback addressed; another review pass needed | `team-lead` (then resume `code-reviewer`) | message + artifact |
| Review cycle finished; work ready for testing | `team-lead` (then `qa`) | message + artifact |

### `code-reviewer` handoff

| When | Next | Interaction |
|---|---|---|
| Review round findings written (fixes needed or clean) | `team-lead` (then resume `developer` if fixes needed) | message + artifact |
| Four-round review limit reached | `team-lead` | message + artifact |
| No blocking findings; implementer can proceed | `team-lead` (then `qa`) | message + artifact |

## Exit

- **Clear exit:** the latest round has no blocking findings. Output: the review artifact path and the completed round count in `STATUS.md`. The next step is `qa` in the referencing workflow.
- **Limit exit:** four rounds complete. Output: the open findings and the completed round count. The next step is the one the referencing workflow states for a limit exit.

The main workflow that reaches this sub-workflow owns the gate and run-state rules that apply after either exit.

## Interactions used

`message`, `artifact`, `resume`. Every main workflow that reaches this sub-workflow must mark each supported on every pair it lists, or keep the use as a caveat.

## Artifacts

- Files under `review/` in the run folder hold each round's findings.
- `STATUS.md` records the current round, the `code-reviewer` instance, and the artifact paths.
