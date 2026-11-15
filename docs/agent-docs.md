# Docs an agent reads

The reader acts on this file without asking a human. A doc earns its space by changing what that reader does. This standard covers Role cards (`ROLE.md`, `PLAYBOOK.md`), process documents under `workflows/`, and the skills that write them.

## The doc travels

A Role card or process document is copied into a consumer project's `.workflow/`; this `docs/` tree is not. State every rule the reader needs inside the artifact, and point only at paths that ship with it—`../../workflows/`, not a docs page the consumer never receives.

Keep machine paths, usernames, and organization names out of a shipped artifact: write the consumer-relative path, or a placeholder the reader fills in.

## Steps and reference

Decide which one you are writing before the first line.

- **Steps**: the ordered actions, one per bullet or numbered item, each starting with a verb. Steps come first in the file.
- **Reference**: the rules, tables, and definitions read on demand. Put it under its own heading below the steps.
- A section only some readers reach moves behind a pointer that says what it is and when to read it. Branching decides the cut: keep what every reader needs, disclose the rest.
- Group a rule with its exception and its example. A rule that needs another file to be understood is in the wrong place.

## Completion criteria

Every step ends on a criterion the reader can check by looking at the artifact.

- Checkable, not felt: "every route names a slug that exists under `roles/`" beats "the routes are sound".
- Exhaustive where the work is flat: "every section present", "every pair labeled".
- A fuzzy criterion invites stopping early; sharpen the wording before adding more steps.

## One meaning, one place

- A rule stated twice drifts. State it once and point at it.
- Cut what the reader can look up: directory listings, command output, a file tree. Keep the convention, the reason, or the gotcha a lookup cannot reveal.
- Delete the no-ops. "Be careful", "make sure to", "it is important that" carry no action.

## Words

- Use `GLOSSARY.md` vocabulary; never a second name for a Role, a route, or a Run.
- Imperative, present tense: "Write only the named file", not "The file should be written".
- Name the target behaviour. A prohibition drags the banned act into attention, so keep one only as a hard guardrail beside the positive target.
- A compact word the model already owns beats a spelled-out triad: *tight*, *red*, *fog of war*. Pick it and reuse it; repeated tokens turn into a concept the reader thinks with.

## One rewrite

Before: "It is important that care is taken to make sure the review is done properly before handoff happens."

After: "Hand off only after a review pass; list findings in `review/`."

## Check before you finish

- [ ] Markdown renders: no bullet broken across lines, no stray blank line inside a list, no paragraph continuation starting at column 1
- [ ] Every step has a criterion that reads true or false from the written file
- [ ] Every pointer names an existing path that ships with the artifact, and says when to read it
- [ ] No rule stated twice; nothing restated that the file tree already shows
- [ ] Names match `GLOSSARY.md`
- [ ] The written file read back once, as its reader
