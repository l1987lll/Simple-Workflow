# WorkFlow

Vocabulary for the multi-agent development workflow and the tools that define its roles.

## Language

**Role**:
A named participation slot in the workflow (for example Team Lead or QA). A Role may have more than one agent instance.
_Avoid_: persona, job, hat

**Role card**:
The Markdown document set that defines one Role for an agent to load. Created by `create-role`.
_Avoid_: agent definition, skill, prompt pack

**ROLE.md**:
The stable document of a Role card: name, slug, purpose, optional speaking style, and fixed boundaries. It always points at `workflow.md` for pipeline and cross-Role routing. It does not define that routing itself.
_Avoid_: IDENTITY.md, main doc (except as informal shorthand), profile, DETAIL.md

**Playbook**:
The mutable document of a Role card (`PLAYBOOK.md`): role-local responsibilities, craft steps for one or more kinds of work, checklists, notes, when *this* Role should hand off, and **When stuck** (when to stop and raise a problem outside the Role—not normal handoff). Does not define how the other Role works. Points to `workflow.md` for full routing.
_Avoid_: details, handbook, charter, DETAIL.md, Escalation (as the section title)

**When stuck**:
A Playbook section: conditions where this Role must stop and raise a problem outside itself. Not a normal handoff.
_Avoid_: Escalation (as the section title), upgrade

**Role-Playbook layout**:
Default Role card shape: `ROLE.md` plus `PLAYBOOK.md`. `ROLE.md` must require reading the Playbook and give its path. Both files point at `workflow.md`. When asking the human, explain the layout before offering the choice.
_Avoid_: Role-Detail, two-document layout, monolith, split

**Role-merged layout**:
Optional Role card shape: one `ROLE.md` with a stable upper section and a mutable lower section (same headings as a Playbook). Points at `workflow.md`. Chinese UI may say「Role 合并」; English token is Role-merged.
_Avoid_: Role-only, single-document layout, monolith

**workflow.md**:
The Process document: end-to-end workflow and how Roles interact. Lives outside Role cards. `create-role` does not create or edit it.
_Avoid_: playbook, process document (except as the concept name), pipeline doc
