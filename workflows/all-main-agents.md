# Workflow

End-to-end collaboration among Roles. Role-local craft stays on the Role card.

Shape: every Role is a main agent (one Grok Bot per Role). Bots communicate with each other using message + artifact. The human's primary conversation is with the team-lead bot; the human may occasionally open another Role bot but usually does not intervene there. Gate and any relay go through team-lead.

Slash commands or skills that only a human can run are not invoked by a Role bot. The team-lead bot reminds the human to run them (including /retro).

## Targets

| Harness | Environment |
|---|---|
| Grok Bot | Local IDE chat |
| Grok Bot | Cloud agent |

## Support

Each cell is supported, unsupported, or uncertain, except subagent-depth, which is 
one, a number of further levels a sub-agent can create, or uncertain. Slash rows name the command.

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
| Grok Bot / Local IDE chat | May edit the repo; does not wait for approval; the main agent (team-lead or the Role bot in scope) decides | Human is available primarily through team-lead; other Role bots are rarely watched and usually not interrupted | yes |
| Grok Bot / Cloud agent | May edit the repo; does not wait for approval; the main agent (team-lead or the Role bot in scope) decides | Human is available primarily through team-lead; other Role bots are rarely watched and usually not interrupted | yes |

## Roles

- `team-lead` — main bot; intake with the human, assign and coordinate other Role bots, unblock until done
- 
research-architect — main bot; used only when research or architecture is needed
- `developer` — main bot; implements the agreed change
- `code-reviewer` — main bot; reviews the branch/PR
- `qa` — main bot; verifies the change
- `closer` — main bot; drives close-out after acceptance

## Flow

1. Human talks with the team-lead bot until the ask is clear.
2. team-lead messages 
research-architect or developer with a brief and artifact paths.
3. Each Role bot does its craft and messages team-lead (and the next Role when team-lead directs) with results and artifacts.
4. Review and QA loops use message + artifact + resume of the same Role bot as needed; team-lead stays the coordinator.
5. On QA pass, team-lead gates done-when with the human, then messages closer.
6. For /retro and any other human-only skill, closer tells team-lead, which reminds the human to run it—even when slash /retro is supported on these pairs, human-only skills still go through that remind path when the human must be the one to run them.
7. Follow-ups from retro require human confirmation via team-lead (gate) before work proceeds.
8. Parallel Role bots may run when they do not edit the same files; otherwise team-lead serializes them.
10. `team-lead` may spawn or message multiple `developer` instances in parallel (`developer#1`, `developer#2`, …) when `STATUS.md` records disjoint path ownership for each instance; otherwise serialize.

## Routes

### `team-lead` handoff

| When | Next | Interaction |
|---|---|---|
| Ask is clear and research or architecture is required | `research-architect` | message + artifact |
| Ask is clear and implementation can start | `developer` | message + artifact |
| A Role finishes a slice and the next Role needs the result | next Role bot or human | message + artifact; resume when continuing the same bot |
| Task meets done-when; confirmation or close-out remains | human, then `closer` | gate, then message + artifact |

### `team-lead` when stuck

| When | Raise to | Interaction |
|---|---|---|
| Human goals conflict or done-when cannot be agreed | human | gate + relay |
| Next move needs deep research or architecture beyond coordination | `research-architect` | message + artifact |
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
| Cleanup or follow-up needs another Role's permissions or craft | `team-lead` (coordinates that Role bot) | message |
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

One **run** is one team execution of this process document (intake through close-out). Several runs may be active at once. Each Role is a main Grok Bot; bots still share one run record.

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

`team-lead` also keeps a short run-level summary (brief pointer, overall phase, branch/worktree).

### Role instances

- Parallel Role bots (and multiple instances of the same Role) require **disjoint path ownership** recorded in `STATUS.md` before they edit. If ownership would overlap, serialize or re-split.
- Role bots do not bypass `team-lead` for STATUS updates. Cross-bot delivery uses message + artifact; the human's primary conversation remains with `team-lead`.

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

The next Role reads only paths listed in `STATUS.md` (and the brief). Human-only skills (including `/retro` when the human must run them) are reminded by `team-lead`; that remind is recorded as waiting on human when active.

## Caveats

(none)

Human-only skills (including /retro when the human must run them) go through team-lead reminding the human, not silent agent invocation.
