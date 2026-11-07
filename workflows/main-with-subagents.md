# Workflow

End-to-end collaboration among Roles. Role-local craft stays on the Role card.

Shape: one main agent (team-lead); all other participating Roles run as sub-agents of that main session. A sub-agent cannot communicate with the human; it returns work to team-lead. The human talks with team-lead only.

Slash commands or skills that only a human can run are not invoked by a Role agent. team-lead reminds the human to run them (including /retro).

## Targets

| Harness | Environment |
|---|---|
| Cursor | Local IDE chat |
| DSH | Local IDE chat |

## Support

Each cell is supported, unsupported, or uncertain, except subagent-depth, which is 
one, a number of further levels a sub-agent can create, or uncertain. Slash rows name the command.

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
| Cursor / Local IDE chat | May edit the repo; does not wait for approval; the main agent decides | Human is available through team-lead only (not watching other Roles) | yes |
| DSH / Local IDE chat | May edit the repo; does not wait for approval; the main agent decides | Human is available through team-lead only (not watching other Roles) | yes |

## Roles

- `team-lead` — main agent; intake with the human, assign and coordinate, unblock until done
- 
research-architect — sub-agent; opened only when research or architecture is needed
- `developer` — sub-agent; implements the agreed change
- `code-reviewer` — sub-agent; reviews the branch/PR
- `qa` — sub-agent; verifies the change
- `closer` — sub-agent; drives close-out after acceptance

## Flow

1. Human talks with team-lead until the ask is clear.
2. If research or architecture is required, team-lead spawns 
research-architect; otherwise spawns developer.
3. 
research-architect returns a plan to team-lead; team-lead then spawns developer with that plan.
4. developer returns a reviewable branch/PR; team-lead spawns or resumes code-reviewer.
5. Review loops (at most four rounds): findings go to team-lead, which resumes developer, then resumes code-reviewer for the next pass.
6. When review is clear or the round limit is hit, team-lead spawns qa.
7. On QA failure, team-lead resumes developer then `qa` as needed. On QA pass, team-lead confirms done-when with the human (gate), then spawns closer.
8. closer inventories cleanup and lessons; for /retro and any other human-only skill, returns to team-lead, which reminds the human to run it. Follow-ups are proposed to the human via team-lead (gate) before anyone applies them.
9. Parallel is allowed when team-lead starts independent slices that do not edit the same files; otherwise Roles run one after another through team-lead.
10. `team-lead` may spawn or message multiple `developer` instances in parallel (`developer#1`, `developer#2`, …) when `STATUS.md` records disjoint path ownership for each instance; otherwise serialize.

## Routes

### `team-lead` handoff

| When | Next | Interaction |
|---|---|---|
| Ask is clear and research or architecture is required | `research-architect` | spawn + artifact |
| Ask is clear and implementation can start | `developer` | spawn + artifact |
| A Role finishes a slice and the next Role needs the result | next Role (sub-agent) or human | message + artifact; resume when continuing the same agent |
| Task meets done-when; confirmation or close-out remains | human, then `closer` | gate, then spawn + artifact |

### `team-lead` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Human goals conflict or done-when cannot be agreed | human | gate + relay |
| Next move needs deep research or architecture beyond coordination | `research-architect` | spawn + artifact |
| Two Roles disagree and this Role cannot resolve it | human | gate + relay |
| Process or priority trade-off needs an explicit human call | human | gate + relay |

### `research-architect` handoff

| When | Next | Interaction |
|---|---|---|
| Research findings and recommended approach are written and reviewable | `team-lead` | message + artifact |
| Architecture or plan is implementable without further design ownership here | `team-lead` (then developer) | message + artifact |
| Only remaining blocker is a clarifying question for the human or Team Lead | `team-lead` | message |

### `research-architect` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Success criteria or constraints missing or contradictory after one clarification | `team-lead` | message |
| Required codebase or domain access unavailable | `team-lead` | message |
| Trade-offs need an explicit product or priority call | `team-lead` | message |
| Ask requires product implementation to answer | `team-lead` | message |

### `developer` handoff

| When | Next | Interaction |
|---|---|---|
| Implementation ready for review (branch/PR prepared) | `team-lead` (then code-reviewer) | message + artifact |
| Review feedback addressed; another review pass needed | `team-lead` (then resume `code-reviewer`) | message + artifact |
| Review cycle finished; work ready for testing | `team-lead` (then qa) | message + artifact |

### `developer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Requirements conflict, incomplete, or change mid-implementation | `team-lead` | message |
| Needs architecture or research beyond normal coding judgment | `team-lead` | message |
| Blocked by missing access, environments, or dependencies | `team-lead` | message |
| CODING_STANDARDS.md or COMMIT_RULES.md not found after search order | `team-lead` | message |
| Review feedback asks for a product or process exception | `team-lead` | message |

### `code-reviewer` handoff

| When | Next | Interaction |
|---|---|---|
| Review round findings written (fixes needed or clean) | `team-lead` (then resume `developer` if fixes needed) | message + artifact |
| Four-round review limit reached | `team-lead` | message + artifact |
| No blocking findings; implementer can proceed | `team-lead` (then qa) | message + artifact |

### `code-reviewer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs missing or cannot be identified | `team-lead` | message |
| Rules files not found after search order | `team-lead` | message |
| Diff, branch, or PR access unavailable | `team-lead` | message |
| Finding needs a product or process exception | `team-lead` | message |

### `qa` handoff

| When | Next | Interaction |
|---|---|---|
| Pass/fail report written | `team-lead` | message + artifact |
| Failure needs a fix; testing cannot usefully continue | `team-lead` (then resume `developer`) | message + artifact |
| Testing complete with no blocking failures | `team-lead` (gate human, then closer) | message + artifact |

### `qa` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Story ACs or bug expected result cannot be identified | `team-lead` | message |
| Test environment, build, or required data/access unavailable | `team-lead` | message |
| Failures look like product or process exceptions | `team-lead` | message |
| Scope of related features unclear after one clarification | `team-lead` | message |

### `closer` handoff

| When | Next | Interaction |
|---|---|---|
| Cleanup or follow-up needs another Role's permissions or craft | `team-lead` (coordinates that Role) | message |
| Retro materials ready; /retro or other human-only skill must run | `team-lead` (reminds human to run the skill) | message + gate + relay |
| Retro summary and proposed follow-ups ready for human confirmation | `team-lead` → human | message + gate + relay |
| Close-out complete | `team-lead` → human | message + gate |

### `closer` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Acceptance or done status unclear | `team-lead` | message |
| Cleanup needs access this Role cannot get and no owning Role responds | `team-lead` | message |
| /retro or another human-only skill cannot be completed after a reasonable remind | `team-lead` → human | message + gate + relay |
| Follow-ups need a product or process call the human has not confirmed | `team-lead` → human | message + gate + relay |

## Run state and artifacts

One **run** is one team execution of this process document (intake through close-out). Several runs may be active at once.

### STATUS

- Path: `runs/<run-id>/STATUS.md` (copy from [`runs/_template/`](../runs/_template/) when starting a run)
- **Single writer:** `team-lead` (the main agent). Other Roles write handoff artifacts only, then message `team-lead`.
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

`team-lead` also keeps a short run-level summary (brief pointer, overall phase, branch/worktree).

### Role instances

- A Role card may initialize many instances in the same run (same Role or different Roles).
- Parallel instances require **disjoint path ownership** recorded in `STATUS.md` before they edit. If ownership would overlap, serialize or re-split.
- Sub-agents do not coordinate peer-to-peer; they return to `team-lead`. `team-lead` updates `STATUS.md` on dispatch, reclaim, and re-dispatch.

### Artifact layout

Product code stays on the run's work branch. Process handoff artifacts live under the run folder:

```text
runs/<run-id>/
  STATUS.md
  brief.md
  research/
  review/
  qa/
  closeout/
  dev/<instance-id>/
```

The next Role reads only paths listed in `STATUS.md` (and the brief). Human-only skills (including `/retro`) are reminded by `team-lead`; that remind is recorded as waiting on human when active.

## Caveats

(none)

Human-only slash /retro is not kept as an agent-invoked route. team-lead reminds the human to run it (and any other human-only skill the workflow needs).
