# Team loop

The team's business loop from assignment through close-out. It covers the seven business Roles: Team Lead, Research Architect, UI/UX Designer, Developer, Code Reviewer, QA, and Closer. The main workflow that reaches this sub-workflow keeps `manager`, `assistant`, and `workflow-owner` outside the loop and owns pairs, support labels, conditions, run state, and caveats; this file owns the business Role order, handoffs, human gates, loops, and exit.

## Entry

- `team-lead` has a clear task brief and has recorded the run in `STATUS.md`.
- The business Role instances are started or can be started by the main workflow.

## Roles

- `team-lead` — assignment, coordination, status, and the group's only channel
- `research-architect` — research and architecture when needed
- `ui-ux-designer` — interface design and prototype when needed
- `developer` — implementation, comment fixes, and PR updates
- `code-reviewer` — review through the nested review loop
- `qa` — verification
- `closer` — clean-up and close-out after acceptance

## Sub-flows

| Sub-flow | Path | Invoked at |
|---|---|---|
| Review loop | [`review-loop.md`](review-loop.md) | Flow step 4; `developer` and `code-reviewer` review handoff routes |

## Flow

1. `team-lead` assigns work inside its group by starting or messaging members; a member returns its result to `team-lead` and never talks to another member.
2. When research or architecture is needed, `team-lead` brings in `research-architect`; the plan returns to `team-lead`, which then assigns `developer` with it.
3. When a real interface design or interaction change is needed, `team-lead` brings in `ui-ux-designer`; a small interface change goes straight to `developer`. The design and the prototype question return to `team-lead`, which approves the design and takes it to the human (gate). After the human agrees, `team-lead` hands the design to `developer`.
4. Implementation returns to `team-lead`, which starts or resumes `code-reviewer`; the [review loop](review-loop.md) stays at four rounds.
5. The author reports every PR to `team-lead`; `team-lead` tracks the PR until it is merged.
6. A review comment that is right, good, and low-impact is fixed by the author without asking. A comment that is high-impact, risky, or uncertain goes to the human through `team-lead` (gate) before anyone changes it.
7. After a comment fix, the change goes through `code-reviewer` again. `team-lead` judges the easy cases: a small change may skip `qa`; a hard call goes to the human (gate); otherwise `qa` must pass.
8. After the pass, the author commits, pushes, and replies to the comment, then reports to `team-lead`.
9. When the task is done, `team-lead` asks the human to confirm clean-up (gate). Then `closer` clears worktrees, temporary files, and temporary resources, and checks for omissions, unfinished work, and Issue Tracker status.
10. `team-lead` confirms those checks. `closer` proposes a `/retro` round to `team-lead`, which asks the human whether members run `/retro` (gate). Members run it where `slash /retro` is supported on their pair; elsewhere the human runs it.
11. Finally `team-lead` sets the task status to Done in `STATUS.md` and returns to the main workflow.

## Routes

Dispatch rows say `spawn or message` because the referencing main binds the interaction. `developer` and `code-reviewer` review handoffs are in the nested [review loop](review-loop.md).

### `team-lead` handoff

| When | Next | Interaction |
|---|---|---|
| Ask is clear and research or architecture is required | `research-architect` | spawn or message + artifact |
| Research is complete or not needed, and an interface design is needed | `ui-ux-designer` | spawn or message + artifact |
| The design is approved by the human; implementation can follow | `developer` | spawn or message + artifact |
| A member finishes a slice and the next Role needs the result | next member | spawn or message + artifact; resume when continuing the same agent |
| A review comment needs the author to fix it | the author | message |
| A review comment or a QA-skip call needs a decision beyond this Role | human | gate + relay |
| Review and QA are clear; clean-up and checks remain | `closer` | spawn or message + artifact |
| Task meets done-when; only confirmation, clean-up, and close-out remain | human, then `closer` | gate, then spawn or message + artifact |

### `research-architect` handoff

| When | Next | Interaction |
|---|---|---|
| Research findings and recommended approach are written and reviewable | `team-lead` | message + artifact |
| Architecture or plan is implementable without further design ownership here | `team-lead` | message + artifact |
| Only remaining blocker is a clarifying question for the human | `team-lead` | message |

### `ui-ux-designer` handoff

| When | Next | Interaction |
|---|---|---|
| Design specification is complete and self-checked, along with any agreed prototype | `team-lead` | message + artifact |
| The prototype decision needs the human | `team-lead` | message + gate + relay |
| Front-end implementation exposes a gap the design does not cover | `team-lead` | message |

### `developer` handoff

| When | Next | Interaction |
|---|---|---|
| A PR is raised | `team-lead` | message |
| A comment fix is committed, pushed, and replied to | `team-lead` | message |
| QA failure addressed; ready for a re-test | `team-lead` (then resume `qa`) | message + artifact |

### `qa` handoff

| When | Next | Interaction |
|---|---|---|
| Pass/fail report written | `team-lead` | message + artifact |
| A failure needs a fix; testing cannot usefully continue | `team-lead` (then resume `developer`) | message + artifact |
| Testing complete with no blocking failures | `team-lead` | message + artifact |

### `closer` handoff

| When | Next | Interaction |
|---|---|---|
| Clean-up or follow-up needs another Role's permissions or craft | `team-lead` | message |
| Clean-up needs the human's confirmation before it starts | `team-lead` | message + gate |
| The checks are done: omissions, unfinished work, Issue Tracker status | `team-lead` | message + artifact |
| A `/retro` round is proposed for every member | `team-lead` | message |
| Retro summary and proposed follow-ups are ready for human confirmation | `team-lead` | message + gate + relay |
| Close-out is complete | `team-lead` | message |

## Exit

- **Close-out exit:** `closer` reports complete and `team-lead` sets Done. Output: close-out artifact paths and status in `STATUS.md`; the main workflow reports the result to the human.
- **Raise exit:** the loop cannot converge. `team-lead` follows the main workflow's When-stuck routes.

## Interactions used

`message`, `artifact`, `resume`, `gate`, `relay`, and `spawn` when the referencing main is one main agent with sub-agents. The nested [review loop](review-loop.md) uses `message`, `artifact`, and `resume`. The main workflows that reach this sub-workflow must mark each supported on every pair they list, or keep a caveat.

## Artifacts

- `brief.md`, `research/`, `design/`, `review/`, `qa/`, and `closeout/` under the run folder hold the handoffs.
- `STATUS.md` records each business Role instance, path ownership, phase, and artifact paths.
