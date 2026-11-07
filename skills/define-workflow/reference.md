# define-workflow reference

Read before classifying support or writing the process document. Vocabulary matches repo-root `GLOSSARY.md`.

## What goes where

| Place | Belongs |
|---|---|
| `workflows/*.md` | Pairs, support labels, conditions (mode, human at handoff, shared repo), which Roles participate, end-to-end flow, who receives each handoff and When-stuck raise, the interaction used, how a run records STATUS and handoff artifacts, caveats |
| Role card | When this Role hands off or is stuck; how this Role does its craft |
| `roles/` | Role cards, created by `create-role` |

## Session identity

Decide this session's pair before labeling interactions. State the pair and the facts that settled it. Do not ask the human which pair this session is when the rules below settle it.

**Harness.** Use the product name written in this session's system or developer instructions. "You operate in Cursor" means Cursor. If no product name is written, the harness is uncertain: say that and ask.

**Environment.** This is where the session is attached, not where the model is hosted. A remote model API does not make the environment Cloud agent. Use the first rule that matches:

1. **Cloud agent** — the instructions say this agent runs on a remote machine, VM, or cloud worker, and this chat is not inside the human's editor and not a terminal on the human's machine.
2. **Local CLI** — this session's surface is a terminal on the human's machine, and no editor workspace is attached to this chat.
3. **Local IDE chat** — this chat is attached to an editor workspace (a workspace path and file tools on that workspace). A shell on that same machine does not make it Local CLI.

If none match, the environment is uncertain: name the missing fact and ask. If the decided pair is not one the human chose, say so and ask before adding it.

The other session judges its own harness and environment. The support prompt includes the session-identity test as a suggested method and does not fill the answer. Show that prompt once. Ask for one other pair at a time, and wait for that result before naming the next pair. The pair named in the step is the pair of record. The judged lines are not. When they differ, keep the step's pair and tell the human both values.

## This-session test

Apply only to the pair settled by the session-identity test. A tool present now marks that interaction supported for this pair. The same tool absent marks it unsupported for this pair. Leave every other pair to the human's pasted result.

| Visible now | Interaction |
|---|---|
| A human in the conversation | relay, gate |
| Repo file read and write | artifact |
| A subagent or task tool on this session | spawn. If that tool shows the child can spawn, record how many further levels it states. If it shows only this session can spawn, record `none` |
| A way for one sub-agent to address another sub-agent | peers supported. A return only to the parent is peers unsupported |
| A way for this main session to address another main session (another chat, or another bot) | `main-peers` supported. No such way: `main-peers` unsupported |
| Concurrent subagents | parallel |
| A way to continue a specific existing agent | resume |
| A way for one agent to deliver to another without the human | message |
| The named command or skill is invocable here | that slash command |

When `subagent-depth` or peers is uncertain, keep the label uncertain and say the matching sentence. Do not add a label such as hint. Call the field `subagent-depth`. Do not say "depth" as a substitute field name; the field is `subagent-depth`.

Every run, say this standing sentence. It is not detected per pair:

A sub-agent cannot communicate with the human. The human talks only with the main session they opened; the sub-agent returns results to that session.

- `subagent-depth`: It is unclear whether a sub-agent can create further sub-agents. Usually it cannot; only the session you are talking to can create children, and there is no further level.
- Peers: It is unclear whether sub-agents can message each other. Usually they cannot; results return to the session that created them.

## Warning

Name the pair, the interaction, and the label (`unsupported` or `uncertain`). Ask the human to:

1. Drop the route
2. Switch it to an interaction every pair marks supported
3. Keep it as a caveat

On a later run, restate a caveat that is still in the file before leaving it there.

## Offer shape (fictional)

Each option is a runnable definition, not a sketch. Before each Role's rows, say whether that instance is a main agent or a sub-agent. For every participating Role, one row per Handoff bullet and one row per When stuck bullet. Columns are When, Interaction, Next, then what is handed.

| When | Interaction | Next | What is handed |
|---|---|---|---|
| Plan is written and implementable | relay (the human carries the brief) and artifact (the next Role reads the file) | `lead` | Brief plus the plan file |
| Constraints still contradict after one clarification | relay (the human carries the brief) | `lead` | The contradiction; no plan file |

Say that the interaction names are this skill's own words, not words every agent already has. Say that in the human's language. Number options only when offering more than one. Order by feasibility, then by how little the human must take part. A later option may say which rows replace an earlier option's rows, and must restate those rows in full.

## Filled fragment (fictional)

Pairs: `Cursor` / `local IDE chat`; `Claude Code` / `local CLI`.

Support, one cell each: spawn is supported on Cursor / local IDE chat and uncertain on Claude Code / local CLI. relay and artifact are supported on both. message is unsupported on both. slash `/retro` is supported on Cursor / local IDE chat and uncertain on Claude Code / local CLI.

Route accepted with no warning: `builder` handoff "ready for review" → `checker` by relay + artifact.

Route warned: `lead` → `scout` by spawn. Claude Code / local CLI is uncertain. Caveat line if the human keeps it:

`lead → scout by spawn — uncertain on Claude Code / local CLI; kept by human.`

## Run state (default offer)

Offer this after the workflow is accepted. The human may rename paths.

- Run id folder: `runs/<run-id>/`
- STATUS file: `runs/<run-id>/STATUS.md`, written only by the coordinating main Role (usually `team-lead`)
- Per in-flight instance row: Role slug, instance id, agent id, slice, path ownership, phase, artifacts, waiting on
- Handoff artifacts under the same run folder; product code on the run's work branch
- Parallel instances require disjoint path ownership recorded before edits

## Process document discovery

At Gate, list `workflows/*.md`, plus any legacy repo-root `workflow.md` / `workflow-*.md`. Summarize each from its opening shape lines. New creates go under `workflows/`. If the human's invoke did not already choose create versus revise a named file, ask before the harness interview.
