# define-workflow — Design Spec

Date: 2026-11-08  
Status: approved

## Intent

Provide a project skill `define-workflow` that interviews the human and creates or revises a **process document** under `workflows/`. The document states how existing Roles collaborate, which harness and environment pairs it runs on, and how a live run records status and handoff artifacts. Role cards stay local. This spec covers the skill only—not the contents of a particular process document.

## Decisions

| Decision | Choice |
|---|---|
| Artifact | One Markdown process document per workflow shape (not a Cursor Agent binding) |
| Skill location | `skills/define-workflow/` in this repo |
| Skill mirror | Byte-identical copy under `.agents/skills/define-workflow/` |
| Packaging | Skill + `reference.md` + templates (no scaffold script) |
| Prerequisite | At least one Role card under `roles/`. Otherwise stop and point at `create-role` |
| Output directory | `workflows/`. Default first file: `workflows/workflow.md`. Another name only when the human names it. Several workflows are several files. Do not merge them unless asked. Do not write a new process document at repo root |
| Legacy files | Gate also lists repo-root `workflow.md` and `workflow-*.md` if present, and may move a revised file into `workflows/` on write |
| Doc language | English in the process document. Interview in the human's language (often Chinese). A few ask-lines are fixed Chinese |
| Invocation | User-invoked (`disable-model-invocation: true`) |
| Interaction names | This skill's catalog. Not words every agent already has. Say that in the human's language. |
| Support labels | `supported`, `unsupported`, or `uncertain`. A label belongs to one pair |
| `subagent-depth` | `none`, a number of further levels, or `uncertain`. Do not say "depth" as a substitute field name; the field is `subagent-depth` |
| Sub-agent and the human | Standing rule, not detected: a sub-agent cannot communicate with the human. The human talks only with the main session they opened. The sub-agent returns its result to that session |
| Human-only slash | Do not keep an agent-invoked slash the Role cannot run. The coordinating main Role (usually `team-lead`) reminds the human to run it (`gate` + `relay`) |
| Offer order | At most three options. Feasible on every pair first. Among those, less human participation first. `relay` on every hop, and `gate`, count as more human participation |
| Offer grain | Runnable rows, not a sketch. Columns: When, Interaction, Next, what is handed. Every Handoff and When stuck bullet of each participating Role. Each Role instance marked main agent or sub-agent |
| Run record | Chat history is not the source of truth across agents. Default: `runs/<run-id>/STATUS.md`, single writer is the coordinating main Role |

## Repository layout

```
workflows/                      # process documents (may be absent until the skill runs)
  workflow.md                   # default name for a first create
docs/define-workflow/spec.md
skills/define-workflow/         # source of truth
  SKILL.md
  reference.md
  templates/workflow.md
  templates/support-prompt.md
.agents/skills/define-workflow/ # byte-identical mirror
```

## Announced steps

Say the step name, then explain in 1–2 sentences, then ask. Chinese names:

| Step | Name |
|---|---|
| Gate | Confirm roles |
| 1 | Harness and environment |
| 2 | Support |
| 4 | Choose workflow |
| 5 | Run state and artifacts |
| 6 | Check |
| 7 | Write |

Create versus revise is not its own announced name. It opens Choose workflow.

## Gate

List every `roles/*/ROLE.md` (slug and one-line purpose) and every process document already found. For each process document, path plus a one-line shape summary from its opening.

If at least one process document exists and the invoke did not already say create versus which file to revise, ask before any later step, in these words:

These workflows are already in the repo. Is this run revising one of them (which path), or creating a new one?

## Interview (ordered)

### 1. Harness and environment

Ask harnesses first, then environments. One harness plus one environment is a pair. Do not ask the human to name pairs.

Harness list (numbers; more than one allowed; a name not on the list is typed):

1. Claude Code
2. GitHub Copilot
3. OpenAI Codex
4. Cursor
5. Grok Bot
6. DSH - Deepseek Harness

Environment list, shown once. The human assigns numbers per harness. More than one per harness is allowed. A name not on the list is typed.

1. Local IDE chat — the session is inside an editor
2. Local CLI — the session is a terminal on the human's machine
3. Cloud agent — the agent runs remotely, not in the local editor or terminal

### 2. Support

**This session.** Settle the pair with the session-identity test in `reference.md` (product name in the instructions; environment is where the session is attached, not where the model is hosted). Label the catalog from tools present now. Record `subagent-depth`, sub-agent peers, and `main-peers`.

**Other pairs.** Do not copy this session's labels. Show `templates/support-prompt.md` once, in English, with Harness and Environment left blank. The prompt suggests the session-identity test; it does not fill the answer. Ask for one pair at a time, in the order chosen, and wait for the paste before naming the next. The pair named in the step is the pair of record. When the reply's Harness or Environment lines differ, keep the step's pair and say both, in these words:

This step named <step harness> / <step environment>. The reply wrote <echo harness> / <echo environment>. Keep this step's pair as the pair of record.

Ask with:

Paste that same prompt into <harness> / <environment>, then paste the reply back here.

A missing line is `uncertain`. After each result, say that pair's unsupported and uncertain labels.

**Not detected.** Every run, say: A sub-agent cannot communicate with the human. The human talks only with the main session they opened; the sub-agent returns results to that session.

**Uncertain `subagent-depth` or peers.** Say the matching sentence in `reference.md`. Do not call that sentence a hint.

**Slash.** Label each command a Role card or the accepted workflow names. Support is per command.

### 3. Opens Choose workflow

Revise: read the chosen file, restate caveats, ask what changes. Keeping the shape skips the menu in step 4. Steps 5–6 still run.

Create: continue to step 4. Default path `workflows/workflow.md` unless the human named another file under `workflows/`.

### 4. Choose workflow

Read each Role card, including `PLAYBOOK.md` or the Playbook region. Draft from Handoffs and When stuck. Who is next is this file; when work leaves stays on the Role card.

Each option states, per Role, main agent or sub-agent. A sub-agent cannot talk with the human and returns to the main session that created it. A sub-agent spawns only when every pair's `subagent-depth` allows that level. Two sub-agents communicate only when every pair's peers label is supported. Two main sessions communicate only when every pair's `main-peers` is supported; otherwise the human uses relay. Fewer main agents is less human participation.

When several shapes fit, number at most three. A shape supported on every pair comes before one that needs an unsupported or uncertain interaction, and that later shape names the pair, the interaction, and the label. Among equally feasible shapes, relay only for a human decision comes before relay on every hop.

Ask with these words:

Which of these workflows is closest to how you will actually work? Reply with a number to choose, and add any changes you want.

A number selects that option. Further text is the modifications. An unsupported or uncertain use is dropped, switched to an interaction every pair supports, or kept as a caveat.

### 5. Run state and artifacts

After acceptance. Chat history is not the source of truth across agents. Offer the default and ask the human to accept or name changes:

- One run is one execution of the accepted workflow. Several runs may proceed at once.
- `runs/<run-id>/STATUS.md` (or a path the human names). The coordinating main Role is the only writer.
- One row per in-flight Role instance: slug, instance id, agent id when known, slice, path ownership, phase, artifact paths, waiting on.
- Handoff artifacts under `runs/<run-id>/`. Product code stays on the work branch.
- Parallel instances need disjoint path ownership before they edit.
- Suggested folders: `brief.md`, `research/`, `review/`, `qa/`, `closeout/`, `dev/<instance-id>/`.

Ask with these words:

This step is Run state and artifacts. Default: `runs/<run-id>/STATUS.md`, single writer `team-lead`; one row per in-flight Role instance; handoff artifacts under the same run folder; parallel work must register disjoint path ownership first. Accept the default, or name changes to the path, fields, or writer?

### 6. Check

Always run after create and after revise; do not skip because only one section changed.

Walk the accepted workflow once. A failure is discussed: name the pair, the route, and the problem. The human drops it, switches it, keeps a caveat, or adds a sentence that states the constraint.

1. Catalog — existing slugs; catalog interactions only; unsupported or uncertain uses are caveats kept this run
2. Mode — each pair records whether this run may edit and whether it waits for approval
3. Attendant — a human is available at each relay or gate
4. Shared repo — the next Role can read an artifact route's files
5. Caller — a slash the workflow has a Role run is invocable by that Role; a human-only command is reminded by the coordinating main Role
6. Overlap — parallel states disjoint files or separate workspaces
7. Craft tool — a tool named in a Role's Steps that a route depends on is confirmed per pair
8. Run state — STATUS path, single writer, instance fields, artifact layout, path-ownership rule

### 7. Write

Fill `templates/workflow.md`. English. One slash row per command; omit slash when the workflow calls none. One handoff table and one when-stuck table per slug. Caveats `(none)` when nothing was kept. Report the path. Leave Role cards unchanged.

## Catalog

| Interaction | What a route requires |
|---|---|
| relay | The human carries the brief to the next Role |
| switch | This session loads the next Role card and continues |
| spawn | This session starts another agent on a Role |
| parallel | More than one Role instance runs at the same time |
| resume | A later step continues a specific earlier agent |
| message | One agent delivers to another without the human |
| artifact | The next Role reads a file this Role wrote |
| gate | An explicit human yes before continuing |
| slash | A named command or skill; support is per command |

Recorded beside the catalog, not as extra interactions the human must memorize as "depth":

| Field | Values |
|---|---|
| `subagent-depth` | `none`, a number of further levels a sub-agent can create, or `uncertain` |
| `subagent-peers` | `supported`, `unsupported`, or `uncertain` — sub-agents talking to each other, not only back to the creator |
| `main-peers` | `supported`, `unsupported`, or `uncertain` — this main session reaching another main session (another chat, or another bot) without the human carrying the message |

## Process document sections

From `templates/workflow.md`: Targets, Support, Conditions (mode, human at handoff, shared repo), Roles, Flow, Routes (handoff and when stuck per slug), Run state and artifacts, Caveats.

## SKILL.md behavior

- `name`: `define-workflow`
- `disable-model-invocation: true`
- Read `reference.md` for session identity, the this-session test, uncertain sentences, offer shape, and the run-state default
- Read `templates/support-prompt.md` when another pair must be judged
- Read `templates/workflow.md` when writing
- Completion criteria are the checklist at the end of `SKILL.md`

## Out of scope

- Creating or editing Role cards
- Registering Cursor Agents or subagents
- Choosing product requirements, review findings, or QA results
- Detecting whether a sub-agent can talk to the human (standing rule instead)
- A support matrix hardcoded per harness (labels come from this session's tools or from a pasted result)

## Implementation approach

Interview, then fill `templates/workflow.md` into `workflows/<name>.md`. No scaffold script.
