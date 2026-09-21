// eslint.config.mjs
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import boundaries from "eslint-plugin-boundaries";
import { uiGuardrailsPlugin } from "./eslint-plugin-ui-guardrails.mjs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default [
  // Ignore build caches and artifacts
  {
    ignores: [
      ".next/**",
      "dist/**",
      "build/**",
      "node_modules/**",
      "playwright-report/**",
      "test-results/**",
    ],
  },

  // Base JS & Strict TypeScript configurations
  js.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,

  {
    languageOptions: {
      parserOptions: {
        project: "./tsconfig.json",
        tsconfigRootDir: __dirname,
      },
    },
    plugins: {
      boundaries,
      "ui-guardrails": uiGuardrailsPlugin,
    },
    settings: {
      "boundaries/elements": [
        {
          type: "ui-primitive",
          pattern: "src/components/ui/**",
          mode: "full",
        },
        {
          type: "feature-component",
          pattern: "src/components/features/**",
          mode: "full",
        },
        {
          type: "app-page",
          pattern: "src/app/**",
          mode: "full",
        },
        {
          type: "lib",
          pattern: "src/lib/**",
          mode: "full",
        },
      ],
      "boundaries/ignore": ["**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts"],
    },
    rules: {
      // 1. AST Custom Guardrail Rules
      "ui-guardrails/ban-raw-html-primitives": "error",
      "ui-guardrails/enforce-compound-subcomponents": "error",

      // 2. Structural Layer Boundaries
      "boundaries/entry-point": [
        "error",
        {
          default: "disallow",
          rules: [
            // Ensure UI components are imported from their index/root
            {
              target: ["ui-primitive"],
              allow: "*.(ts|tsx)",
            },
          ],
        },
      ],
      "boundaries/element-types": [
        "error",
        {
          default: "disallow",
          rules: [
            // UI Primitives cannot import from feature components or pages
            {
              from: ["ui-primitive"],
              allow: ["ui-primitive", "lib"],
            },
            // Feature components can import primitives and shared utils
            {
              from: ["feature-component"],
              allow: ["ui-primitive", "feature-component", "lib"],
            },
            // Pages can import features, primitives, and libs
            {
              from: ["app-page"],
              allow: ["feature-component", "ui-primitive", "lib"],
            },
            // Utils/Lib cannot import UI components
            {
              from: ["lib"],
              allow: ["lib"],
            },
          ],
        },
      ],

      // 3. Complexity & Invariant Limits for Agents
      "max-lines": [
        "error",
        {
          max: 180,
          skipBlankLines: true,
          skipComments: true,
        },
      ],
      "@typescript-eslint/no-explicit-any": "error",
      "@typescript-eslint/consistent-type-definitions": ["error", "interface"],
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
        },
      ],
    },
  },
];
