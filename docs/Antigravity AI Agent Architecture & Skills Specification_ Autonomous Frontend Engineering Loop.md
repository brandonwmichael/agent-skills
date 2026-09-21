# **Antigravity AI Agent Architecture & Skills Specification**

# **Autonomous Frontend Engineering Loop**

## **1\. System Overview & Executive Summary**

This document defines the architectural blueprint and operational skill specifications required for an autonomous AI agent operating within the Antigravity IDE environment. The primary objective of this agent is to develop, test, debug, and verify frontend web applications autonomously, reliably, and deterministically.

&nbsp;

By utilizing a tightly constrained technology stack—Next.js / Vite \+ React, TypeScript (Strict Mode), Tailwind CSS, shadcn/ui, Vitest, and Playwright—the agent operates inside closed-loop feedback systems where compilation errors, type mismatches, unit assertion failures, and visual/E2E regressions are automatically captured, parsed, and self-healed without requiring human intervention.

## **2\. Technical Stack & Architectural Rationale**

### **2.1 Core Framework: Next.js (App Router) / Vite \+ React**

* **Why for Agents:** Next.js and Vite represent the highest density of synthetic and real-world code generation data in modern language models. File-based routing creates deterministic directory structures that an agent can traverse and generate predictably.  
* **Convention over Configuration:** Standard pathing (`app/`, `components/`, `lib/`, `tests/`) limits structural drift.

### **2.2 Language: TypeScript in Strict Mode (tsconfig.json)**

* **Deterministic Type Verification:** Compilers act as an automated validation step. The agent executes `tsc --noEmit` to get immediate compiler error codes (line numbers, expected vs received types) prior to runtime testing.  
* **Rules:** Prohibit `any` types; enforce strict null checks.

### **2.3 Design System & Styling: Tailwind CSS & shadcn/ui**

* **Locality of Behavior:** Tailwind colocates styling directly within TSX markup. The agent does not need to synchronize edits across separate CSS or SCSS stylesheets.  
* **Direct Source Injection:** `shadcn/ui` components reside directly in `components/ui/` as copy-paste Radix UI primitives. The agent has direct visibility into component implementation details rather than fighting opaque, packaged third-party runtime APIs.

### **2.4 Testing Infrastructure: Vitest & Playwright**

* **Vitest:** Ultra-fast, isolated component and utility testing with native ESM support and DOM simulation via `happy-dom` or `jsdom`.  
* **Playwright:** End-to-end automation engine capable of capturing structured test output, console errors, network telemetry, trace files, and visual snapshots for visual/DOM evaluation.

## **3\. Autonomous Execution & Self-Healing Loop**

The agent follows an iterative 5-phase loop for any engineering task:

&nbsp;

1. **Specification & Plan Generation:** Parse requirements, create task checklist, and identify dependencies. Scaffold components and declare required types first.  
2. **Code Synthesis:** Write or update TSX components using Tailwind CSS and shadcn/ui primitives. Ensure explicit TypeScript types for all component props, state values, and API payloads.  
3. **Level 1 Verification (Type & Lint Gate):** Execute `npx tsc --noEmit`. If errors exist, parse compiler output, localize faulty lines, and regenerate code before proceeding to runtime tests.  
4. **Level 2 Verification (Unit & Component Testing):** Execute `npx vitest run --reporter=json`. If assertions fail, inspect test diffs, pinpoint logic flaws in components or tests, and re-run.  
5. **Level 3 Verification (E2E & Visual Verification):** Execute `npx playwright test --reporter=json`. Capture DOM element states, screenshots, console logs, and network failures. Feed stack traces or image diffs back into context window to correct regressions.

## **4\. Antigravity IDE Skills Specification**

To execute this architecture, the Antigravity agent harness must implement the following modular tool skills:

&nbsp;

| Skill Identifier | Purpose | Primary Actions |
| :---- | :---- | :---- |
| `frontend_scaffold_project` | Initialize workspace | Create directory layout; write `package.json`, `tsconfig.json`, `tailwind.config.ts`. |
| `frontend_install_ui_component` | Add UI primitives | Execute `npx shadcn@latest add`; verify generated exports in `components/ui/`. |
| `frontend_typecheck` | Headless verification | Run `tsc --noEmit`; parse error stream into structured JSON for healing logic. |
| `frontend_run_unit_tests` | Fast logic validation | Run Vitest with JSON reporter; extract failing suite names and call stacks. |
| `frontend_run_e2e_tests` | Full workflow validation | Run Playwright; handle artifacts like screenshots and network traces on failure. |
| `frontend_diagnose_and_repair` | Self-healing logic | Map errors to source files; formulate targeted diffs; re-trigger verification. |

## **5\. Standardized Configuration Profiles**

### **5.1 Strict TypeScript Configuration (tsconfig.json)**

{

&nbsp;

&nbsp;&nbsp;"compilerOptions": {

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"target": "ES2022",

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"lib": \["dom", "dom.iterable", "esnext"\],

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"allowJs": false,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"skipLibCheck": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"strict": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noImplicitAny": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"strictNullChecks": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"strictFunctionTypes": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noImplicitThis": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"alwaysStrict": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noUnusedLocals": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noUnusedParameters": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noImplicitReturns": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noFallthroughCasesInSwitch": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"forceConsistentCasingInFileNames": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"noEmit": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"esModuleInterop": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"module": "esnext",

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"moduleResolution": "bundler",

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"resolveJsonModule": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"isolatedModules": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"jsx": "preserve",

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"incremental": true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"plugins": \[{ "name": "next" }\],

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;"paths": {

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"@/\*": \["./src/\*"\]

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;}

&nbsp;

&nbsp;&nbsp;},

&nbsp;

&nbsp;&nbsp;"include": \["next-env.d.ts", "\*\*/\*.ts", "\*\*/\*.tsx", ".next/types/\*\*/\*.ts"\],

&nbsp;

&nbsp;&nbsp;"exclude": \["node\_modules"\]

&nbsp;

}

### **5.2 Deterministic Playwright Configuration (playwright.config.ts)**

import { defineConfig, devices } from '@playwright/test';

&nbsp;

export default defineConfig({

&nbsp;

&nbsp;&nbsp;testDir: './tests/e2e',

&nbsp;

&nbsp;&nbsp;fullyParallel: true,

&nbsp;

&nbsp;&nbsp;forbidOnly: \!\!process.env.CI,

&nbsp;

&nbsp;&nbsp;retries: 0,

&nbsp;

&nbsp;&nbsp;workers: 1,

&nbsp;

&nbsp;&nbsp;reporter: \[\['json', { outputFile: 'test-results/results.json' }\], \['list'\]\],

&nbsp;

&nbsp;&nbsp;use: {

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;baseURL: 'http://localhost:3000',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;trace: 'retain-on-failure',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;screenshot: 'only-on-failure',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;video: 'off',

&nbsp;

&nbsp;&nbsp;},

&nbsp;

&nbsp;&nbsp;webServer: {

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;command: 'npm run dev',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;url: 'http://localhost:3000',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;reuseExistingServer: true,

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;timeout: 120000,

&nbsp;

&nbsp;&nbsp;},

&nbsp;

&nbsp;&nbsp;projects: \[

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;{

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;name: 'chromium',

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;use: { ...devices\['Desktop Chrome'\] },

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;},

&nbsp;

&nbsp;&nbsp;\],

&nbsp;

});

## **6\. Antigravity Agent Skill Guardrails & Invariants**

1. **Never Bypass Type Checking:** An agent must never disable `strict` mode or add `@ts-ignore` / `@ts-expect-error` comments to resolve compilation issues unless explicitly instructed.  
2. **Deterministic Selectors:** All generated interactive elements must include explicit accessibility attributes or deterministic test identifiers (`data-testid="..."`) to ensure Playwright locators never break due to cosmetic styling tweaks.  
3. **Bounded Iteration Count:** If an agent fails to resolve an issue after 3 successive build/test cycles, it must halt, summarize the unresolved error trace, and request human-in-the-loop triage.  
4. **Single-Responsibility Edits:** Modifications during repair cycles must directly address the compiler or test assertion output without refactoring unrelated modules.

&nbsp;