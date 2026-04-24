---
name: generic-project-planning
description: Use when the user asks for a complex, multi-part plan that should be captured in a repo-root `.plan/<plan-name>/` folder with numbered step files and an `open-questions.md` file.
---

# Goal
Turn large, multi-part planning requests into a durable file-based planning workspace in the repository so the plan is explicit, sequenced, and ready to execute.

# Use When
- The user asks for a complicated or complex plan.
- The request has many dependencies, phases, or unknowns.
- The plan needs a persistent artifact before work can start.
- You need to track unresolved questions separately from execution steps.

# Workflow
1. Identify the repository root and create `.plan/` there if it does not already exist.
2. Create a subfolder for the specific plan using a concise lowercase kebab-case name.
3. Write `.plan/<plan-name>/open-questions.md` first and list every unresolved question needed before execution can begin.
4. Create one markdown file per step in the plan, using zero-padded numeric prefixes such as `01-`, `02-`, and `03-` so the files sort in execution order.
5. Keep each step file focused on a single phase, dependency, or deliverable.
6. Update the plan files as scope changes, but keep the numbering stable unless the sequence itself changes.
7. If the request is still underspecified, add the gaps to `open-questions.md` before inventing details.

# References
- [Plan Layout](references/plan-layout.md)

# Notes
- Use ASCII filenames and lowercase kebab-case for folders.
- Treat `open-questions.md` as the canonical place for blockers and unknowns.
- Do not mix step content and unresolved questions in the same file.
- If a plan is small and simple, skip the file scaffold and answer directly.
