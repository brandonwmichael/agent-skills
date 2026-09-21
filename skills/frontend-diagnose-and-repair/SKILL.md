---
name: frontend-diagnose-and-repair
description: >-
  Use this skill to orchestrate the autonomous 5-phase frontend engineering loop and self-healing workflow.
  Handles error localization, targeted repair generation, and re-verification across TypeScript, ESLint AST guardrails,
  Vitest, and Playwright. Enforces the 3-cycle iteration bound, design pattern invariants, and programmatic boundaries.
---

# Frontend Diagnose and Repair (`frontend_diagnose_and_repair`)

This skill acts as the master orchestrator for diagnosing and repairing failures across all three verification gates in the Autonomous Frontend Engineering Loop.

## The 5-Phase Operational Loop
1. **Specification & Plan Generation:** Clarify requirements, define interfaces, plan component breakdown.
2. **Code Synthesis:** Implement TSX components using Tailwind CSS and shadcn/ui, adhering to `frontend-author-component` standards (compound dot-notation, logic hooks, polymorphic slots, CVA).
3. **Level 1 Verification (Type & AST Lint Gate):** Execute `frontend-typecheck` (`tsc --noEmit` and `eslint`).
4. **Level 2 Verification (Unit & Component Testing):** Execute `frontend-run-unit-tests` (Vitest).
5. **Level 3 Verification (E2E & Visual Verification):** Execute `frontend-run-e2e-tests` (Playwright).

## Core Invariants & Guardrails
- **No Type Bypasses:** Under NO circumstances use `@ts-ignore`, `@ts-expect-error`, or weaken strict compiler flags.
- **Design Pattern Invariants:**
  - Ban raw HTML primitives (`<button>`, `<input>`) in feature components; use design token primitives.
  - Enforce compound dot-notation (`<Card.Header>`, `<Dialog.Title>`).
  - Container/Presentational split (extract side-effects to custom hooks).
  - Maximum 180 lines per component file.
- **Deterministic Selectors:** All interactive elements must include `data-testid` or accessible roles/labels.
- **Bounded Iteration Count:** Never exceed 3 successive repair attempts for any failing gate. If an issue is unresolved after 3 cycles, halt and prompt for human triage.
- **Single-Responsibility Edits:** Fixes must be strictly localized to the failing code or test without sweeping unrelated refactorings.

## Step-by-Step Healing Workflow

1. **Gate Identification**
   Identify which gate failed (Typecheck/Lint, Vitest, or Playwright).

2. **Error Localization**
   - Extract the offending file, line number, and error message, ESLint rule violation, or failed test assertion.
   - For visual/E2E failures, examine failure screenshots and traces in `test-results/`.

3. **Consult Detailed Protocol**
   Refer to [self_healing_protocol.md](./references/self_healing_protocol.md) for gate-specific diagnostic patterns and ESLint AST rule remedies.

4. **Apply Targeted Fix**
   Formulate a minimal diff strictly addressing the root cause.

5. **Cycle Tracking & Re-verification**
   - Increment cycle count (1, 2, or 3).
   - Re-run verification starting at Level 1 (`tsc --noEmit` + `eslint`), then Level 2, then Level 3.
   - If cycle count reaches 4 without resolution, halt and present triage report to the user.
