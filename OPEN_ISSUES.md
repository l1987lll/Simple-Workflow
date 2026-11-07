# Open issues

Tracked work that is not done in Role cards or process documents yet.

## OI-001 — How an agent picks which process document to load

**Status:** open  
**Raised:** 2026-11-08  
**Context:** More than one process document exists under `workflows/` (`main-with-subagents.md` for Cursor/DSH, `all-main-agents.md` for Grok Bot). Role cards currently point at the `workflows/` directory, not a single file.

**Interim:** Keep Role/Playbook links to [`workflows/`](workflows/). Do not use the phrasing "active process document for this run" in Role cards.

**Planned fix:** A future **install-workflow** skill chooses which `workflows/*.md` is active for a harness/environment (optional pointer file). Until then, selection stays unresolved in-repo.



## OI-002 — `.gitignore` policy for `runs/`

**Status:** parked (ignore for now)  
**Raised:** 2026-11-08  
**Summary:** Decide whether `runs/` (STATUS and handoff artifacts) is committed, ignored, or partially ignored.

---

## OI-003 — Confirm craft-tool files per pair in process documents

**Status:** open  
**Raised:** 2026-11-08  
**Summary:** Playbooks depend on `CODING_STANDARDS.md`, `COMMIT_RULES.md`, and `REVIEW_RULES.md`. Process documents do not yet record per-pair confirmation that those files are reachable.

---

## OI-004 — Optional `STATUS.md` template

**Status:** done  
**Raised:** 2026-11-08  
**Done:** Added [`runs/_template/STATUS.md`](runs/_template/STATUS.md) and [`runs/_template/brief.md`](runs/_template/brief.md). Copy the folder to `runs/<run-id>/` when starting a run.

## OI-005 — `closer` handoff rows vs Playbook bullets

**Status:** done  
**Raised:** 2026-11-08  
**Done:** Added a matching Handoff bullet to `roles/closer/PLAYBOOK.md` for handing human-only skills such as `/retro` to team-lead to remind the human.

