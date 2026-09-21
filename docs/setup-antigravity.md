# Autonomous Frontend Engineering Loop
## Setup Guide — Antigravity IDE

This guide explains how to install and use the **Autonomous Frontend Engineering Loop** skills inside [Antigravity IDE](https://antigravity.dev).

---

## What This Gives You

A set of AI agent skills that enable fully autonomous frontend development with:

- ✅ **Strict TypeScript** — type errors caught and self-healed before any runtime
- ✅ **Deterministic E2E tests** — Playwright with structured JSON output for agent feedback loops
- ✅ **AST-level guardrails** — custom ESLint rules that ban raw HTML and enforce compound component patterns
- ✅ **Bounded self-healing** — automatic repair with a 3-cycle limit before escalating to you

---

## How Skills Work in Antigravity

Antigravity discovers skills from two locations:

| Location | Scope |
|---|---|
| `~/.gemini/config/skills/` | Global — available in all workspaces |
| `.agents/skills/` | Workspace-local — checked into your project repo |

Each skill lives in its own directory and must contain a `SKILL.md` file with YAML frontmatter. The agent reads the `name` and `description` at startup and loads the full instructions only when the skill is relevant to your request.

---

## Installation

### Option A — Workspace-Local (Recommended)

Copy the skills directly into your project's `.agents/` directory so they're versioned alongside your code:

```bash
# From your project root
git clone https://github.com/brandonwmichael/agent-skills.git /tmp/agent-skills

mkdir -p .agents/skills .agents/rules

# Copy skills
cp -r /tmp/agent-skills/skills/frontend-author-component      .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-diagnose-and-repair   .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-install-ui-component  .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-run-e2e-tests         .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-run-unit-tests        .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-scaffold-project      .agents/skills/
cp -r /tmp/agent-skills/skills/frontend-typecheck             .agents/skills/

# Copy guardrails rule
cp /tmp/agent-skills/rules/frontend-guardrails.md .agents/rules/
```

### Option B — Global Installation

Install once and use across all your projects:

```bash
mkdir -p ~/.gemini/config/skills ~/.gemini/config/rules

cp -r /tmp/agent-skills/skills/frontend-* ~/.gemini/config/skills/
cp /tmp/agent-skills/rules/frontend-guardrails.md ~/.gemini/config/rules/
```

---

## Resulting Directory Structure

After installation, your `.agents/` directory should look like:

```text
.agents/
├── rules/
│   └── frontend-guardrails.md        # Always-on behavioral invariants
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

## Script Path Convention

All scripts reference each other using the `.agents/skills/` path prefix:

```bash
bash .agents/skills/frontend-typecheck/scripts/run_typecheck.sh
bash .agents/skills/frontend-run-unit-tests/scripts/run_unit_tests.sh
bash .agents/skills/frontend-run-e2e-tests/scripts/run_e2e_tests.sh
```

> **Note:** Always run these from your **project root** so the `.agents/` relative path resolves correctly.

---

## How Rules Work in Antigravity

Files in `.agents/rules/` are **always-on behavioral constraints** loaded into every agent interaction. `frontend-guardrails.md` enforces:

- No `@ts-ignore` or TypeScript suppression comments
- No raw `<button>`, `<input>`, etc. in feature components
- Compound dot-notation for UI components (`<Card.Header>`)
- Max 180 lines per component file
- 3-cycle repair limit before halting for human triage

---

## Using the Skills

The agent activates the appropriate skill automatically based on context. You can also invoke explicitly in chat:

| What you say | Skill activated |
|---|---|
| *"Scaffold a new Next.js project"* | `frontend-scaffold-project` |
| *"Add a shadcn Card component"* | `frontend-install-ui-component` |
| *"Build a user profile feature component"* | `frontend-author-component` |
| *"Run typechecking"* | `frontend-typecheck` |
| *"Run unit tests"* | `frontend-run-unit-tests` |
| *"Run E2E tests"* | `frontend-run-e2e-tests` |
| *"Fix the failing typecheck errors"* | `frontend-diagnose-and-repair` |

---

## Scaffold a New Project

```bash
# Next.js App Router
bash .agents/skills/frontend-scaffold-project/scripts/scaffold.sh . nextjs

# Vite + React
bash .agents/skills/frontend-scaffold-project/scripts/scaffold.sh . vite
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
