---
name: frontend-run-e2e-tests
description: >-
  Use this skill to execute end-to-end integration and visual verification tests (Level 3 Verification Gate) using Playwright.
  Captures structured JSON test results, trace files, screenshots on failure, and console/network logs.
  Triggers after passing Level 1 Typecheck and Level 2 Unit tests, or during final verification.
---

# Frontend Run E2E Tests (`frontend_run_e2e_tests`)

This skill defines the Level 3 Verification Gate in the Autonomous Frontend Engineering Loop. It validates full user journeys, route transitions, DOM states, and API interactions in real headless browser engines (Chromium) using Playwright.

## Invariant: Deterministic Locators
- All locators must use deterministic identifiers:
  - `page.getByTestId('submit-btn')`
  - `page.getByRole('button', { name: /save/i })`
  - `page.getByLabel('Email address')`
- Do NOT use fragile CSS class selectors or DOM hierarchy selectors (e.g. `.css-1x84j2`, `div > span:nth-child(2)`).

## Execution

1. **Run E2E Suite**
   Execute the E2E runner helper script:
   ```bash
   bash .agents/skills/frontend-run-e2e-tests/scripts/run_e2e_tests.sh
   ```
   Or execute directly:
   ```bash
   npx playwright test --reporter=json
   ```

2. **Handle Failure Artifacts**
   When tests fail, inspect the generated artifacts in `test-results/`:
   - **Screenshots:** Examine `test-results/**/test-failed-*.png` to inspect visual regressions or missing elements.
   - **Traces:** Inspect Playwright trace files (`trace.zip`) for action timelines, DOM snapshots, console errors, and failed network calls.
   - **Results JSON:** Parse `test-results/results.json` to extract precise failure lines and error messages.

3. **Autonomous Remediation**
   - If an element is missing, verify if the component failed to mount, had an unmet prop, or an incorrect `data-testid`.
   - If an interaction timed out, check network mock endpoints or loading state transitions.
   - Re-run the suite to verify the fix.
