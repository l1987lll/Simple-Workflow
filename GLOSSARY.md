# WorkFlow

Vocabulary for the multi-agent development workflow and the tools that define its roles and process.

## Language

**Role**:
A named participation slot in the workflow (for example Team Lead or QA). A Role may have more than one agent instance.
_Avoid_: persona, job, hat

**Role card**:
The Markdown document set that defines one Role for an agent to load. Created by `create-role`.
_Avoid_: agent definition, skill, prompt pack

**ROLE.md**:
The stable document of a Role card: name, slug, purpose, optional speaking style, and fixed boundaries. It always points at `workflows/` for pipeline and cross-Role routing. It does not define that routing itself.
_Avoid_: IDENTITY.md, main doc (except as informal shorthand), profile, DETAIL.md

**Playbook**:
The mutable document of a Role card (`PLAYBOOK.md`): role-local responsibilities, craft steps for one or more kinds of work, checklists, notes, when *this* Role should hand off, and **When stuck** (when to stop and raise a problem outside the Role—not normal handoff). Does not define how the other Role works. Points to `workflows/` for full routing.
_Avoid_: details, handbook, charter, DETAIL.md, Escalation (as the section title)

**When stuck**:
A Playbook section: conditions where this Role must stop and raise a problem outside itself. Not a normal handoff.
_Avoid_: Escalation (as the section title), upgrade

**Role-Playbook layout**:
Default Role card shape: `ROLE.md` plus `PLAYBOOK.md`. `ROLE.md` must require reading the Playbook and give its path. Both files point at `workflows/`. When asking the human, explain the layout before offering the choice.
_Avoid_: Role-Detail, two-document layout, monolith, split

**Role-merged layout**:
Optional Role card shape: one `ROLE.md` with a stable upper section and a mutable lower section (same headings as a Playbook). Points at `workflows/`. English token is Role-merged.
_Avoid_: Role-only, single-document layout, monolith

**Process document** (`workflows/*.md`):
End-to-end workflow and how Roles interact, including each pair's support for the interactions it uses. Lives under `workflows/`, outside Role cards. `define-workflow` creates and edits these files. `create-role` does not. Informal shorthand may still say workflow.md.
_Avoid_: playbook, pipeline doc

**Harness**:
The agent product a workflow runs on (for example Cursor or Claude Code).
_Avoid_: runtime, platform, tool

**Environment**:
The tool surface a harness runs in for a workflow (for example local IDE chat or cloud agent). One harness can have several environments.
_Avoid_: setup, context, workspace

**Pair**:
One harness plus one environment. A workflow may name more than one pair.
_Avoid_: target, profile, matrix

**Interaction**:
A cross-Role behavior a route may require. The catalog lives in the `define-workflow` skill.
_Avoid_: capability, action, step

**Support**:
Whether a pair can perform an interaction: supported, unsupported, or uncertain. For slash, support is per command.
_Avoid_: compatibility, available

**Mode**:
Whether a pair may edit the repo on this run, and whether it waits for approval before acting.
_Avoid_: configuration, settings

**Attendant**:
A human available at the moment a relay or gate happens.
_Avoid_: user, operator

**Shared repo**:
The next Role can read the files this Role wrote.
_Avoid_: workspace, checkout

**Route**:
Who receives a Role's handoff or When-stuck raise, and which interaction carries it. Written in `workflow.md`.
_Avoid_: handoff (that is the Playbook section), transition, edge

**Caveat**:
A route kept in `workflow.md` after the human was warned that an interaction is unsupported or uncertain on a named pair.
_Avoid_: exception, waiver

**Run**:
One team execution of the process document, from intake through close-out. Several runs may be active at once.
_Avoid_: session, job (except as informal shorthand), ticket

**Run state**:
The durable record of a run's progress (typically `runs/<run-id>/STATUS.md`), including every in-flight Role instance. The coordinating main Role is the single writer.
_Avoid_: chat log, memory, scratch notes

**Role instance**:
One agent playing a Role in a run (for example `developer#2`). A Role may have more than one instance in the same run when path ownership is disjoint.
_Avoid_: clone, copy, duplicate Role

**Role-bot group**:
One set of Role bots for the same consumer `.workflow/` install, distinguished by a naming prefix (for example `T1` or `T2`). A Role-bot group is one kind of Team, typically on an all-main-agents harness. Groups share the same Role cards, process documents, and standards; each group has its own bots, its own Team config, and may use its own sidebar section.
_Avoid_: team copy, second install (that would be another `.workflow/` tree), re-setup (that is updating the installed trees)

**Team (workflow instance)**:
One agent team executing a process document (for example a Grok Role-bot group, or a Cursor lead chat with sub-agents). Multiple Teams may share one `.workflow/` install. Not a run.
_Avoid_: session (except as informal shorthand for a chat), install (that is the `.workflow/` tree)

**Team config**:
`.workflow/teams/<id>.yaml` for one Team (`id` = platform team-lead id or GUID; filename stem equals `id`; not short `t1`/`t2`). v1 fields in order: `id`, `workflow`, `team_lead_id`, `harness`. Agents read their bound Team config path, then the `workflow` process document named inside. If either is missing, stop. Team config is the only current-workflow pointer.
_Avoid_: process-document path written outside Team config, install (that is the `.workflow/` tree)

**Handoff artifact**:
A file a Role writes for another Role to read on an artifact route. Process artifacts live under the run folder; product code lives on the work branch.
_Avoid_: attachment, drop, packet

**Path ownership**:
The file or directory set a Role instance may edit during a slice. Parallel instances must not overlap ownership.
_Avoid_: lock, lease, scope (except as informal shorthand)
