---
name: frontend-scaffold-project
description: >-
  Use this skill to initialize or configure a modern frontend workspace using Next.js (App Router)
  or Vite + React, Strict TypeScript, Tailwind CSS, shadcn/ui, Vitest, Playwright, and ESLint AST Guardrails.
  Triggers on project initialization, workspace setup, or creating missing configuration profiles.
---

# Frontend Scaffold Project (`frontend_scaffold_project`)

This skill defines the procedures to scaffold deterministic frontend projects adhering to the Autonomous Frontend Engineering Loop specification and programmatic UI guardrails.

## Core Architectural Stack
- **Framework:** Next.js (App Router) or Vite + React
- **Language:** TypeScript in Strict Mode (ES2022, bundler resolution, noImplicitAny, strictNullChecks)
- **Styling & UI:** Tailwind CSS + shadcn/ui (Compound Radix primitives in `components/ui/`)
- **Static Analysis & Guardrails:** ESLint flat config with `eslint-plugin-boundaries` and custom AST `ui-guardrails`
- **Testing:** Vitest (unit/component testing) + Playwright (deterministic E2E testing)

## Directory Structure Standards
All projects must conform to the following directory layout:
```text
├── src/ (or app/)
│   ├── app/                 # Next.js App Router routes or page components
│   ├── components/
│   │   ├── features/        # Business feature components (importing from ui/ and lib/)
│   │   └── ui/              # shadcn/ui Radix UI compound primitives (Card.Header, Dialog.Title)
│   └── lib/                 # Shared utilities (cn helper, logic hooks)
├── tests/
│   ├── unit/                # Vitest unit and component tests
│   └── e2e/                 # Playwright E2E tests
├── tsconfig.json            # Strict TypeScript configuration
├── eslint.config.mjs        # Flat ESLint config with layer boundaries & complexity limits
├── eslint-plugin-ui-guardrails.mjs # AST rules banning raw HTML and enforcing compound subcomponents
├── playwright.config.ts     # Single-worker deterministic Playwright setup
├── tailwind.config.ts       # Tailwind styling tokens & shadcn theme
├── vitest.config.ts         # Fast unit runner with happy-dom
└── package.json
```

## Step-by-Step Execution

1. **Scaffold Directory Layout and Configs**
   Run the scaffold helper script or copy configs directly from `./resources`:
   ```bash
   bash .agents/skills/frontend-scaffold-project/scripts/scaffold.sh . [nextjs|vite]
   ```

2. **Verify Configuration Profiles**
   - Verify `tsconfig.json` matches [tsconfig.strict.json](./resources/tsconfig.strict.json):
     - `strict: true`, `noImplicitAny: true`, `strictNullChecks: true`, `noEmit: true`.
   - Verify `eslint.config.mjs` and `eslint-plugin-ui-guardrails.mjs` match [eslint.config.mjs](./resources/eslint.config.mjs) and [eslint-plugin-ui-guardrails.mjs](./resources/eslint-plugin-ui-guardrails.mjs).
   - Verify `playwright.config.ts` matches [playwright.config.ts](./resources/playwright.config.ts):
     - `retries: 0`, `workers: 1`, `baseURL: 'http://localhost:3000'`, JSON reporter configured.
   - Verify `tailwind.config.ts` and `vitest.config.ts` are present.

3. **Install Core Dependencies**
   Ensure essential devDependencies are declared:
   ```bash
   npm install -D typescript @types/node @types/react @types/react-dom tailwindcss postcss autoprefixer vitest @vitejs/plugin-react happy-dom @playwright/test eslint @eslint/js typescript-eslint eslint-plugin-boundaries
   ```

4. **Verify Typecheck & Lint Gate**
   Execute `npx tsc --noEmit` and `npx eslint .` to ensure the clean workspace passes without any compiler warnings or boundary violations.
