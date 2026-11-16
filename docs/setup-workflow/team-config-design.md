# Team config files

**Status:** approved for implementation planning  
**Date:** 2026-11-08  
**Repo:** Simple-Workflow  
**Related:** setup-workflow, Role-bot group / agent team, OI-001

## Goal

One **Team** config file per workflow instance (agent team). New teams get a new file. Agents know which config they use via a written path plus `team_lead_id`. The file is extensible for later settings.

> Historical note: an earlier harness-scoped pointer model under `workflows/` was replaced by Team config; that older model is out of scope for setup.

## Vocabulary

- **Team (workflow instance):** One agent team executing a process document. Examples: a Grok Role-bot group (`T1`, `T2`), or a Cursor lead chat plus its sub-agents. Multiple teams may share one consumer `.workflow/` install.
- **Team config:** `.workflow/teams/<team-id>.yaml` for that Team.

Not the same as a **run** (`runs/<run-id>/`).

## Layout

```text
.workflow/
  roles/               # shared by every Team and harness
  workflows/           # shared; process documents only
  project-standards/   # shared
  teams/
    216ab690-efa9-4760-9938-e54be49013bd.yaml
    a1b2c3d4-e5f6-7890-abcd-ef1234567890.yaml
  runs/                # one folder per run; each run belongs to one Team
  .git/                # the .workflow repository
```

One `.workflow/` serves every harness on the project. `roles/`, `workflows/`, and `project-standards/` are shared; `teams/` holds one config per Team, and `runs/` holds every Team's runs side by side.

## Config schema (v1.1)

Field order (required):

1. `id` — unique Team id (platform team-lead id or GUID; matches filename stem; typically same as `team_lead_id`). Do not use short codes `t1`, `t2`, …
2. `workflow` — path relative to `.workflow/workflows/`
3. `team_lead_id` — unique lead identifier (platform agent/session id when available)
4. `workflow_owner_id` — the workflow-owner's platform agent or session id for this Team; same as `team_lead_id` when one session holds both; a GUID the human remembers when the platform id is unknown
5. `harness` — lowercase product slug (`grok`, `cursor`, `deepseek`, …)

Example:

```yaml
id: 216ab690-efa9-4760-9938-e54be49013bd
workflow: all-main-agents.md
team_lead_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
workflow_owner_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
harness: cursor
```

Rules:

- Prefer a real platform id for `team_lead_id` and `workflow_owner_id` (Grok agent id or Cursor session id).
- If unavailable at create time, generate a GUID, write it into the yaml, and require the human to remember the same id (standing instructions / session notes).
- A config written before `workflow_owner_id` existed has four keys; the next Update install resolves the owner and adds it, and Check fails a config that still lacks it.
- A New install creates only Teams it can bring up now: an all-main-agents harness may create several bot groups at once, and a sub-agent harness creates one Team. Later Teams come through Add Team.
- No other fields in v1.1; later settings may be added without renaming the file.

## Agent binding (runtime)

1. On Team create/init, write the team config file.
2. Write the **exact config path** (e.g. `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`) into the lead’s standing instructions AND every member Role bot’s standing instructions when the platform allows. That standing-instructions bind is the hard runtime gate (read path → open `workflow` target → stop if missing). Do not put a Team-specific yaml path into shared Role cards.
3. Runtime hard rule for every agent in the Team: read that config path, then read `workflow` from it. If the path, file, or target process document is missing/unreadable, **stop**.
4. Team config is the only current-workflow pointer.
5. Sub-agents / other Roles inherit the same config path from the lead brief or their own instructions.
6. **Detect bound config (setup create vs update):** standing instructions path first; else `teams/*.yaml` whose `team_lead_id`/`workflow_owner_id`/`id` equals this session's platform id; else none → create. Multiple matches for the same lead id → stop / fail Check. Update install updates the bound file; Add Team creates a new yaml for the new Team.

## setup-workflow changes

- **Runner:** the `workflow-owner` runs setup. When none is recorded, setup resolves one from the bound config, this session, a visible bot, or the human's choice, then records `workflow_owner_id`.
- **New install:** the full set of people and process, for one or more Teams chosen by the human. Every Team uses the one process document chosen for the install. Copy the shared trees, write this Team's config, bring the Teams up, then write each additional Team's config once its bots exist; bind the path into lead and owner instructions.
- **Update install:** apply the accepted trees and have every existing Role instance on this harness re-read its card—this session now, reachable bots or sessions by message, unreachable ones as pending. The update covers every Team on this harness; Teams on another harness sync on their own run. The human approves full or selective replace. Record a missing `workflow_owner_id` on this Team's yaml.
- **Add Team:** a new harness or bot group joins the same `.workflow/` with a new yaml; on a sub-agent harness run it from the new Team's session; write the new yaml after its bots exist; no tree copy; do not overwrite other Teams' configs.
- **Check only:** no tree copy, no yaml rewrite.
- **Gitignore:** the consumer repository keeps ignoring `.workflow/`; the tree's own repository tracks it.
- **Commit:** after Check passes, setup commits the definition changes in the `.workflow/` repository and reports the commit id. `.workflow/.gitignore` ignores `runs/*` and keeps `runs/_template/`, so run data stays out of the definition history.
- **Check:** every expected Team config exists and parses; five keys in order; `workflow` target readable; lead and owner instructions cite the matching path; both ids present.

## Out of scope (v1)

- Member roster fields, sidebar section ids, display names (may be added later).
- A global `teams/index.yaml` (avoid second source of truth).
- Changing Role cards’ static pointers away from the `workflows/` directory (still directory-level; team config chooses the file).

## Acceptance

- [ ] Setup writes Team configs under `.workflow/teams/`
- [ ] A new Team creates a new yaml with `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness` in that order
- [ ] Lead, owner, and members are instructed to read that yaml first
- [ ] Setup resolves the workflow-owner and records it; a missing owner is recorded on the next update and fails Check until then
- [ ] Setup can detect this session's bound Team config (instructions path, then lead-id match) and choose create vs update without guessing another Team's file
- [ ] Check fails if config or workflow target missing
- [ ] GLOSSARY, README, setup-workflow skill/reference updated in the implementation plan
