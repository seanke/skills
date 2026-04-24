# Template Instantiation

Use this when the template is already known and you need to create the project.

## Workflow

1. Confirm the template and parameters.
2. Check the workspace for conventions such as Central Package Management and solution layout.
3. Run `dotnet new` with a dry-run first when the output is not obvious.
4. Create the project.
5. Add it to the solution if needed.
6. Build it to verify the result.

## Common Follow-Up Checks

- CPM adaptation
- Framework selection
- Multi-project wiring
- Current SDK version

If the user only wants to compare templates, move back to `references/discovery.md`.
