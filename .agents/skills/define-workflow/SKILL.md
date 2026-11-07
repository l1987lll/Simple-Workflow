---
name: define-workflow
description: Create or revise the workflow definition by recording harness and environment support, then offering the most likely workflows for the existing Roles.
disable-model-invocation: true
---

# define-workflow

Interview the human, then create or revise the process document. Spec, from the repo root: `docs/define-workflow/spec.md`. Vocabulary: repo-root `GLOSSARY.md`. Section ownership, the this-session test, and a filled fragment: [reference.md](reference.md). File shape: [templates/workflow.md](templates/workflow.md).

This skill file is English only. Generated process Markdown is English. Explain and ask in the human's language at runtime; do not put non-English script into this skill's files.

## Hard rules

- When `roles/` has no Role card, stop and point the human at `create-role`.
- The process document names only slugs that already exist under `roles/`. Ask for an existing slug when a route names one that does not.
- Write the process document only. Default directory is repo-root `workflows/`. Default path for a first create is `workflows/workflow.md`. Use another file name under `workflows/` when the human names one (for example `workflows/main-with-subagents.md`). When the human wants more than one process document, write each as its own file under `workflows/`; do not merge them into one file unless they ask. Do not write new process documents at repo root.
- At Gate, list existing process documents as well as Roles. If any exist and the human has not said create versus revise which file, ask before continuing.
- Leave Role cards unchanged.
- A slash command or skill that only the human can run is not invoked by a Role agent. Route it through the coordinating main Role (usually `team-lead`): that Role reminds the human to run it (gate + relay). Record that routing in the process document. Prefer this remind path over keeping an unsupported or uncertain agent-invoked slash as a caveat.
- After the workflow is accepted, run step Run state and artifacts before the check. The process document must say how a run records STATUS, who may write it, how each in-flight Role instance is listed, where handoff artifacts live, and how parallel instances get disjoint path ownership.
- A label belongs to the pair it was classified for.
- A route uses only interactions from the catalog below. Add a new kind to that catalog and classify it before any route uses it.

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
| slash | A named command or skill in that harness; support is per command |

## Gate

List every `roles/*/ROLE.md`: slug and one-line purpose.

List every process document already in the repo. Discover `workflows/*.md`. Also list legacy repo-root `workflow.md` and repo-root `workflow-*.md` if any still exist, and offer to move a revised file into `workflows/` on write. For each file found, give its path and a one-line shape summary from its opening (for example one main agent with sub-agents, or every Role a main agent). If none exist, say none.

If no Role card exists, stop and point the human at `create-role`.

If at least one process document exists, and the human has not already made clear whether this run **creates a new** process document or **revises** a named existing one, ask before any later interview step. Use these words:

These workflows are already in the repo. Is this run revising one of them (which path), or creating a new one?

A path or clear create/revise phrase answers. Do not ask again when the invoke already named the path or said create versus revise.

Done when the Role list is in hand (or the run stopped for no Role card), the process-document list was shown (including none), and either no process document exists, or the human has chosen create versus which existing file to revise.

## Interview

Say the step name, then explain it in 1–2 sentences, then ask. Use the English names below when speaking English; translate the same names if the human's language is not English. Create or revise is the opening of Choose workflow, not its own named step.

| Step | Name |
|---|---|
| Gate | Confirm roles |
| 1 | Harness and environment |
| 2 | Support |
| 4 | Choose workflow |
| 5 | Run state and artifacts |
| 6 | Check |
| 7 | Write |

### 1. Harness and environment

A **harness** is the agent product. An **environment** is where that product runs for this workflow. Ask for harnesses first, then environments. Record the same harness separately in each environment, because support can differ. In the file, one harness in one environment is a pair. Do not ask the human to name pairs.

Show this numbered list and ask the human to answer with numbers. More than one number is allowed. A harness not on the list is a name the human types.

1. Claude Code
2. GitHub Copilot
3. OpenAI Codex
4. Cursor
5. Grok Bot
6. DSH - Deepseek Harness

Show this numbered list once. In the same question, ask which numbers each chosen harness runs in. The human may assign a different set to each harness. More than one number per harness is allowed. An environment not on the list is a name the human types. Several environments for one harness are normal.

1. Local IDE chat — the session is inside an editor
2. Local CLI — the session is a terminal on the human's machine
3. Cloud agent — the agent runs remotely, not in the local editor or terminal

Done when at least one harness is chosen and each chosen harness has at least one environment.

### 2. Support

Read the this-session test in [reference.md](reference.md). Label a slash command when a Role card or the accepted workflow names it.

Decide this session's pair with the session-identity test in [reference.md](reference.md). Then label every interaction from the this-session test, and record `subagent-depth`, whether sub-agents can talk to each other, and `main-peers`. `subagent-depth` is how many further levels a sub-agent can create. `main-peers` is whether this main session can communicate with another main session: another chat session, or another bot. A sub-agent cannot communicate with the human. Do not detect that. Every run, tell the human the standing sentence in [reference.md](reference.md). An item the test does not settle is **uncertain**. When `subagent-depth` or peers is uncertain, say the matching sentence in [reference.md](reference.md). Do not call it a hint. Do not say "depth" as a substitute field name; the field is `subagent-depth`.

For every other pair, do not copy this session's labels. Show [templates/support-prompt.md](templates/support-prompt.md) once. Do not fill Harness or Environment. That prompt asks the other session to judge both. The suggested method in the prompt is the session-identity test; it is a suggestion, not a filled answer. Repeat the slash bullet and the slash result line once per named command. Omit both when no command is named. When no other pair remains, do not show the prompt.

Ask for those pairs one at a time, in the order the human chose them. Name the pair. Tell the human to paste that same prompt into that pair and paste the result back. Wait for the result before naming the next pair. Bind the result to the pair just named. The judged Harness and Environment lines are not the pair of record. When those lines are present and differ from the pair just named, keep the pair just named and tell the human both. A missing judgment does not change the pair. Ask before adding a pair the human did not choose. A missing interaction, a missing `subagent-depth` line, a missing peers line, or a missing `main-peers` line in a result is **uncertain**. When `subagent-depth` or peers is uncertain, say the matching sentence in [reference.md](reference.md). Do not call it a hint. Do not say "depth" as a substitute field name; the field is `subagent-depth`. Call the field `subagent-depth`. Tell the human the standing sentence about sub-agents and the human.

Use these words, with the pair filled in:

Paste that same prompt into <harness> / <environment>, then paste the reply back here.

When the echo differs, use these words:

This step named <step harness> / <step environment>. The reply wrote <echo harness> / <echo environment>. Keep this step's pair as the pair of record.

An interaction the human is unsure about is **uncertain**. After each result, tell the human that pair's unsupported and uncertain labels before naming the next pair.

On a revise, keep each label already in the file until the human changes that pair or that interaction. When this session is a stored pair and today's tools disagree with a stored label, warn and ask before changing it.

Done when every pair has a label for every interaction, a `subagent-depth` value, a peers label, a `main-peers` label, and every named slash command, the standing sentence was told to the human, and every unsupported or uncertain label was told to the human in plain words. When other pairs exist, the support prompt was shown once with no harness or environment filled in, and each of them was named only after the previous result was in hand.

### 3. Create or revise

Do not announce a separate step name. This opens Choose workflow.

Use the Gate decision: which path this run writes, and whether it creates or revises.

When this run **revises** a named process document, read that file. Restate any caveat already in it. Ask what changes: pairs, support, the workflow shape, or run state and artifacts. Re-classify only pairs or interactions the human adds or disputes. When the human keeps the existing workflow shape, skip the menu in step 4. Step 5 (Run state and artifacts) still runs if that section changes or is missing; otherwise keep the stored run-state section. **Step 6 (Check) always runs on revise**, even when the human changed only one part and kept the rest. Keep the chosen path unless the human renames it.

When this run **creates** a process document, continue to step 4. Default path is `workflows/workflow.md` unless the human named another file under `workflows/` (including a second file beside an existing one).

Done when the create-versus-revise choice and target path are fixed, and either the human said which parts change on a revise, or the run is ready to offer workflows on a create.
### 4. Workflows

This step's name is Choose workflow.

Read each Role card's purpose, boundaries, Handoffs, When stuck, and Steps, and the support labels for the chosen pairs. Role-Playbook cards keep those sections in `PLAYBOOK.md`. Role-merged cards keep them in the Playbook region of `ROLE.md`. A workflow is the Role order, who receives each handoff or When-stuck raise, and the interaction that carries it. Role cards state when work leaves; the workflow states who is next. Offer shape: [reference.md](reference.md).

The interaction names are defined by this skill. They are not words every agent already has. Say that in the human's language. In the offer, write each interaction as its name from the table above plus its meaning, in the human's language. Also list, in those same words, every interaction that all chosen pairs marked supported, so the human need not remember the Support step.

In the offer, the columns are When, then Interaction, then Next, then what is handed. For every participating Role, include every Handoff bullet and every When stuck bullet. Include branches, return loops, and any stop limit that changes who is next. A one-line sketch is not an option.

In each option, every Role instance is either a main agent or a sub-agent. Say which before that Role's rows. A sub-agent cannot communicate with the human. It returns work to the main session that created it. The human talks only with a main agent. Two main agents communicate directly only when `main-peers` is supported on every pair; otherwise the human carries the brief with relay. Which Roles are main agents is part of what makes two options different. Fewer main agents is less human participation.

Build the offer from the cards and from interactions every chosen pair marks supported. Use `subagent-depth`, peers, and `main-peers`. A Role other than the top session may spawn only when every pair's `subagent-depth` allows that many further levels. Two sub-agents may communicate only when every pair's peers label is supported. Two main sessions may communicate only when every pair's `main-peers` is supported. A sub-agent does not talk with the human: it returns to the main session, and that session uses relay for the human. Warn as with any unsupported or uncertain interaction. A Role whose card makes it conditional is a branch, or a separate offer when leaving that Role out changes the shape. Two offers differ by who takes part or by which interaction carries the work.

When one workflow fits, describe it and ask the human to accept it or say what to change. When several fit, number at most three. Order by feasibility, then by how little the human must take part. A shape whose interactions are supported on every pair comes before one that needs an unsupported or uncertain interaction. On that later shape, name the pair, the interaction, and the label. Among equally feasible shapes, put first the one that uses relay only for a decision the human must make. A shape that uses relay to carry every brief between Roles comes after that. `gate` counts as human participation too.

Ask with these words:

Which of these workflows is closest to how you will actually work? Reply with a number to choose, and add any changes you want.

A number selects that option. Further text is the human's modifications. Check the accepted workflow on every pair:

- Every pair **supported** → accept
- Any pair **unsupported** or **uncertain** → warn with the pair, the interaction, and the label. Ask the human to drop that part, switch it to an interaction every pair marks supported, or keep it. A kept part is a **caveat**

Done when one workflow is accepted, including any changes the human named, every Handoff and When stuck bullet of each participating Role is stated in that workflow, and each interaction it uses is supported on every pair or kept as a caveat after a warning this run.

### 5. Run state and artifacts

This step's name is Run state and artifacts.

After a workflow is accepted, decide how a live run records progress when more than one Role or more than one agent instance is in flight. Say that chat history is not the source of truth across agents.

Propose this default unless the human already has one. Ask them to accept it or name changes.

**Defaults**

- One **run** is one team execution of the accepted workflow (intake through close-out). Multiple runs may proceed at the same time.
- Record run state in the shared repo at `runs/<run-id>/STATUS.md` (or another path the human names). Product code stays on the run's work branch; process artifacts stay under `runs/<run-id>/`.
- The coordinating main Role (usually `team-lead`) is the **only writer** of `STATUS.md`. Other Roles write handoff artifacts only, then message the coordinator.
- Every in-flight Role **instance** has one row in `STATUS.md`: Role slug, instance id (for example `developer#2`), harness agent id when known, slice summary, path ownership, phase, artifact paths, and what it is waiting on.
- A Role card may initialize many instances. Parallel instances (same Role or different Roles) need **disjoint path ownership** recorded before they edit. If ownership would overlap, serialize or re-split.
- Instances do not coordinate peer-to-peer unless every pair marks subagent-peers or main-peers supported for that path; default is return or message through the coordinator.
- Suggested artifact layout (human may rename folders):

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

Ask with these words:

This step is Run state and artifacts. Default: `runs/<run-id>/STATUS.md`, single writer `team-lead`; one row per in-flight Role instance; handoff artifacts under the same run folder; parallel work must register disjoint path ownership first. Accept the default, or name changes to the path, fields, or writer?

On a revise, keep the run-state section already in the process document until the human changes it.

Done when the human accepted the default or named the path, writer, required instance fields, artifact layout, and parallel-ownership rule to store in the process document.

### 6. Check

Always run this step after create and after revise. Do not skip Check because only one section changed.

Before writing, walk the accepted workflow once. A check passes when the workflow matches what the human has said for every pair. When it conflicts or is still unknown, discuss it: name the pair, the route, and the problem, then ask the human to drop that part, switch it, keep it as a caveat, or add a sentence that states the constraint.

1. **Catalog.** Every slug exists under `roles/`. Every interaction is in the catalog. An unsupported or uncertain use is a caveat the human kept this run.
2. **Mode.** Each pair records whether this run may edit the repo and whether it waits for approval. A route that writes or spawns needs a mode that may edit. A route that continues with no person waiting needs a mode that does not wait.
3. **Attendant.** A human is available when each relay or gate happens on that pair.
4. **Shared repo.** On each artifact route, the next Role can read the files this Role wrote.
5. **Caller.** A slash command the workflow has a Role run is invocable by that Role on that pair. A human-only command or skill is carried by relay: the coordinating main Role (usually `team-lead`) reminds the human to run it.
6. **Overlap.** When the workflow uses parallel, it states which files each Role changes, or that they use separate workspaces.
7. **Craft tool.** When a route depends on a tool named in a Role's Steps, that tool is confirmed for each pair.
8. **Run state.** The process document states the run STATUS path, the single writer, required per-instance fields, artifact layout, and the disjoint path-ownership rule for parallel instances.

Done when every check passes, or each failure was discussed and the human chose.

### 7. Write and report

Fill [templates/workflow.md](templates/workflow.md) with the pairs, labels, conditions, roles used, flow, routes, run state and artifacts, and caveats. One slash row per command; omit it when the workflow calls no command. One handoff table and one when-stuck table per slug. Conditions record, per pair, the mode, whether a human is available at handoffs, and whether Roles share one repo. Caveat lines match the fragment in [reference.md](reference.md). The Caveats section is `(none)` when nothing was kept. Report the path.

Done when the file under `workflows/` matches the accepted workflow after the check, caveats and conditions are visible, the path was reported, and Role cards are unchanged.

## Completion criteria

- [ ] At least one Role card existed; slugs listed
- [ ] Existing process documents listed (or none); create versus revise chosen when more than none existed and the invoke was unclear
- [ ] At least one harness + environment pair named
- [ ] Every interaction labeled per pair; `subagent-depth`, peers, and `main-peers` recorded; slash labeled per command
- [ ] The standing sentence that a sub-agent cannot communicate with the human was told to the human
- [ ] Unsupported and uncertain labels told to the human
- [ ] The human accepted one workflow: the only description, a numbered choice, that choice plus named changes, or the existing workflow kept on a revise
- [ ] Flow and routes use existing slugs and catalog interactions
- [ ] Unsupported or uncertain uses warned this run; kept ones written as caveats
- [ ] The check passed on this create or revise, or each failure was discussed and the human chose
- [ ] Conditions recorded per pair
- [ ] Run state and artifacts accepted: STATUS path, single writer, per-instance rows, artifact layout, parallel path ownership
- [ ] Process document written in English; path reported
- [ ] Role cards unchanged
