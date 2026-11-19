---
name: define-workflow
description: Create or revise a main workflow or sub-workflow under workflows/ when the human wants a new way of working defined — interview for harness, environment, per-pair support, and the participating Roles on a main workflow, then offer the workflows those Roles can run and write the one the human accepts.
---

# define-workflow

Interview the human, then create or revise the process document. Spec, from the repo root: `docs/define-workflow/spec.md`. Vocabulary: repo-root `GLOSSARY.md`. Section ownership, the this-session test, and a filled fragment: [reference.md](reference.md). File shape: [templates/workflow.md](templates/workflow.md) for a main workflow and [templates/subflow.md](templates/subflow.md) for a sub-workflow. Doc craft, from the repo root: `docs/agent-docs.md`.

This skill file is English only. Generated process Markdown is English. Explain and ask in the human's language at runtime; do not put non-English script into this skill's files.

## Hard rules

- When `roles/` has no Role card, stop and point the human at `define-role`.
- The process document names only slugs that already exist under `roles/`. Ask for an existing slug when a route names one that does not.
- A workflow is a **main workflow** at `workflows/*.md` or a **sub-workflow** at `workflows/subflows/<slug>.md`. A main workflow owns pairs, support labels, conditions, run state, and caveats. A sub-workflow owns a reusable process fragment: Roles, entry, its nested `## Sub-flows`, Flow, Routes, exit, interactions used, and artifacts. It carries no pair, support, condition, run-state, or caveat section.
- Every sub-workflow is reachable from a main workflow through `## Sub-flows` tables. A sub-workflow may reference another sub-workflow; the reference graph has no cycles. A sub-workflow is never a Team's selected workflow.
- Write the process document only. Default directory is repo-root `workflows/` for a main workflow and `workflows/subflows/` for a sub-workflow. Default path for a first main create is `workflows/workflow.md`. Use another file name under those directories when the human names one (for example `workflows/main-with-subagents.md`). When the human wants more than one main workflow, write each as its own file under `workflows/`; do not merge them into one file unless they ask. Do not write new process documents at repo root.
- At Gate, list existing main workflows and sub-workflows as well as Roles. If any exist and the human has not said create versus revise which file, ask before continuing.
- Write the process document as a doc an agent reads: follow `docs/agent-docs.md`—one action per numbered step, reference below the steps, every pointer naming a path that exists
- Leave Role cards unchanged.
- Settle the participating Roles before offering shapes: on a create, choose from the cards under `roles/`; on a revise, keep, add, or remove. The Roles section, the route tables, and the Flow stay in step: every listed Role has one handoff table and one when-stuck table, and every route target is a listed Role. For a sub-workflow, every route target is one of its Roles; the main workflows that reach it keep the When-stuck tables, and the sub-workflow has no When-stuck table.
- A slash command or skill that only the human can run is not invoked by a Role agent. Route it through the coordinating main Role (usually `team-lead`): that Role reminds the human to run it (gate + relay). Record that routing in the process document. Prefer this remind path over keeping an unsupported or uncertain agent-invoked slash as a caveat.
- After a main workflow is accepted, run step Run state and artifacts before the check. The main workflow must say how a run records STATUS, who may write it, how each in-flight Role instance is listed, where handoff artifacts live, and how parallel instances get disjoint path ownership. A sub-workflow uses the run state of every main workflow that reaches it.
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

List every process document already in the repo. Discover main workflows at `workflows/*.md` and sub-workflows at `workflows/subflows/*.md`. Also list legacy repo-root `workflow.md` and repo-root `workflow-*.md` if any still exist, and offer to move a revised file into `workflows/` on write. For each file found, give its path and a one-line shape summary from its opening (for example one main agent with sub-agents, or every Role a main agent). If none exist, say none. A sub-workflow needs a path to a main workflow; when no main workflow exists, a create is a main workflow.

If no Role card exists, stop and point the human at `define-role`.

If at least one process document exists, and the human has not already made clear whether this run **creates a new** process document or **revises** a named existing one, ask before any later interview step. Use these words:

These workflows are already in the repo. Is this run revising one of them (which path), or creating a new one?

A path or clear create/revise phrase answers. Do not ask again when the invoke already named the path or said create versus revise. When the run creates a process document, ask whether it is a main workflow or a sub-workflow, and for a sub-workflow which workflow references it (a main workflow, or a sub-workflow that is itself reachable from a main).

Done when the Role list is in hand (or the run stopped for no Role card), the main-workflow and sub-workflow list was shown (including none), and either no process document exists, or the human has chosen create versus which existing file to revise; for a create, the file kind and the referencing workflow and main workflows are also fixed.

## Interview

Say the step name, then explain it in 1–2 sentences, then ask. Use the English names below when speaking English; translate the same names if the human's language is not English. Create or revise is the opening of Choose workflow, not its own named step.

| Step | Name |
|---|---|
| Gate | Confirm roles |
| 1 | Harness and environment |
| 2 | Support |
| 3 | Roles |
| 4 | Choose workflow |
| 5 | Run state and artifacts |
| 6 | Check |
| 7 | Write |

For a sub-workflow, skip steps 1, 2, and 5. The main workflows that reach it own pairs, support, conditions, and run state. Go from Gate to Roles (step 3), then Choose workflow (step 4).

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

### 3. Roles

This step's name is Roles.

Read every `roles/*/ROLE.md`, and its `PLAYBOOK.md` when the card has one. A workflow runs only the Roles the human picks; an unpicked Role gets no Roles line and no route tables. For a sub-workflow, this step settles the Roles inside the fragment; the main workflows that reach it keep the When-stuck tables, and the sub-workflow has handoff tables only.

On a **create**, show every card's slug and one-line purpose and ask which take part. More than one answer is allowed. One Role is allowed when the human says so.

On a **revise**, read the Roles section of the chosen file and show the Roles already in it, the cards that are not in it, and both route tables each current Role has. Ask what changes: keep, add, or remove. Name every Role the human adds or removes.

Apply the answer before the shape offer:

- A kept Role keeps its Roles line, its Flow mentions, and both route tables.
- An added Role gets a Roles line, one handoff table, and one when-stuck table built from its card's Handoffs and When stuck bullets. A sub-workflow added Role gets no when-stuck table.
- A removed Role loses its Roles line, both route tables, and every Flow mention. A route that pointed at it is re-pointed to a Role still listed, or the removal is dropped. A sub-workflow removed Role loses only its handoff table; the main workflow keeps the when-stuck table.
- The Flow is renumbered and reworded to match the final Role set.

On a **create**, the confirmation settles the Role set; the Flow arrives with the accepted shape in Choose workflow.

On a **revise**, show the adjusted Flow and every added or removed route. Ask with these words:

These are the Roles in the workflow and the flow they produce. Accept it, or name what to change.

Done when the participating Role set is fixed, every chosen Role's card was read, and on a revise the adjusted Flow and every added or removed route were shown and confirmed.

### 4. Workflows

This step's name is Choose workflow.

Open with the Gate decision: which path this run writes, whether it creates or revises, and whether the file is a main workflow or a sub-workflow.

For a sub-workflow, default path is `workflows/subflows/<slug>.md` unless the human named another file under `workflows/subflows/`. The run adds or updates the sub-workflow row in the `## Sub-flows` table of every referencing workflow, main or sub-workflow. A sub-workflow may invoke a nested sub-workflow for a reusable part inside it; offer that nested part the same way.

When this run **revises** a named process document, read that file. Restate any caveat already in it. Ask what changes beyond Roles: pairs, support, the workflow shape, or run state and artifacts. Re-classify only pairs or interactions the human adds or disputes. When the human keeps the existing workflow shape, skip the menu below. Step 5 (Run state and artifacts) still runs for a main workflow if that section changes or is missing; a sub-workflow skips it. **Step 6 (Check) always runs on revise**, even when the human changed only one part and kept the rest. Keep the chosen path unless the human renames it.

When this run **creates** a main workflow, build the offer from the Roles chosen in step 3. Default path is `workflows/workflow.md` unless the human named another file under `workflows/` (including a second file beside an existing one).

The cards for the chosen Roles were read in step 3; use their purpose, boundaries, Handoffs, When stuck, and Steps, and the support labels for the chosen pairs. Role-Playbook cards keep those sections in `PLAYBOOK.md`. Role-merged cards keep them in the Playbook region of `ROLE.md`. A workflow is the Role order, who receives each handoff or When-stuck raise, and the interaction that carries it. Role cards state when work leaves; the workflow states who is next. Offer shape: [reference.md](reference.md).

The interaction names are defined by this skill. They are not words every agent already has. Say that in the human's language. In the offer, write each interaction as its name from the table above plus its meaning, in the human's language. Also list, in those same words, every interaction that all chosen pairs marked supported, so the human need not remember the Support step.

In the offer, the columns are When, then Interaction, then Next, then what is handed. For every Role chosen in step 3, include every Handoff bullet and every When stuck bullet, except a handoff already owned by a referenced sub-workflow (name the sub-workflow and do not repeat its rows). In a sub-workflow offer, include every Handoff bullet of each Role the sub-workflow routes; its When stuck bullets stay in the main workflow. Include branches, return loops, and any stop limit that changes who is next. A one-line sketch is not an option.

In each option, every Role instance is either a main agent or a sub-agent. Say which before that Role's rows. A sub-agent cannot communicate with the human. It returns work to the main session that created it. The human talks only with a main agent. Two main agents communicate directly only when `main-peers` is supported on every pair; otherwise the human carries the brief with relay. Which Roles are main agents is part of what makes two options different. Fewer main agents is less human participation.

Build the offer from the cards and from interactions every chosen pair marks supported. Use `subagent-depth`, peers, and `main-peers`. A Role other than the top session may spawn only when every pair's `subagent-depth` allows that many further levels. Two sub-agents may communicate only when every pair's peers label is supported. Two main sessions may communicate only when every pair's `main-peers` is supported. A sub-agent does not talk with the human: it returns to the main session, and that session uses relay for the human. Warn as with any unsupported or uncertain interaction. A Role whose card makes it conditional is a branch, or a separate offer when leaving that Role out changes the shape. Two offers differ by who takes part or by which interaction carries the work.

When one workflow fits, describe it and ask the human to accept it or say what to change. When several fit, number at most three. Order by feasibility, then by how little the human must take part. A shape whose interactions are supported on every pair comes before one that needs an unsupported or uncertain interaction. On that later shape, name the pair, the interaction, and the label. Among equally feasible shapes, put first the one that uses relay only for a decision the human must make. A shape that uses relay to carry every brief between Roles comes after that. `gate` counts as human participation too.

Ask with these words:

Which of these workflows is closest to how you will actually work? Reply with a number to choose, and add any changes you want.

A number selects that option. Further text is the human's modifications. Check the accepted workflow on every pair:

- Every pair **supported** → accept
- Any pair **unsupported** or **uncertain** → warn with the pair, the interaction, and the label. Ask the human to drop that part, switch it to an interaction every pair marks supported, or keep it. A kept part is a **caveat**

Done when one workflow is accepted, including any changes the human named; every Handoff bullet of each participating Role is stated in that workflow or in a sub-workflow it references; every When stuck bullet of each participating Role is stated in the main workflow; and each interaction it uses is supported on every pair or kept as a caveat after a warning this run.

### 5. Run state and artifacts

This step's name is Run state and artifacts.

Run this step only for a main workflow. A sub-workflow has no run-state section; it uses the run state of every main workflow that reaches it. Skip to Check for a sub-workflow.

After a main workflow is accepted, decide how a live run records progress when more than one Role or more than one agent instance is in flight. Say that chat history is not the source of truth across agents.

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

On a main-workflow revise, keep the run-state section already in the process document until the human changes it.

Done when, for a main workflow, the human accepted the default or named the path, writer, required instance fields, artifact layout, and parallel-ownership rule to store in the process document; for a sub-workflow, the step was skipped because the main workflows that reach it own run state.

### 6. Check

Always run this step after create and after revise. Do not skip Check because only one section changed.

Before writing, walk the accepted workflow once. A check passes when the workflow matches what the human has said for every pair. For a sub-workflow, a check passes when it matches the behavior every main workflow that reaches it needs on that main's pairs. When it conflicts or is still unknown, discuss it: name the pair, the route, and the problem, then ask the human to drop that part, switch it, keep it as a caveat, or add a sentence that states the constraint.

Checks 2–4 and 6–8 apply to a main workflow. Check every interaction a referenced sub-workflow uses against that main's Support table.

1. **Catalog.** Every slug in the Roles section exists under `roles/`. Every route target is a Role listed in the Roles section. Every listed Role has one handoff table and one when-stuck table; a sub-workflow has handoff tables only. Every interaction is in the catalog. An unsupported or uncertain use is a caveat the human kept this run. For a sub-workflow, every interaction it uses is supported on every pair of each main workflow that reaches it, or that main keeps a caveat this run.
2. **Mode.** Each pair records whether this run may edit the repo and whether it waits for approval. A route that writes or spawns needs a mode that may edit. A route that continues with no person waiting needs a mode that does not wait.
3. **Attendant.** A human is available when each relay or gate happens on that pair.
4. **Shared repo.** On each artifact route, the next Role can read the files this Role wrote.
5. **Caller.** A slash command the workflow has a Role run is invocable by that Role on that pair. A human-only command or skill is carried by relay: the coordinating main Role (usually `team-lead`) reminds the human to run it.
6. **Overlap.** When the workflow uses parallel, it states which files each Role changes, or that they use separate workspaces.
7. **Craft tool.** When a route depends on a tool named in a Role's Steps, that tool is confirmed for each pair.
8. **Run state.** A main workflow states the run STATUS path, the single writer, required per-instance fields, artifact layout, and the disjoint path-ownership rule for parallel instances. A sub-workflow carries no run-state section.
9. **Sub-flows.** Every main workflow's and sub-workflow's `## Sub-flows` table lists each sub-workflow it invokes; each path resolves under `workflows/subflows/`; every sub-workflow is reachable from a main workflow; the reference graph has no cycles.

Done when every check that applies to the file kind passes, or each failure was discussed and the human chose.

### 7. Write and report

Fill the template for the file kind: [templates/workflow.md](templates/workflow.md) for a main workflow, [templates/subflow.md](templates/subflow.md) for a sub-workflow. A main workflow records pairs, labels, conditions, roles used, its `## Sub-flows` table, flow, routes, run state and artifacts, and caveats. A sub-workflow records roles, entry, its `## Sub-flows` table, flow, routes, exit, interactions used, and artifacts. One slash row per command; omit it when the workflow calls no command. Write only the Roles chosen in step 3: one handoff table per chosen slug, one when-stuck table per chosen slug on a main workflow, and no table for a removed Role. Conditions record, per pair, the mode, whether a human is available at handoffs, and whether Roles share one repo. Caveat lines match the fragment in [reference.md](reference.md). The Caveats section is `(none)` when nothing was kept. When writing a sub-workflow, add or update its row in every referencing workflow's `## Sub-flows` table in the same run. Read back the written file and every referencing workflow changed this run; fix a broken list item or a stray line before reporting the path.

Done when the file under `workflows/` matches the accepted workflow after the check, every referencing workflow's `## Sub-flows` table names the sub-workflow, the sub-workflow is reachable from a main workflow, caveats and conditions are visible on a main workflow, the path or paths were reported, and Role cards are unchanged.

## Completion criteria

- [ ] At least one Role card existed; slugs listed
- [ ] Existing main workflows and sub-workflows listed (or none); create versus revise chosen when more than none existed and the invoke was unclear; file kind and target path fixed
- [ ] Participating Roles settled: chosen on a create, kept, added, or removed on a revise
- [ ] On a revise, the adjusted Flow and every added or removed route were confirmed with the human
- [ ] Every listed Role has one handoff table; every main-workflow Role also has one when-stuck table; every route target is a listed Role
- [ ] For a main workflow: at least one harness + environment pair named
- [ ] For a main workflow: every interaction labeled per pair; `subagent-depth`, peers, and `main-peers` recorded; slash labeled per command
- [ ] For a main workflow: the standing sentence that a sub-agent cannot communicate with the human was told to the human; unsupported and uncertain labels told to the human
- [ ] For a sub-workflow: its referencing workflow and the main workflows that reach it are named, and every interaction it uses is supported on every pair of each reaching main or kept as a caveat there
- [ ] The human accepted one workflow: the only description, a numbered choice, that choice plus named changes, or the existing workflow kept on a revise
- [ ] Flow and routes use existing slugs and catalog interactions
- [ ] Unsupported or uncertain uses warned this run; kept ones written as caveats
- [ ] The check passed on this create or revise, or each failure was discussed and the human chose
- [ ] For a main workflow: conditions recorded per pair, and run state and artifacts accepted (STATUS path, single writer, per-instance rows, artifact layout, parallel path ownership)
- [ ] For a main workflow: every referenced sub-workflow is in its `## Sub-flows` table; for a sub-workflow: at least one referencing workflow's `## Sub-flows` table names it, and it is reachable from a main workflow with no cycle
- [ ] Written file or files read back; no broken list item or stray line
- [ ] Process document written in English; path or paths reported
- [ ] Role cards unchanged
