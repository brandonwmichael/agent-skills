# agent-skills

> **Autonomous Frontend Engineering Loop** — a portable set of AI agent skills for building, testing, and self-healing modern React frontends with zero human intervention in the happy path.

Compatible with **Antigravity IDE**, **Kiro IDE**, Claude Code, and any agent harness that supports the open [Agent Skills](https://kiro.dev/docs/skills) standard.

---

## What's Inside

Seven modular skills + one always-on guardrails rule that together implement a closed-loop, self-healing frontend engineering workflow:

| Skill | What It Does |
|---|---|
| `frontend-scaffold-project` | Initialize a Next.js or Vite + React workspace with strict TypeScript, Tailwind, shadcn/ui, Vitest, and Playwright |
| `frontend-install-ui-component` | Install `shadcn/ui` primitives and enforce compound namespace exports (`Card.Header`, `Dialog.Title`) |
| `frontend-typecheck` | Run `tsc --noEmit` + ESLint AST guardrails; emit structured JSON for agent self-healing |
| `frontend-run-unit-tests` | Run Vitest with JSON reporter; extract failing suites and assertion diffs |
| `frontend-run-e2e-tests` | Run Playwright; capture screenshots, traces, and structured failure output |
| `frontend-author-component` | Author React components following Compound, Container/Presentational, CVA, and Slot patterns |
| `frontend-diagnose-and-repair` | Orchestrate the full 5-phase self-healing loop across all verification gates |

**`rules/frontend-guardrails.md`** — always-on behavioral invariants enforced on every agent interaction.

---

## The 5-Phase Autonomous Loop

```
1. Specification & Plan    →  Parse requirements, scaffold types & interfaces
2. Code Synthesis          →  Write TSX using shadcn/ui primitives & design patterns
3. Level 1 Gate (Type+Lint)→  tsc --noEmit + ESLint AST rules   (auto-repair ≤ 3×)
4. Level 2 Gate (Unit)     →  vitest run                         (auto-repair ≤ 3×)
5. Level 3 Gate (E2E)      →  playwright test                    (auto-repair ≤ 3×)
```

If any gate can't be resolved within 3 repair cycles, the agent halts and hands off a structured triage report.

---

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Next.js (App Router) / Vite + React | Deterministic file-based structure; highest LLM training density |
| Language | TypeScript (Strict Mode) | Compiler errors = structured, parseable agent feedback |
| Styling & UI | Tailwind CSS + shadcn/ui | Collocated styles; source-injected primitives with full agent visibility |
| Unit Testing | Vitest + happy-dom | Fast, ESM-native, JSON-reportable |
| E2E Testing | Playwright | Screenshot + trace artifacts; deterministic `data-testid` locators |
| Linting | ESLint flat config + custom AST plugin | Bans raw HTML, enforces compound dot-notation, enforces layer boundaries |

---

## IDE Setup

### Antigravity IDE

See **[docs/setup-antigravity.md](./docs/setup-antigravity.md)** for the full guide.

**Quick install:**
```bash
mkdir -p .agents/skills .agents/rules
cp -r skills/frontend-* .agents/skills/
cp rules/frontend-guardrails.md .agents/rules/
```

Skills are discovered from `.agents/skills/`. Rules in `.agents/rules/` are always-on automatically.

---

### Kiro IDE

See **[docs/setup-kiro.md](./docs/setup-kiro.md)** for the full guide, including hook automation and steering file setup.

**Quick install:**
```bash
mkdir -p .kiro/skills .kiro/steering
cp -r skills/frontend-* .kiro/skills/
cp rules/frontend-guardrails.md .kiro/steering/frontend-guardrails.md

# Update internal script path references (.agents/ → .kiro/)
find .kiro/skills -name "SKILL.md" | xargs sed -i '' 's|.agents/skills/|.kiro/skills/|g'
```

Then prepend this frontmatter to `.kiro/steering/frontend-guardrails.md`:
```yaml
---
inclusion: always
---
```

---

## Guardrails (Always-On Rules)

The `frontend-guardrails.md` rule enforces five hard invariants on every agent interaction:

1. **No type bypasses** — `@ts-ignore`, `@ts-expect-error`, and weakening `tsconfig.json` strict flags are prohibited
2. **No raw HTML in feature components** — `<button>`, `<input>`, `<select>`, `<textarea>` must be replaced with design token primitives from `@/components/ui/*`
3. **Compound dot-notation** — `<Card.Header>` not `<CardHeader>`; enforced by a custom ESLint AST rule
4. **180-line ceiling** — components exceeding 180 lines trigger decomposition into hooks or subcomponents
5. **3-cycle repair limit** — after 3 failed fix attempts on any gate, the agent stops and requests human triage

---

## Repository Structure

```text
agent-skills/
├── rules/
│   └── frontend-guardrails.md
├── skills/
│   ├── frontend-author-component/
│   │   ├── SKILL.md
│   │   └── references/design_patterns.md
│   ├── frontend-diagnose-and-repair/
│   │   ├── SKILL.md
│   │   └── references/self_healing_protocol.md
│   ├── frontend-install-ui-component/
│   │   ├── SKILL.md
│   │   └── scripts/install_component.sh
│   ├── frontend-run-e2e-tests/
│   │   ├── SKILL.md
│   │   └── scripts/run_e2e_tests.sh
│   ├── frontend-run-unit-tests/
│   │   ├── SKILL.md
│   │   └── scripts/run_unit_tests.sh
│   ├── frontend-scaffold-project/
│   │   ├── SKILL.md
│   │   ├── resources/          # Canonical config files (tsconfig, eslint, playwright, etc.)
│   │   └── scripts/scaffold.sh
│   └── frontend-typecheck/
│       ├── SKILL.md
│       └── scripts/run_typecheck.sh
└── docs/
    ├── setup-antigravity.md
    ├── setup-kiro.md
    └── Antigravity AI Agent Architecture & Skills Specification_.md
```

---

## License

MIT