# Open issues

Tracked work that is not done in Role cards or process documents yet.

## OI-001 — How an agent picks which process document to load

**Status:** open  
**Raised:** 2026-11-08  
**Context:** More than one process document exists under `workflows/` (`main-with-subagents.md` for Cursor/DSH, `all-main-agents.md` for Grok Bot). Role cards currently point at the `workflows/` directory, not a single file.

**Interim:** Keep Role/Playbook links to [`workflows/`](workflows/). Do not use the phrasing "active process document for this run" in Role cards. Agents must read their bound Team config under `.workflow/teams/`, then that process document; if either is missing, stop.

**Planned fix:** [`setup-workflow`](skills/setup-workflow/SKILL.md) (formerly referred to as install-workflow) writes `.workflow/teams/<id>.yaml` in a consumer project (one file per Team). Each file records `id`, `workflow` (a path relative to `.workflow/workflows/`), `team_lead_id`, and `harness`. Team config is the only current-workflow pointer. Role cards keep pointing at the `workflows/` directory.



## OI-002 — `.gitignore` policy for `runs/`

**Status:** done  
**Raised:** 2026-11-08  
**Done:** In a consumer project the entire `.workflow/` directory (including `runs/`) is gitignored. `setup-workflow` ensures the consumer `.gitignore` contains `.workflow/`. The kit repo itself still tracks `roles/`, `workflows/`, and `runs/_template/`.

---

## OI-003 — Confirm standards-tool files per pair in process documents

**Status:** done  
**Raised:** 2026-11-08  
**Done:** Handled by [`setup-workflow`](skills/setup-workflow/SKILL.md): kit templates in [`project-standards/`](project-standards/) copy to `.workflow/project-standards/` and Playbooks are rewritten to those paths automatically (no detection ask).

---

## OI-004 — Optional `STATUS.md` template

**Status:** done  
**Raised:** 2026-11-08  
**Done:** Added [`runs/_template/STATUS.md`](runs/_template/STATUS.md) and [`runs/_template/brief.md`](runs/_template/brief.md). Copy the folder to `runs/<run-id>/` when starting a run.

## OI-005 — `closer` handoff rows vs Playbook bullets

**Status:** done  
**Raised:** 2026-11-08  
**Done:** Added a matching Handoff bullet to `roles/closer/PLAYBOOK.md` for handing human-only skills such as `/retro` to team-lead to remind the human.

