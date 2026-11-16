# Open issues

Tracked work that is not done in Role cards or process documents yet.

## OI-001 — How an agent picks which process document to load

**Status:** done  
**Raised:** 2026-11-08  
**Done:** [`setup-workflow`](skills/setup-workflow/SKILL.md) writes `.workflow/teams/<id>.yaml` per Team with `id`, `workflow`, `team_lead_id`, `workflow_owner_id`, and `harness`; the Team config is the only current-workflow pointer, and every agent reads it before the document. Role cards keep pointing at [`workflows/`](workflows/). Schema and runtime rule: [`setup-workflow` reference](skills/setup-workflow/reference.md#team-config-format).



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

## OI-006 — Role templates point at a `workflow.md` that does not exist

**Status:** done  
**Raised:** 2026-11-15  
**Done:** All three templates now point at `../../workflows/`, matching OI-001. [`define-role`](skills/define-role/SKILL.md) warns only when `workflows/` holds no process document, and the spec and reference were updated with the templates.


