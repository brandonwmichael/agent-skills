---
name: frontend-run-unit-tests
description: >-
  Use this skill to run isolated unit and component tests (Level 2 Verification Gate) with Vitest.
  Executes tests with JSON reporting, extracting failing suites, assertion diffs, and call stacks.
  Triggers after passing Level 1 Typecheck, before proceeding to full E2E validation.
---

# Frontend Run Unit Tests (`frontend_run_unit_tests`)

This skill defines the Level 2 Verification Gate in the Autonomous Frontend Engineering Loop. It validates component logic, state transitions, utility functions, and hooks in an isolated ESM environment using Vitest and `happy-dom`.

## Verification Scope
- Component rendering assertions using React Testing Library or `@testing-library/react`.
- State reducer and hook behavior.
- Data transformation and utility function invariants.

## Execution

1. **Run Unit Tests with JSON Reporter**
   Execute the test runner helper script:
   ```bash
   bash .agents/skills/frontend-run-unit-tests/scripts/run_unit_tests.sh
   ```
   Or execute directly:
   ```bash
   npx vitest run --reporter=json --outputFile=test-results/vitest-results.json
   ```

2. **Diagnose Test Failures**
   - Review failing test titles, expected vs. received values in assertion diffs.
   - Inspect call stack traces to localize whether the failure is in component implementation or test setup.
   - Apply single-responsibility corrections directly to the component or mock.

3. **Re-Verification**
   Re-run the runner after adjustments. Ensure all suites pass before proceeding to Level 3 E2E testing.
