# Team config files Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship per-Team YAML configs at `.workflow/teams/<id>.yaml`, and update setup-workflow so new teams, binding, and Check follow the approved design.

**Architecture:** One Team (workflow instance) gets one YAML file (`id`, `workflow`, `team_lead_id`, `harness`). Setup writes the file, binds the config path into lead (and members when possible) instructions, and Check validates Team configs. Skill copies under `skills/`, `.agents/skills/`, and the machine global skill stay identical.

**Tech Stack:** Markdown skills (`setup-workflow`), YAML team configs, GLOSSARY/README/OPEN_ISSUES docs; consumer layout under `.workflow/`.

**Spec:** [`docs/setup-workflow/team-config-design.md`](team-config-design.md)

## Global Constraints

- Chat with the human may be Chinese; all skill files, docs, commits, and written configs are English only.
- Consumer install dir remains `.workflow/` (never bare `workflow/`).
- Do not invent CreateSection; sidebar section binding stays optional as today.
- Do not add a `teams/index.yaml` in v1.
- Field order in every team YAML: `id`, `workflow`, `team_lead_id`, `harness`.
- `workflow` values are paths relative to `.workflow/workflows/`.
- If platform team-lead id is unavailable, generate a GUID and require the lead agent to remember the same id.
- Sync skill trees: `skills/setup-workflow/` is source of truth; copy to `.agents/skills/setup-workflow/` and `C:\Users\Transfinder\.agents\skills\setup-workflow\` after skill edits.
- Prefer small surgical edits; do not remove Gitignore-if-exists, Standards auto-wire, cwd-first Target, or add-group intent.
- Work on branch `feature/setup-workflow` (or current feature branch); do not commit to `develop`/`master`; commit only when the human asks or at task commit steps if they approved commits for this plan.

## File map

| File | Responsibility |
|---|---|
| `docs/setup-workflow/team-config-design.md` | Approved design (reference only; already written) |
| `docs/setup-workflow/team-config-implementation-plan.md` | This plan |
| `GLOSSARY.md` | Define Team config |
| `README.md` | Describe teams/*.yaml as the Team config pointer |
| `OPEN_ISSUES.md` (OI-001) | Interim/planned fix points at team configs |
| `skills/setup-workflow/SKILL.md` | Hard rules, steps, human actions, Check, Report, completion criteria |
| `skills/setup-workflow/reference.md` | Detection, existing-install, naming/add-group, Check list, schema |
| `.agents/skills/setup-workflow/*` | Identical mirror of skills/setup-workflow |
| `C:\Users\Transfinder\.agents\skills\setup-workflow\*` | Local global mirror |
| Consumer `.workflow/` (optional) | Ensure Team configs exist if human asks in-session |

---

### Task 1: Glossary and README vocabulary

**Files:**
- Modify: `GLOSSARY.md`
- Modify: `README.md`
- Modify: `OPEN_ISSUES.md` (OI-001 section)

**Interfaces:**
- Consumes: design vocabulary (Team, Team config)
- Produces: canonical English terms used by later skill edits

- [ ] **Step 1: Add Glossary entries**

Add (English):

**Team (workflow instance):** One agent team executing a process document (for example a Grok Role-bot group, or a Cursor lead chat with sub-agents). Multiple Teams may share one `.workflow/` install. Not a run.

**Team config:** `.workflow/teams/<team-id>.yaml` for one Team. v1 fields in order: `id`, `workflow`, `team_lead_id`, `harness`.

Update **Role-bot group** to note it is one kind of Team on all-main-agents harnesses.

Ensure Glossary defines Team config as the only current-workflow pointer.

- [ ] **Step 2: Update README**

In the Workflows / setup paragraphs:

- State that setup writes `.workflow/teams/<id>.yaml`.
- Mention agents read their Team config path, then the `workflow` file named inside.
- Keep project-standards / naming-confirm sentences.
- Ensure the Documents list includes `docs/setup-workflow/team-config-design.md` with unbroken markdown.

- [ ] **Step 3: Update OI-001**

Rewrite interim/planned fix: Team config files under `.workflow/teams/` are the only current-workflow pointer. Role cards may still point at the `workflows/` directory. Agents must read their bound Team config, then that process document; if either is missing, stop.

- [ ] **Step 4: Verify**

Run from repo root (PowerShell):

```powershell
Select-String -Path GLOSSARY.md,README.md,OPEN_ISSUES.md -Pattern 'Team config|teams/'
```

Expected: Glossary/README/OI mention Team config and `teams/`; OI-001 points at Team configs only.

- [ ] **Step 5: Commit (only if human asked to commit this plan)**

```powershell
git add GLOSSARY.md README.md OPEN_ISSUES.md
git commit -m "docs: define Team config files"
```

---

### Task 2: reference.md — schema and Check

**Files:**
- Modify: `skills/setup-workflow/reference.md`

**Interfaces:**
- Consumes: Team config schema from design
- Produces: authoritative schema + Check bullets for SKILL.md to mirror

- [ ] **Step 1: Team config format section**

Ensure **Team config format** documents:

- Path: `.workflow/teams/<team-id>.yaml`
- Required keys in order: `id`, `workflow`, `team_lead_id`, `harness`
- `workflow`: one relative path under `.workflow/workflows/`
- `team_lead_id`: platform id if known, else generated GUID the lead must remember
- `harness`: lowercase slug for this Team's product
- Runtime: read bound config path, then read `workflow` target; missing either means stop

Include a full example yaml block matching the design.

- [ ] **Step 2: Existing install / Re-setup**

Update existing-install reporting: list `teams/*.yaml` (ids, workflow, harness).

Intent **Add Role-bot group** / add Team: create a new team yaml; keep trees; do not overwrite other team yamls.


- [ ] **Step 3: End-to-end Check**

Team-config Check items:

1. Every expected Team config under `.workflow/teams/` exists, parses, has the four keys in order.
2. Each `workflow` target exists under `.workflow/workflows/`.
3. Bound lead instructions (when this session can see them) cite the matching config path.
5. Do not fail solely because another Team's config is absent unless this run was supposed to create it.

Keep roles/hops/standards/gitignore checks.

- [ ] **Step 4: Human actions table**

Ensure "Choose which workflow…" records into the Team config `workflow` field / creating `teams/<id>.yaml`.

Add: confirm or accept generated `team_lead_id` when platform id missing.

Keep add-group naming / shared instructions / create-init plan / sidebar rows.

- [ ] **Step 5: Verify**

```powershell
Select-String -Path skills\setup-workflow\reference.md -Pattern 'Team config|teams/|team_lead_id'
```

Expected: Team config schema present.

- [ ] **Step 6: Commit (if human asked)**

```powershell
git add skills/setup-workflow/reference.md
git commit -m "docs(setup-workflow): team config schema and Check in reference"
```

---

### Task 3: SKILL.md — hard rules and steps

**Files:**
- Modify: `skills/setup-workflow/SKILL.md`

**Interfaces:**
- Consumes: reference.md Team config schema and Check
- Produces: step behavior Write team config

- [ ] **Step 1: Hard rules**

Hard rules use Team config only:

- Write `.workflow/teams/<id>.yaml` for each Team created or explicitly updated.
- Field order and meanings as in reference.
- Preserve other teams' yaml files; never silent overwrite.
- Keep copy-trees, standards auto-wire, gitignore-if-exists, team-lead-only runner rules.

Update Dynamic edits list: write/update team yaml only.

- [ ] **Step 2: Rename / rewrite step 6**

Keep step name **Write team config** (step number 6; update the steps table).

Behavior:

- First install or new Team: create `teams/<id>.yaml` after workflow choice.
- Add-group: create new yaml only; skip tree copy (already true); do not touch other yamls.
- Update install: only rewrite a team yaml when the human asked to change workflow/metadata for that team.

Step 5 Choose workflows: ask which process document; map into the Team config `workflow` field at step 6.

- [ ] **Step 3: Re-setup / Initialize / Report / Completion**

- Re-setup report lists team configs; intents keep Update / Add Role-bot group (Team) / Check only.
- Initialize: after create/init plan confirm, ensure lead instructions include config path + `team_lead_id` (generate GUID if needed).
- Report: team config path(s); Team config only.
- Completion criteria: team yaml exists; Check uses team configs only.

- [ ] **Step 4: Grep self-check inside SKILL**

```powershell
Select-String -Path skills\setup-workflow\SKILL.md -Pattern 'Team config|teams/'
```

Expected: Team config rules present.

- [ ] **Step 5: Commit (if human asked)**

```powershell
git add skills/setup-workflow/SKILL.md
git commit -m "feat(setup-workflow): write Team configs"
```

---

### Task 4: Sync skill mirrors and optional consumer verify

**Files:**
- Sync: `.agents/skills/setup-workflow/` from `skills/setup-workflow/`
- Sync: `C:\Users\Transfinder\.agents\skills\setup-workflow\`
- Optional consumer: `D:\DevelopmentGit\.workflow\` (only if human asks)

**Interfaces:**
- Consumes: final SKILL.md + reference.md
- Produces: identical hashes across three skill copies

- [ ] **Step 1: Copy mirrors**

```powershell
$src = 'D:\DevelopmentGit\Simple-Workflow\skills\setup-workflow'
$mirrors = @(
  'D:\DevelopmentGit\Simple-Workflow\.agents\skills\setup-workflow',
  'C:\Users\Transfinder\.agents\skills\setup-workflow'
)
foreach ($dst in $mirrors) {
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Copy-Item "$src\SKILL.md","$src\reference.md" -Destination $dst -Force
}
Get-FileHash "$src\SKILL.md",($mirrors | ForEach-Object { "$_\SKILL.md" }) -Algorithm SHA256
Get-FileHash "$src\reference.md",($mirrors | ForEach-Object { "$_\reference.md" }) -Algorithm SHA256
```

Expected: three identical hashes for SKILL.md; three identical for reference.md.

- [ ] **Step 2: Optional consumer verify**

If the human asks about `D:\DevelopmentGit\.workflow` now: ensure a Team config yaml exists for each Team. Use platform id or generate GUID per design when creating a missing Team config.

- [ ] **Step 3: Commit skill sync (if human asked)**

```powershell
git add skills/setup-workflow .agents/skills/setup-workflow
git commit -m "chore: sync setup-workflow team-config skill mirrors"
```

(Global path outside the repo is not committed.)

---

### Task 5: Self-review against the design

**Files:**
- Read: `docs/setup-workflow/team-config-design.md`
- Read: updated skill + glossary + README + OI-001

- [ ] **Step 1: Spec coverage checklist**

Confirm each design acceptance box maps to an edited file:

- Setup writes Team configs → SKILL Write team config
- New Team new yaml with four fields in order → SKILL/reference
- Lead instructed to read yaml first → Initialize binding
- Check fails if config/workflow missing → Check section
- Docs updated → Task 1

- [ ] **Step 2: Placeholder scan**

Search plan/skill edits for TBD/TODO/"similar to" without content; fix before handoff.

- [ ] **Step 3: Report to human**

Summarize files changed, hash equality, and any remaining consumer follow-up.

---

## Spec coverage (plan self-review)

| Design requirement | Task |
|---|---|
| `.workflow/teams/<id>.yaml` schema/order | Task 2–3 |
| Binding path + team_lead_id / GUID | Task 3 Initialize |
| Add Team creates new yaml | Task 3 Re-setup/add-group |
| Check uses team configs | Task 2–3 |
| GLOSSARY/README/OI | Task 1 |
| Three skill copies synced | Task 4 |

## Out of scope for this plan

- Implementing CreateSection
- Member roster / display name fields in yaml
- Rewriting Role card links away from `workflows/` directory
- Automatic changes on every consumer machine without human ask
