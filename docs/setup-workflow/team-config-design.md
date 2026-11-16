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
  roles/
  workflows/           # process documents only
  teams/
    216ab690-efa9-4760-9938-e54be49013bd.yaml
    a1b2c3d4-e5f6-7890-abcd-ef1234567890.yaml
  runs/
  project-standards/
```

## Config schema (v1)

Field order (required):

1. `id` — unique Team id (platform team-lead id or GUID; matches filename stem; typically same as `team_lead_id`). Do not use short codes `t1`, `t2`, …
2. `workflow` — path relative to `.workflow/workflows/`
3. `team_lead_id` — unique lead identifier (platform agent/session id when available)
4. `harness` — lowercase product slug (`grok`, `cursor`, `deepseek`, …)

Example:

```yaml
id: 216ab690-efa9-4760-9938-e54be49013bd
workflow: all-main-agents.md
team_lead_id: 1eb63955-4fed-4a73-a5b5-b817d86ae77f
harness: cursor
```

Rules:

- Prefer a real platform id for `team_lead_id` (Grok agent id or Cursor session id).
- If unavailable at create time, generate a GUID, write it into the yaml, and require the lead agent to remember the same id (standing instructions / session notes).
- No other fields in v1; later settings may be added without renaming the file.

## Agent binding (runtime)

1. On Team create/init, write the team config file.
2. Write the **exact config path** (e.g. `.workflow/teams/216ab690-efa9-4760-9938-e54be49013bd.yaml`) into the lead’s standing instructions AND every member Role bot’s standing instructions when the platform allows. That standing-instructions bind is the hard runtime gate (read path → open `workflow` target → stop if missing). Do not put a Team-specific yaml path into shared Role cards.
3. Runtime hard rule for every agent in the Team: read that config path, then read `workflow` from it. If the path, file, or target process document is missing/unreadable, **stop**.
4. Team config is the only current-workflow pointer.
5. Sub-agents / other Roles inherit the same config path from the lead brief or their own instructions.
6. **Detect bound config (setup create vs update):** standing instructions path first; else `teams/*.yaml` whose `team_lead_id`/`id` equals this session's platform id; else none → create. Multiple matches for the same lead id → stop / fail Check. Re-setup updates the bound file; add-group creates a new yaml for the new lead.

## setup-workflow changes

- **First install / new Team:** create `teams/<id>.yaml`. Ask which process document to use; record harness; resolve or generate `team_lead_id`; bind path + id into lead instructions.
- **Add Team:** create another yaml; do not treat as tree re-setup; do not overwrite other teams’ configs.
- **Update install:** may change trees and/or update a named team’s `workflow` / metadata only with explicit approval; never silent overwrite of other team yamls.
- **Gitignore:** entire `.workflow/` remains ignored when consumer `.gitignore` exists (unchanged).
- **Check:** every expected team config exists and parses; `workflow` target readable; lead instructions cite the matching path; `team_lead_id` present.

## Out of scope (v1)

- Member roster fields, sidebar section ids, display names (may be added later).
- A global `teams/index.yaml` (avoid second source of truth).
- Changing Role cards’ static pointers away from the `workflows/` directory (still directory-level; team config chooses the file).

## Acceptance

- [ ] Setup writes Team configs under `.workflow/teams/`
- [ ] New Team creates a new yaml with `id`, `workflow`, `team_lead_id`, `harness` in that order
- [ ] Lead (and members when possible) instructed to read that yaml first
- [ ] Setup can detect this session's bound Team config (instructions path, then lead-id match) and choose create vs update without guessing another Team's file
- [ ] Check fails if config or workflow target missing
- [ ] GLOSSARY, README, setup-workflow skill/reference updated in the implementation plan
