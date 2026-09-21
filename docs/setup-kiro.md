# Autonomous Frontend Engineering Loop
## Setup Guide — Kiro IDE

This guide explains how to install and use the **Autonomous Frontend Engineering Loop** skills inside [Kiro IDE](https://kiro.dev).

---

## What This Gives You

A set of AI agent skills that enable fully autonomous frontend development with:

- ✅ **Strict TypeScript** — type errors caught and self-healed before any runtime
- ✅ **Deterministic E2E tests** — Playwright with structured JSON output for agent feedback loops
- ✅ **AST-level guardrails** — custom ESLint rules that ban raw HTML and enforce compound component patterns
- ✅ **Bounded self-healing** — automatic repair with a 3-cycle limit before escalating to you

---

## How Skills Work in Kiro

Kiro organizes agent customization across several directories under `.kiro/`:

| Directory | Purpose |
|---|---|
| `.kiro/skills/` | Modular skills loaded on demand |
| `.kiro/steering/` | Always-on rules and behavioral constraints |
| `.kiro/hooks/` | Event-driven automation (e.g., run lint on save) |

Skills use the same open `SKILL.md` format as other AI coding tools (Claude Code, Cursor, Antigravity). Kiro reads the `name` and `description` at startup and only loads the full instructions when your request matches — keeping the context window lean.

---

## Installation

### Option A — Workspace-Local (Recommended)

Copy the skills into your project's `.kiro/` directory so they're versioned alongside your code:

```bash
# From your project root
git clone https://github.com/brandonwmichael/agent-skills.git /tmp/agent-skills

mkdir -p .kiro/skills .kiro/steering

# Copy skills
cp -r /tmp/agent-skills/skills/frontend-author-component      .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-diagnose-and-repair   .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-install-ui-component  .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-run-e2e-tests         .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-run-unit-tests        .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-scaffold-project      .kiro/skills/
cp -r /tmp/agent-skills/skills/frontend-typecheck             .kiro/skills/

# Convert the guardrails rule → Kiro steering file
cp /tmp/agent-skills/rules/frontend-guardrails.md .kiro/steering/frontend-guardrails.md
```

Then add the required Kiro frontmatter to the steering file (see [Steering Setup](#steering-setup) below).

### Option B — Global Installation

Install once and use across all your projects:

```bash
mkdir -p ~/.kiro/skills

cp -r /tmp/agent-skills/skills/frontend-* ~/.kiro/skills/
```

> **Note:** Global steering files go in `~/.kiro/steering/`.

---

## Resulting Directory Structure

```text
.kiro/
├── steering/
│   └── frontend-guardrails.md        # Always-on behavioral invariants
├── hooks/
│   └── typecheck-on-save.json        # Optional: auto-run typecheck after edits
└── skills/
    ├── frontend-author-component/
    │   ├── SKILL.md
    │   └── references/design_patterns.md
    ├── frontend-diagnose-and-repair/
    │   ├── SKILL.md
    │   └── references/self_healing_protocol.md
    ├── frontend-install-ui-component/
    │   ├── SKILL.md
    │   └── scripts/install_component.sh
    ├── frontend-run-e2e-tests/
    │   ├── SKILL.md
    │   └── scripts/run_e2e_tests.sh
    ├── frontend-run-unit-tests/
    │   ├── SKILL.md
    │   └── scripts/run_unit_tests.sh
    ├── frontend-scaffold-project/
    │   ├── SKILL.md
    │   ├── resources/
    │   └── scripts/scaffold.sh
    └── frontend-typecheck/
        ├── SKILL.md
        └── scripts/run_typecheck.sh
```

---

## Steering Setup

Kiro uses **steering files** instead of a `rules/` directory. After copying the guardrails file, add YAML frontmatter to the top to tell Kiro when to load it.

**`.kiro/steering/frontend-guardrails.md`** — prepend this frontmatter:

```yaml
---
inclusion: always
---
```

> `inclusion: always` means these guardrails are injected into **every** agent interaction — equivalent to how Antigravity loads all files in `.agents/rules/` automatically.

For file-type-specific loading (e.g., only when editing TypeScript files), use:

```yaml
---
inclusion: fileMatch
fileMatchPattern: "**/*.{ts,tsx}"
---
```

---

## Script Path Convention

> ⚠️ **Important difference from Antigravity:** The skills' internal script references use `.agents/skills/` paths (the Antigravity convention). In Kiro, you need to update these to `.kiro/skills/`.

After copying, update the path prefix in any scripts that reference other skills:

```bash
# Find all cross-skill script references and update the path
find .kiro/skills -name "SKILL.md" | xargs sed -i '' 's|.agents/skills/|.kiro/skills/|g'
```

After this, scripts will correctly resolve from project root:

```bash
bash .kiro/skills/frontend-typecheck/scripts/run_typecheck.sh
bash .kiro/skills/frontend-run-unit-tests/scripts/run_unit_tests.sh
bash .kiro/skills/frontend-run-e2e-tests/scripts/run_e2e_tests.sh
```

---

## Optional: Automate with Kiro Hooks

Kiro's **hooks** let you trigger skills or shell commands on IDE events. For example, automatically run the Level 1 typecheck gate whenever the agent saves a TypeScript file:

**`.kiro/hooks/typecheck-on-save.json`**
```json
{
  "name": "Typecheck on Save",
  "trigger": "PostFileSave",
  "matcher": "\\.(ts|tsx)$",
  "action": {
    "type": "command",
    "command": "bash .kiro/skills/frontend-typecheck/scripts/run_typecheck.sh"
  }
}
```

Other useful hooks:

```json
{
  "name": "Unit Tests After Component Edit",
  "trigger": "PostFileSave",
  "matcher": "src/components/**/*.tsx",
  "action": {
    "type": "command",
    "command": "bash .kiro/skills/frontend-run-unit-tests/scripts/run_unit_tests.sh"
  }
}
```

---

## Using the Skills

Invoke skills by describing your task in the Kiro chat, or use the slash command:

| What you say / type | Skill activated |
|---|---|
| *"Scaffold a new Next.js project"* or `/frontend-scaffold-project` | `frontend-scaffold-project` |
| *"Add a shadcn Card component"* or `/frontend-install-ui-component` | `frontend-install-ui-component` |
| *"Build a user profile feature component"* or `/frontend-author-component` | `frontend-author-component` |
| *"Run typechecking"* or `/frontend-typecheck` | `frontend-typecheck` |
| *"Run unit tests"* or `/frontend-run-unit-tests` | `frontend-run-unit-tests` |
| *"Run E2E tests"* or `/frontend-run-e2e-tests` | `frontend-run-e2e-tests` |
| *"Fix the failing typecheck errors"* or `/frontend-diagnose-and-repair` | `frontend-diagnose-and-repair` |

---

## Scaffold a New Project

```bash
# Next.js App Router
bash .kiro/skills/frontend-scaffold-project/scripts/scaffold.sh . nextjs

# Vite + React
bash .kiro/skills/frontend-scaffold-project/scripts/scaffold.sh . vite
```

---

## The 5-Phase Autonomous Loop

```
1. Specification & Plan    →  Parse requirements, scaffold types
2. Code Synthesis          →  Write TSX using shadcn/ui primitives
3. Level 1 Gate (Type+Lint)→  tsc --noEmit + eslint  (auto-repair ≤ 3x)
4. Level 2 Gate (Unit)     →  vitest run              (auto-repair ≤ 3x)
5. Level 3 Gate (E2E)      →  playwright test         (auto-repair ≤ 3x)
```

If any gate fails after 3 repair attempts, the agent halts and presents a triage report.

---

## Compatibility Notes

| Feature | Antigravity | Kiro |
|---|---|---|
| `SKILL.md` format | ✅ Same open standard | ✅ Same open standard |
| Skill directory | `.agents/skills/` | `.kiro/skills/` |
| Always-on rules | `.agents/rules/*.md` | `.kiro/steering/` with `inclusion: always` |
| File-match rules | Not supported (all rules are always-on) | `.kiro/steering/` with `inclusion: fileMatch` |
| Event automation | Not supported natively | `.kiro/hooks/*.json` |
| Slash command invocation | Not supported | ✅ `/skill-name` |
| Global skill path | `~/.gemini/config/skills/` | `~/.kiro/skills/` |
