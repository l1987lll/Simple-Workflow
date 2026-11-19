# setup-workflow reference

Read when detecting the install and its workflow-owner, choosing an intent, planning a tree sync or a new Team, writing a Team config, running the all-main-agents Role-bot flow, listing human actions, or walking the Check. Vocabulary matches repo-root `GLOSSARY.md`.

## Consumer layout

```text
<project>/
  .workflow/
    roles/               # shared by every Team and harness
    workflows/          # shared; main workflows at the top level, sub-workflows under subflows/
      subflows/
    project-standards/   # shared
    teams/
      <id>.yaml          # one per Team
    runs/
      _template/         # shared template
      <run-id>/          # one folder per run; each run belongs to one Team
    .git/                # the .workflow repository
    .gitignore           # runs/* ignored; runs/_template/ kept
  .gitignore             # if present, contains .workflow/
```

The consumer install directory is `.workflow/` (not a bare `workflow/` folder). The consumer repository ignores `.workflow/`; the tree is versioned by its own repository inside it.

That repository holds definitions only. `.workflow/.gitignore` ignores `runs/*` and keeps `runs/_template/`:

```gitignore
runs/*
!runs/_template/
!runs/_template/**
```

Run data in `runs/<run-id>/` belongs to the Team running that run; it is not a definition change and does not go through the workflow-owner.

One `.workflow/` serves every harness on the project. `roles/`, `workflows/`, and `project-standards/` are shared; each Team has one `teams/<id>.yaml`; runs live side by side and each belongs to one Team. A new harness or bot group joins as a new Team, never as a second tree.

After install, a main process document's `runs/` paths mean the copied tree at `.workflow/runs/`, not a new `runs/` folder at the consumer repo root. Relative links from `.workflow/workflows/*.md` to `../runs/_template/` must resolve. Do not create a consumer-root `runs/`, and do not rewrite those path strings (that rewrite is not a listed Dynamic edit). A sub-workflow sits one level deeper at `.workflow/workflows/subflows/`; it writes run-folder paths as plain code spans, not relative links, and its own `## Sub-flows` path resolves from that sub-workflow.

## Valid kit source

A path is a valid **kit root** when it has:

- `roles/<slug>/ROLE.md` for at least one slug
- at least one main workflow `workflows/*.md` (sub-workflows under `workflows/subflows/` travel with it)

A path is a valid **installed consumer source** when it has:

- `.workflow/roles/<slug>/ROLE.md` for at least one slug
- at least one main workflow `.workflow/workflows/*.md` (sub-workflows under `.workflow/workflows/subflows/` travel with it)

A legacy `workflow/roles/` plus `workflow/workflows/` tree is also a valid installed consumer source.

Prefer a kit root over an installed consumer when both match the same path.

Do not treat this skill directory, `skills/`, or `.agents/skills/` as the kit source.

A directory is the Simple-Workflow **kit itself** (not an install target) when it looks like a kit root and also has kit-only files such as `skills/define-workflow/` or a root README that names Simple-Workflow.

## Valid install target

A path is a valid **install root** for Target when it is **not** the Simple-Workflow kit itself. Prefer and list first:

1. **Current working directory / current workspace root** (preferred default) — show the real path when asking
2. A path the human types or names (single consumer repo, or a **multi-repo parent** — install `.workflow/` directly under that parent as `<parent>/.workflow/`; do **not** require picking a child repo)

Do not present a sibling-repo multiple-choice list as the primary Target ask. The consumer directory name is always `.workflow/` (leading dot), never bare `workflow/`.

Only the kit itself is blocked. If they hit the kit, ask briefly for a different path.

## Kit detection order

Stop at the first valid source.

1. **Already-named path or cwd.** Check the current working directory and any path the human already named this run. Accept it when it is a kit root or an installed consumer source. If that path is also this run's consumer target and is not a kit root, keep looking.
2. **Common path heuristics.** Check each path that exists, in this order:
   - a sibling of the consumer project named `Simple-Workflow`
   - `../Simple-Workflow` relative to the consumer
   - `<consumer-parent>/Simple-Workflow`
   - `~/src/Simple-Workflow`
   - `~/dev/Simple-Workflow`
   - `~/code/Simple-Workflow`
3. **Ask the human** for the source directory.

## Install and Team state

Two separate checks decide the offered intent.

A **shared install** is present when any of these has content:

- `.workflow/roles/` (at least one `*/ROLE.md`)
- `.workflow/workflows/*.md`
- `.workflow/project-standards/` (any of the three standards templates)

The shared install is shared by every harness. One harness installing it makes it present for all of them, so it does not prove this environment was installed.

**This session's Team** is present when a `teams/*.yaml` binds to this session: the exact path in this session's standing instructions, or a file whose `team_lead_id`, `workflow_owner_id`, or `id` equals this session's platform id. A populated `teams/` directory alone does not prove it; those configs may belong to other harnesses. A populated `runs/` directory does not prove it either.

The pair selects the intent:

| Shared install | This session's Team | Intent |
|---|---|---|
| absent | absent | New install |
| present | absent | Add Team; or, when the human names an existing Team, keep that Team and offer Update install or Check only |
| present | present | Update install or Check only |

A populated legacy `workflow/` tree (no leading dot) counts as a shared install. Tell the human the consumer directory is now `.workflow/` and ask before copying, so a second tree is not created beside the old one.

Before asking the intent, report:

- Whether the shared install is present, and which of `roles/`, `workflows/`, `runs/_template/`, and `project-standards/` exist
- Whether this session has a Team, and which `teams/*.yaml` if it does
- Role slugs and process document filenames
- Whether live `.workflow/runs/<run-id>/` folders exist
- Every `.workflow/teams/*.yaml` file (id, workflow, harness, team_lead_id, workflow_owner_id), or that no Team configs exist yet
- The workflow-owner from [Find the workflow-owner](#find-the-workflow-owner), or that none was found
- Whether Playbooks already require `.workflow/project-standards/` paths

## Environment kind

The project supports two environment kinds:

- **Bot environment** — the session has a bot identity and can create or message named bots. A workflow may have several main agents.
- **Chat Session** — one chat session with no named bots. A workflow has exactly one main agent; every other Role is a sub-agent.

Detect the kind from the runtime before Choose workflow. If the runtime does not settle it, ask the human once. Record it for this run.

- A Chat Session may choose only a main workflow whose `## Roles` section names exactly one main agent.
- A Bot environment may choose any main workflow; state the main-agent count when listing choices.
- A Chat Session has no separate `workflow-owner` main agent. `team-lead` is both lead and owner, so write the same id in `team_lead_id` and `workflow_owner_id`.
- A kept Team config whose workflow breaks the Chat Session limit fails Check; ask the human to choose a different workflow.

## Find the workflow-owner

The `workflow-owner` runs setup and holds the `.workflow/` write permission for its Team. When asking the human to choose one, say it is the Role dedicated to maintaining the workflow. Resolve one before any write. In a **Chat Session**, there is no separate `workflow-owner`: `team-lead` is the single main agent and is both lead and owner; use the same id for `team_lead_id` and `workflow_owner_id`.

Order:

1. **Bound Team config.** Read `workflow_owner_id` from this session's bound config. When the field is missing, continue to the next rule.
2. **This session.** When this session's Role, profile, or standing instructions name it `workflow-owner`, it is the owner.
3. **A visible bot or agent.** When a bot or agent for this install is known to play `workflow-owner` (its name, profile, or standing instructions say so), name it and ask the human to confirm it is the owner.
4. **Ask the human** (human action): the current session becomes `workflow-owner`, an existing bot becomes it, or a new one is created.

On a first install, only rule 4 applies outside a Chat Session. In a Chat Session, the single `team-lead` session is the owner and adopts `roles/team-lead/ROLE.md`; there is no `workflow-owner` card to adopt. Outside a Chat Session, designate the owner and adopt the Role from the kit's `roles/workflow-owner/ROLE.md` after Find kit, because the installed card does not exist yet. When the shared install is present, adopt from `.workflow/roles/workflow-owner/ROLE.md` during Detect install and owner. Adopting means the session carries the Role and its maintenance rules—write definitions only, commit every definition change—before setup writes anything. Initialize (step 10) binds the Team config path into the adopted owner; it does not adopt the Role again. When the human wants a new owner bot, create and adopt it when the platform allows, then stop and run setup from it. When the owner is a bot whose platform id is unknown, generate one GUID and say the human must remember it.

Write the resolved id into `workflow_owner_id` of this Team's config at Write team config; Initialize (step 10) then binds that path into the adopted owner's instructions. When the owner is the same session as the lead, write the same id in `team_lead_id` and `workflow_owner_id`, and say so.

When the resolved owner is not this session, stop and tell the human to run setup from that owner. Where this session can message the owner bot, send the request and stop.

When the human declines to name an owner, stop the run.

## Intents

Ask **intent first** and wait for the answer before any tree or Team question.

1. **New install** — no shared install. When the shared install exists, do not offer it. Ask which process document to install once; every Team uses it. Ask how many Teams to create in this environment only when the shape can bring several up: an all-main-agents harness creates one bot group per Team. A sub-agent harness creates one Team, and later Teams come through Add Team. Then run every step: copy all trees, write this Team's config (step 7 on a sub-agent shape; step 10 after its bots exist on an all-main-agents shape), standards, gitignore, bring up the Teams, write each additional Team's config once its bots exist, check, commit, report.
2. **Update install** — the shared install exists and this session has a Team, and the kit's Role cards, process documents, project standards, or Team configs changed. It applies to every Team on this harness; Teams on another harness sync through their own run. Find the kit, ask full versus selective tree replace, copy the accepted trees, keep this Team's config (backfilling a missing owner), rewrite standards references when `roles/` or `project-standards/` was replaced, then have every existing Role instance in those Teams re-read its installed card: this session now, every reachable bot or session by message, and every unreachable one as a pending human action. Do not rewrite other Teams' configs. Check, commit, report.
3. **Add Team** — the shared install exists and this session has no Team: a new harness or another bot group. Skip Find kit, Copy trees, and Standards. Ask which workflow the new Team uses, create a new Team config, initialize the new Team's sessions or bots, check, commit, report. On a **new harness** this session becomes the new Team's owner; on an **extra bot group** this session keeps its own Team and the new group gets a new `workflow-owner` bot. Do not replace trees or overwrite other Teams' yamls.
4. **Check only** — no tree copy, no Team yaml rewrite, no commit unless the human asks. Run Check and Report.

A **Team** is one workflow instance: a bot group on an all-main-agents harness, or a main session plus its sub-agents on a sub-agent harness, or any other harness sharing this `.workflow/`. Several Teams are normal.

## Human actions (report list)

Use with Human actions in `SKILL.md`. This table is a lookup, not a script to read aloud: do not preview later steps, and include a row only if it **applied this run**. Mark those rows done, declined, or pending. Do not claim the run is complete while any included row is pending. Do not list rows that never applied. Do not list the other harness except as Initialize/Report follow-up.

| Action | Remind at | Only when |
|---|---|---|
| Choose intent (New install / Update install / Add Team / Check only) | Intent | Always; the offered set follows the shared-install and Team state |
| Choose the workflow-owner (current session, an existing bot, or a new one) | Detect install and owner | No owner in the bound Team config, this session, or a visible bot |
| Choose install root: **current working directory first (preferred)**, or name another path | Target | Target step, unless an install path was already named this run; always list current working directory first with its real path; if the choice is the kit, ask for a different path. A multi-repo parent is allowed |
| Name the kit source directory | Find kit | Detection did not find a valid source |
| Approve overwrite / update choices | Intent | Intent is Update install |
| Choose which workflow to install (ask: "Which workflow do you want to install?"; after write, say recorded into `.workflow/teams/<id>.yaml` in the `workflow` field) | Choose workflow | New install asks once for every Team; Add Team or Update install asks for that Team when its config or `workflow` target no longer resolves |
| Choose how many Teams a New install creates in this environment, and each Team's prefix and display name | Choose workflow | New install, and the shape can bring several Teams up |
| Confirm or accept a generated `team_lead_id` or `workflow_owner_id` | Write team config / Initialize | The platform id is unavailable, so setup generated a GUID the human must remember |
| Approve deleting consumer-only extras | Update install | A replace would remove Role slugs or process documents the kit lacks |
| Approve removing live `runs/<run-id>/` folders | Intent | Only if someone proposed removing them |
| Confirm Role bot naming rule (or edit proposed names) | Initialize | All-main-agents session that creates Role bots, and at least one Role bot still needs creating (including every Role in a new Team) |
| Have each unreachable Role re-read its installed card and process document | Initialize | Update install, and a Role bot or session on this harness could not be reached this run |
| Confirm shared standing instructions for all Role bots (or decline / none) | Initialize | Creating other Role bots; ask before create |
| Confirm Role bot create/init plan (including initializing this session bot as `workflow-owner`) | Initialize | After naming and shared standing instructions; before any create or this session's profile rewrite. On Add Team, default this-session init to yes for a new harness and no for an extra bot group |
| Confirm sidebar section for a new Team | Initialize | Add Team mode when the platform lists sidebar sections (`ListSections`); ask which existing section to place the new bots in, or leave unassigned |
| Create or authorize Role bots | Initialize | After the create/init plan is confirmed; initialize this session bot as `workflow-owner` when the plan says so; create the other bots with confirmed names and apply shared instructions |
| Grant local machine / workspace permissions | The step that blocked | A specific tool call was refused or blocked. Do not remind in advance |
| Install `setup-workflow` into global skills | Only if relevant this run | The human asked to use the skill outside the kit or asked how to get `/setup-workflow` everywhere. Do not offer unsolicited |
| Other-harness init | Initialize follow-up list and Report only | This session cannot finish that harness's init |
| Run human-only slash commands (for example `/retro`) | Not during setup | A later run needs them; do not mention during setup |

## Role bot naming (all-main-agents)

Used only when this session's selected process document is an **all-main-agents** shape and this session can create Role bots (for example Grok Bot). This session is the `workflow-owner` bot for its Team.

On a New install that creates several Teams, run this flow once per Team with its own prefix. Reuse the shared-instructions answer unless the human changes it, and confirm each Team's create/init plan separately.

### Infer

1. Read this session bot's **display name**.
2. When other Role bots for this install are already visible, test whether their names share a pattern with this bot.
3. Prefer a reusable rule such as:
   - shared **prefix** + Role **title** (Title Case from the Role card name), e.g. `SW Developer`
   - shared **prefix** + Role **slug**, e.g. `SW developer`
   - short **code** + separator + title, e.g. `T1 - Team Lead` → keep the code/separator style for other Roles only when that pattern clearly fits more than one bot
4. If no pattern is clear, propose a simple default: take a prefix from this bot's name (strip a trailing Role title or slug if present) and append each Role's title.

### Confirm (human action)

- Show the proposed **rule** in one line and a **preview name** for every Role that still needs a bot, including `workflow-owner` for **this session bot** and `team-lead` for the lead bot.
- Ask the human to confirm, change the rule, or edit individual names.
- Do **not** create any bot, and do **not** rewrite this session bot's profile, until naming is confirmed, the shared-standing-instructions ask is answered (including none), **and** the create/init plan is confirmed.
- If they change the rule, regenerate the remaining previews from the new rule and confirm again only when the names changed.

### Shared standing instructions (human action)

After naming is confirmed and **before** the create/init plan:

- Ask whether there is anything to tell **every** Role bot in the plan the same way (standing instructions or rules), including this session bot when it will be initialized.
- Give short examples only if helpful: may only access a named directory or repo tree; prefer a chat language; must not use certain tools or sites.
- Accept **none** / decline. Do not invent constraints the human did not state.
- Record the answer for Report (done with text, declined, or pending).

### Create/init plan (human action)

After naming and shared standing instructions, and **before** any create or this session's profile rewrite, show one plan and wait for confirm:

- **This session bot:** initialize as `workflow-owner` from `.workflow/roles/workflow-owner/` (yes/no). If yes, note the confirmed display name (keep current name vs rename).
- **Other Role bots:** list each Role to create or reconfigure with its confirmed name, including `team-lead`.
- **Shared standing instructions:** none, or the text they gave.

Do not create bots and do not rewrite this session bot until they confirm. They may decline this-session init, drop Roles from the list, or edit names again. On Add Team, this-session init defaults to no; see [Add Team](#add-team).

### Create

- Only after the create/init plan is confirmed.
- If the plan includes this session bot: initialize it as `workflow-owner` from the installed Role card (description / standing-instruction fields the platform supports; rename only when the plan says so).
- Create or configure the other bots in the plan with the confirmed names and installed Role cards.
- Apply any shared standing instructions to each bot in the plan (including this session bot when initialized). Role-specific craft still comes from the Role card; shared instructions do not replace the card.
- Do not ask the human to paste each card.
- Remind them to authorize a bot only when the platform still requires a person after create.
- Do not start those bots on product work during setup.
- On Update install: do not rename existing bots or rewrite their standing instructions unless the human asks or the confirmed plan says so; for new Roles only, reuse the last confirmed naming rule when available or re-infer, re-ask (or reuse) shared standing instructions, confirm the create/init plan, then create. A full new Team uses the Add Team path, not this new-Roles-only rule.

## Add Team

Used when Intent is **Add Team**. A new harness or an extra bot group joins the same `.workflow/` with its own Team config.

Two cases. A **new harness** has no Team yet, so this session becomes the new Team's `workflow-owner`; adopt the Role, and on an all-main-agents shape create the other bots for this Team. An **extra bot group on the same harness** belongs to a session that already owns a Team, so that session keeps its Team and the new group gets its own `workflow-owner` bot.

Read the shared `workflows/*.md` list and the kit's or current install's Role cards. The new Team uses the shared trees; nothing is copied.

1. Infer the **next** group naming rule from already-visible Role bots for this install. If bots use a `Tn` code (for example `T1 - Team Lead`), propose the next code after the highest `Tn` seen. If the pattern is unclear, propose that next `Tn` or ask.
2. Preview a name for **every Role** the process document names, for the **new** Team only, including a new `workflow-owner` and a new `team-lead`. Do not preview renaming or rewriting bots that already belong to an existing Team unless the human asks.
3. Confirm the naming rule (human action).
4. Ask shared standing instructions for bots in **this new Team** (or none). Do not invent constraints.
5. Show the create/init plan (human action) before any create:
   - **This session bot:** on a new harness, initialize it as the new Team's `workflow-owner` (default yes). On an extra bot group, default **no** — keeps this session as its own Team's owner, and the new Team gets its own `workflow-owner` bot.
   - **New Role bots:** each Role in the new Team with confirmed names and installed Role cards.
   - **Sidebar section:** if the platform can list sidebar sections (`ListSections`), ask which existing section to place the new bots in, or leave them unassigned. There is no CreateSection tool; only `CreateAgent` with a `section_id` returned by ListSections.
   - Shared standing instructions as confirmed.
6. Create only after the plan is confirmed. Do not rename or rewrite existing bots unless the plan says so. Remind the human to authorize a bot only when the platform still requires a person after create. Do not start those bots on product work during setup.
7. After the new Team's bots exist, write its config with the created owner and lead ids (Write team config).

On a sub-agent harness, run Add Team from that new Team's session; that session is the Team's workflow-owner, and its ids go into the config. Do not create bots.

## Detect this session's bound Team config

Use this order whenever setup must know whether **this session** already has a Team config and **which** `.workflow/teams/<id>.yaml` it is — and therefore whether to **update** that Team or **create** a new yaml. Run it in Detect install and owner, Choose workflow, Write team config, Check, and Report.

1. **Standing instructions / profile / session notes.** If this session already names an exact path `.workflow/teams/<id>.yaml` (or an absolute path to that file), that path is the bound config. Verify the file exists and parses; if the path is named but missing/unreadable, say so (do not silently fall through to another Team's file).
2. **Match by lead or owner id.** Else scan `.workflow/teams/*.yaml`. Prefer a file whose `team_lead_id` or `workflow_owner_id` equals this session's platform agent id (Grok) or session id (Cursor). If none, accept a file whose `id` equals that same platform id. The filename stem should match `id`.
3. **None bound.** Else this session has **no** bound config → New install **create** a new yaml, or Add Team **create** one for the new Team. Do **not** guess or reuse another Team's file.

**Ambiguity:** If more than one `teams/*.yaml` matches the same lead id (`team_lead_id` or `id`), **fail Check / stop** and tell the human. Do not pick silently. Two Teams matching through `workflow_owner_id` alone is normal when one owner serves several Teams; report it and use the Team whose lead matches this session. When no lead matches and one owner serves several Teams, ask the human which Team this session belongs to, then use that Team.

**Create vs update:**

| Situation | Action |
|---|---|
| Bound config found; Update install keep/change | **Update** that path (or keep it). Never create a duplicate for the same lead id. |
| Bound config found; Check only | Use that path for Check; do not rewrite yaml. |
| No bound config; New install | On a sub-agent shape **create** `.workflow/teams/<id>.yaml` now with `id`/`team_lead_id` = platform id or GUID and `workflow_owner_id` = resolved owner. On an all-main-agents shape step 10 creates it after the lead bot exists. |
| Add Team | **Create** a new yaml for the new Team. On an extra bot group, this session keeps its own config; on a new harness, this session owns the new Team. Do not overwrite another Team's yaml. |

Say the detected path (or that none was found) in Detect install and owner, Choose workflow (when keeping), Write team config, and Report.

## Team config format

Each Team has one config file at `.workflow/teams/<id>.yaml`. The filename stem MUST equal the yaml `id` field. `id` is the unique Team identifier: prefer the platform team-lead id when known; otherwise a GUID. Do not use short codes `t1`, `t2`, … (example: `216ab690-efa9-4760-9938-e54be49013bd.yaml` with `id: 216ab690-efa9-4760-9938-e54be49013bd`).

Required keys, in this order:

1. `id` — unique Team id (platform team-lead id or GUID); must match the filename stem; typically the same value as `team_lead_id`
2. `workflow` — one path relative to `.workflow/workflows/` naming a main workflow at the top level of that directory; never a file under `subflows/`
3. `team_lead_id` — unique lead identifier. On an all-main-agents shape it is the created lead bot's id. On a sub-agent shape the lead is a separate session this run cannot read, so it is a generated GUID written into the lead session's instructions. A real platform id (Grok agent id or Cursor session id) replaces the GUID once known.
4. `workflow_owner_id` — the workflow-owner's platform agent or session id for this Team; the same value as `team_lead_id` when one session holds both; a GUID when the platform id is unknown, remembered by the human
5. `harness` — lowercase product slug for this Team (for example `grok`, `cursor`, or `deepseek` — examples only, not an exhaustive allowlist). If the slug is unknown, ask the human once.

Example:

```yaml
id: 216ab690-efa9-4760-9938-e54be49013bd
workflow: all-main-agents.md
team_lead_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
workflow_owner_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
harness: grok
```

No other top-level keys in v1.1; later settings may be added without renaming the file. Do not add a `teams/index.yaml`.

A config written before `workflow_owner_id` existed has four keys. On Update install, resolve the owner and add the field to that Team's file. Check fails a config that still lacks it, with the fix being to record the owner.

Every Team has a session or bot group behind it, and its config is written after those sessions or bots exist so its ids are real. A New install creates only the Teams it brings up now; a later Team goes through Add Team.

Runtime rule: every agent in the Team reads its bound config path (for example `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`), then reads the `workflow` target. Missing the path, the file, a required key, or the target main workflow means stop. The hard bind is that exact path in lead, owner, and member standing instructions (Initialize); spawn briefs must carry the same path. Do not fail solely because another Team's config is absent unless this run was supposed to create it.

Role cards continue to point at the `workflows/` directory. Setup does not rewrite those pointers to a Team config path.

Team config is the only current-workflow pointer.

## standards apply

The kit ships templates under `project-standards/`. Setup copies them to `.workflow/project-standards/` once for every Team:

- `.workflow/project-standards/CODING_STANDARDS.md`
- `.workflow/project-standards/COMMIT_RULES.md`
- `.workflow/project-standards/REVIEW_RULES.md`

Those three paths are the only standards paths setup writes into Playbooks. Do **not** search the consumer tree for alternate standards files, and do **not** ask the human to confirm, decline, or name alternates. During Standards, remind the human they may edit the copied files under `.workflow/project-standards/` to add project-specific rules Roles must follow; do not invent those rules for them.

After Copy trees on a New install, and after any update that replaced `roles/` or `project-standards/`, rewrite every copied Role that mentions these files (`developer` for coding standards and commit rules; `code-reviewer` for all three; any other Role that names them) so the Playbook **must read** the matching path above. Replace search-order Notes with those paths. Keep a When-stuck raise if a required file later cannot be read.

Do not invent template contents beyond the shipped files. Replacing the `project-standards/` tree is only a Copy trees / Update install tree choice.

## End-to-end check

Walk this session's selected main workflow (from its bound Team config `workflow`) and every sub-workflow it reaches. Also walk any other main workflow already named by an existing `teams/*.yaml` you are reporting; walk a file once if more than one config names it.

Start at `team-lead` intake and follow every Flow step and every Routes table row (handoffs and When stuck) until close-out.

1. **Roles.** Every slug the document names exists as `.workflow/roles/<slug>/ROLE.md`. A Role-Playbook card also has `PLAYBOOK.md`.
2. **Team configs.** Every expected Team config under `.workflow/teams/` exists, parses as YAML, and has `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness` in that order (`id` matches the filename stem). Each `workflow` target is a main workflow at the top level of `.workflow/workflows/`, exists, and is readable; a target under `subflows/` fails. The workflow's `## Roles` section must fit this session's environment kind: a Chat Session has exactly one main agent; a Bot environment may have several. In a Chat Session, `team_lead_id` and `workflow_owner_id` name the same single main session. Resolve this session's bound config with [Detect this session's bound Team config](#detect-this-sessions-bound-team-config); that config must be present and valid — failure of that config fails the check. Fail if more than one `teams/*.yaml` matches the same lead id. Bound lead and owner instructions, when this session can see them, must cite the matching config path.
3. **Shared trees.** `roles/`, `workflows/`, and `project-standards/` exist once. No second copy of them sits beside `.workflow/` for another harness.
4. **Document shape.** Each main workflow has a Shape line naming the environment kind and its main agents, Targets, Support, Roles, Sub-flows, Flow, Routes (handoff and When-stuck tables for each listed Role, except a handoff owned by a referenced sub-workflow), Run state and artifacts, and Caveats. Each referenced sub-workflow has Entry, Roles, Sub-flows, Flow, Routes, Exit, Interactions used, and Artifacts, and carries no pairs, support, conditions, run state, or caveats.
5. **Hops.** Each route's Next is a listed slug or `human`. The interaction is one the document's Support table names. A spawn hop fits a shape where a lead starts sub-agents. A message hop between main agents fits an all-main-agents shape when `main-peers` is supported; where it is unsupported, the route uses relay. An unsupported or uncertain interaction is acceptable only as a caveat already recorded in the document. Walk every route in each referenced sub-workflow, and in each sub-workflow it nests, as if inserted at the invocation point in the main workflow's Flow. Every `## Sub-flows` path in a main workflow or sub-workflow resolves under `.workflow/workflows/subflows/`; every sub-workflow is reachable from a main workflow; the reference graph has no cycles.
6. **Gates and relay.** Every `gate` or `relay` hop reaches the human through a main agent the human opened — the lead, or another main Role the document names. Human-only slash commands are reminded by the main agent that talks to the human. `/retro` follows the document: where `slash /retro` is supported and the document allows it, members run it after a human gate; elsewhere the human runs it and a recorded caveat is acceptable.
7. **Artifacts and run template.** `.workflow/runs/_template/STATUS.md` and `.workflow/runs/_template/brief.md` exist. Relative links from the process document to `../runs/_template/` resolve to that folder. The document states the STATUS path, the single writer (the lead), per-instance rows, artifact layout, and disjoint path ownership when `parallel` is used. A live run folder is created under `.workflow/runs/<run-id>/`.
8. **Coding / commit / review standards.** `.workflow/project-standards/` has the three template files (when that tree was installed or replaced this run, or already present and Playbooks already require them), each readable, and the matching Playbooks require those paths.
9. **Static pointers.** Role cards still link to the `workflows/` directory, not to a Team config file.
10. **Consumer hygiene.** `.gitignore` (when the consumer has one) lists `.workflow/`. `.workflow/` does not contain copied kit `skills/`, `docs/`, or root README. `.workflow/.git` may exist as the tree's own repository, and `.workflow/.gitignore` ignores `runs/*` while keeping `runs/_template/`. When `project-standards/` was installed this run or kept from an earlier install, `.workflow/project-standards/` holds the three template filenames.
11. **Intent.** Check always runs after an Update install, Add Team, or Check only, even when the human kept Team configs or no trees were copied. On Update install, only trees the human accepted were replaced, other Teams' yamls were not silently overwritten, and every existing Role instance in this harness's Teams re-read the installed definitions or is listed as pending. On Add Team, no trees were replaced, other Team yamls were kept, and a new Team yaml was created. On Check only, no trees were replaced and Team yamls were not rewritten. Live `runs/<run-id>/` folders remain unless the human asked to remove them.

A check that only verifies "the path string exists" without walking hops is incomplete.

On success, report what was checked: Roles, Team configs, process hops, `runs/_template/`, and the project-standards paths.
