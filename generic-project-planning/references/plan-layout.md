# Plan Layout

Use this layout when the plan should live on disk instead of only in chat.

## Directory Structure

```text
.plan/
  <plan-name>/
    open-questions.md
    01-first-step.md
    02-second-step.md
    03-third-step.md
```

## Naming Rules

- Create `.plan/` at the repository root.
- Use one subfolder per plan.
- Name the plan folder in lowercase kebab-case.
- Keep step files zero-padded so they sort naturally.
- Keep `open-questions.md` unnumbered so it is easy to find.

## File Roles

- `open-questions.md` holds unresolved questions only.
- `01-*.md` holds the first executable step or phase.
- `02-*.md` holds the next step or phase.
- Continue until every durable step in the plan has its own file.

## Open Questions Format

Use a table in `open-questions.md`:

```text
# Open Questions

| Status | Question | Why it matters | Next step |
| --- | --- | --- | --- |
| 🔴 | ... | Blocks starting implementation | Resolve before coding |
| 🟡 | ... | Requires a follow-up before production | Capture as a todo or follow-up |
| 🟢 | ... | Resolved | No further action |
```

- Use `🟢` when the question is resolved.
- Use `🟡` when the answer is good enough to build now, but it still needs a production-safe follow-up.
- Use `🔴` when the question blocks starting the code or plan execution.

## Step Lifecycle

Every numbered step file must include `Current state:` near the top.

- `🆕` brand new / not started
- `🔵` in progress
- `🟡` follow-up needed
- `🔴` blocked
- `🟢` ready
- `✅` completed

## Recommended Step File Contents

Each step file should have exactly this shape:

```text
# 01-first-step

Current state: 🆕 Brand new

## Plan
- What this step is
- Why it exists
- What it depends on
- What it produces
- How to tell it is complete

## Findings / Outcome
- List discoveries, decisions, or blockers here.
- If implementation already happened, add a short recap of what changed.
- If nothing has happened yet, write `Not started yet.`
```

## Example

For a migration plan, the files might look like this:

```text
.plan/
  auth-migration/
    open-questions.md
    01-audit-current-state.md
    02-design-target-state.md
    03-execute-migration.md
    04-verify-and-cutover.md
```

## Guardrails

- Put unresolved questions only in `open-questions.md`.
- Do not split one logical step across multiple files unless the plan itself has distinct phases.
- Keep each numbered step file as a living record with the same two sections.
- If scope changes, update the affected files and keep the numbering consistent where possible.
