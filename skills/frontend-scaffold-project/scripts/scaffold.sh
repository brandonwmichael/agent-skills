#!/usr/bin/env bash
set -euo pipefail

# Scaffold project directory structure and configurations
TARGET_DIR="${1:-.}"
FRAMEWORK="${2:-nextjs}" # "nextjs" or "vite"

echo "Scaffolding frontend project in: ${TARGET_DIR} (framework: ${FRAMEWORK})"

mkdir -p "${TARGET_DIR}/src/components/ui"
mkdir -p "${TARGET_DIR}/src/components/features"
mkdir -p "${TARGET_DIR}/src/lib"
mkdir -p "${TARGET_DIR}/tests/unit"
mkdir -p "${TARGET_DIR}/tests/e2e"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="${SCRIPT_DIR}/../resources"

# Copy configs if they don't already exist
if [ ! -f "${TARGET_DIR}/tsconfig.json" ]; then
  cp "${RESOURCES_DIR}/tsconfig.strict.json" "${TARGET_DIR}/tsconfig.json"
  echo "Created tsconfig.json (Strict Mode)"
fi

if [ ! -f "${TARGET_DIR}/playwright.config.ts" ]; then
  cp "${RESOURCES_DIR}/playwright.config.ts" "${TARGET_DIR}/playwright.config.ts"
  echo "Created playwright.config.ts (Deterministic E2E)"
fi

if [ ! -f "${TARGET_DIR}/tailwind.config.ts" ]; then
  cp "${RESOURCES_DIR}/tailwind.config.ts" "${TARGET_DIR}/tailwind.config.ts"
  echo "Created tailwind.config.ts"
fi

if [ ! -f "${TARGET_DIR}/vitest.config.ts" ]; then
  cp "${RESOURCES_DIR}/vitest.config.ts" "${TARGET_DIR}/vitest.config.ts"
  echo "Created vitest.config.ts"
fi

if [ ! -f "${TARGET_DIR}/eslint-plugin-ui-guardrails.mjs" ]; then
  cp "${RESOURCES_DIR}/eslint-plugin-ui-guardrails.mjs" "${TARGET_DIR}/eslint-plugin-ui-guardrails.mjs"
  echo "Created eslint-plugin-ui-guardrails.mjs (AST Guardrails)"
fi

if [ ! -f "${TARGET_DIR}/eslint.config.mjs" ]; then
  cp "${RESOURCES_DIR}/eslint.config.mjs" "${TARGET_DIR}/eslint.config.mjs"
  echo "Created eslint.config.mjs (Flat Config with Boundaries & Guardrails)"
fi

if [ ! -f "${TARGET_DIR}/src/components/ui/card.tsx" ]; then
  cp "${RESOURCES_DIR}/card.compound.tsx" "${TARGET_DIR}/src/components/ui/card.tsx"
  echo "Created src/components/ui/card.tsx (Compound Component Canonical Example)"
fi

echo "Scaffold complete."
