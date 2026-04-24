# Plan Layout

Use this layout when a request is large enough that the plan should live on disk in the repository instead of only in chat.

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
- Use a single subfolder per plan.
- Name the plan folder in lowercase kebab-case.
- Keep step files zero-padded so they sort naturally.
- Keep `open-questions.md` unnumbered so it is easy to find.

## File Roles

- `open-questions.md` holds every blocker, dependency, assumption, and decision that must be resolved before execution starts.
- `01-*.md` holds the first executable step or phase.
- `02-*.md` holds the next step or phase.
- Continue until every durable step in the plan has its own file.

## Recommended Step File Contents

Each step file should answer:

- What is being done
- Why this step exists
- What it depends on
- What it produces
- How to tell it is complete

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

- Put unresolved questions in `open-questions.md` instead of hiding them in step files.
- Do not split one logical step across multiple files unless the plan itself has distinct phases.
- If the user changes scope, update the affected files and keep the numbering consistent where possible.
