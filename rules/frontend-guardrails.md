# Autonomous Frontend Engineering Invariants & Guardrails

These rules enforce strict invariants and architectural design patterns for all frontend engineering, code synthesis, testing, and debugging operations within this repository.

## 1. Never Bypass Type Checking
- Under NO circumstances may the agent disable TypeScript `strict` mode in `tsconfig.json`.
- Do NOT insert `@ts-ignore`, `@ts-expect-error`, or `@ts-nocheck` comments to resolve compilation or type-checking issues unless explicitly instructed by the user.
- Prohibit `any` types; use explicit interfaces, type unions, generics, or `unknown` with narrowing.
- Enforce strict null checks and handle potential `null` or `undefined` values explicitly.

## 2. Deterministic Selectors & Locators
- All interactive and stateful elements (buttons, inputs, toggles, modals, links, cards) MUST include deterministic identifiers:
  - Explicit accessibility attributes (e.g. `role`, `aria-label`, `aria-expanded`).
  - Semantic test identifiers: `data-testid="<component-action>"` (e.g., `data-testid="submit-btn"`, `data-testid="filter-dropdown"`).
- Playwright tests and user interactions must target `data-testid` or standard accessible locators (`getByRole`, `getByTestId`), never brittle CSS classes or deep styling selectors.

## 3. Structural Design Patterns & UI Uniformity
- **Ban Raw Interactive HTML Elements:** Never use raw HTML elements (`<button>`, `<input>`, `<select>`, `<textarea>`) in application pages or feature components. Standardized design token primitives from `@/components/ui/*` (e.g. `<Button>`, `<Input>`) MUST be imported instead.
- **Enforce Compound Dot-Notation:** When consuming UI components with interdependent subcomponents (Card, Dialog, DropdownMenu, Sheet, Accordion), always use dot-notation namespacing (e.g. `<Card.Header>`, `<Card.Title>`, `<Dialog.Trigger>`) instead of flat imports (`<CardHeader>`).
- **Container / Presentational Separation (Logic Hooks):** Pure TSX components must act as declarative visual templates. Extract all data fetching, side-effects, and state mutations into dedicated custom hooks (e.g., `useMetricsData()`, `useUserProfile()`).
- **Slot & Polymorphic Composition (`asChild`):** Use Radix UI / shadcn style `asChild` composition to delegate container rendering without introducing nested wrapper elements or style collisions.
- **Variant Schema Typing via `cva`:** All visual variants (size, intent, color) must be typed schemas with Class Variance Authority. Never pass ad-hoc arbitrary utility strings (e.g. `text-[13px] bg-[#123456]`).
- **Complexity & Size Ceiling:** No single component file may exceed 180 lines (excluding blank lines and comments). Decompose large files into composable subcomponents or extract logic into hooks.
- **Reference Canonical Primitives First:** Before generating any new UI component, inspect existing primitives in `src/components/ui/` to align styling, prop interfaces, and export structures.
- **Single-Purpose Composition:** Newly synthesized components must have a single primary export and zero embedded data mutations outside custom hooks.

## 4. Bounded Iteration Count (3-Cycle Rule)
- During automated self-healing loops (typecheck, lint, unit tests, E2E tests):
  - Track iteration cycles for any single failing issue.
  - The maximum allowed number of successive repair iterations is **3 cycles**.
  - If the issue cannot be resolved within 3 iterations, HALT immediately.
  - Summarize the unresolved error trace, the attempted fixes, and request human-in-the-loop triage.

## 5. Single-Responsibility Edits
- When diagnosing and fixing compiler errors or test assertion failures:
  - Formulate targeted diffs addressing ONLY the specific failure.
  - Do NOT perform opportunistic refactoring or re-architecting of unrelated modules.
  - Preserve existing comments, docstrings, and non-targeted implementations.
