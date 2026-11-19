# Workflow

End-to-end collaboration among Roles. Role-local craft stays on the Role card.

Shape: every Role is a main bot. `manager`, `team-lead`, `assistant`, and `workflow-owner` are the bots the human opens; the rest are group members. `main-peers` is supported on both pairs, so the four bots message each other directly. Members never message each other; they go through `team-lead`. `team-lead` never messages another `team-lead`; `manager` carries that.

Levels: the human is level 1. `manager`, `assistant`, and `workflow-owner` are level 2 and do not manage each other. `team-lead` is level 3 and manages its own group. Expert groups are planned and have no Role cards yet; when their cards land they sit under `manager`, and a member attached to a team answers to that `team-lead`, while a member working alone tracks their own PR.

Only `workflow-owner` writes the definition files under `.workflow/`—process documents, Role cards, run templates, Team configs, and project standards. Everyone reads and writes the live run folder `runs/<run-id>/`: members write their own handoff artifacts there and `team-lead` alone writes `STATUS.md`. Run artifacts are not definition changes. The `.workflow/` repository tracks definitions only; `runs/` is ignored, so run data never enters its history.

## Targets

| Harness | Environment |
|---|---|
| Grok Bot | Local IDE chat |
| Grok Bot | Cloud agent |

## Support

Each cell is supported, unsupported, or uncertain, except subagent-depth, which is one, a number of further levels a sub-agent can create, or uncertain. Slash rows name the command.

| Interaction | Grok Bot / Local IDE chat | Grok Bot / Cloud agent |
|---|---|---|
| relay | supported | supported |
| switch | unsupported | supported |
| spawn | supported | supported |
| parallel | supported | supported |
| resume | supported | supported |
| message | supported | supported |
| artifact | supported | supported |
| gate | supported | supported |
| slash /retro | supported | supported |
| subagent-depth | none | none |
| subagent-peers | unsupported | unsupported |
| main-peers | supported | supported |

## Conditions

| Pair | Mode | Human at handoff | Shared repo |
|---|---|---|---|
| Grok Bot / Local IDE chat | May edit the repo; does not wait for approval; the main agent (the bot in scope) decides | Human is available through the bots the human opened; other bots are rarely watched | yes |
| Grok Bot / Cloud agent | May edit the repo; does not wait for approval; the main agent (the bot in scope) decides | Human is available through the bots the human opened; other bots are rarely watched | yes |

## Roles

- `manager` — main bot; level 2; manages every `team-lead`: task assignment, people, priorities, status, and proposals to the human. Does not join the business work
- `team-lead` — main bot; level 3; runs one task with its group and is the group's only channel
- `assistant` — main bot; level 2; personal chores only, and hands project or business work back to the human
- `workflow-owner` — main bot; level 2; the only writer of the `.workflow/` tree
- `research-architect` — main bot; member of a group; opened only when research or architecture is needed
- `ui-ux-designer` — main bot; member of a group; real interface design or interaction work
- `developer` — main bot; member of a group; implements the agreed change
- `code-reviewer` — main bot; member of a group; reviews the branch/PR
- `qa` — main bot; member of a group; verifies the change
- `closer` — main bot; member of a group; cleans up and drives close-out after acceptance

## Sub-flows

| Sub-flow | Path | Invoked at |
|---|---|---|
| Team loop | [`subflows/team-loop.md`](subflows/team-loop.md) | Flow step 2; all business Role handoff routes |

## Flow

1. The human talks with `team-lead` about the task. Rarely `manager` takes the task from the human and messages `team-lead` with the brief.
2. `team-lead` runs the [team loop](subflows/team-loop.md) with the business Role bots: assignment, research, design, implementation, review, PR tracking, QA, close-out, and `/retro`.
3. A `.workflow/` change goes only to `workflow-owner`, with no approval chain. Any Role messages it directly: a member messages `workflow-owner`, `manager` and `assistant` message it, and the human may open it. `workflow-owner` confirms with the human (gate) before writing, then commits the change in the `.workflow/` repository.
4. Parallel members are allowed when `team-lead` starts independent slices that do not edit the same files.
5. `team-lead` may run several `developer` instances in parallel (`developer#1`, `developer#2`, …) when `STATUS.md` records disjoint path ownership for each instance; otherwise serialize.

## Routes

### `manager` handoff

| When | Next | Interaction |
|---|---|---|
| The instruction is settled and every affected Role holds a current brief | `team-lead` | message + artifact |
| Priorities or owners changed and each affected Role has the new brief | `team-lead` | message + artifact |
| The human asked for status and the answer is assembled | human | relay |
| The human asked for a `.workflow/` change | `workflow-owner` | message + artifact |
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
| A member needs a `.workflow/` change | `workflow-owner` | message + artifact |

### `team-lead` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Human goals conflict or done-when cannot be agreed | human | gate + relay |
| The next move needs deep research or architecture beyond coordination | `research-architect` | message |
| Two members disagree and this Role cannot resolve it | human | gate + relay |
| Process or priority trade-off needs an explicit human call | human | gate + relay |

### `assistant` handoff

| When | Next | Interaction |
|---|---|---|
| The personal chore is done and the result is reported | human | relay |
| The request turned out to be project or business work | `manager` | message + artifact |
| The request is a `.workflow/` change | `workflow-owner` | message + artifact |
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
| The change came from `manager` or `assistant` and is ready for them | that Role | message + artifact |
| A change spans several documents and the batch is written and reported | human | relay |

### `workflow-owner` when stuck

| When | Raise to | Interaction |
|---|---|---|
| The requested change contradicts a documented route and the human has not said which wins | human | gate |
| A route needs an interaction the named pair does not support and no fallback exists | human | gate |
| The change would need a Role card shape the role-definition standard rejects | human | gate |
| A `teams/*.yaml` points at a process document that is missing or unreadable | human | gate |
| Git is available but the `.workflow/` repository cannot take a commit | human | gate |

### `research-architect` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Success criteria or constraints missing or contradictory after one clarification | `team-lead` | message |
| Required codebase or domain access unavailable | `team-lead` | message |
| Trade-offs need an explicit product or priority call | `team-lead` | message |
| Ask requires product implementation to answer | `team-lead` | message |

### `ui-ux-designer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Requirement goal or target user stays contradictory after one clarification | `team-lead` | message |
| No brand guide or design system exists and no one can set one | `team-lead` | message |
| The design needs a product trade-off beyond this Role's authority | `team-lead` | message |
| An agreed prototype needs a tool this Role lacks and no proposed alternative was accepted | `team-lead` | message |
| No answer on the prototype question and the design cannot be signed off without it | `team-lead` | message |

### `developer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Requirements conflict, are incomplete, or change mid-implementation | `team-lead` | message |
| Needs architecture or research beyond normal coding judgment | `team-lead` | message |
| Blocked by missing access, environments, or dependencies | `team-lead` | message |
| `CODING_STANDARDS.md` or `COMMIT_RULES.md` not found at `.workflow/project-standards/` | `team-lead` | message |
| Review feedback asks for a product or process exception | `team-lead` | message |

### `code-reviewer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs missing or cannot be identified | `team-lead` | message |
| Rules files not found after search order | `team-lead` | message |
| Diff, branch, or PR access unavailable | `team-lead` | message |
| A finding needs a product or process exception | `team-lead` | message |

### `qa` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs or the bug's expected result cannot be identified | `team-lead` | message |
| Test environment, build, or required data/access unavailable | `team-lead` | message |
| Failures look like product or process exceptions | `team-lead` | message |
| Scope of related features unclear after one clarification | `team-lead` | message |

### `closer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Acceptance or done status unclear | `team-lead` | message |
| Clean-up needs access this Role cannot get and no owning Role responds | `team-lead` | message |
| A `/retro` round cannot be completed after a reasonable ask | `team-lead` | message |
| Follow-ups need a product or process call the human has not confirmed | `team-lead` | message |

## Run state and artifacts

One **run** is one team execution of this process document (intake through close-out). Several runs may be active at once. Each Role is a main bot; bots still share one run record. A run belongs to one group under one `team-lead`; `manager` may track several runs but writes none of them.

Handoff artifacts: a short message is handed over directly in the message. Anything long or detailed goes into a file under the run folder, and the handoff carries the file path.

### STATUS

- Path: `runs/<run-id>/STATUS.md` (copy from [`runs/_template/`](../runs/_template/) when starting a run)
- **Single writer:** the `team-lead` bot. Other Role bots write handoff artifacts only, then message `team-lead`.
- Chat history is not the source of truth across bots.

Every in-flight Role **instance** (usually one bot per Role; more than one bot may share a Role slug only with disjoint path ownership) has one row in `STATUS.md` with at least:

| Field | Meaning |
|---|---|
| Role slug | e.g. `developer` |
| Instance id | e.g. `developer#2` |
| Agent id | bot / agent id when known (for resume) |
| Slice | short summary of the assigned work |
| Path ownership | file/directory set this instance may edit |
| Phase | e.g. `in_progress`, `handed_off`, `blocked` |
| Artifacts | paths of handoff files for this instance |
| Waiting on | none / `team-lead` / human / another instance |

`team-lead` also keeps a short run-level summary (brief pointer, overall phase, branch/worktree), and sets the final phase to Done.

### Role instances

- Parallel Role bots (and multiple instances of the same Role) require **disjoint path ownership** recorded in `STATUS.md` before they edit. If ownership would overlap, serialize or re-split.
- Role bots do not bypass `team-lead` for STATUS updates. Cross-bot delivery uses message + artifact; members never message each other.
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

(none)

`/retro` is run by members on their own bot after the human agrees in the close-out gate; `team-lead` never runs another bot's retrospective for it.
