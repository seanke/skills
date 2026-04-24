---
name: generic-tdd-bug-fixing
description: "Fix bugs and regressions by writing a failing unit test first, then changing only production code until the test passes. Use when diagnosing an existing defect, locking in a regression, or verifying a bug fix with red-green TDD."
---

# TDD Bug Fixing

## Goal
Use this skill for Regression test-driven bug fixing.

## Use When
- A user reports a bug or regression in existing code
- You need to pin down unexpected behavior with a regression test
- You want a narrow, repeatable fix instead of a speculative refactor
- A fix should be guarded by a unit test before code changes

## Workflow
### Inputs
| Input | Required | Description |
|-------|----------|-------------|
| Bug report or observed failure | Yes | The incorrect behavior to reproduce |
| Relevant production code | Yes | The module, class, or function that likely contains the defect |
| Existing tests | No | Current tests near the bug area |
| Repro data or steps | No | Example inputs, edge cases, or stack traces |

### 1. Reproduce the bug

- Read the bug report, logs, and surrounding code.
- Identify the smallest observable behavior that is wrong.
- Prefer a direct unit-level reproduction over an integration path.
- If the bug is ambiguous, choose the narrowest case that proves the defect.

### 2. Write the regression test first

- Add or modify a unit test that captures the incorrect behavior.
- Make the test fail against the current production code.
- Keep the test focused on one bug and one expected outcome.
- Use real inputs and minimal mocking unless the dependency boundary forces it.
- Do not change production code yet.

### 3. Verify the red state

- Run only the new or targeted test.
- Confirm it fails for the intended reason, not because of unrelated setup.
- If the test passes, the bug is not reproduced. Tighten the test or the fixture until it fails.
- If the test is flaky or depends on timing, network, or randomness, replace it with deterministic inputs.

### 4. Fix production code only

- Change production code, not the test, until the failing test passes.
- Make the smallest change that fixes the observed behavior.
- Avoid broad refactors unless they are required to make the fix correct.
- Preserve existing behavior outside the bug scope.

### 5. Verify green

- Re-run the regression test.
- Run the closest related test slice to catch nearby regressions.
- If another test fails, fix the production code rather than weakening the regression test unless the test was wrong.

### 6. Refactor safely

- Clean up naming or structure only after the test is green.
- Keep the regression test in place.
- If you learned a new edge case, add an additional test instead of expanding the original one too far.

### Rules
- The regression test must fail before the fix and pass after it.
- Do not fix the bug by loosening, deleting, or rewriting the test to make it pass.
- Do not alter the test after it is confirmed red unless it was incorrect.
- Prefer one bug, one test, one fix.
- Keep the fix minimal and behavior-driven.
- If you cannot make a unit test fail, stop and explain why instead of guessing.

## References
- No bundled reference files or helper directories.

## Notes
- You are adding a new feature with no existing defect
- The issue is clearly in test code, fixtures, or environment setup
- The behavior cannot be isolated deterministically with a unit test
- The user asked for a refactor without changing behavior

### Validation
- [ ] The new test fails before any production change
- [ ] The same test passes after the production fix
- [ ] No test-only workaround was introduced
- [ ] Related tests still pass
- [ ] The production change is the smallest correct fix

### Common Pitfalls
- Test passes immediately because it does not actually reproduce the bug
- Test is changed after red to match existing behavior instead of the intended behavior
- Production fix is overbroad and changes unrelated code paths
- Mock setup hides the real defect
- A refactor sneaks in before the regression is locked down
