---
name: setup-workflow
description: Use when installing or syncing Simple-Workflow in a consumer or product repository; when a project needs a local .workflow/ tree sourced from the kit; when the human asks to create the full set, update an existing install after Role-card or process-document changes, or add another Team for a new harness; or when the older name install-workflow is requested.
disable-model-invocation: true
---

# setup-workflow

Install or sync the kit's Role cards, process documents, run templates, project-standards templates, and Team configs in a consumer project's `.workflow/` directory.

Only the `workflow-owner` runs this skill. If another Role session invoked it, stop and say the `workflow-owner` runs it; the human designates the owner first when none exists.

One `.workflow/` serves every harness that works on the project. `roles/`, `workflows/`, and `project-standards/` are shared by all Teams; each Team has one `teams/<id>.yaml`, and every run belongs to one Team. Adding a harness or another bot group means adding a Team, not copying the trees again.

The human picks one of four intents: **New install** (the full set of people and process, creating one or more Teams), **Update install** (apply the kit's definition changes to every Team on this harness, then have every Role instance in those Teams re-read it), **Add Team** (another harness or bot group on the same `.workflow/`), or **Check only**.

Owner discovery, intents, layout, human actions, Role-bot flow, Team config format, standards, and the end-to-end check list: [reference.md](reference.md). Vocabulary: repo-root `GLOSSARY.md`.

Actions only a human can do are listed in [reference.md](reference.md#human-actions-report-list). A human action is something only the person can do: do not impersonate them, invent their answer, or skip a reminder that is needed now. Remind one only at the step where it is needed, and only when it applies to this session's harness. In Report, list only the items that applied this run as done, declined, or pending, and do not claim the run is complete while any of those remain pending.

This skill file is English only. Files this skill writes are English. Explain and ask in the human's language at runtime; do not put non-English script into this skill's files.

This skill lives in the Simple-Workflow kit (and later as a globally installed skill). It does not embed `roles/`, `workflows/`, or `runs/`. Copy those trees from a kit source.

## Hard rules

- The consumer layout is `<project>/.workflow/{roles,workflows,teams,runs,project-standards}`. Create `.workflow/` when missing. Never install into a bare `workflow/` directory, and never write Role cards at the consumer repo root.
- `roles/`, `workflows/`, and `project-standards/` are shared by every Team and every harness. Never keep a second copy of them per harness.
- Never copy trees for a new Team. A new harness or bot group joins the existing `.workflow/` as a new Team with its own `teams/<id>.yaml`.
- Copy only the kit's `roles/`, `workflows/`, `runs/` (including `runs/_template/`), and `project-standards/`. Never copy the kit's `skills/`, `docs/`, root README, GLOSSARY, OPEN_ISSUES, AGENTS, LICENSE, `.agents/`, or `.git`.
- Detect this session's harness id from the runtime environment: the platform or product name in lowercase slug form. `cursor`, `grok`, and `deepseek` are examples, not an allowlist. If the id is unknown, ask the human once.
- Each Team has one config file at `.workflow/teams/<id>.yaml` with `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness` in that order; `id` matches the filename stem. Schema, identifier rules, and create-versus-update cases: [reference.md](reference.md#team-config-format). Team config is the only current-workflow pointer.
- `workflow_owner_id` names the session or bot that runs this skill for that Team and holds the `.workflow/` write permission. Resolve it before any write: [reference.md](reference.md#find-the-workflow-owner).
- Every run resolves this session's **bound** Team config before deciding create versus update: [reference.md](reference.md#detect-this-sessions-bound-team-config). Stop when more than one `teams/*.yaml` matches the same lead id.
- Leave Role cards pointing at the `workflows/` directory (library location only). Never rewrite a Role card to a Team config path: the hard runtime gate is the config path bound into standing instructions at Initialize.
- Never silently overwrite a populated `.workflow/` tree. Ask **intent first** (New install / Update install / Add Team / Check only), then follow that intent in [reference.md](reference.md#intents).
- Consumer edits are limited to the Dynamic edits list below. Do not invent further edits at runtime.
- Touch a consumer `.gitignore` only when it already exists and lacks `.workflow/`. Never create the file, and never gitignore `.workflow/` inside the Simple-Workflow kit.
- The installed templates under `.workflow/project-standards/` are the only standards files. Rewrite Playbook references there after a first install or after `roles/` or `project-standards/` was replaced, and never search for alternates or ask the human about them. Details: [reference.md](reference.md#standards-apply).
- Role changes stay in the kit. This skill does not reserve a consumer path for `define-role` output; after kit Role or process-document changes, run Update install so every Team on this harness picks them up.
- When syncing `runs/`, replace `runs/_template/` only. Never delete or overwrite live `.workflow/runs/<run-id>/` folders, including another Team's runs.
- Always run Check after a first install and after every update, add-team, or check-only.
- After the writes pass Check, commit the definition changes in the `.workflow/` repository, then report the commit id.

## Dynamic edits

This list is fixed in the skill.

1. Copy trees into `.workflow/` (step 5).
2. Write or update `.workflow/teams/<id>.yaml` for a Team created, kept, or explicitly updated this run (step 7), and write an additional Team's yaml at step 10 once its bots exist. Never silently overwrite another Team's yaml.
3. Append `.workflow/` to an existing consumer `.gitignore` when the entry is missing, and write `.workflow/.gitignore` so `runs/*` is ignored and `runs/_template/` is kept (step 9).
4. Rewrite standards references in Playbooks to the installed `.workflow/project-standards/` paths (step 8).
5. Commit the definition changes in the `.workflow/` git repository (step 12).

On Update install, perform only the items the human accepted this run (which trees to replace, whether to update a named Team config). On Add Team, do not copy trees; do write a new Team yaml and do commit it. On Check only, do not copy trees, do not rewrite Team yamls, and do not commit unless the human asks. Live `.workflow/runs/<run-id>/` folders are not a Dynamic edit.

## Steps

Say the step name, then explain it in 1-2 sentences, then ask when a choice is needed. Use the English names below when speaking English; translate the same names if the human's language is not English.

| Step | Name |
|---|---|
| 1 | Target |
| 2 | Detect install and owner |
| 3 | Intent |
| 4 | Find kit |
| 5 | Copy trees |
| 6 | Choose workflow |
| 7 | Write team config |
| 8 | Standards |
| 9 | Gitignore |
| 10 | Initialize |
| 11 | Check |
| 12 | Commit |
| 13 | Report |

### 1. Target

This step's name is Target.

The destination is always `<chosen-path>/.workflow/` under the install root the human picks. Valid roots, the kit-exclusion rule, and why the current workspace comes first: [reference.md](reference.md#valid-install-target).

- If the human already named an install path this run and it is not the kit, use it (do not re-ask).
- Otherwise ask (human action). Offer **current working directory / current workspace** first and preferred, showing its real path, then "I'll type/name another path". Do not make a list of sibling repositories the primary ask.
- A multi-repo parent is a valid root: create `.workflow/` directly under it.

Done when the install root is known and the destination is `<chosen-path>/.workflow/`.

### 2. Detect install and owner

This step's name is Detect install and owner.

Detect two things and report both before asking anything else: whether the shared install exists, and whether this session already belongs to a Team.

1. **Shared install.** Content under `.workflow/roles/`, `.workflow/workflows/*.md`, or `.workflow/project-standards/`. This is shared by every harness, so one harness installing makes it true for all of them.
2. **This session's Team.** A `teams/*.yaml` bound to this session: the exact path in this session's standing instructions, or a file whose `team_lead_id`, `workflow_owner_id`, or `id` equals this session's platform id. A populated `teams/` directory does not prove this session has a Team.
3. Resolve the `workflow-owner` with [reference.md](reference.md#find-the-workflow-owner): this session's bound Team config first, then this session's own Role, then a visible workflow-owner bot, then the human's choice.
4. When no owner is found, tell the human that the `workflow-owner` is the Role dedicated to maintaining the workflow. Then ask the human to pick one: the current session becomes `workflow-owner`, an existing bot becomes it, or a new one is created. That pick is a human action.
5. When the human picks the current session, designate it as `workflow-owner` for this run and adopt the Role before any write: read `.workflow/roles/workflow-owner/ROLE.md` when it exists, or the kit's `roles/workflow-owner/ROLE.md` after Find kit on a New install. Adopting means the session carries the Role and its maintenance rules—write definitions only, commit every definition change. Step 10 later binds the Team config path; it does not adopt the Role again.

When the shared install exists but this session has no Team, say that this environment joins as a new Team. When the human says this session takes over an existing Team, ask which `teams/*.yaml` and treat that Team as kept.

When the resolved owner is not this session, stop and tell the human to run setup from that owner. Where this session can message the owner bot, send it the request and stop; do not continue as it.

When the human wants a new owner bot, create and initialize it as `workflow-owner` when the platform allows, then stop and tell the human to run setup from it. When the platform cannot create bots, ask the human to create it and run setup there.

On a first install, the human picks the session that becomes the owner; when that is not this session, stop and let that session run the setup.

Done when the shared-install state and this session's Team state are known, one `workflow-owner` is designated, and the owner Role is adopted when its installed card exists; or the human declined and this run stopped.

### 3. Intent

This step's name is Intent.

Ask **intent first** (human action) and wait for the answer before any tree or Team-config question. Which steps each intent skips or asks: [reference.md](reference.md#intents).

1. **New install** — no shared install. When the shared install exists, do not offer it.
2. **Update install** — the shared install exists and this session belongs to a Team. Sync the accepted definitions and have this Team re-read them.
3. **Add Team** — the shared install exists and this session has no Team: a new harness or another bot group. It joins the shared trees with its own config; no tree copy. When the shared install exists and this session has no Team, Add Team is the install intent; Update install belongs to a Team that already exists.
4. **Check only** — no tree copy and no Team yaml rewrite; run Check and report.

Done when the intent is recorded, and for the chosen intent its skips are noted.

### 4. Find kit

This step's name is Find kit.

If this run's intent is Add Team or Check only, skip this step.

Detect the kit source in the order in [reference.md](reference.md#kit-detection-order) and stop at the first valid source. This skill's own folder is not one: [reference.md](reference.md#valid-kit-source).

Done when a valid kit source is identified and the human has not objected to it, or this step was skipped; and, on a New install where this session is the owner, the kit's `workflow-owner` card was read and adopted before Copy trees.

### 5. Copy trees

This step's name is Copy trees.

When the consumer has a `.gitignore` that lacks `.workflow/`, run Gitignore (step 9) before copying so new files are ignored as they appear.

If this run's intent is Add Team or Check only, skip the copy. Do not replace any tree.

On **New install**, copy all four trees below. On **Update install**, copy only the trees the human accepted. If that set is empty, skip the copy.

| Kit location | Consumer location |
|---|---|
| `roles/` (or `.workflow/roles/` when the source is an installed consumer, or legacy `workflow/roles/`) | `<project>/.workflow/roles/` |
| `workflows/` | `<project>/.workflow/workflows/` |
| `runs/_template/` | `<project>/.workflow/runs/_template/` |
| `project-standards/` | `<project>/.workflow/project-standards/` |

An Update install applies the accepted trees to **every Team on this harness**. Other harnesses sync on their own Update install, so do not enumerate them or update their configs, but do not narrow the update to one Team either. Never overwrite or delete `.workflow/teams/*.yaml` during a tree replace. When replacing `runs/`, write `runs/_template/` only; do not delete sibling `runs/<run-id>/` folders.

After a New install, the consumer must contain Role cards under `.workflow/roles/<slug>/`, process documents `.workflow/workflows/*.md`, `.workflow/runs/_template/` (at least `STATUS.md` and `brief.md`), and `.workflow/project-standards/` with `CODING_STANDARDS.md`, `COMMIT_RULES.md`, and `REVIEW_RULES.md`.

Done when the accepted trees are copied, existing Team yamls were left in place, live run folders were left in place, and no kit-only tree was copied into `.workflow/`.

### 6. Choose workflow

This step's name is Choose workflow.

If this run's intent is Check only, skip this step.

Run **bound-Team detection** ([reference.md](reference.md#detect-this-sessions-bound-team-config)). On Update install that keeps Team configs, read the detected bound config, tell the human its path and `workflow` value, and skip the ask when the file exists, has the required keys, and its `workflow` target is still readable. Otherwise say why and ask which workflow to use for **this Team**; that answer creates or fixes only this session's yaml.

If this run's intent is Add Team, ask which workflow the **new** Team should use.

Otherwise list every process document under the kit (or just-copied) `workflows/*.md`. For each file, give its path and a one-line shape summary from its opening. Ask the human (human action): **Which workflow do you want to install?** A number or a filename answers. Recommend from the document's own Targets when that is obvious for this harness. Do not write the Team yaml until the human has chosen or kept a document.

On a **New install**, ask which process document to install once; every Team this install creates uses that one document. Then settle how many Teams this install creates in this environment (human action), default one: this session's Team. Ask that count only when this run can bring several Teams up: an all-main-agents harness creates one bot group per Team. On a sub-agent harness, create one Team and say that more Teams come later through Add Team, each a new main session. Every Team uses this session's harness. For each additional Team, ask only its display name and its prefix (for example `T2`).

Done when this Team has a chosen `workflows/*.md` that exists at the consumer `.workflow/workflows/` path, or an existing bound Team config was kept and still resolves, and on a New install the number of Teams is recorded.

### 7. Write team config

This step's name is Write team config.

If this run's intent is Check only, skip this step.

If this run's intent is Add Team: on an **all-main-agents** shape skip the write here; step 10 writes the new Team's config once its bots exist. On a **sub-agent** shape write it here with a generated `team_lead_id`. Do not overwrite this session's bound yaml or other Team yamls unless the confirmed plan says so.

If this run kept existing Team configs: do not overwrite them. Recheck that this session's bound config exists, has `workflow_owner_id`, and its `workflow` target resolves; if an owner is missing, write the resolved owner into that file only.

Otherwise: **update** the bound Team yaml when detection found one. Create one here only on a sub-agent shape; an all-main-agents New install writes its config in step 10. Never create a second yaml for the same lead id.

Write the five keys in order from the human's workflow choice, the resolved ids, and this session's harness slug. `workflow_owner_id` is the id resolved in step 2. `team_lead_id` is the created lead bot's id on an all-main-agents shape, the platform session id when the lead session already exists, or a generated GUID when the lead is a separate session this run cannot read—then say the human must record that GUID in the lead session's instructions. When the owner and the lead are the same session, write the same id in both fields. Schema and example: [reference.md](reference.md#team-config-format).

Write a config only when its ids exist. On an **all-main-agents** shape the lead bot is created in step 10, so this Team's config is written there; a sub-agent shape writes it here. An additional Team's config is always written in step 10, after its bots exist. Every config carries the same `workflow` value: the one document chosen for the install.

After writing, tell the human it was **recorded into** `.workflow/teams/<id>.yaml`, and state the runtime rule in [reference.md](reference.md#team-config-format).

Done when every Team whose ids exist has a config with the five keys in order, its `workflow` target is readable, and other Teams' yamls were not silently overwritten; on an all-main-agents shape this step may write none, and step 10 completes them.

### 8. Standards

This step's name is Standards.

No detection and no human confirm: the copied templates are the standards files (three paths under `.workflow/project-standards/`; list and rewrite rules in [reference.md](reference.md#standards-apply)).

Remind the human (informational; does not block setup) that they may edit those files to add project-specific rules the Roles must follow. Do not invent rules for them, and do not open an editor unless they ask.

Rewrite the Playbook references only on a New install after Copy trees, or when this update replaced `roles/` and/or `project-standards/`. Otherwise leave existing Playbook wording unchanged, as on Add Team and Check only.

Done when the three paths exist under `.workflow/project-standards/` and the matching Playbooks require those paths, or this run did not replace `roles/` or `project-standards/` so no rewrite was needed.

### 9. Gitignore

This step's name is Gitignore.

Only touch `.gitignore` when the consumer project root already has one. If it is missing, skip this step and do not create the file.

When it exists and does not yet list `.workflow/`, append a `.workflow/` entry so the entire `.workflow/` tree (including `runs/`) stays out of the consumer repository. Do not remove other entries. The `.workflow/` repository from step 12 is inside that ignored tree and stays separate.

Inside `.workflow/`, write or update a `.gitignore` so the tree's own repository tracks definitions only: ignore `runs/*` and keep `runs/_template/`:

```gitignore
runs/*
!runs/_template/
!runs/_template/**
```

That keeps run data out of the definition history: `runs/<run-id>/` belongs to the Team running that run.

This step may run as soon as the Target is known; otherwise run it here. It applies on every intent.

Done when either there was no `.gitignore` (skipped), or the existing `.gitignore` lists `.workflow/`, and `.workflow/.gitignore` ignores `runs/*` while keeping `runs/_template/`.

### 10. Initialize

This step's name is Initialize.

If this run's intent is Check only, skip this step unless the human explicitly asked to re-init.

This session is the `workflow-owner` for this Team; its Role was adopted before the writes. Initialize from the **shape** of the selected process document, and do only this session's harness. Binding the Team config path below is the part of initialization that waits for the config to exist; do not adopt the Role again.

- **Several main agents with one execution lead** (the shape with `manager`, `team-lead`, `assistant`, and `workflow-owner` as main agents): this chat stays `workflow-owner`. Tell the human which other main sessions to open for this Team, giving each one its Role card and the Team config path. `team-lead` is the execution lead that spawns the other Roles; do not pre-spawn them during setup. A New install here creates this one Team; more Teams come later through Add Team, each with its own main sessions.
- **Every Role a main agent** (for example Grok Bot on that shape): this session bot is the `workflow-owner` bot of this Team. Create or configure the other Role bots, including a `team-lead` bot, following the naming, shared-instructions, create/init-plan, and create flow in [reference.md](reference.md#role-bot-naming-all-main-agents). On a New install that creates several Teams, repeat that flow once per Team with its own prefix; do not re-initialize this session for the other Teams.
- **One main agent with sub-agents** (a legacy shape that names only `team-lead`): this chat becomes `workflow-owner` for the config, and `team-lead` runs as another chat. Follow the same binding rule below.

**Team config binding (hard runtime gate)**, every shape: write the exact Team config path into the `workflow-owner` instructions, the lead's instructions, and every member Role bot's instructions when the platform allows. The text must say: read that path first, open the `workflow` target named inside, and stop if the path, file, required keys, or target is missing. Also record `team_lead_id` and `workflow_owner_id`. Never put a Team-specific yaml path into shared Role cards. For the sub-agent shape, require spawn briefs to carry the same path.

On an **all-main-agents** shape, write each Team's config after that Team's bots are created, using the created lead and owner ids, then bind the path. On a **sub-agent** shape the config was written in step 7; bind its generated `team_lead_id` into the lead session's instructions.

On Update install, every existing Role instance in every Team on this harness re-reads its installed card. This session re-reads its own card, the selected process document, `.workflow/project-standards/`, and this Team's config when those were replaced. Every other Role bot or session on this harness that this run can reach gets one message: re-read `.workflow/roles/<slug>/ROLE.md` and the selected process document, then confirm. Each Role instance this run cannot reach is a pending human action with what it must re-read; the run is not complete while one is pending. Update other Role bots only for **new** Roles. Teams on another harness are not this run's concern; they sync on their own Update install.

If a tool call was actually blocked pending a permission grant, remind the human what to grant and record it as pending. For a harness this session cannot configure, add it to the follow-up list and Report only.

On a New install, bring up every Team this run created: on an all-main-agents harness that is one bot group per Team. After each additional Team's bots exist, write that Team's config with the created ids and say it was recorded. No Team exists without a session or bot group behind it; a Team added later goes through Add Team.

Done when this session is initialized as `workflow-owner` (or the human's decline is recorded), the other main sessions or bots this run can configure are ready or waiting only on an applied human action, other-harness init is listed as follow-up only, and no out-of-scope human-action reminder was given.

### 11. Check

This step's name is Check.

Always run Check after the writes, including every update, add-team, or check-only. Walk each selected process document end to end: the installed trees, Team configs, run template, routes, and required interactions must let a run start and follow every hop. Checklist: [reference.md](reference.md#end-to-end-check).

Fail when this session's bound config is missing (when this run should have one), unreadable, missing required keys, missing `workflow_owner_id`, or its `workflow` target is missing or unreadable, and when more than one `teams/*.yaml` matches the same lead id. Do not fail solely because another Team's config is absent, unless this run was supposed to create it.

When a hop cannot be walked, name the process document, the route, and the problem. Fix it when this skill is allowed to; otherwise stop and tell the human.

Done when every check in [reference.md](reference.md#end-to-end-check) passes, or each failure was fixed this run or discussed and the human chose what to do.

### 12. Commit

This step's name is Commit.

Only after Check passes. The `.workflow/` tree is versioned by its own git repository: initialize it when git is available and `.workflow/.git` is missing, then commit this run's definition changes with a message that names what changed and why. Run data under `runs/<run-id>/` is ignored, so the history holds definitions only. A check-only run commits nothing unless the human asks.

Done when `.workflow/.git` exists and the definition changes from this run are committed, or git is unavailable and the report says so.

### 13. Report

This step's name is Report.

Tell the human:

- Intent: New install, Update install, Add Team, or Check only
- Consumer project root and `.workflow/` path
- The `workflow-owner` for this Team: how it was found or chosen, and its id
- Kit source used (skipped on Add Team or Check only)
- On Update install: which trees were replaced, which were kept, which Roles in this harness's Teams re-read the installed definitions, and which are still pending
- On Add Team: the new Team config path, which Role bots were created when this session creates bots, and that the shared trees and other Team yamls were left untouched
- On a New install: how many Teams were created, each config path, and that a later Team goes through Add Team
- On Check only: trees untouched and Team configs not rewritten
- Paths copied
- This session's bound Team config path from detection (or that none was bound); this run's Team config path(s), whether each was created, kept, or updated; other existing `teams/*.yaml` files
- Standards Playbooks wired to `.workflow/project-standards/` (or unchanged because neither `roles/` nor `project-standards/` was replaced); the reminder that the human may add Role rules into those files
- `.gitignore` update
- Init done in this session
- The `.workflow/` commit id, or that git was unavailable
- Other-harness follow-up only if that work remains
- Check result (on pass: Roles, Team configs, process hops, `runs/_template/`, project-standards)
- **Human actions:** list only the items that applied this run, each done, declined, or pending, with what the human still must do for a pending one. Do not dump the catalog, do not list optional items that were not relevant, and do not list a permission grant unless a tool actually blocked.

Do not say setup is complete if any human action that applied this run is pending.

Done when that report has been given, Role process pointers still point at the `workflows/` directory, and either no applied human action is pending or the report states that the run is not complete and lists the pending items.

## Completion criteria

- [ ] Ran as `workflow-owner`: the owner Role was adopted before any write, and the Team config path was bound at Initialize
- [ ] Consumer project root known; destination is `<project>/.workflow/`
- [ ] Shared-install state and this session's Team state detected; intent recorded (New install, Update install, Add Team, or Check only)
- [ ] `workflow-owner` resolved and recorded in the Team config, or the run stopped for the human's choice
- [ ] On Update install: trees to replace recorded; that the update covers every Team on this harness stated; no silent overwrite of trees or of other Teams' yamls; every existing Role instance in those Teams re-read the installed definitions or is listed as pending
- [ ] On Add Team: no trees were copied, other Team yamls were kept, and a new Team yaml was created; this-session init matched a new harness or an extra bot group
- [ ] On Check only: no trees were replaced and Team yamls were not rewritten
- [ ] Kit source found by the detection order (or given by the human); skipped on Add Team or Check only
- [ ] On a New install, `.workflow/roles/`, `.workflow/workflows/*.md`, `.workflow/runs/_template/`, and `.workflow/project-standards/` materialized from the kit; on Update install, only accepted trees were copied; on Add Team or Check only, no trees were copied
- [ ] On a New install, the number of Teams was chosen, every Team got its own config with ids from its sessions or bots, and every config carries the same `workflow`
- [ ] Kit `skills/`, `docs/`, and root README not copied into `.workflow/`
- [ ] Live `.workflow/runs/<run-id>/` folders left in place, including other Teams' runs
- [ ] Bound-Team detection ran; human chose a process document for this Team, or this session's existing bound Team config was kept and still resolves; no duplicate yaml for the same lead id
- [ ] This Team's `.workflow/teams/<id>.yaml` exists with `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness` in that order and a readable `workflow` target; other Team yamls were preserved
- [ ] Role card `workflows/` directory pointers left unchanged
- [ ] Standards Playbooks rewritten to `.workflow/project-standards/` after a New install or after `roles/` / `project-standards/` replace; no detection ask
- [ ] Consumer `.gitignore` contains `.workflow/` (or the consumer had none); `.workflow/.gitignore` ignores `runs/*` and keeps `runs/_template/`
- [ ] This session's init matches the selected shape; remaining other-harness init listed
- [ ] The `.workflow/` repository exists and this run's definition changes are committed, or git was unavailable and the report says so
- [ ] Human actions were reminded only at the steps where they apply, and only for this session's harness
- [ ] Report lists only human actions that applied this run as done, declined, or pending
- [ ] Did not claim the run complete while a pending human action that applied this run remained
- [ ] End-to-end check passed for each selected process document after this run
