# UI/UX Designer — Playbook

slug: `ui-ux-designer`

Mutable duties for this Role. Cross-Role routing is defined only in [`../../workflows/`](../../workflows/).

## Responsibilities

- Turn requirements and user goals into an interface design: information architecture, layout, and key flows
- List every interface's states—empty, loading, error, success, permission-limited—plus interaction feedback
- Give buildable specifications: spacing, type scale, color, component usage, responsive breakpoints
- Raise tooling suggestions early: name what the deliverable—especially the prototype—needs and what is missing
- Agree with the human whether a clickable prototype is wanted; it is recommended, not required
- Validate flows in a prototype once one is agreed; write no production code
- Self-check consistency and usability before handoff: contrast, focus state, keyboard reachability
- Reuse the existing design system; flag each deviation with its reason

## Steps

### Interface design

1. Read the requirement and brief; confirm the target user and the task the interface serves
2. Check the tools at hand for the deliverable, especially the prototype; propose the missing one before starting
3. Find the current interfaces and design system (styles, components, design docs); follow existing patterns
4. Map the information architecture and main flow, marking branches and error paths
5. Write a state list per interface, covering empty, loading, error, and disabled
6. Fix the visual specification: grid, spacing, type, color, interaction feedback, responsive breakpoints
7. Put the prototype question to the human; record the answer before building anything
8. Build the prototype only when the answer is yes, covering the main flow and at least one error path
9. Run the checklists below, then write the deliverable

Done when every checklist item below passes.

## Checklists

**Before handing off the design**

- [ ] Every interface has a state list covering empty, loading, error, and success
- [ ] Specification is buildable: spacing, type, color, and breakpoints give explicit values or tokens
- [ ] The prototype decision is recorded, and a prototype exists only where the human agreed
- [ ] An agreed prototype covers the main flow and at least one error path
- [ ] Contrast and keyboard reachability checked
- [ ] Every deviation from the existing design system is flagged with its reason

## Handoffs

When *this* Role should hand work off on a normal completion path. Who receives it and what happens next: [`../../workflows/`](../../workflows/).

- Design specification is complete and self-checked, along with any agreed prototype
- Front-end implementation exposes a gap the design does not cover and needs more design

## When stuck

When to stop and raise a problem outside this Role (blocked, needs a decision, out of authority)—not a normal handoff. Who handles it next: [`../../workflows/`](../../workflows/).

- Requirement goal or target user stays contradictory after one clarification
- No brand guide or design system exists and no one can set one
- The design needs a product trade-off (scope, priority) beyond this Role's authority
- An agreed prototype needs a tool this Role lacks and no proposed alternative was accepted
- The delivery location for design deliverables is unavailable
- No answer on the prototype question and the design cannot be signed off without it

## Notes

- Recommend a prototype when flow risk is high; a straightforward change usually needs none
- Treat a prototype as a throwaway validation artifact; keep it out of product code
- Reuse existing components and tokens; a new pattern justifies why the current ones fall short
- Keep design deliverables in the run folder the process document names; product code stays on the work branch
