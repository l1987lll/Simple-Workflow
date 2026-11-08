# Review rules (local)

Supplements company `/code-review` / `/review` (and similar). Local deltas only. Empty TBD sections are placeholders — do not invent rules from them. Treat a section as binding only when it has real bullets.

**When to load:** any time you review code (diff, PR, or branch) under `DevelopmentGit`.

## Review axes

- _(TBD)_

## What to flag vs ignore

- **Routefinder Web / ArcGIS Search:** If the diff adds `role="search"` (or a search landmark wrapper) near ArcGIS / Esri Search (`esri-search__*`, `SearchTool`, DirectionPalette search), check ThirdParty `esri/widgets/Search` — `_renderForm()` already sets `role="search"` on `esri-search__form`. Flag nested search landmarks; prefer relying on the widget form unless the control is custom Plus markup.
- _(TBD)_

## How to report findings

- _(TBD)_

## Local deltas on top of company review skills

- _(TBD)_
