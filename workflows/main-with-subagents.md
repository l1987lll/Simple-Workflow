# Workflow

End-to-end collaboration among Roles. Role-local craft stays on the Role card.

Shape: four main agents talk to the human—`manager`, `team-lead`, `assistant`, and `workflow-owner`—and every other Role runs as a sub-agent of `team-lead`. `main-peers` is unsupported on both pairs, so two main agents never message each other; the human carries the brief (relay). A sub-agent cannot communicate with the human; it returns work to `team-lead`. Members never talk to each other; they go through `team-lead`.

Levels: the human is level 1. `manager`, `assistant`, and `workflow-owner` are level 2 and do not manage each other. `team-lead` is level 3 and manages its own group. Expert groups are planned and have no Role cards yet; when their cards land they sit under `manager`, and a member attached to a team answers to that `team-lead`, while a member working alone tracks their own PR.

Only `workflow-owner` writes the definition files under `.workflow/`—process documents, Role cards, run templates, Team configs, and project standards. Everyone reads and writes the live run folder `runs/<run-id>/`: members write their own handoff artifacts there and `team-lead` alone writes `STATUS.md`. Run artifacts are not definition changes. The `.workflow/` repository tracks definitions only; `runs/` is ignored, so run data never enters its history.

## Targets

| Harness | Environment |
|---|---|
| Cursor | Local IDE chat |
| DSH | Local IDE chat |

## Support

Each cell is supported, unsupported, or uncertain, except subagent-depth, which is one, a number of further levels a sub-agent can create, or uncertain. Slash rows name the command.

| Interaction | Cursor / Local IDE chat | DSH / Local IDE chat |
|---|---|---|
| relay | supported | supported |
| switch | unsupported | supported |
| spawn | supported | supported |
| parallel | supported | supported |
| resume | supported | supported |
| message | supported | supported |
| artifact | supported | supported |
| gate | supported | supported |
| slash /retro | unsupported | uncertain |
| subagent-depth | uncertain | uncertain |
| subagent-peers | unsupported | supported |
| main-peers | unsupported | unsupported |

## Conditions

| Pair | Mode | Human at handoff | Shared repo |
|---|---|---|---|
| Cursor / Local IDE chat | May edit the repo; does not wait for approval; the main agent decides | Human is available through the main agents the human opened | yes |
| DSH / Local IDE chat | May edit the repo; does not wait for approval; the main agent decides | Human is available through the main agents the human opened | yes |

## Roles

- `manager` — main agent; level 2; manages every `team-lead`: task assignment, people, priorities, status, and proposals to the human. Does not join the business work
- `team-lead` — main agent; level 3; runs one task with its group and is the group's only channel
- `assistant` — main agent; level 2; personal chores only, and hands project or business work back to the human
- `workflow-owner` — main agent; level 2; the only writer of the `.workflow/` tree
- `research-architect` — sub-agent of `team-lead`; opened only when research or architecture is needed
- `ui-ux-designer` — sub-agent of `team-lead`; real interface design or interaction work
- `developer` — sub-agent of `team-lead`; implements the agreed change
- `code-reviewer` — sub-agent of `team-lead`; reviews the branch/PR
- `qa` — sub-agent of `team-lead`; verifies the change
- `closer` — sub-agent of `team-lead`; cleans up and drives close-out after acceptance

## Flow

1. The human talks with `team-lead` about the task. Rarely `manager` takes the task from the human and passes it on: `manager` → `team-lead` is relay, so the human carries the brief.
2. `team-lead` assigns work inside its group by spawning or messaging members. A member returns its result to `team-lead` and never talks to another member.
3. When research or architecture is needed, `team-lead` spawns `research-architect`. The plan returns to `team-lead`, which then assigns `developer` with it.
4. When a real interface design or interaction change is needed, `team-lead` spawns `ui-ux-designer`. A small interface change goes straight to `developer`. The design and the prototype question return to `team-lead`, which approves the design and then takes it to the human (gate). After the human agrees, `team-lead`—not the human—hands the design to `developer`.
5. Implementation returns to `team-lead`, which spawns or resumes `code-reviewer`. Review loops stay at four rounds.
6. The author reports every PR to `team-lead`. `team-lead` tracks the PR until it is merged.
7. A review comment that is right, good, and low-impact is fixed by the author without asking. A comment that is high-impact, risky, or uncertain goes to the human through `team-lead` (gate) before anyone changes it.
8. After a comment fix, the change goes through `code-reviewer` again. `team-lead` judges the easy cases: a small change may skip `qa`. A hard call goes to the human (gate). Otherwise `qa` must pass.
9. After the pass, the author commits, pushes, and replies to the comment, then reports to `team-lead`.
10. When the task is done, `team-lead` asks the human to confirm clean-up (gate). Then `closer` clears worktrees, temporary files, and temporary resources, and checks for omissions, unfinished work, and Issue Tracker status.
11. `team-lead` confirms those checks. `closer` proposes a `/retro` round to `team-lead`, which asks the human whether members run `/retro` (gate). Members run it where `slash /retro` is supported on their pair; elsewhere the human runs it.
12. Finally `team-lead` sets the task status to Done in `STATUS.md`.
13. A `.workflow/` change goes only to `workflow-owner`, with no approval chain. Any Role may send it: a member sends it to `team-lead`, the only channel a sub-agent has; `team-lead`, `assistant`, and `manager` carry it to `workflow-owner` through the human, because two main agents cannot message each other here. The human may open `workflow-owner` directly. `workflow-owner` confirms with the human (gate) before writing, then commits the change in the `.workflow/` repository.
14. Parallel members are allowed when `team-lead` starts independent slices that do not edit the same files.
15. `team-lead` may run several `developer` instances in parallel (`developer#1`, `developer#2`, …) when `STATUS.md` records disjoint path ownership for each instance; otherwise serialize.

## Routes

### `manager` handoff

| When | Next | Interaction |
|---|---|---|
| The instruction is settled and every affected Role holds a current brief | `team-lead` | relay + artifact |
| Priorities or owners changed and each affected Role has the new brief | `team-lead` | relay + artifact |
| The human asked for status and the answer is assembled | human | relay |
| The human asked for a `.workflow/` change | `workflow-owner` | relay + artifact |
| The human must decide before anyone continues | human | gate + relay |

### `manager` when stuck

| When | Raise to | Interaction |
|---|---|---|
| The human's instruction conflicts with an earlier decision and they have not said which wins | human | gate + relay |
| Two Roles claim the same work and ownership cannot be split | human | gate + relay |
| A Role is blocked on something outside every Role's authority | human | gate + relay |
| No one can state the current priority | human | gate + relay |

### `team-lead` handoff

| When | Next | Interaction |
|---|---|---|
| Ask is clear and research or architecture is required | `research-architect` | spawn + artifact |
| Ask is clear and implementation can start | `developer` | spawn + artifact |
| A real interface design or interaction change is needed | `ui-ux-designer` | spawn + artifact |
| The design is approved by the human; implementation can follow | `developer` | spawn + artifact |
| A member finishes a slice and the next Role needs the result | next member | spawn or message + artifact; resume when continuing the same agent |
| A review comment needs the author to fix it | the author | message |
| A review comment or a QA-skip call needs a decision beyond this Role | human | gate + relay |
| Review and QA are clear; clean-up and checks remain | `closer` | spawn + artifact |
| Task meets done-when; only confirmation, clean-up, and close-out remain | human, then `closer` | gate, then spawn + artifact |
| A member needs a `.workflow/` change | human, then `workflow-owner` | relay |

### `team-lead` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Human goals conflict or done-when cannot be agreed | human | gate + relay |
| The next move needs deep research or architecture beyond coordination | `research-architect` | spawn |
| Two members disagree and this Role cannot resolve it | human | gate + relay |
| Process or priority trade-off needs an explicit human call | human | gate + relay |

### `assistant` handoff

| When | Next | Interaction |
|---|---|---|
| The personal chore is done and the result is reported | human | relay |
| The request turned out to be project or business work | human, who takes it to `manager` or `team-lead` | relay |
| The request is a `.workflow/` change | `workflow-owner` | relay + artifact |
| The chore needs a decision only the human can make | human | gate |

### `assistant` when stuck

| When | Raise to | Interaction |
|---|---|---|
| The ask stays ambiguous after one clarifying question | human | gate |
| The chore needs access, credentials, or a tool the harness does not give | human | gate |
| A step would change the machine or data in a way that is hard to undo and the human has not agreed | human | gate |
| The request is project or business work and no owner Role can take it | human | gate + relay |

### `workflow-owner` handoff

| When | Next | Interaction |
|---|---|---|
| The requested change is written, committed, and re-read | human | relay |
| An audit found drift and the proposal is ready for the human to confirm | human | gate + relay |
| The change came from `manager` or `assistant` and is ready for them | that Role | relay + artifact |
| A change spans several documents and the batch is written and reported | human | relay |

### `workflow-owner` when stuck

| When | Raise to | Interaction |
|---|---|---|
| The requested change contradicts a documented route and the human has not said which wins | human | gate |
| A route needs an interaction the named pair does not support and no fallback exists | human | gate |
| The change would need a Role card shape the role-definition standard rejects | human | gate |
| A `teams/*.yaml` points at a process document that is missing or unreadable | human | gate |
| Git is available but the `.workflow/` repository cannot take a commit | human | gate |

### `research-architect` handoff

| When | Next | Interaction |
|---|---|---|
| Research findings and recommended approach are written and reviewable | `team-lead` | message + artifact |
| Architecture or plan is implementable without further design ownership here | `team-lead` | message + artifact |
| Only remaining blocker is a clarifying question for the human | `team-lead` | message |

### `research-architect` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Success criteria or constraints missing or contradictory after one clarification | `team-lead` | message |
| Required codebase or domain access unavailable | `team-lead` | message |
| Trade-offs need an explicit product or priority call | `team-lead` | message |
| Ask requires product implementation to answer | `team-lead` | message |

### `ui-ux-designer` handoff

| When | Next | Interaction |
|---|---|---|
| Design specification is complete and self-checked, along with any agreed prototype | `team-lead` | message + artifact |
| Front-end implementation exposes a gap the design does not cover | `team-lead` | message |

### `ui-ux-designer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Requirement goal or target user stays contradictory after one clarification | `team-lead` | message |
| No brand guide or design system exists and no one can set one | `team-lead` | message |
| The design needs a product trade-off beyond this Role's authority | `team-lead` | message |
| An agreed prototype needs a tool this Role lacks and no proposed alternative was accepted | `team-lead` | message |
| No answer on the prototype question and the design cannot be signed off without it | `team-lead` | message |

### `developer` handoff

| When | Next | Interaction |
|---|---|---|
| Implementation ready for review (branch/PR prepared) | `team-lead` | message + artifact |
| Review feedback addressed; another review pass needed | `team-lead` | message + artifact |
| Review cycle finished; work ready for testing | `team-lead` | message |
| A PR is raised | `team-lead` | message |
| A comment fix is committed, pushed, and replied to | `team-lead` | message |

### `developer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Requirements conflict, are incomplete, or change mid-implementation | `team-lead` | message |
| Needs architecture or research beyond normal coding judgment | `team-lead` | message |
| Blocked by missing access, environments, or dependencies | `team-lead` | message |
| `CODING_STANDARDS.md` or `COMMIT_RULES.md` not found at `.workflow/project-standards/` | `team-lead` | message |
| Review feedback asks for a product or process exception | `team-lead` | message |

### `code-reviewer` handoff

| When | Next | Interaction |
|---|---|---|
| Review round findings written (fixes needed or clean) | `team-lead` | message + artifact |
| Four-round review limit reached | `team-lead` | message + artifact |
| No blocking findings; the implementer can proceed | `team-lead` | message + artifact |

### `code-reviewer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs missing or cannot be identified | `team-lead` | message |
| Rules files not found after search order | `team-lead` | message |
| Diff, branch, or PR access unavailable | `team-lead` | message |
| A finding needs a product or process exception | `team-lead` | message |

### `qa` handoff

| When | Next | Interaction |
|---|---|---|
| Pass/fail report written | `team-lead` | message + artifact |
| A failure needs a fix; testing cannot usefully continue | `team-lead` | message + artifact |
| Testing complete with no blocking failures | `team-lead` | message + artifact |

### `qa` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs or the bug's expected result cannot be identified | `team-lead` | message |
| Test environment, build, or required data/access unavailable | `team-lead` | message |
| Failures look like product or process exceptions | `team-lead` | message |
| Scope of related features unclear after one clarification | `team-lead` | message |

### `closer` handoff

| When | Next | Interaction |
|---|---|---|
| Clean-up or follow-up needs another Role's permissions or craft | `team-lead` | message |
| Clean-up needs the human's confirmation before it starts | `team-lead` | message + gate |
| The checks are done: omissions, unfinished work, Issue Tracker status | `team-lead` | message + artifact |
| A `/retro` round is proposed for every member | `team-lead` | message |
| Retro summary and proposed follow-ups are ready for human confirmation | `team-lead` | message + gate + relay |
| Close-out is complete | `team-lead` | message |

### `closer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Acceptance or done status unclear | `team-lead` | message |
| Clean-up needs access this Role cannot get and no owning Role responds | `team-lead` | message |
| A `/retro` round cannot be completed after a reasonable ask | `team-lead` | message |
| Follow-ups need a product or process call the human has not confirmed | `team-lead` | message |

## Run state and artifacts

One **run** is one team execution of this process document (intake through close-out). Several runs may be active at once. A run belongs to one group under one `team-lead`; `manager` may track several runs but writes none of them.

Handoff artifacts: a short message is handed over directly in the message. Anything long or detailed goes into a file under the run folder, and the handoff carries the file path.

### STATUS

- Path: `runs/<run-id>/STATUS.md` (copy from [`runs/_template/`](../runs/_template/) when starting a run)
- **Single writer:** `team-lead`. Other Roles write handoff artifacts only, then report to `team-lead`.
- Chat history is not the source of truth across agents.

Every in-flight Role **instance** has one row in `STATUS.md` with at least:

| Field | Meaning |
|---|---|
| Role slug | e.g. `developer` |
| Instance id | e.g. `developer#2` |
| Agent id | harness id when known (for resume) |
| Slice | short summary of the assigned work |
| Path ownership | file/directory set this instance may edit |
| Phase | e.g. `in_progress`, `handed_off`, `blocked` |
| Artifacts | paths of handoff files for this instance |
| Waiting on | none / `team-lead` / human / another instance |

`team-lead` also keeps a short run-level summary (brief pointer, overall phase, branch/worktree), and sets the final phase to Done.

### Role instances

- A Role card may initialize many instances in the same run (same Role or different Roles).
- Parallel instances require **disjoint path ownership** recorded in `STATUS.md` before they edit. If ownership would overlap, serialize or re-split.
- Members do not coordinate peer-to-peer; they return to `team-lead`. `team-lead` updates `STATUS.md` on dispatch, reclaim, and re-dispatch.
- Every Role reads the run folder and writes its own handoff artifacts under `runs/<run-id>/`; `team-lead` alone writes `STATUS.md`.

### Artifact layout

Product code stays on the run's work branch. Process handoff artifacts live under the run folder:

```text
runs/<run-id>/
  STATUS.md
  brief.md
  research/
  design/
  review/
  qa/
  closeout/
  dev/<instance-id>/
```

The next Role reads only paths listed in `STATUS.md` (and the brief). `.workflow/` changes live in the `.workflow/` repository, not in a run folder.

## Caveats

`team-lead` → members by `slash /retro` — unsupported on Cursor / Local IDE chat; the human runs `/retro` there instead; kept by human.

`team-lead` → members by `slash /retro` — uncertain on DSH / Local IDE chat; the human runs `/retro` there instead; kept by human.

Slash commands or skills that only a human can run are not invoked by a Role agent. `/retro` is the one exception written above: members run it where the pair supports it, after the human agrees; elsewhere `team-lead` reminds the human to run it.
