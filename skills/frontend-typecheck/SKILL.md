---
name: frontend-typecheck
description: >-
  Use this skill to run headless TypeScript verification and ESLint AST guardrails (Level 1 Verification Gate).
  Parses compilation error streams and ESLint rule violations into structured diagnostics for automated self-healing.
  Triggers after modifying TypeScript or TSX files, prior to running runtime/unit/E2E tests.
---

# Frontend Typecheck & Lint Gate (`frontend_typecheck`)

This skill defines the Level 1 Verification Gate in the Autonomous Frontend Engineering Loop. It validates static typing, exports, prop contracts, nullability, and AST architectural constraints (raw HTML ban, compound dot-notation, layer boundaries, max lines) across the application.

## Strict Invariants
1. **Never Disable Strict Mode:** Do not alter `tsconfig.json` flags to suppress errors.
2. **No Suppression Comments:** Do NOT insert `// @ts-ignore`, `// @ts-expect-error`, or `// eslint-disable`.
3. **No Unchecked Any:** Avoid typing variables or props as `any`. Always use concrete interfaces or type narrowing.
4. **AST Guardrails:** All interactive elements must use design token primitives (no `<button>`, `<input>`); compound components must use dot-notation (`<Card.Header>`).

## Execution

1. **Run Level 1 Gate**
   Execute the structured runner:
   ```bash
   bash .agents/skills/frontend-typecheck/scripts/run_typecheck.sh
   ```
   Or run the CLI commands directly:
   ```bash
   npx tsc --noEmit && npx eslint .
   ```

2. **Parse Structured Diagnostics**
   The runner outputs a structured JSON report combining type errors and lint rule violations:
   ```json
   {
     "status": "failed",
     "typeErrors": [
       {
         "file": "src/components/UserProfile.tsx",
         "line": 42,
         "column": 15,
         "code": "TS2339",
         "message": "Property 'avatarUrl' does not exist on type 'User'."
       }
     ],
     "lintErrors": [
       {
         "file": "src/components/features/ProfileCard.tsx",
         "line": 14,
         "column": 5,
         "ruleId": "ui-guardrails/ban-raw-html-primitives",
         "message": "Raw <button> is prohibited. Import the standardized design token primitive from '@/components/ui/Button' instead."
       },
       {
         "file": "src/components/features/ProfileCard.tsx",
         "line": 22,
         "column": 9,
         "ruleId": "ui-guardrails/enforce-compound-subcomponents",
         "message": "Direct usage of flat subcomponent '<CardHeader>' is prohibited. Use the compound dot-notation '<Card.Header>' instead."
       }
     ],
     "totalErrors": 3
   }
   ```

3. **Self-Healing Instructions**
   - For `typeErrors`: Locate file and line, inspect interfaces, supply missing properties or handle nullability.
   - For `ban-raw-html-primitives`: Replace `<button>`, `<input>`, etc., with `<Button>`, `<Input>` from `@/components/ui/*`.
   - For `enforce-compound-subcomponents`: Replace `<CardHeader>` with `<Card.Header>`, `<DialogTitle>` with `<Dialog.Title>`.
   - For `boundaries/element-types`: Ensure `src/components/ui/` does not import from feature folders or pages.
   - For `max-lines`: Extract sub-components or move state/logic into a custom hook.
   - Re-run `bash .agents/skills/frontend-typecheck/scripts/run_typecheck.sh` to confirm resolution before advancing to Level 2 Verification.
