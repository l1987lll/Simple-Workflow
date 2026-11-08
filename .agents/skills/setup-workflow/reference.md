# setup-workflow reference

Read when detecting the kit source, planning a re-setup or adding a Role-bot group, listing human actions, or walking the Check. Vocabulary matches repo-root `GLOSSARY.md`.

## Consumer layout

```text
<project>/
  .workflow/
    roles/
    workflows/          # process documents only
    teams/              # one <id>.yaml per Team
    runs/_template/
    project-standards/  # CODING_STANDARDS.md, COMMIT_RULES.md, REVIEW_RULES.md
  .gitignore            # if present, contains .workflow/; do not create if missing
```

The consumer install directory is `.workflow/` (not a bare `workflow/` folder). The consumer `.workflow/` tree is not committed.

After install, a process document's `runs/` paths mean the copied tree at `.workflow/runs/`, not a new `runs/` folder at the consumer repo root. Relative links from `.workflow/workflows/*.md` to `../runs/_template/` must resolve. Do not create consumer-root `runs/`, and do not rewrite those path strings (that rewrite is not a listed Dynamic edit).

## Valid kit source

A path is a valid **kit root** when it has:

- `roles/<slug>/ROLE.md` for at least one slug
- at least one `workflows/*.md` process document

A path is a valid **installed consumer source** when it has:

- `.workflow/roles/<slug>/ROLE.md` for at least one slug
- at least one `.workflow/workflows/*.md` process document

A legacy `workflow/roles/` plus `workflow/workflows/` tree is also a valid installed consumer source.

Prefer a kit root over an installed consumer when both match the same path.

Do not treat this skill directory, `skills/`, or `.agents/skills/` as the kit source.

A directory is the Simple-Workflow **kit itself** (not an install target) when it looks like a kit root and also has kit-only files such as `skills/define-workflow/` or a root README that names Simple-Workflow.

## Valid install target

A path is a valid **install root** for Target when it is **not** the Simple-Workflow kit itself. Prefer and list first:

1. **Current working directory / current workspace root** (preferred default) — show the real path when asking
2. A path the human types or names (single consumer repo, or a **multi-repo parent** such as `D:\DevelopmentGit` — install `.workflow/` directly under that parent as `D:\DevelopmentGit\.workflow/`; do **not** require picking a child repo)

Do not present a sibling-repo multiple-choice list as the primary Target ask. The consumer directory name is always `.workflow/` (leading dot), never bare `workflow/`.

Only the kit itself is blocked. If they hit the kit, ask briefly for a different path. Do not scold.

## Kit detection order

Stop at the first valid source.

1. **Already-named path or cwd.** Check the current working directory and any path the human already named this run. Accept it when it is a kit root or an installed consumer source. If that path is also this run's consumer target and is not a kit root, keep looking.
2. **Common path heuristics.** Check each path that exists, in this order:
   - a sibling of the consumer project named `Simple-Workflow`
   - `../Simple-Workflow` relative to the consumer
   - `<consumer-parent>/Simple-Workflow`
   - `~/DevelopmentGit/Simple-Workflow`
   - `~/src/Simple-Workflow`
   - `~/dev/Simple-Workflow`
   - `~/code/Simple-Workflow`
   - `D:\DevelopmentGit\Simple-Workflow` when that path exists on Windows
3. **Ask the human** for the source directory.

## Existing install and re-setup

An **existing install** is present when any of these already has content:

- `.workflow/roles/` (at least one `*/ROLE.md`)
- `.workflow/workflows/*.md`
- `.workflow/runs/` (`_template` or any run folder)
- `.workflow/project-standards/` (any of the three standards templates)

Also treat the run as re-setup when the human asked to re-setup, sync, add a Role-bot group, or reinstall after kit Role or process-document changes, even if detection is partial. A populated legacy `workflow/` tree (no leading dot) also counts as an existing install. Tell the human the consumer directory is now `.workflow/` and ask before copying, so a second tree is not created beside the old one. Do not use bare `workflow/` as the new install directory. An empty or missing `.workflow/` (and no populated legacy `workflow/` tree) with no such ask is a first install; skip the Re-setup questions.

A **Role-bot group** is one set of Role bots for the same consumer `.workflow/` install, distinguished by a naming prefix (for example `T1` or `T2`). A Role-bot group is one kind of Team, typically on an all-main-agents harness. Groups share the same Role cards, process documents, and standards; each group has its own bots, its own Team config, and may use its own sidebar section. See repo-root `GLOSSARY.md`.

Before asking, report:

- Which of `roles/`, `workflows/`, and `runs/_template/` exist
- Role slugs and process document filenames
- Whether live `.workflow/runs/<run-id>/` folders exist (do not treat them as templates)
- Every `.workflow/teams/*.yaml` file (id, workflow, harness, team_lead_id), or that no Team configs exist yet
- This session's **bound** Team config from [Detect this session's bound Team config](#detect-this-sessions-bound-team-config) (exact path, or none → create); if multiple yaml match the same lead id, stop
- whether Playbooks already require `.workflow/project-standards/` paths
- Any already-visible Role bots or Role-bot group prefixes for this install, when that is knowable

Then ask **intent first** (human action). Never assume; never silently overwrite trees. **Add Role-bot group** must not replace trees or overwrite other Teams' yaml files.

1. **Update install** — classic re-setup: full or selective tree replace and/or change a named Team's `workflow` or metadata.
2. **Add Role-bot group** — keep the existing `.workflow/` trees and other Team yamls unchanged; create another Team (a new `teams/<id>.yaml`). On an all-main-agents session that can create Role bots (for example Grok), also create another Role-bot group. On a one-main-with-sub-agents session (for example Cursor), still create the new Team yaml and bind this chat as lead; do not pre-create Role bots.
3. **Check only** — no tree copy; do not rewrite Team yamls; skip toward Check (run Initialize only if the human explicitly asks to re-init).

If intent is **Add Role-bot group**: record mode `add-group`; trees to copy = none; do not overwrite existing Team yamls; a new Team yaml will be written at Write team config. Do **not** ask the tree-replace questions. Skip Find kit, Copy trees, and Standards rewrite. Still run Choose workflows (for the new Team) and Write team config. Still run Gitignore if `.gitignore` exists and lacks `.workflow/`. Proceed to Initialize in add-group mode, then always Check, then Report.

If intent is **Update install**: ask the tree and Team-config questions below (always ask; never assume; never silent overwrite):

1. Full replace of `roles/`, `workflows/` process documents, `runs/_template/`, and `project-standards/`, versus a selective sync. If selective, which of those trees. "None" is allowed when the human only wants to change a Team config or re-check.
2. Prefer this session's **bound** Team config from detection. Keep that config, or change its `workflow` or metadata. Name another Team only when the human clearly means that Team. When a bound config exists, treat keep/change as **update** that file — never create a duplicate for the same lead id. Do not overwrite other Teams' yaml files.

If intent is **Check only**: record trees to copy = none; do not rewrite Team yamls. Skip Find kit, Copy trees, Choose workflows, and Write team config. Still run Gitignore if `.gitignore` exists and lacks `.workflow/`. Skip Initialize unless the human explicitly asks to re-init. Always run Check, then Report.

**Replacing a tree** updates it from the kit (overwrite matching files and add new kit files). If the consumer has Role slugs or extra process documents the kit does not have, say so and ask whether to delete those extras. Do not delete extras silently.

**Keeping Team configs:** do not overwrite existing `.workflow/teams/*.yaml` files when copying trees. `teams/` is not a kit tree to replace. If a kept Team config then names a process document that no longer exists, Check fails; tell the human they need to re-choose that Team's `workflow`.

## Human actions (report list)

Use with Human actions in `SKILL.md`. This table is a lookup, not a script to read aloud. In Report, include a row only if it **applied this run**. Mark those rows done, declined, or pending. Do not claim the run is complete while any included row is pending. Do not list rows that never applied. Do not list the other harness except as Initialize/Report follow-up.

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
| Confirm Role bot naming rule (or edit proposed names) | Initialize | All-main-agents session that creates Role bots, and at least one Role bot still needs creating (including every Role in a new Role-bot group on add-group) |
| Confirm shared standing instructions for all Role bots (or decline / none) | Initialize | Creating other Role bots (including a new Role-bot group); ask before create |
| Confirm Role bot create/init plan (including whether to initialize this session bot as `team-lead`) | Initialize | After naming and shared standing instructions; before any create or this-session profile rewrite. On add-group, default this-session init to no (create a new team-lead bot instead) |
| Confirm sidebar section for new Role-bot group | Initialize | Add-group mode when the platform lists sidebar sections (`ListSections`); ask which existing section to place the new bots in, or leave unassigned |
| Create or authorize Grok Role bots | Initialize | After the create/init plan is confirmed; init this session bot when the plan says so; create other bots with confirmed names and apply shared instructions. Remind only when the platform still requires a person to authorize |
| Grant local machine / workspace permissions | The step that blocked | A specific tool call was refused or blocked. Do not remind in advance |
| Install `setup-workflow` into global skills | Only if relevant this run | The human asked to use the skill outside the kit or asked how to get `/setup-workflow` everywhere. Do not offer unsolicited |
| Other-harness init | Initialize follow-up list and Report only | This session cannot finish that harness's init |
| Run human-only slash commands (for example `/retro`) | Not during setup | A later run needs them; do not mention during setup |

## Role bot naming (all-main-agents)

Used only when this session's selected process document is an **all-main-agents** shape and this session can create Role bots (for example Grok Bot). Skip entirely for one-main-with-sub-agents shapes.

### Infer

1. Read this session bot's **display name**.
2. When other Role bots for this install are already visible, test whether their names share a pattern with this bot.
3. Prefer a reusable rule such as:
   - shared **prefix** + Role **title** (Title Case from the Role card name), e.g. `SW Developer`
   - shared **prefix** + Role **slug**, e.g. `SW developer`
   - short **code** + separator + title, e.g. `T1 - Team Lead` → keep the code/separator style for other Roles only when that pattern clearly fits more than one bot
4. If no pattern is clear, propose a simple default: take a prefix from this bot's name (strip a trailing Role title or slug if present) and append each Role's title.

### Confirm (human action)

- Show the proposed **rule** in one line and a **preview name** for every participating Role, including `team-lead` for **this session bot** and every other Role that still needs a bot.
- Ask the human to confirm, change the rule, or edit individual names.
- Do **not** create any bot, and do **not** rewrite this session bot's profile, until naming is confirmed, the shared-standing-instructions ask is answered (including none), **and** the create/init plan below is confirmed.
- If they change the rule, regenerate the remaining previews from the new rule and confirm again only when the names changed.

### Shared standing instructions (human action)

After naming is confirmed and **before** the create/init plan:

- Ask whether there is anything to tell **every** Role bot in the plan the same way (standing instructions or rules), including this session bot when it will be initialized.
- Give short examples only if helpful: may only access a named directory or repo tree; prefer a chat language; must not use certain tools or sites.
- Accept **none** / decline. Do not invent constraints the human did not state.
- Record the answer for Report (done with text, declined, or pending).

### Create/init plan (human action)

After naming and shared standing instructions, and **before** any create or this-session profile rewrite, show one plan and wait for confirm:

- **This session bot:** initialize as `team-lead` from `.workflow/roles/team-lead/` (yes/no). If yes, note the confirmed display name (keep current name vs rename).
- **Other Role bots:** list each Role to create or reconfigure with its confirmed name.
- **Shared standing instructions:** none, or the text they gave.

Do not create bots and do not rewrite this session bot until they confirm. They may decline this-session init, drop Roles from the list, or edit names again. On add-group, this-session init defaults to no; see Add Role-bot group.

### Create

- Only after the create/init plan is confirmed.
- If the plan includes this session bot: initialize it as `team-lead` from the installed Role card (description / standing-instruction fields the platform supports; rename only when the plan says so).
- Create or configure the other bots in the plan with the confirmed names and installed Role cards.
- Apply any shared standing instructions to each bot in the plan (including this session bot when initialized). Role-specific craft still comes from the Role card; shared instructions do not replace the card.
- Do not ask the human to paste each card.
- Remind them to authorize a bot only when the platform still requires a person after create.
- On update-install: do not rename existing bots or rewrite their standing instructions unless the human asks or the confirmed plan says so; for new Roles only, reuse the last confirmed naming rule when available or re-infer, re-ask (or reuse) shared standing instructions, confirm the create/init plan, then create. A full extra group uses the Add Role-bot group path, not this new-Roles-only rule.

### Add Role-bot group

A **Role-bot group** is one set of Role bots for the same consumer `.workflow/` install, distinguished by a naming prefix (for example `T1` or `T2`). A Role-bot group is one kind of Team, typically on an all-main-agents harness. Groups share the same Role cards, process documents, and standards; each group has its own bots, its own Team config, and may use its own sidebar section. See repo-root `GLOSSARY.md`.

Used when Re-setup intent is **add-group**. On an all-main-agents session that can create Role bots (for example Grok Bot), also create the Role bots for the new group. On a one-main-with-sub-agents session, create the new Team yaml and bind this chat as lead; skip Role-bot create steps.

Read the new Team config written this run (or this session's bound Team config) to know the process document and its Roles. If that config is missing or its `workflow` target is unreadable, say so and ask the human to name the process document or go back to Choose workflows; do not invent one.

1. Infer the **next** group naming rule from already-visible Role bots for this install. If bots use a `Tn` code (for example `T1 - Team Lead`, `T1 - Developer`), propose the next code after the highest `Tn` seen (`T2 - <Role title>`). If the pattern is unclear, propose that next `Tn` or ask.
2. Preview a name for **every Role** named in the process document, for the **new** group only, including a **new** `team-lead` bot. Do not preview renaming or rewriting bots that already belong to an existing group unless the human asks.
3. Confirm the naming rule (human action).
4. Ask shared standing instructions for bots in **this new group** (or none). Do not invent constraints.
5. Show the create/init plan (human action) before any create:
   - **This session bot:** default **no** — do not re-initialize this session as `team-lead` for the new group; create a new `team-lead` bot instead. Include this-session init or rename only when the human explicitly wants that in the plan.
   - **New Role bots:** each Role in the new group with confirmed names and installed Role cards.
   - **Sidebar section:** if the platform can list sidebar sections (`ListSections`), ask which existing section to place the new bots in, or leave them unassigned. Prefer proposing an existing matching section (for example a section named Team 2 when the prefix is `T2`). There is no CreateSection tool; only `CreateAgent` with a `section_id` returned by ListSections.
   - Shared standing instructions as confirmed.
6. Create only after the plan is confirmed. Do not rename or rewrite existing bots unless the plan says so. Apply shared standing instructions to the new group's bots. Remind the human to authorize a bot only when the platform still requires a person after create.
7. An Update-install re-setup that also creates new Roles still follows the "new Roles only" rule in Create above. Add-group is the dedicated path for a full extra group.

## Detect this session's bound Team config

Use this order whenever setup must know whether **this session** already has a Team config and **which** `.workflow/teams/<id>.yaml` it is — and therefore whether to **update** that Team or **create** a new yaml. Run it in Re-setup Report, Choose workflows, Write team config, Check only, Update install, and Check.

1. **Standing instructions / profile / session notes.** If this session already names an exact path `.workflow/teams/<id>.yaml` (or an absolute path to that file), that path is the bound config. Verify the file exists and parses; if the path is named but missing/unreadable, say so (do not silently fall through to another Team's file).
2. **Match by lead id.** Else scan `.workflow/teams/*.yaml`. Prefer a file whose `team_lead_id` equals this session's platform agent id (Grok) or session id (Cursor). If none, accept a file whose `id` equals that same platform id. The filename stem should match `id`.
3. **None bound.** Else this session has **no** bound config → first-install write or add-group **create** a new yaml. Do **not** guess or reuse another Team's file.

**Ambiguity:** If more than one `teams/*.yaml` matches the same lead id (`team_lead_id` or `id`), **fail Check / stop** and tell the human. Do not pick silently.

**Create vs update:**

| Situation | Action |
|---|---|
| Bound config found; Update install keep/change | **Update** that path (or keep it). Never create a duplicate for the same lead id. |
| Bound config found; Check only | Use that path for Check; do not rewrite yaml. |
| No bound config; first install | **Create** `.workflow/teams/<id>.yaml` with `id`/`team_lead_id` = platform lead id or new GUID. |
| Add Role-bot group | This session usually **keeps** its own bound config. **Create** a new yaml for the **new** Team / new lead. Do not overwrite this session's yaml unless the confirmed plan says so. |

Say the detected path (or that none was found) in Re-setup Report, Choose workflows (when keeping), Write team config, and Report.

## Team config format

Each Team has one config file at `.workflow/teams/<id>.yaml`. The filename stem MUST equal the yaml `id` field. `id` is the unique Team identifier: prefer the platform team-lead id when known; otherwise a GUID. Do not use short codes `t1`, `t2`, … (example: `216ab690-efa9-4760-9938-e54be49013bd.yaml` with `id: 216ab690-efa9-4760-9938-e54be49013bd`).

Required keys, in this order:

1. `id` — unique Team id (platform team-lead id or GUID); must match the filename stem; typically the same value as `team_lead_id`
2. `workflow` — one path relative to `.workflow/workflows/` naming a process document in that directory
3. `team_lead_id` — unique lead identifier: the platform agent id (for example Grok) or session id (for example Cursor) when known; otherwise a GUID generated at create time that the lead must remember (written into standing instructions or session notes)
4. `harness` — lowercase product slug for this Team (for example `grok`, `cursor`, or `deepseek` — examples only, not an exhaustive allowlist). If the slug is unknown, ask the human once.

Example:

```yaml
id: 216ab690-efa9-4760-9938-e54be49013bd
workflow: all-main-agents.md
team_lead_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
harness: grok
```

No other top-level keys in v1; later settings may be added without renaming the file. Do not add a `teams/index.yaml`.

Runtime rule: every agent in the Team reads its bound config path (for example `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`), then reads the `workflow` target. Missing the path, the file, a required key, or the target process document means stop. The hard bind is that exact path in lead and member standing instructions (Initialize); spawn briefs for one-main-with-subagents must carry the same path. Do not fail solely because another Team's config is absent unless this run was supposed to create it.

Role cards continue to point at the `workflows/` directory. Setup does not rewrite those pointers to a Team config path.

Team config is the only current-workflow pointer.

## standards apply

The kit ships templates under `project-standards/`. Setup copies them to:

- `.workflow/project-standards/CODING_STANDARDS.md`
- `.workflow/project-standards/COMMIT_RULES.md`
- `.workflow/project-standards/REVIEW_RULES.md`

Those three paths are the only standards paths setup writes into Playbooks. Do **not** search the consumer tree for alternate standards files, and do **not** ask the human to confirm, decline, or name alternates. During Standards, remind the human they may edit the copied files under `.workflow/project-standards/` to add project-specific rules Roles must follow; do not invent those rules for them.

After Copy trees on a first install, and after any re-setup that replaced `roles/` or `project-standards/`, rewrite every copied Role that mentions these files (`developer` for coding standards and commit rules; `code-reviewer` for all three; any other Role that names them) so the Playbook **must read** the matching path above. Replace search-order Notes with those paths. Keep a When-stuck raise if a required file later cannot be read.

Do not invent template contents beyond the shipped files. Replacing the `project-standards/` tree is only a Copy trees / Re-setup tree choice.


## End-to-end check

Walk this session's selected process document (from its bound Team config `workflow`). Also walk any other process document already named by an existing `teams/*.yaml` you are reporting; walk a file once if more than one config names it.

Start at `team-lead` intake and follow every Flow step and every Routes table row (handoffs and When stuck) until close-out.

1. **Roles.** Every slug the document names exists as `.workflow/roles/<slug>/ROLE.md`. A Role-Playbook card also has `PLAYBOOK.md`.
2. **Team configs.** Every expected Team config under `.workflow/teams/` exists, parses as YAML, and has `id`, `workflow`, `team_lead_id`, and `harness` in that order (`id` matches the filename stem). Each `workflow` target exists and is readable under `.workflow/workflows/`. Resolve this session's bound config with [Detect this session's bound Team config](#detect-this-sessions-bound-team-config); that config must be present and valid — failure of that config fails the check. Fail if more than one `teams/*.yaml` matches the same lead id. Do not fail solely because another Team's config is absent unless this run was supposed to create it. Bound lead instructions, when this session can see them, must cite the matching config path.
3. **Document shape.** The process document has Targets, Support, Roles, Flow, Routes (handoff and When-stuck tables for each participating Role), Run state and artifacts, and Caveats.
4. **Hops.** Each route's Next is an existing slug or `human`. The interaction is one the document's Support table names. A spawn hop fits a one-main-with-sub-agents shape (usually `team-lead` spawning). A message hop between main agents fits an all-main-agents shape when `main-peers` is supported. An unsupported or uncertain interaction is acceptable only as a caveat already recorded in the document.
5. **Gates and relay.** Every `gate` or `relay` hop has a human path through `team-lead` (the human talks with the main `team-lead` session). Human-only slash commands (including `/retro`) are routed by reminding the human via `team-lead`, not by a Role agent invoking them.
6. **Artifacts and run template.** `.workflow/runs/_template/STATUS.md` and `.workflow/runs/_template/brief.md` exist. Relative links from the process document to `../runs/_template/` resolve to that folder. The document states the STATUS path, the single writer (`team-lead`), per-instance rows, artifact layout, and disjoint path ownership when `parallel` is used. A live run folder is created under `.workflow/runs/<run-id>/`.
7. **Coding / commit / review standards.** `.workflow/project-standards/` has the three template files (when that tree was installed or replaced this run, or already present and Playbooks already require them), each readable, and the matching Playbooks require those paths.
8. **Static pointers.** Role cards still link to the `workflows/` directory, not to a Team config file.
9. **Consumer hygiene.** If `.gitignore` already exists, it contains `.workflow/` (append if missing; do not create `.gitignore`). `.workflow/` does not contain copied kit `skills/`, `docs/`, or root README. When `project-standards/` was installed this run or kept from an earlier install, `.workflow/project-standards/` holds the three template filenames.
10. **Re-setup.** Check always runs after a sync, add-group, or check-only, even when the human kept Team configs or no trees were copied. On update-install, only trees the human accepted were replaced and other Teams' yamls were not silently overwritten. On add-group, no trees were replaced, other Team yamls were kept, and a new Team yaml was created if this run was supposed to create one. On check-only, no trees were replaced and Team yamls were not rewritten. Live `runs/<run-id>/` folders remain unless the human asked to remove them.

A check that only verifies "the path string exists" without walking hops is incomplete.
