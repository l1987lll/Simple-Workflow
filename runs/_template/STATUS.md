# Run STATUS

Copy this folder to `runs/<run-id>/` and fill in the fields. Only `team-lead` updates this file.

## Run

| Field | Value |
|---|---|
| run-id | |
| title | |
| process document | e.g. `workflows/main-with-subagents.md` |
| work branch / worktree | |
| overall phase | e.g. `intake` / `in_progress` / `closeout` / `done` |
| brief | `brief.md` |
| waiting on | none / human / (Role instance) |

## Instances

One row per in-flight Role instance. Add rows as needed. Parallel instances must have disjoint path ownership before editing.

| Role | Instance id | Agent id | Slice | Path ownership | Phase | Artifacts | Waiting on |
|---|---|---|---|---|---|---|---|
| team-lead | team-lead#1 | | coordinate run | (coordinator; no product paths) | | | |
| developer | developer#1 | | | e.g. `src/auth/**` | | `dev/developer#1/` | |
| developer | developer#2 | | | e.g. `src/ui/**` | | `dev/developer#2/` | |

## Notes

- Product code stays on the work branch; process artifacts stay under this run folder.
- Next Role reads only paths listed above (and the brief).
