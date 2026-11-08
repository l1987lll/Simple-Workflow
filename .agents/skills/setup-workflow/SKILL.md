---
name: setup-workflow
description: Use when installing or setting up Simple-Workflow in a consumer or product repository; when a project needs a local .workflow/ tree sourced from the kit; when the human asks to apply, sync, re-setup, or reinstall after kit Role or process-document changes; when adding another Role-bot group on an existing install; or when the older name install-workflow is requested.
disable-model-invocation: true
---

# setup-workflow

Install the kit's Role cards, process documents, run templates, and project-standards templates into a consumer project's `.workflow/` directory, write Team config files, and confirm the selected workflow can be walked. Re-setup and sync after kit Role or process-document changes are first-class: detect an existing install, ask intent first (Update install, Add Role-bot group, or Check only), ask before replacing anything, and always re-run Check. Kit detection, existing-install intent and questions, human actions, and the end-to-end check list: [reference.md](reference.md). Vocabulary: repo-root `GLOSSARY.md`.

Actions only the human can do are listed under Human actions. Remind each one only at the step where it is needed, and only when it applies to this session's harness. In Report, list only the items that applied this run as done, declined, or pending, and do not claim the run is complete while any of those remain pending.

This skill file is English only. Files this skill writes are English. Explain and ask in the human's language at runtime; do not put non-English script into this skill's files.

This skill lives in the Simple-Workflow kit (and later as a globally installed skill). It does not embed `roles/`, `workflows/`, or `runs/`. Copy those trees from a kit source.

Only the coordinating main Role (`team-lead`) runs this skill. If another Role session invoked it, stop and tell them to run it from `team-lead`.

## Hard rules

- The consumer layout is `<project>/.workflow/{roles,workflows,runs}`. Create `.workflow/` if it is missing. Do not use a bare `workflow/` directory as the consumer install dir, and do not write Role cards at the consumer repo root.
- Copy only the kit's `roles/`, `workflows/`, `runs/` (including `runs/_template/`), and `project-standards/` into `.workflow/`. Do not copy the kit's `skills/`, `docs/`, root README, GLOSSARY, OPEN_ISSUES, AGENTS, LICENSE, `.agents/`, or `.git`.
- Do not embed Role cards or process documents inside this skill.
- Leave each Role card's process pointer pointing at the `workflows/` directory (library location only). Do not rewrite Role cards to a specific `.workflow/teams/<id>.yaml` path. The hard runtime gate is the Team config path bound into standing instructions (Initialize), not Role-card prose.
- Detect this session's harness id from the runtime environment (how the agent is running): use the platform/product name for this session in lowercase slug form. Examples of ids include `cursor`, `grok`, and `deepseek` — examples only, not an exhaustive allowlist. If the id is unknown, ask the human once for the harness slug to store in the Team config `harness` field.
- Each Team has one config file at `.workflow/teams/<id>.yaml`. Required keys in this order: `id`, `workflow`, `team_lead_id`, `harness`. `id` is the unique Team identifier and MUST match the filename stem. Prefer the platform team-lead id (Grok agent id / Cursor session id) when known; if unavailable, generate a GUID and require the lead to remember it. Typically set `id` to the same value as `team_lead_id`. Do NOT invent or auto-assign short codes `t1`, `t2`, … for the filename or the `id` field. Example filename: `216ab690-efa9-4760-9938-e54be49013bd.yaml`. `workflow` is one path relative to `.workflow/workflows/`. `team_lead_id` is the platform agent or session id when available; if it is unavailable, generate a GUID, write it into the yaml, and require the lead agent to remember the same id (standing instructions or session notes). `harness` is the lowercase product slug for this Team. Schema details: [reference.md](reference.md).
- On a first install or when creating a new Team, write `.workflow/teams/<id>.yaml`. Set `id` (and the filename stem) to the platform team-lead id when known, otherwise a new GUID; typically use the same value for `id` and `team_lead_id`. Do not invent short codes `t1`, `t2`, … Do not invent a fixed closed set of harness names. On update-install, rewrite a Team config only when the human asked to change that Team's `workflow` or metadata; never silently overwrite other Teams' yaml files. On add-group, create a new Team yaml and do not overwrite existing Team yamls. On check-only, do not write or rewrite Team yamls. Team config is the only current-workflow pointer.
- **Detect this session's bound Team config** before deciding create vs update (full order in [reference.md](reference.md#detect-this-sessions-bound-team-config)):
  1. Exact path already written in this session's standing instructions / profile / session notes (`.workflow/teams/<id>.yaml`).
  2. Else a `teams/*.yaml` whose `team_lead_id` (or `id`) equals this session's platform agent/session id.
  3. Else: no bound config for this session → first install write or add-group **create** a new yaml (do not guess another Team's file).
  If more than one `teams/*.yaml` matches the same lead id, **fail Check / stop** and tell the human (do not pick silently).
  Re-setup Report / Choose workflows / Write team config: when a bound config is found, **say that path** and treat keep/change as **update** that Team; never create a duplicate for the same lead id.
  Add-group: this session usually keeps its own bound config; **create** a new yaml for the new Team (new lead); do not overwrite this session's yaml unless the plan says so.
  Check only / Update install: use the same detection.
- Runtime rule: every agent in a Team reads its bound Team config path (for example `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`), then reads the `workflow` target named inside. If the path, file, required keys, or target process document is missing or unreadable, stop. The hard bind is standing instructions: write the exact Team config path into the lead's standing instructions AND into every member Role bot's standing instructions when the platform allows. Do not put a Team-specific yaml path into shared Role `ROLE.md` / `PLAYBOOK.md`. Role cards may keep a generic `workflows/` directory link as the library location only. For Cursor one-main-with-subagents: bind on the lead and require spawn briefs to carry the same config path. Sub-agents inherit that path from the lead brief or their own instructions.

- When the consumer already has a .gitignore, ensure it contains a .workflow/ entry so the entire .workflow/ tree stays out of git. If there is no .gitignore, skip — do not create one. Do not change the kit repo's own tracking of `roles/`, `workflows/`, `runs/`, or `project-standards/`.
- Coding, commit, and review standards templates ship in the kit's `project-standards/` (`CODING_STANDARDS.md`, `COMMIT_RULES.md`, `REVIEW_RULES.md`) and are copied to `.workflow/project-standards/`. After that copy (and whenever `roles/` or `project-standards/` is replaced on re-setup), rewrite Playbook references so those three installed paths are **mandatory reads**. Do **not** search for alternate standards files, and do **not** ask the human to confirm, decline, or name alternate paths. Do not invent file contents beyond the shipped templates.
- Role changes stay in the kit. This skill does not reserve a consumer path for `create-role` output. After kit Role or process-document changes, the human re-runs this skill to sync the consumer.
- Never silently overwrite an existing populated `.workflow/` tree. When `.workflow/roles`, `.workflow/workflows`, `.workflow/runs`, or `.workflow/project-standards` already has content, or the human asks to re-setup, sync, or add a Role-bot group, detect the existing install and ask **intent first** (Update install, Add Role-bot group, or Check only) before any tree or Team-config question. Only **Update install** then asks full replace of `roles/`, process documents, `runs/_template/`, and `project-standards/` versus a selective sync (which trees), and whether to keep or change a named Team's `workflow` or metadata. **Add Role-bot group** must not replace trees; it creates a new Team config and must not overwrite other Teams' yaml files. **Check only** must not replace trees and must not rewrite Team configs.

- When syncing `runs/`, replace `runs/_template/` only. Do not delete or overwrite live `.workflow/runs/<run-id>/` folders unless the human explicitly asks.
- Always run Check after a first install and after every re-setup or sync, including add-group and check-only.
- Remind the human only of the human-only action needed at the current step, and only when it applies to this session's harness (see Human actions). Do not read out the catalog. Do not mention a harness-specific action that does not apply to this session (for example, a Cursor-only or DSH-only action in a Grok session, or a Grok-only action in a Cursor or DSH session â€” examples of harness-specific actions, not the only harnesses). Mention another harness only as follow-up in Initialize and Report. Do not invent their answers or perform those actions as if you were them. Do not claim the run is complete while any pending human action that applied this run remains. In Report, list only items that applied this run as done, declined, or pending.

## Dynamic edits

This list is fixed in the skill. Do not invent further consumer edits at runtime.

1. Write or update `.workflow/teams/<id>.yaml` for a Team created or explicitly updated this run. Never silently overwrite another Team's yaml.
2. Rewrite standards references in Playbooks (or the Playbook region of a Role-merged `ROLE.md`) to the installed `.workflow/project-standards/` paths after Copy trees on a first install, and after any re-setup that replaced `roles/` or `project-standards/`.
3. When the consumer already has a .gitignore, ensure it contains .workflow/ (do not create .gitignore if missing).
4. Materialize or copy `roles/`, `workflows/`, `runs/` (including `_template`), and `project-standards/` into the consumer `.workflow/` directory.

On update-install, perform only the items the human accepted this run (which trees to replace, whether to update a named Team config). On add-group, do not copy trees; do write a new Team yaml. On check-only, do not copy trees and do not rewrite Team yamls.
Rewrite standards Playbook references automatically when `roles/` or `project-standards/` was replaced. Live `.workflow/runs/<run-id>/` folders are not a Dynamic edit.

## Human actions

A **human action** is something only the person can do. Do not impersonate them, invent their answer, or skip a reminder that is needed now.

Remind **only at the step where that action is needed**, and **only when it applies to this session's harness**. Do not read this catalog aloud. Do not preview later steps. Do not mention a harness-specific action that does not apply to this session (for example, a Cursor-only or DSH-only action in a Grok session, or a Grok-only action in a Cursor or DSH session â€” examples of harness-specific actions, not the only harnesses).

If work remains for another harness, mention it only as follow-up in the Initialize follow-up list and in Report - not during earlier steps.

Keep a Report list of items that **actually applied this run** (you asked, a tool blocked, or the human requested that optional item). Mark each as **done**, **declined**, or **pending**. An item is pending when it applied and the human has not done it or explicitly declined or skipped it. Do not claim the run is complete while any pending item remains. Do not list catalog rows that never applied.

### When to remind

| Action | Remind at | Only when |
|---|---|---|
| Choose existing-install intent (Update install / Add Role-bot group / Check only) | Re-setup | Existing install, or the human asked to add a group, re-setup, or sync |
| Approve overwrite / re-setup choices | Re-setup | Intent is Update install (existing install, or the human asked to re-setup or sync) |
| Choose which workflow to install (ask: "Which workflow do you want to install?"; after write, say recorded into `.workflow/teams/<id>.yaml` in the `workflow` field) | Choose workflows | First install, add-group (new Team), or update-install with a change to a named Team's workflow, or this session's Team config or `workflow` target no longer resolves |
| Confirm or accept a generated `team_lead_id` | Write team config / Initialize | Platform team-lead id is unavailable, so setup generated a GUID the lead must remember |
| Choose install root: **current working directory first (preferred)**, or name another path | Target | Target step, unless an install path was already named this run; always list current working directory first with its real path; do not replace it with a sibling-repo picker; if the choice is the kit, ask for a different path. A multi-repo parent is allowed |
| Name the kit source directory | Find kit | Detection did not find a valid source |
| Approve deleting consumer-only extras | Re-setup | A replace would remove Role slugs or process documents the kit lacks |
| Approve removing live `runs/<run-id>/` folders | Re-setup | Only if someone proposed removing them |
| Confirm Role bot naming rule (or edit proposed names) | Initialize | This session is Grok Bot (or another all-main-agents harness that creates Role bots), the selected document is an all-main-agents shape, and at least one Role bot still needs creating (including every Role in a new Role-bot group on add-group) |
| Confirm shared standing instructions for all Role bots (or decline / none) | Initialize | This session is creating other Role bots (all-main-agents), including a new Role-bot group; ask before create. Examples the human may give: may only access a named directory or repo; chat language; tools they must not use |
| Confirm Role bot create/init plan (including whether to initialize this session bot as `team-lead`) | Initialize | All-main-agents session after naming and shared standing instructions are settled; show the plan before any create or this-session profile rewrite. On add-group, default this-session init to no (create a new team-lead bot instead) |
| Confirm sidebar section for new Role-bot group | Initialize | Add-group mode when the platform lists sidebar sections (`ListSections`); ask which existing section to place the new bots in, or leave unassigned |
| Create or authorize Grok Role bots | Initialize | After the create/init plan is confirmed; initialize this session bot when the plan says so, create other Role bots with confirmed names, apply shared instructions. Remind the human only when the platform still requires a person to authorize a bot |
| Grant local machine / workspace permissions | The step that blocked | A specific tool call was refused or blocked pending a person granting access. Name what was blocked. Do not remind in advance |
| Install `setup-workflow` into global skills | Only if relevant this run | The human asked to use this skill outside the kit, or asked how to get `/setup-workflow` (or the equivalent) everywhere. Do not offer it unsolicited |
| Other-harness init | Initialize follow-up list and Report only | This session cannot finish that harness's init (examples of harness-specific init, not an exhaustive list: Cursor or DSH initializing this chat as `team-lead`; Grok Role bot create/auth) |
| Human-only slash commands (for example `/retro`) | Not during setup | A later run needs them; `team-lead` reminds then |

Choosing a process document is recorded in this Team's config `workflow` field. Choosing existing-install intent (Update install / Add Role-bot group / Check only) happens at Re-setup before any tree or Team-config question. Confirm Role bot naming, shared standing instructions, the create/init plan (including this session bot; default no on add-group), sidebar section for a new Role-bot group, and create or authorize Role bots are examples of all-main-agents (often Grok) actions, not a sign that Grok is one of only two supported harnesses. Do not describe another harness's init except as follow-up.

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

The destination is always `<chosen-path>/.workflow/` (leading dot required — never bare `workflow/`) under whatever directory the human picks as the install root - a single consumer repo, the current workspace, or a multi-repo parent (e.g. `D:\DevelopmentGit` -> `D:\DevelopmentGit\.workflow/`). That is allowed; do not require picking a child repo. Do **not** install into the Simple-Workflow kit itself as if it were a consumer.

- If the human already named an install path this run (and it is not the kit), use it (do not re-ask).
- Otherwise **ask the human** (human action). The ask **must** offer **current working directory / current workspace** as the **first and preferred** option (this session's working directory / open workspace root). Then offer typing or naming another path. Recommend the current working directory unless they already said otherwise.
  - Phrase the options like: (1) **Current working directory** (`<actual cwd path>`) — preferred; (2) I'll type/name another path. Show the real cwd path in the first option when known.
  - If they choose the current workspace or name a path: use that directory as the install root **unless** it is a Simple-Workflow kit source (see [reference.md](reference.md)). If it is the kit, say so briefly and ask them to name a different path. Do not install into the kit.
  - A multi-repo parent is a valid choice: create `.workflow/` directly under it.

Do **not** invent a multiple-choice list of sibling repositories as the primary Target ask, and do not replace the current-working-directory option with such a list. If you optionally mention nearby folders as examples after the preferred option, keep current working directory first and preferred. Ask only current workspace versus a path they name (or a different path if they hit the kit). Always say the install lands in `.workflow/` under the chosen root, never `workflow/` without the leading dot.

Detect whether an **existing install** is present (see [reference.md](reference.md)): any of `.workflow/roles`, `.workflow/workflows`, `.workflow/runs`, or `.workflow/project-standards` already has content under the chosen path. Also treat a populated legacy `workflow/` tree (no leading dot) as an existing install: tell the human the install directory is now `.workflow/`, and do not install into bare `workflow/`. Also treat the run as re-setup when the human asked to re-setup, sync, add a Role-bot group, or reinstall after kit Role or process-document changes. Report first install versus existing install. Do not replace anything in this step.

If `<chosen-path>/.workflow/` does not exist, it will be created at Copy trees.

Done when the install root is known, the destination is `<chosen-path>/.workflow/`, and first install versus existing install has been recorded.

### 2. Re-setup

This step's name is Re-setup.

If this is a first install (no populated trees, and the human did not ask to re-setup, sync, or add a Role-bot group), say so and skip the rest of this step.

When it is an existing install or the human asked to re-setup, sync, or add a Role-bot group, plan before any copy. Report what is already there: which trees exist, role slugs and process document names, whether `runs/_template/` exists, whether live `runs/<run-id>/` folders exist, every `.workflow/teams/*.yaml` (id, workflow, harness, team_lead_id) if present, whether Playbooks already require `.workflow/project-standards/` paths (how to read them: [reference.md](reference.md)), and any already-visible Role bots or Role-bot group prefixes for this install when that is knowable. **Also run bound-Team detection** ([reference.md](reference.md#detect-this-sessions-bound-team-config)): if this session already has a bound config, say the exact path and that later keep/change will **update** that Team; if none, say so and that a first-install write or add-group will **create** a new yaml (do not guess another Team's file). If multiple yaml match the same lead id, stop and tell the human before asking intent.

Then ask **intent first** (human action) and wait for the answer before any tree or Team-config question:

1. **Update install** — classic re-setup: full or selective tree replace and/or change a named Team's `workflow` or metadata.
2. **Add Role-bot group** — keep the existing `.workflow/` trees and other Team yamls unchanged; create another Team (a new `teams/<id>.yaml`). On an **all-main-agents** session that can create Role bots (for example Grok), also create another Role-bot group (a named set of Role bots) for this same install. On a one-main-with-sub-agents session (for example Cursor), still create the new Team yaml and bind this chat as lead; do not pre-create Role bots.
3. **Check only** — no tree copy; do not rewrite Team yamls; skip toward Check (run Initialize only if the human explicitly asks to re-init).

Never silently overwrite trees. **Add Role-bot group** must not replace trees or overwrite other Teams' yaml files.

If intent is **Add Role-bot group**:
- Record mode `add-group`; trees to copy = none; do not overwrite existing Team yamls; a new Team yaml will be written at Write team config.
- Do **not** ask the tree-replace questions.
- Skip Find kit, Copy trees, and Standards rewrite (the install is already present). Say the skipped step name and that it is skipped because the install is already present / trees are untouched.
- Still run Choose workflows (for the new Team) and Write team config (create the new yaml).
- Still run Gitignore if `.gitignore` exists and lacks `.workflow/`.
- Proceed to Initialize in **add-group** mode, then always Check, then Report.

If intent is **Update install**: ask the tree and Team-config questions next; they are human actions. Never replace a tree or rewrite a Team yaml until the human has answered.

1. **Trees.** Full replace of `roles/`, process documents under `workflows/`, `runs/_template/`, and `project-standards/`, or a selective sync? If selective, ask which of those trees to replace. "None" is allowed when the human only wants to change a Team config or re-check. Do not copy a tree the human did not name. If a replace would remove consumer-only Role slugs, extra process documents, or customized standards files the kit does not have, say so and ask whether to delete or overwrite those extras.
2. **Team config.** Prefer this session's **bound** Team config path from detection. Keep that config, or change its `workflow` or metadata? If the human names another Team, use that path/`id` only when they clearly mean that Team. Do not ask to overwrite other Teams' yaml files. When a bound config exists, treat keep/change as **update** that file — never create a duplicate for the same lead id.

After Copy trees, if this update-install replaced `roles/` and/or `project-standards/`, the Standards step rewires Playbooks to `.workflow/project-standards/` automatically (no ask).

If intent is **Check only**: record trees to copy = none; do not rewrite Team yamls. Skip Find kit, Copy trees, Choose workflows, Write team config, and Standards rewrite. Still run Gitignore if `.gitignore` exists and lacks `.workflow/`. Skip Initialize unless the human explicitly asks to re-init. Always run Check, then Report.

Live `.workflow/runs/<run-id>/` folders are not part of a template sync; leave them unless the human explicitly asks to remove them.

Done when either this is a first install, or the existing-install intent is recorded (and, for Update install, the tree and Team-config choices are recorded; for add-group, trees none and a new Team yaml planned; for check-only, trees none and Team configs unchanged).

### 3. Find kit

This step's name is Find kit.

If this run's intent is add-group or check-only, skip this step (the consumer install is already present).

The kit source is a Simple-Workflow clone (or another tree that already holds the Role cards and process documents to copy). Detect in this order; stop at the first valid source (rules in [reference.md](reference.md)):

1. The current working directory, or a path the human already named this run, that looks like a kit root (`roles/` plus `workflows/*.md`) or like an installed consumer (`.workflow/roles` plus `.workflow/workflows`; also accept a legacy `workflow/roles` plus `workflow/workflows` tree).
2. Common path heuristics in [reference.md](reference.md).
3. Ask the human for the kit source directory (a human action).

Do not treat this skill's own folder as the kit source. Roles and process documents are not inside the skill.

Done when a valid kit source is identified and the human has not objected to it, or this step was skipped because the intent is add-group or check-only.

### 4. Copy trees

This step's name is Copy trees.

If the consumer already has a .gitignore and it does not yet list .workflow/, do the Gitignore step before copying so new files are ignored as they appear. If there is no .gitignore, skip Gitignore.

If this run's intent is add-group or check-only, skip the copy (trees to copy = none). Do not replace any tree.

On a first install, copy all four trees below. On update-install, copy only the trees the human accepted in Re-setup. If that set is empty, skip the copy.

| Kit location | Consumer location |
|---|---|
| `roles/` (or `.workflow/roles/` when the source is an installed consumer, or legacy `workflow/roles/`) | `<project>/.workflow/roles/` |
| `workflows/` (or `.workflow/workflows/`, or legacy `workflow/workflows/`) | `<project>/.workflow/workflows/` |
| `runs/_template/` (or `.workflow/runs/_template/`, or legacy `workflow/runs/_template/`) | `<project>/.workflow/runs/_template/` |
| `project-standards/` (or `.workflow/project-standards/`) | `<project>/.workflow/project-standards/` |

Overwrite only trees accepted in Re-setup (or all four on a first install). When replacing `workflows/`, copy process `*.md` files only. Never overwrite or delete `.workflow/teams/*.yaml` during a tree replace (`teams/` is not a copied kit tree). When replacing `runs/`, write `runs/_template/` only; do not delete sibling `runs/<run-id>/` folders.

After a first-install copy, the consumer must contain Role cards under `.workflow/roles/<slug>/`, process documents `.workflow/workflows/*.md`, `.workflow/runs/_template/` (at least `STATUS.md` and `brief.md`), and `.workflow/project-standards/` with `CODING_STANDARDS.md`, `COMMIT_RULES.md`, and `REVIEW_RULES.md`. After a selective sync, the accepted paths must still exist from the copy or from what was already installed.

Done when the accepted trees have been copied (including `project-standards/` when accepted or on first install), existing Team yamls were left in place, live run folders were left in place, and no kit-only tree (`skills/`, `docs/`, root README, and the other files listed in Hard rules) was copied into `.workflow/`.

### 5. Choose workflows

This step's name is Choose workflows.

If this run's intent is check-only, skip this step (Team configs are not rewritten).

Run **bound-Team detection** ([reference.md](reference.md#detect-this-sessions-bound-team-config)) for this session. If this is an update-install and the human chose to keep existing Team configs, read the **detected bound** Team config path. Tell the human that path and its `workflow` value, and skip asking when that file exists, has the required keys, and its `workflow` target is still readable — treat as **update/keep** that Team. If this session has no bound Team config, or the config is missing, unreadable, or points at a missing process document, say so and ask again which workflow to use (this Team only); that answer will **create** or **fix** only this session's Team yaml, never another Team's file. If multiple yaml match the same lead id, stop and tell the human (do not pick silently).

If this run's intent is add-group, list process documents as below and ask which workflow the **new** Team should use. Recommending the same document other Teams already use is fine when that still fits this harness.

Otherwise list every process document under the kit (or just-copied) `workflows/*.md`. For each file, give its path and a one-line shape summary from its opening (for example one main agent with sub-agents, or every Role a main agent).

Ask the human (human action): **Which workflow do you want to install?** A number or a filename answers. Recommend from the document's own Targets when that is obvious for this harness (for example, the current kit's `main-with-subagents.md` names Cursor and DSH; `all-main-agents.md` names Grok Bot). Map the choice to the Team config `workflow` field only at Write team config. Do not write the Team yaml until the human has chosen or kept it.

Do not ask which file another Team or another harness should use. Do not write or overwrite other Teams' yaml files in this step.

Done when this Team has a chosen `workflows/*.md` that exists at the consumer `.workflow/workflows/` path, or an existing bound Team config was kept and still resolves.

### 6. Write team config

This step's name is Write team config.

If this run's intent is check-only: skip this step (do not create or rewrite Team yamls).

If this run's intent is add-group: create a **new** Team yaml for the **new** lead only; do not overwrite this session's bound yaml or other Team yamls unless the confirmed plan says so. Do **not** map Role-bot display prefixes (`T2`, …) to short config ids (`t2.yaml`). Set `id` and `team_lead_id` to the new lead's platform id when known; if the yaml must be written before that bot exists, generate one GUID, write it as both `id` and `team_lead_id`, then update both (and rename the file if needed) once the platform lead id is known. Write the four keys in order from the human's workflow choice, this session's harness slug, and that `team_lead_id`. Role-bot **display** prefixes like `T1 - Team Lead` / `T2 - …` are unchanged and are NOT used as Team config filenames.

If this is an update-install and the human chose to keep Team configs: do not overwrite existing Team yamls. Recheck via **bound-Team detection** that this session's bound config exists and its `workflow` target resolves; if it does not, **create or fix only that session's** config after the human chooses which workflow to use — never invent a path belonging to another Team.

If this is a first install, or an update-install that changes a named Team: **update** the bound Team yaml when detection found one for this session (or the Team the human named); **create** a new yaml only when detection found none (first install) or the human clearly asked for a new Team. Never create a second yaml for the same lead id. A first-install create sets `id` (and filename stem) to the lead platform id or a generated GUID — never short codes `t1`/`t2`.

Detect the harness slug as specified in Hard rules (lowercase platform/product slug; ask once if unknown). Resolve `team_lead_id`: prefer the platform agent id (Grok) or session id (Cursor); if unavailable, generate a GUID and require the lead to remember it.

Write the file as YAML with keys in this order (no extra top-level keys in v1):

```yaml
id: 216ab690-efa9-4760-9938-e54be49013bd
workflow: all-main-agents.md
team_lead_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
harness: grok
```

After writing or updating, tell the human it was **recorded into** `.workflow/teams/<id>.yaml`. Also tell them the runtime rule: read that Team config path, then the `workflow` process document; if either is missing, stop. If `team_lead_id` was generated, say so and that Initialize will write the same id into the lead's instructions.

Done when this run's Team config exists (or check-only skipped writes), the file has the four keys in order, the `workflow` target is readable, and other Teams' yamls were not silently overwritten.

### 7. Standards

This step's name is Standards.

No detection and no human confirm. The installed templates are the standards files:

- `.workflow/project-standards/CODING_STANDARDS.md`
- `.workflow/project-standards/COMMIT_RULES.md`
- `.workflow/project-standards/REVIEW_RULES.md`

Remind the human (informational; does not block setup): they may edit these files to add project-specific rules the Roles must follow. Do not invent rules for them. Do not open an editor unless they ask.

If this run's intent is add-group or check-only, leave existing Playbook wording unchanged (do not rewrite).

Run this rewrite when:

- this is a first install after Copy trees, or
- update-install replaced `roles/` and/or `project-standards/` this run.

Otherwise leave existing Playbook wording unchanged.

Rewrite Playbook references (developer and code-reviewer today; any other copied Role that names these files) so each Role **must read** the matching path above before the matching standards step. Replace any search-order Notes with those paths. Keep a When-stuck raise if a required file later cannot be read. Do not invent template contents. Do not ask the human for alternate paths.

Done when the three paths exist under `.workflow/project-standards/` (after a copy that included them) and the matching Playbooks require those paths, or this re-setup did not replace `roles/` or `project-standards/` so no rewrite was needed.

### 8. Gitignore

This step's name is Gitignore.

Only touch `.gitignore` when the consumer project root already has one. If `.gitignore` is missing, skip this step — do not create the file.

When `.gitignore` exists and does not yet list `.workflow/`, append a `.workflow/` entry so the entire `.workflow/` tree (including `runs/`) stays out of git. Do not remove other entries. Do not gitignore `.workflow/` inside the Simple-Workflow kit itself.

This step may run as soon as the Target is known; if it was not done then, do it now. Run it on update-install, add-group, and check-only as well when `.gitignore` exists and the entry is missing.

Done when either there was no `.gitignore` (skipped), or the existing `.gitignore` lists `.workflow/`.


### 9. Initialize

This step's name is Initialize.

If this run's intent is check-only, skip this step unless the human explicitly asked to re-init.

Initialize from the **shape** of each selected process document, not only from its file name. Do only this session's harness. Do not remind a harness-specific action that does not apply here (for example, do not remind Cursor or DSH init in a Grok session, or Grok bot create/auth in a Cursor or DSH session — examples of harness-specific actions, not the only harnesses).

**One main agent with sub-agents** (example: when this session is Cursor or DSH and that is the selected document's shape): this chat is `team-lead`. Read `<project>/.workflow/roles/team-lead/ROLE.md` and its Playbook and act as that Role from here. Spawn other Roles on demand later; do not pre-spawn them during setup.

**Every Role a main agent** (example: when this session is Grok Bot and that is the selected document's shape): this session bot is intended to be `team-lead`, and the other Roles each get their own bot. Before creating or rewriting any bot, run the naming and confirm flow in [reference.md](reference.md#role-bot-naming-all-main-agents). If this run's mode is **add-group**, use the add-group mode steps below instead of treating existing group bots as the ones to rename or rewrite.

1. Infer a naming rule from this session bot's display name (and, when visible, any already-created Role bots for this install). Prefer a shared pattern such as a prefix plus Role title, a prefix plus Role slug, or a short code plus separator plus title.
2. Preview proposed display names for **every Role that participates**, including `team-lead` for **this session bot** (rename only if the human wants that) and every other Role that still needs a bot (skip Roles the human already has a bot for and wants to keep unchanged).
3. Ask the human (human action) to confirm the naming rule, change the rule, or edit individual names. Do **not** create or rewrite bots until naming is confirmed.
4. Ask the human (human action) whether there are **shared standing instructions or rules** every Role bot in this plan should follow (for example: may only access a named directory or repo tree; chat language; tools or sites they must not use). They may answer none / decline. Record what they give; do **not** invent constraints.
5. Show a **create/init plan** and ask the human to confirm it (human action) before any create or profile rewrite:
   - whether to **initialize this session bot** as `team-lead` from the installed `team-lead` Role card (update description / standing instructions the platform supports; optionally rename to the confirmed `team-lead` name);
   - which **other Role bots** to create (or reconfigure) with the confirmed names and Role cards;
   - that shared standing instructions (if any) will be applied as confirmed.
   Do **not** create bots, and do **not** rewrite this session bot's profile, until they confirm the plan. They may decline initializing this session bot, decline creating some Roles, or edit the plan.
6. Only after that confirmation: initialize this session bot when the plan says so; create or configure the other Role bots in the plan; apply any shared standing instructions; load each Role from its installed card. Remind the human to authorize a bot only when the platform still requires a person after create. Do not ask them to paste each card. Do not start those bots on product work during setup.

If no reusable naming rule is clear, propose a simple default derived from this bot's name (for example keep a shared prefix and append each Role's title) and still wait for confirmation. The human may change the naming rule at any time before the create/init plan is confirmed; use their latest rule for the remaining names.

**Add-group mode** (all-main-agents session that can create Role bots; mode recorded in Re-setup):

Read the new Team config written this run (or this session's bound Team config) and that process document to list every participating Role. If the config is missing or its `workflow` target is unreadable, say so and ask the human to name the process document or go back to Choose workflows; do not invent one.

1. Infer the **next** group naming rule from already-visible Role bots for this install (for example existing `T1 - Team Lead` bots → propose `T2 - <Role title>`). If the pattern is unclear, propose the next code after the highest `Tn` seen, or ask.
2. Preview names for **every Role** in the process document for the **new** group only (including a **new** `team-lead` bot). Do **not** list renaming or rewriting existing group bots unless the human asks.
3. Ask the human (human action) to confirm the naming rule, change the rule, or edit individual names. Do **not** create or rewrite bots until naming is confirmed.
4. Ask the human (human action) whether there are **shared standing instructions or rules** every Role bot in **this new group** should follow. They may answer none / decline. Record what they give; do **not** invent constraints.
5. Show a **create/init plan** and ask the human to confirm it (human action) before any create:
   - **This session bot:** default **do not** re-initialize this session as `team-lead` for the new group (create a new `team-lead` bot instead). Only initialize or rename this session bot if the human explicitly wants that in the plan.
   - **New Role bots:** create each Role in the new group with the confirmed names and Role cards (including the new `team-lead`).
   - **Sidebar section:** if the platform lists sidebar sections (`ListSections`), ask which section to place the new bots in, or leave them unassigned (human action). Prefer proposing an existing matching section (for example Team 2 when the prefix is `T2`). There is no CreateSection tool — only `CreateAgent` with a `section_id` from ListSections.
   - Shared standing instructions as confirmed.
   Do **not** create bots, and do **not** rewrite this session bot's profile, until they confirm the plan.
6. Only after that confirmation: create the new group's Role bots (and initialize this session bot only when the plan says so); apply any shared standing instructions; load each new bot from its installed Role card. Remind the human to authorize a bot only when the platform still requires a person after create. Do not ask them to paste each card. Do not start those bots on product work during setup. Do not rename or rewrite existing bots unless the confirmed plan says so.

An Update-install re-setup that also creates new Roles still follows the "new Roles only" rule below; **add-group** is the dedicated path for a full extra Role-bot group.

Perform the init this session can do:

- If this session's selected document is a one-main-with-sub-agents shape (for example Cursor or DSH on that shape), initialize this chat as `team-lead` now.
- If this run's mode is add-group and this session can create Role bots, run the add-group mode flow above (this-session init defaults to no). If this session cannot create Role bots (for example a one-main-with-sub-agents Cursor chat), still treat the new Team yaml as created: initialize this chat as `team-lead` for that Team and apply Team config binding; do not pre-create Role bots.
- If this session's selected document is an all-main-agents shape (for example Grok Bot on that shape) and this run is not add-group, run the naming-rule infer → confirm → shared-instructions ask → **create/init plan confirm** → create/init flow above. Include initializing **this session bot** as `team-lead` in the plan when appropriate; do not assume silent init. Ask for authorize when the platform still requires a person.
- If a write, read, or spawn in this step or an earlier step this run was actually blocked pending a permission grant, remind the human what to grant and record that grant as pending. Do not remind about permissions that were never blocked.
- On update-install, re-read `team-lead` when `roles/` was replaced this run. If this session can update other Role bots (for example a Grok session after Role cards changed), update them from the new cards. For **new** Role bots only, reuse the last confirmed naming rule when still available, or re-infer; always confirm names, re-ask (or reuse) shared standing instructions, and confirm the create/init plan (including whether to re-init this session bot as `team-lead`) before creating or rewriting. Do not rename an existing bot or rewrite an existing bot's standing instructions unless the human asks or the confirmed plan says so. Add-group is the dedicated path for a full extra Role-bot group and does not replace `roles/`.
- For a harness this session cannot configure, add it only to the follow-up list (and Report). Do not discuss that harness's human actions during this step beyond that list.

**Team config binding (hard runtime gate):** After the create/init plan is confirmed (or, for a one-main-with-sub-agents shape, when initializing this chat as `team-lead`), write the **exact** Team config path (for example `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`) into the lead's standing instructions AND into every member Role bot's standing instructions when the platform allows. Standing-instructions text must say: read that path first; open the `workflow` target named inside; stop if the path, file, required keys, or target is missing/unreadable. Also record `team_lead_id`. Do **not** put a Team-specific yaml path into shared Role `ROLE.md` / `PLAYBOOK.md` (Role cards stay generic; `workflows/` directory link is library location only). For Cursor one-main-with-subagents: bind on the lead and require spawn briefs to carry the same config path. If `team_lead_id` is a generated GUID, the lead must remember that same id; when the platform lead id becomes known, update `id` and `team_lead_id` (and rename the file if the stem must match). If a new `team-lead` bot is created (add-group default), prefer that bot's platform id as both `id` and `team_lead_id` when known, update/rename the yaml to match, and bind the config path on that new lead — not on this session bot unless the confirmed plan initializes this session for the new Team.

Do not offer optional global-skill install here unless that item already applied earlier this run and is still pending.

Do not treat Initialize as finished while a naming confirmation, shared-instructions ask, create/init plan confirmation, sidebar section confirmation, create/auth, or permission grant that applied this run is pending. Carry those items into Report as pending.

Done when this session's harness is initialized as `team-lead` when the confirmed plan said so (or the human declined this-session init and that decline is recorded), any other-bot configuration this session can do is done or waiting only on human naming confirmation, shared-instructions answer, create/init plan confirmation, sidebar section confirmation, or create/auth that applied (recorded as pending), other-harness init is listed only as follow-up, and no out-of-scope human-action reminders were given. On add-group, the new Role-bot group was created only after naming, shared standing instructions, and create/init plan confirmation (this-session init default no unless the human asked).

### 10. Check

This step's name is Check.

Always run Check after the writes, including after every re-setup or sync (update-install, add-group, or check-only). Do not skip Check because only one tree changed, because no trees were copied, or because the human kept existing Team configs. Walk each selected process document end to end. Passing is not only "the links exist": the installed trees, Team configs, run template, routes, and required interactions must let a run start and follow every hop. Use the checklist in [reference.md](reference.md).

Resolve this session's bound Team config with the detection order in [reference.md](reference.md#detect-this-sessions-bound-team-config). Fail and do not report success when that bound config is missing (and this run was supposed to have one), unreadable, missing required keys, or its `workflow` target is missing or unreadable. Fail if **more than one** `teams/*.yaml` matches the same lead id. Do not fail the whole Check solely because another Team's config is absent unless this run was supposed to create it.

When reporting Check to the human on success, summarize: Roles, Team configs, process hops, `runs/_template/`, and project-standards (plus any real failure details when Check failed).

The three `.workflow/project-standards/` template files must exist and be readable after they were installed or replaced this run, and the matching Playbooks must require those paths. If this re-setup did not touch `roles/` or `project-standards/` and Playbooks already require those paths, treat standards as OK.

If a hop cannot be walked, name the process document, the route, and the problem. Fix it when this skill is allowed to (broken Team config, missing workflow target, missing copy). Otherwise stop and tell the human.

Done when every check in [reference.md](reference.md) passes, or each failure was fixed this run or discussed and the human chose what to do.

### 11. Report

This step's name is Report.

Tell the human:

- First install, update-install, add-group, or check-only
- Consumer project root and `.workflow/` path
- Kit source used (skipped on add-group or check-only)
- On update-install: which trees were replaced, which were kept, whether extra consumer-only slugs or process documents were deleted, and whether live run folders were left in place
- On add-group: the naming prefix (for example `T2`), which Role bots were created (when this session creates Role bots), which sidebar section was used or that bots were left unassigned, that trees and other Team yamls were left untouched, and the new Team config path
- On check-only: trees untouched and Team configs not rewritten
- Paths copied
- This session's bound Team config path from detection (or that none was bound); this run's Team config path(s), whether each was **created**, **kept**, or **updated**; other existing `teams/*.yaml` files
- standards Playbooks wired to `.workflow/project-standards/` (or unchanged because neither `roles/` nor `project-standards/` was replaced); reminded human they may add Role rules into those files
- `.gitignore` update
- Init done in this session
- Other-harness follow-up only if that work remains (do not describe the other harness if nothing remains)
- Check result (on pass: Roles, Team configs, process hops, `runs/_template/`, project-standards)
- **Human actions:** list only the items that applied this run (checklist of possible items in [reference.md](reference.md)), each done, declined, or pending. For each pending item, say exactly what the human still needs to do. Do not dump the catalog. Do not list harness-specific items that did not apply this session (for example, Cursor-only or DSH-only items after a Grok session, or Grok-only items after a Cursor or DSH session â€” examples, not the only harnesses), except as other-harness follow-up. Do not list optional items unless they were relevant this run. Do not list a permission grant unless a tool actually blocked. Do not list Grok bot create/auth unless this session was on a Grok all-main-agents path and a person was required, or that work remains as other-harness follow-up.

Do not say setup is complete if any human action that applied this run is pending.

Done when that report has been given, Role process pointers still point at the `workflows/` directory, and either no applied human action is pending or the report states that the run is not complete and lists the pending items.

## Completion criteria

- [ ] Ran as `team-lead` (or this session was initialized as `team-lead`)
- [ ] Consumer project root known; destination is `<project>/.workflow/`
- [ ] First install versus existing install recorded; when existing, intent recorded (Update install, Add Role-bot group, or Check only)
- [ ] On update-install: tree replace versus selective sync recorded; Team-config keep versus change recorded; no silent overwrite of trees or of other Teams' yamls
- [ ] On add-group: no trees were replaced and other Team yamls were not overwritten; a new Team yaml was created; when this session creates Role bots, the new Role-bot group was created only after naming confirmation, shared standing instructions, and create/init plan confirmation (this-session init default no)
- [ ] On check-only: no trees were replaced and Team yamls were not overwritten
- [ ] Kit source found by the detection order (or given by the human); skipped on add-group or check-only
- [ ] On a first install, `.workflow/roles/`, `.workflow/workflows/*.md`, `.workflow/runs/_template/`, and `.workflow/project-standards/` materialized from the kit; on update-install, only accepted trees were copied; on add-group or check-only, no trees were copied
- [ ] Kit `skills/`, `docs/`, and root README not copied into `.workflow/`
- [ ] Live `.workflow/runs/<run-id>/` folders left in place unless the human explicitly asked to remove them
- [ ] Bound-Team detection ran; human chose a process document for this Team, or this session's existing bound Team config was kept and still resolves; no duplicate yaml for the same lead id
- [ ] This Team's `.workflow/teams/<id>.yaml` exists with `id`, `workflow`, `team_lead_id`, and `harness` in that order and a readable `workflow` target; other Team yamls were preserved
- [ ] Role card `workflows/` directory pointers left unchanged
- [ ] Standards Playbooks rewritten to `.workflow/project-standards/` after first install or after `roles/` / `project-standards/` replace; no detection ask
- [ ] Consumer `.gitignore` contains `.workflow/`
- [ ] This session's init matches the selected shape; remaining other-harness init listed
- [ ] Human actions were reminded only at the steps where they apply, and only for this session's harness
- [ ] Report lists only human actions that applied this run as done, declined, or pending
- [ ] Did not claim the run complete while a pending human action that applied this run remained
- [ ] End-to-end check passed for each selected process document after this install, update-install, add-group, or check-only
