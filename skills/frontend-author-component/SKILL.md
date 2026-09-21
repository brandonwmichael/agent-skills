---
name: frontend-author-component
description: >-
  Use this skill when authoring, refactoring, or generating React UI components.
  Enforces structural design patterns: Compound Components with dot-notation, Container/Presentational
  split with custom logic hooks, Polymorphic Slot composition (asChild), CVA variant typing,
  max-line limits (<=180 lines), and deterministic data-testid attributes.
---

# Frontend Author Component (`frontend_author_component`)

This skill defines the end-to-end authoring procedure for synthesizing UI components that deterministically adhere to project design patterns and programmatic AST guardrails.

## Pre-Authoring Checklist
Before writing a single line of code:
1. **Inspect Canonical Primitives:** Check `src/components/ui/` to see if suitable primitives (e.g. `Button`, `Card`, `Dialog`, `Input`, `Badge`) already exist.
2. **Determine Component Tier:**
   - **UI Primitive (`src/components/ui/`):** Purely presentational, atomic, highly reusable. Can use raw HTML within itself, must export compound namespaces if multi-part.
   - **Feature Component (`src/components/features/`):** Composes UI primitives. **Banned from using raw `<button>`, `<input>`**, must use dot-notation for compound subcomponents.
   - **Logic Hook (`src/lib/hooks/`):** Contains data fetching, state mutations, effects. TSX files consume hooks.

## Key Design Patterns Reference
See [design_patterns.md](./references/design_patterns.md) for full code examples:
- **Compound Dot-Notation:** `<Card.Header>`, `<Card.Title>`, `<Card.Content>`.
- **Container / View Separation:** TSX files have 0 side-effects; all mutations in `useXData()`.
- **Slot Composition:** Use `asChild` via `@radix-ui/react-slot`.
- **CVA Variant Typing:** Use `cva` for all styled variants.
- **Deterministic Selectors:** All interactive elements must declare `data-testid="<component-action>"`.
- **Max-Line Bound:** Keep file size strictly under 180 lines.

## Authoring Steps

1. **Write Logic Hook (if data/side-effects needed)**
   Create `src/lib/hooks/use<Feature>.ts` declaring state, fetchers, and return types.

2. **Compose Component TSX**
   - Import primitives: `import { Button } from "@/components/ui/button";`
   - Import compound component: `import { Card } from "@/components/ui/card";`
   - Use compound notation: `<Card.Header><Card.Title>...</Card.Title></Card.Header>`
   - Attach test IDs: `<Button data-testid="submit-btn">Submit</Button>`

3. **Verify with Level 1 Gate**
   Run the typecheck and AST lint gate:
   ```bash
   bash .agents/skills/frontend-typecheck/scripts/run_typecheck.sh
   ```
   Ensure 0 errors for `ui-guardrails/ban-raw-html-primitives`, `ui-guardrails/enforce-compound-subcomponents`, `max-lines`, and TypeScript compilation.
