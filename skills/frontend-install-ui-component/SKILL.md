---
name: frontend-install-ui-component
description: >-
  Use this skill to install and verify shadcn/ui components (e.g., button, dialog, input, card, dropdown-menu).
  Triggers when new UI primitives or Radix UI components need to be added to the project.
---

# Frontend Install UI Component (`frontend_install_ui_component`)

This skill defines the procedures for adding `shadcn/ui` component primitives directly into the workspace source tree (`components/ui/` or `src/components/ui/`) with deterministic export verification and compound namespace packaging.

## Rationale: Direct Source Injection & Compound Packaging
- `shadcn/ui` components reside directly in the workspace repository as copy-paste Radix UI primitives. The agent has direct visibility into component implementation details, props, and variant definitions (`cva`).
- **Compound Packaging Invariant:** Whenever installing components with multiple subcomponents (e.g. `Card`, `Dialog`, `DropdownMenu`, `Sheet`, `Accordion`), the component file must export a compound namespace object using `Object.assign`. This ensures consuming code can use dot-notation (e.g., `<Card.Header>`, `<Dialog.Title>`), satisfying the `ui-guardrails/enforce-compound-subcomponents` AST rule.

## Execution Steps

1. **Install Component Non-Interactively**
   Run the installation helper script or invoke the CLI directly:
   ```bash
   bash .agents/skills/frontend-install-ui-component/scripts/install_component.sh <component_name>
   ```
   Or directly via npx:
   ```bash
   npx shadcn@latest add <component_name> --yes --overwrite
   ```

2. **Verify Compound Namespace Export**
   If the component has subcomponents (e.g., `CardHeader`, `CardTitle`, `DialogTrigger`), ensure the root component bundles them:
   ```tsx
   export const Card = Object.assign(CardRoot, {
     Header: CardHeader,
     Title: CardTitle,
     Description: CardDescription,
     Content: CardContent,
     Footer: CardFooter,
   });
   ```
   Also keep the named individual exports for backwards compatibility if needed, but ensure the compound object is exported as default or primary named export.

3. **Verify Dependencies**
   Ensure any peer dependencies (e.g. `@radix-ui/react-dialog`, `clsx`, `tailwind-merge`, `class-variance-authority`, `lucide-react`) were added to `package.json`.

4. **Verify TypeScript & Lint Compatibility**
   Run the Level 1 verification gate:
   ```bash
   bash .agents/skills/frontend-typecheck/scripts/run_typecheck.sh
   ```
