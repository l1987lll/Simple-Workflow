# AGENTS.md

## Branching

When the current branch is `develop` or `master` and no branch for this work exists yet, create the work branch first, then make the change there. `develop` and `master` receive changes only through merges.

A branch can carry several small pieces of work: reuse it for related changes, and cut a new one when the work is unrelated.

## Agent docs

Every file an agent reads follows [`docs/agent-docs.md`](docs/agent-docs.md): Role cards, Playbooks, process documents, and skills. Read it before writing or revising one of those files, and run its check before finishing.

## Skill mirrors

`skills/` is the only source of truth for skills. `.agents/skills/<skill-name>/` is a committed mirror of it, so AI coding tools that scan `.agents/` can discover the skills.

- Never edit a file under `.agents/skills/` directly. Edit `skills/` and regenerate the mirror.
- After adding or changing anything under `skills/<skill-name>/`, regenerate that whole mirror folder. Copying one file and leaving the rest stale is not enough.
- If a skill is renamed or removed, rename or delete its mirror folder in `.agents/skills/` in the same commit.
- Done when both folders hold the same file list and the same SHA-256 hash for every file.

Regenerate one skill's mirror:

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
