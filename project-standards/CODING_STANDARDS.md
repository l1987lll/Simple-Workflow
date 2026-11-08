# Coding standards (local)

Local deltas only. Company skills remain the default. Empty TBD sections are placeholders - do not invent rules from them. Treat a section as binding only when it has real bullets.

**When to load:** any time you write or change code under `DevelopmentGit`.

## Scope

- _(TBD)_

## Language / stack notes

- _(TBD)_

## Style and naming

- _(TBD)_

## Tests and verification before done

- _(TBD)_

## Do / don't

- Do not reference docs from code comments at all — wiki, Confluence, share drives, chat, ADRs, `spec.md`, or other design/spec notes. Those files often are not committed with the product code, so the pointer goes stale or is missing for others. Put needed intent in the comment itself (or in code that makes the intent obvious).
- _(TBD)_

## Patrolfinder family

Product-specific rules for repos under `patrolfinder/`. Company-wide review principles stay in `tf-code-review` (source: `AI/tf-dev-workspace`).

### SharedTest fakes

When a test needs behavior that a SharedTest fake currently throws `NotSupportedException` for (e.g. `HashAndSetCache` stream `Lock*` / `SetLength`):

1. Prefer a **derived fake** or an **in-test stub** scoped to that suite.
2. Changing a **shared** fake is allowed only when existing tests that use it still pass; note which filter you ran in the PR Evidence.
3. Do not silently widen a public fake for convenience without that Evidence line.

## Routefinder Web (Plus)

- Do not add `role="search"` on a container that wraps ArcGIS Search when `esri-search__form` already has that role (nested search landmarks). Custom Plus search UIs may use one `role="search"` wrapper.
- For BrowserStack a11y tickets: parse the xlsx rows before coding; verify on localhost via menu navigation (see routefinder-web `AGENTS.md` Accessibility landmarks).


## Local workflow (agent / worktree)

- Branch names follow the commit skill: `<type>/<JIRA-KEY>-<short-description>` (e.g. `bugfix/RW-60898-skip-to-main-content`). Do not use date/time suffixes as the description.
- After finishing a change, commit promptly. Prefer few commits: squash related edits into one commit when they belong together.
- When work is done in a git worktree, commit there first, then sync the committed changes into the main local checkout. After that sync, switch the main checkout onto the same integration/feature branch (not leave it on `Develop`/`main` with only a dirty tree).
