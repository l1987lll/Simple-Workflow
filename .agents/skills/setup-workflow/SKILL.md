---
name: setup-workflow
description: Use when installing or setting up Simple-Workflow in a consumer or product repository; when a project needs a local .workflow/ tree sourced from the kit; when the human asks to apply, sync, re-setup, or reinstall after kit Role or process-document changes; when adding another Role-bot group on an existing install; or when the older name install-workflow is requested.
disable-model-invocation: true
---

# setup-workflow

Install the kit's Role cards, process documents, run templates, and project-standards templates into a consumer project's `.workflow/` directory, write Team config files, and confirm the selected workflow can be walked. Re-setup and sync after kit Role or process-document changes are first-class: detect an existing install, ask intent first, ask before replacing anything, and always re-run Check.

Detection, valid targets, existing-install intent and its questions, the human-actions table, the all-main-agents Role-bot flow, Team config format, standards, and the end-to-end check list: [reference.md](reference.md). Vocabulary: repo-root `GLOSSARY.md`.

Actions only a human can do are listed in [reference.md](reference.md#human-actions-report-list). A human action is something only the person can do: do not impersonate them, invent their answer, or skip a reminder that is needed now. Remind one only at the step where it is needed, and only when it applies to this session's harness. In Report, list only the items that applied this run as done, declined, or pending, and do not claim the run is complete while any of those remain pending.

This skill file is English only. Files this skill writes are English. Explain and ask in the human's language at runtime; do not put non-English script into this skill's files.

This skill lives in the Simple-Workflow kit (and later as a globally installed skill). It does not embed `roles/`, `workflows/`, or `runs/`. Copy those trees from a kit source.

Only the coordinating main Role (`team-lead`) runs this skill. If another Role session invoked it, stop and tell them to run it from `team-lead`.

## Hard rules

- The consumer layout is `<project>/.workflow/{roles,workflows,teams,runs,project-standards}`. Create `.workflow/` when missing. Never install into a bare `workflow/` directory, and never write Role cards at the consumer repo root.
- Copy only the kit's `roles/`, `workflows/`, `runs/` (including `runs/_template/`), and `project-standards/`. Never copy the kit's `skills/`, `docs/`, root README, GLOSSARY, OPEN_ISSUES, AGENTS, LICENSE, `.agents/`, or `.git`.
- Detect this session's harness id from the runtime environment: the platform or product name in lowercase slug form. `cursor`, `grok`, and `deepseek` are examples, not an allowlist. If the id is unknown, ask the human once.
- Each Team has one config file at `.workflow/teams/<id>.yaml` with `id`, `workflow`, `team_lead_id`, and `harness` in that order; `id` matches the filename stem. Schema, identifier rules, and create-versus-update cases: [reference.md](reference.md#team-config-format). Team config is the only current-workflow pointer.
- Every run resolves this session's **bound** Team config before deciding create versus update: [reference.md](reference.md#detect-this-sessions-bound-team-config). Stop when more than one `teams/*.yaml` matches the same lead id.
- Leave Role cards pointing at the `workflows/` directory (library location only). Never rewrite a Role card to a Team config path: the hard runtime gate is the config path bound into standing instructions at Initialize.
- Never silently overwrite a populated `.workflow/` tree. Ask **intent first** (Update install / Add Role-bot group / Check only), then follow that intent in [reference.md](reference.md#existing-install-and-re-setup).
- Consumer edits are limited to the Dynamic edits list below. Do not invent further edits at runtime.
- Touch a consumer `.gitignore` only when it already exists and lacks `.workflow/` (step 8). Never create the file, and never gitignore `.workflow/` inside the Simple-Workflow kit.
- The installed templates under `.workflow/project-standards/` are the only standards files. Rewrite Playbook references there after a first install or after `roles/` or `project-standards/` was replaced, and never search for alternates or ask the human about them. Details: [reference.md](reference.md#standards-apply).
- Role changes stay in the kit. This skill does not reserve a consumer path for `define-role` output; after kit Role or process-document changes, the human re-runs this skill to sync the consumer.
- When syncing `runs/`, replace `runs/_template/` only. Never delete or overwrite live `.workflow/runs/<run-id>/` folders unless the human explicitly asks.
- Always run Check after a first install and after every re-setup, sync, add-group, or check-only.

## Dynamic edits

This list is fixed in the skill.

1. Copy trees into `.workflow/` (step 4).
2. Write or update `.workflow/teams/<id>.yaml` for a Team created or explicitly updated this run (step 6). Never silently overwrite another Team's yaml.
3. Append `.workflow/` to an existing consumer `.gitignore` when the entry is missing (step 8).
4. Rewrite standards references in Playbooks to the installed `.workflow/project-standards/` paths (step 7).

On update-install, perform only the items the human accepted this run (which trees to replace, whether to update a named Team config). On add-group, do not copy trees; do write a new Team yaml. On check-only, do not copy trees and do not rewrite Team yamls. Live `.workflow/runs/<run-id>/` folders are not a Dynamic edit.

## Steps

Say the step name, then explain it in 1-2 sentences, then ask when a choice is needed. Use the English names below when speaking English; translate the same names if the human's language is not English.

| Step | Name |
|---|---|
| 1 | Target |
| 2 | Re-setup |
| 3 | Find kit |
| 4 | Copy trees |
| 5 | Choose workflows |
| 6 | Write team config |
| 7 | Standards |
| 8 | Gitignore |
| 9 | Initialize |
| 10 | Check |
| 11 | Report |

### 1. Target

This step's name is Target.

The destination is always `<chosen-path>/.workflow/` under the install root the human picks. Valid roots, the kit-exclusion rule, and why the current workspace comes first: [reference.md](reference.md#valid-install-target).

- If the human already named an install path this run and it is not the kit, use it (do not re-ask).
- Otherwise ask (human action). Offer **current working directory / current workspace** first and preferred, showing its real path, then "I'll type/name another path". Do not make a list of sibling repositories the primary ask.
- A multi-repo parent is a valid root: create `.workflow/` directly under it.

Detect whether an **existing install** is present ([reference.md](reference.md#existing-install-and-re-setup)) and report first install versus existing install. Do not replace anything in this step.

Done when the install root is known, the destination is `<chosen-path>/.workflow/`, and first install versus existing install has been recorded.

### 2. Re-setup

This step's name is Re-setup.

If this is a first install (no populated trees, and the human did not ask to re-setup, sync, or add a Role-bot group), say so and skip the rest of this step.

Otherwise report what is already there and this session's bound Team config, using the report list and bound-Team detection in [reference.md](reference.md#existing-install-and-re-setup). If more than one yaml matches the same lead id, stop and tell the human before asking intent.

Then ask **intent first** (human action) and wait for the answer before any tree or Team-config question:

1. **Update install** — classic re-setup: full or selective tree replace, and/or change a named Team's `workflow` or metadata.
2. **Add Role-bot group** — keep the existing trees and other Team yamls; create another Team (a new `teams/<id>.yaml`). On an all-main-agents session that can create Role bots, also create the new group's Role bots.
3. **Check only** — no tree copy, no Team yaml rewrite; go to Check, running Initialize only if the human explicitly asks to re-init.

Which steps and questions each intent skips or asks, the tree-replace choice, the Team-config choice, and the delete-or-keep rule for consumer-only extras: [reference.md](reference.md#existing-install-and-re-setup). Never replace a tree or rewrite a Team yaml before the human answers.

Live `.workflow/runs/<run-id>/` folders are not part of a template sync; leave them unless the human explicitly asks to remove them.

Done when either this is a first install, or the intent is recorded and, for the chosen intent, its questions are answered and its skips are noted.

### 3. Find kit

This step's name is Find kit.

If this run's intent is add-group or check-only, skip this step (the consumer install is already present).

Detect the kit source in the order in [reference.md](reference.md#kit-detection-order) and stop at the first valid source. The skill's own folder is never a kit source: roles and process documents are not inside it.

Done when a valid kit source is identified and the human has not objected to it, or this step was skipped because the intent is add-group or check-only.

### 4. Copy trees

This step's name is Copy trees.

When the consumer has a `.gitignore` that lacks `.workflow/`, run Gitignore (step 8) before copying so new files are ignored as they appear.

If this run's intent is add-group or check-only, skip the copy (trees to copy = none). Do not replace any tree.

On a first install, copy all four trees below. On update-install, copy only the trees the human accepted in Re-setup. If that set is empty, skip the copy.

| Kit location | Consumer location |
|---|---|
| `roles/` (or `.workflow/roles/` when the source is an installed consumer, or legacy `workflow/roles/`) | `<project>/.workflow/roles/` |
| `workflows/` (or `.workflow/workflows/`, or legacy `workflow/workflows/`) | `<project>/.workflow/workflows/` |
| `runs/_template/` (or `.workflow/runs/_template/`, or legacy `workflow/runs/_template/`) | `<project>/.workflow/runs/_template/` |
| `project-standards/` (or `.workflow/project-standards/`) | `<project>/.workflow/project-standards/` |

Overwrite only trees accepted in Re-setup (or all four on a first install). Never overwrite or delete `.workflow/teams/*.yaml` during a tree replace (`teams/` is not a copied kit tree). When replacing `runs/`, write `runs/_template/` only; do not delete sibling `runs/<run-id>/` folders.

After a first-install copy, the consumer must contain Role cards under `.workflow/roles/<slug>/`, process documents `.workflow/workflows/*.md`, `.workflow/runs/_template/` (at least `STATUS.md` and `brief.md`), and `.workflow/project-standards/` with `CODING_STANDARDS.md`, `COMMIT_RULES.md`, and `REVIEW_RULES.md`. After a selective sync, the accepted paths must still exist from the copy or from what was already installed.

Done when the accepted trees have been copied (including `project-standards/` when accepted or on first install), existing Team yamls were left in place, live run folders were left in place, and no kit-only tree (`skills/`, `docs/`, root README, and the other files listed in Hard rules) was copied into `.workflow/`.

### 5. Choose workflows

This step's name is Choose workflows.

If this run's intent is check-only, skip this step (Team configs are not rewritten).

Run **bound-Team detection** ([reference.md](reference.md#detect-this-sessions-bound-team-config)). On an update-install that keeps Team configs, read the detected bound config, tell the human its path and `workflow` value, and skip the ask when the file exists, has the required keys, and its `workflow` target is still readable. Otherwise say why and ask which workflow to use for **this Team**; that answer creates or fixes only this session's yaml. Do not pick silently when more than one yaml matches the same lead id.

If this run's intent is add-group, ask which workflow the **new** Team should use; recommending a document other Teams already use is fine when it still fits this harness.

Otherwise list every process document under the kit (or just-copied) `workflows/*.md`. For each file, give its path and a one-line shape summary from its opening (for example one main agent with sub-agents, or every Role a main agent).

Ask the human (human action): **Which workflow do you want to install?** A number or a filename answers. Recommend from the document's own Targets when that is obvious for this harness (for example, the current kit's `main-with-subagents.md` names Cursor and DSH; `all-main-agents.md` names Grok Bot). Do not write the Team yaml until the human has chosen or kept a document.

Done when this Team has a chosen `workflows/*.md` that exists at the consumer `.workflow/workflows/` path, or an existing bound Team config was kept and still resolves.

### 6. Write team config

This step's name is Write team config.

If this run's intent is check-only: skip this step (do not create or rewrite Team yamls).

If this run's intent is add-group: create a **new** Team yaml for the new lead only. Do not overwrite this session's bound yaml or other Team yamls unless the confirmed plan says so. Role-bot display prefixes like `T2 - Team Lead` are not Team config filenames; never create short codes such as `t2.yaml`.

If this run kept existing Team configs: do not overwrite them. Recheck that this session's bound config exists and its `workflow` target resolves; if not, create or fix only that session's config after the human chooses a workflow, never a path belonging to another Team.

Otherwise: **update** the bound Team yaml when detection found one, or **create** one when detection found none (first install) or the human clearly asked for a new Team. Never create a second yaml for the same lead id.

Write the four keys in order from the human's workflow choice, this session's harness slug, and the resolved `team_lead_id`. Resolve that id from the platform agent or session id; when it is unavailable, generate one GUID, write it as both `id` and `team_lead_id`, and say the lead must remember it. Schema and example: [reference.md](reference.md#team-config-format).

After writing, tell the human it was **recorded into** `.workflow/teams/<id>.yaml`, and state the runtime rule in [reference.md](reference.md#team-config-format). When `team_lead_id` was generated, say that Initialize writes the same id into the lead's instructions.

Done when this run's Team config exists (or check-only skipped writes), the file has the four keys in order, the `workflow` target is readable, and other Teams' yamls were not silently overwritten.

### 7. Standards

This step's name is Standards.

No detection and no human confirm: the copied templates are the standards files (three paths under `.workflow/project-standards/`; list and rewrite rules in [reference.md](reference.md#standards-apply)).

Remind the human (informational; does not block setup) that they may edit those files to add project-specific rules the Roles must follow. Do not invent rules for them, and do not open an editor unless they ask.

Rewrite the Playbook references only on a first install after Copy trees, or when this re-setup replaced `roles/` and/or `project-standards/`. Otherwise leave existing Playbook wording unchanged, as on add-group and check-only.

Done when the three paths exist under `.workflow/project-standards/` (after a copy that included them) and the matching Playbooks require those paths, or this re-setup did not replace `roles/` or `project-standards/` so no rewrite was needed.

### 8. Gitignore

This step's name is Gitignore.

Only touch `.gitignore` when the consumer project root already has one. If it is missing, skip this step and do not create the file.

When it exists and does not yet list `.workflow/`, append a `.workflow/` entry so the entire `.workflow/` tree (including `runs/`) stays out of git. Do not remove other entries.

This step may run as soon as the Target is known; otherwise run it here. It applies on update-install, add-group, and check-only as well.

Done when either there was no `.gitignore` (skipped), or the existing `.gitignore` lists `.workflow/`.

### 9. Initialize

This step's name is Initialize.

If this run's intent is check-only, skip this step unless the human explicitly asked to re-init.

Initialize from the **shape** of the selected process document, not only from its file name, and do only this session's harness.

- **One main agent with sub-agents** (for example Cursor or DSH on that shape): this chat is `team-lead`. Read `<project>/.workflow/roles/team-lead/ROLE.md` and its Playbook and act as that Role from here. Spawn other Roles on demand later; do not pre-spawn them during setup.
- **Every Role a main agent** (for example Grok Bot on that shape): this session bot is intended to be `team-lead`, and the other Roles each get their own bot. Follow the naming, shared-instructions, create/init-plan, and create flow in [reference.md](reference.md#role-bot-naming-all-main-agents). On add-group, follow [reference.md](reference.md#add-role-bot-group) instead.

**Team config binding (hard runtime gate)**, every shape: once the plan is confirmed (or, for one main with sub-agents, when initializing this chat as `team-lead`), write the exact Team config path into the lead's standing instructions and into every member Role bot's when the platform allows. The text must say: read that path first, open the `workflow` target named inside, and stop if the path, file, required keys, or target is missing. Also record `team_lead_id`. Never put a Team-specific yaml path into shared Role cards. For one main with sub-agents, require spawn briefs to carry the same path. A generated `team_lead_id` is remembered by the lead, and updated (with the filename when the stem must match) once the platform id is known.

On update-install: re-read `team-lead` when `roles/` was replaced this run, and update other Role bots only for **new** Roles, following the same confirm flow. Add-group is the dedicated path for a full extra Role-bot group.

If a tool call was actually blocked pending a permission grant, remind the human what to grant and record it as pending. For a harness this session cannot configure, add it to the follow-up list and Report only.

An applied item is not finished while a naming confirmation, shared-instructions answer, create/init plan confirmation, sidebar section choice, bot create, or permission grant is still pending. Carry those into Report as pending.

Done when this session is initialized as `team-lead` when the confirmed plan said so (or the human's decline is recorded), any other bot work this session can do is done or waiting only on an applied human action, other-harness init is listed as follow-up only, and no out-of-scope human-action reminder was given.

### 10. Check

This step's name is Check.

Always run Check after the writes, including every re-setup or sync (update-install, add-group, or check-only). Walk each selected process document end to end: the installed trees, Team configs, run template, routes, and required interactions must let a run start and follow every hop. Checklist: [reference.md](reference.md#end-to-end-check).

Fail when this session's bound config is missing (when this run should have one), unreadable, missing required keys, or its `workflow` target is missing or unreadable, and when more than one `teams/*.yaml` matches the same lead id. Do not fail solely because another Team's config is absent, unless this run was supposed to create it.

The three `.workflow/project-standards/` templates count as OK when this run did not touch `roles/` or `project-standards/` and the Playbooks already require those paths.

When a hop cannot be walked, name the process document, the route, and the problem. Fix it when this skill is allowed to; otherwise stop and tell the human.

Done when every check in [reference.md](reference.md#end-to-end-check) passes, or each failure was fixed this run or discussed and the human chose what to do.

### 11. Report

This step's name is Report.

Tell the human:

- First install, update-install, add-group, or check-only
- Consumer project root and `.workflow/` path
- Kit source used (skipped on add-group or check-only)
- On update-install: which trees were replaced, which were kept, whether consumer-only slugs, extra process documents, or mismatched standards files were deleted, and whether live run folders were left in place
- On add-group: the naming prefix (for example `T2`), which Role bots were created (when this session creates Role bots), which sidebar section was used or that bots were left unassigned, that trees and other Team yamls were left untouched, and the new Team config path
- On check-only: trees untouched and Team configs not rewritten
- Paths copied
- This session's bound Team config path from detection (or that none was bound); this run's Team config path(s), whether each was created, kept, or updated; other existing `teams/*.yaml` files
- Standards Playbooks wired to `.workflow/project-standards/` (or unchanged because neither `roles/` nor `project-standards/` was replaced); the reminder that the human may add Role rules into those files
- `.gitignore` update
- Init done in this session
- Other-harness follow-up only if that work remains
- Check result (on pass: Roles, Team configs, process hops, `runs/_template/`, project-standards)
- **Human actions:** list only the items that applied this run, each done, declined, or pending, with what the human still must do for a pending one. Do not dump the catalog, do not list optional items that were not relevant, and do not list a permission grant unless a tool actually blocked.

Do not say setup is complete if any human action that applied this run is pending.

Done when that report has been given, Role process pointers still point at the `workflows/` directory, and either no applied human action is pending or the report states that the run is not complete and lists the pending items.

## Completion criteria

- [ ] Ran as `team-lead` (or this session was initialized as `team-lead`)
- [ ] Consumer project root known; destination is `<project>/.workflow/`
- [ ] First install versus existing install recorded; when existing, intent recorded (Update install, Add Role-bot group, or Check only)
- [ ] On update-install: tree replace versus selective sync recorded; Team-config keep versus change recorded; no silent overwrite of trees or of other Teams' yamls
- [ ] On add-group: no trees were replaced and other Team yamls were not overwritten; a new Team yaml was created; when this session creates Role bots, the new group was created only after naming confirmation, shared standing instructions, and create/init plan confirmation (this-session init default no)
- [ ] On check-only: no trees were replaced and Team yamls were not overwritten
- [ ] Kit source found by the detection order (or given by the human); skipped on add-group or check-only
- [ ] On a first install, `.workflow/roles/`, `.workflow/workflows/*.md`, `.workflow/runs/_template/`, and `.workflow/project-standards/` materialized from the kit; on update-install, only accepted trees were copied; on add-group or check-only, no trees were copied
- [ ] Kit `skills/`, `docs/`, and root README not copied into `.workflow/`
- [ ] Live `.workflow/runs/<run-id>/` folders left in place unless the human explicitly asked to remove them
- [ ] Bound-Team detection ran; human chose a process document for this Team, or this session's existing bound Team config was kept and still resolves; no duplicate yaml for the same lead id
- [ ] This Team's `.workflow/teams/<id>.yaml` exists with `id`, `workflow`, `team_lead_id`, and `harness` in that order and a readable `workflow` target; other Team yamls were preserved
- [ ] Role card `workflows/` directory pointers left unchanged
- [ ] Standards Playbooks rewritten to `.workflow/project-standards/` after first install or after `roles/` / `project-standards/` replace; no detection ask
- [ ] Consumer `.gitignore` contains `.workflow/` (or the consumer had none)
- [ ] This session's init matches the selected shape; remaining other-harness init listed
- [ ] Human actions were reminded only at the steps where they apply, and only for this session's harness
- [ ] Report lists only human actions that applied this run as done, declined, or pending
- [ ] Did not claim the run complete while a pending human action that applied this run remained
- [ ] End-to-end check passed for each selected process document after this install, update-install, add-group, or check-only
