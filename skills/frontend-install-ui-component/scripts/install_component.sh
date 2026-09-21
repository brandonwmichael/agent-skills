#!/usr/bin/env bash
set -euo pipefail

# Non-interactive shadcn/ui component installer with export validation
COMPONENT_NAME="${1:-}"

if [ -z "${COMPONENT_NAME}" ]; then
  echo "Error: Component name required (e.g. button, dialog, input, card)."
  exit 1
fi

echo "Adding shadcn/ui component: ${COMPONENT_NAME}..."

# Execute non-interactively
npx shadcn@latest add "${COMPONENT_NAME}" --yes --overwrite

# Determine target directory
UI_DIR="src/components/ui"
if [ ! -d "${UI_DIR}" ] && [ -d "components/ui" ]; then
  UI_DIR="components/ui"
fi

COMPONENT_FILE="${UI_DIR}/${COMPONENT_NAME}.tsx"

if [ ! -f "${COMPONENT_FILE}" ]; then
  echo "Error: Component file ${COMPONENT_FILE} not found after installation!"
  exit 1
fi

echo "Component file created at ${COMPONENT_FILE}."
# Verify exports
if grep -q "export " "${COMPONENT_FILE}"; then
  echo "Verified exports exist in ${COMPONENT_FILE}."
else
  echo "Warning: No explicit export statement found in ${COMPONENT_FILE}."
fi
