# AGENTS.md

## Branching

When the current branch is `develop` or `master` and no branch for this work exists yet, create the work branch first, then make the change there. `develop` and `master` receive changes only through merges.

A branch can carry several small pieces of work: reuse it for related changes, and cut a new one when the work is unrelated.

## Pull requests

Write the PR body with the `pr` skill from your agent profile; this repo does not maintain it. [`.github/pull_request_template.md`](.github/pull_request_template.md) fixes the headings.

## Agent docs

Every file an agent reads follows [`docs/agent-docs.md`](docs/agent-docs.md): Role cards, Playbooks, process documents, and skills. Read it before writing or revising one of those files, and run its check before finishing.

## Skill directories

Two directories hold skills, with different jobs:

- `skills/` holds the skills this repo produces and ships.
- `.agents/skills/` is the surface this repo's tools discover skills from. It holds a copy of every repo skill, and may hold an outside skill this repo calls.

The two are not compared as sets.

- Give every skill under `skills/` a copy at `.agents/skills/<skill-name>/` with the same file list and the same SHA-256 hash for every file.
- Never edit that copy directly; edit `skills/` and regenerate it.
- When a skill is renamed or removed under `skills/`, rename or delete its folder under `.agents/skills/` in the same commit.
- A folder under `.agents/skills/` with no match under `skills/` comes from outside this repo; edit it at its source.

Regenerate one skill's copy:

```powershell
$skill = '<skill-name>'
Remove-Item -Recurse -Force ".agents\skills\$skill"
Copy-Item -Recurse "skills\$skill" ".agents\skills\$skill"
```

Check for drift (prints nothing when the two folders match):

```powershell
$skill = '<skill-name>'
$src = (Resolve-Path "skills\$skill").Path
$dst = ".agents\skills\$skill"
Get-ChildItem -Recurse -File $src | ForEach-Object {
  $m = Join-Path $dst $_.FullName.Substring($src.Length).TrimStart('\')
  if (-not (Test-Path $m)) { "missing: $m" }
  elseif ((Get-FileHash $_.FullName).Hash -ne (Get-FileHash $m).Hash) { "differs: $m" }
}
```
