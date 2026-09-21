#!/usr/bin/env bash
set -uo pipefail

# Run Level 1 Verification Gate: TypeScript compiler (tsc --noEmit) + ESLint static analysis
echo "Running Level 1 Verification Gate: Typecheck (tsc --noEmit) & ESLint AST Guardrails..."

node -e '
const { execSync } = require("child_process");
const fs = require("fs");

const report = {
  status: "passed",
  typeErrors: [],
  lintErrors: [],
  totalErrors: 0
};

// 1. Run tsc --noEmit
try {
  execSync("npx tsc --noEmit", { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] });
} catch (error) {
  const stdout = error.stdout ? error.stdout.toString() : "";
  const stderr = error.stderr ? error.stderr.toString() : "";
  const fullOutput = stdout + "\n" + stderr;
  const lines = fullOutput.split("\n");
  const errorRegex = /^(.+?)\((\d+),(\d+)\):\s+error\s+(TS\d+):\s+(.+)$/;

  for (const line of lines) {
    const match = line.match(errorRegex);
    if (match) {
      report.typeErrors.push({
        file: match[1].trim(),
        line: parseInt(match[2], 10),
        column: parseInt(match[3], 10),
        code: match[4],
        message: match[5].trim()
      });
    }
  }
}

// 2. Run ESLint (if eslint is available or config exists)
const hasEslint = fs.existsSync("eslint.config.mjs") || fs.existsSync("eslint.config.js") || fs.existsSync(".eslintrc.json");
if (hasEslint) {
  try {
    const eslintOut = execSync("npx eslint . --format json", { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] });
    // Parse json output
    try {
      const results = JSON.parse(eslintOut);
      for (const res of results) {
        for (const msg of res.messages || []) {
          if (msg.severity >= 2) {
            report.lintErrors.push({
              file: res.filePath,
              line: msg.line,
              column: msg.column,
              ruleId: msg.ruleId,
              message: msg.message
            });
          }
        }
      }
    } catch (e) {}
  } catch (error) {
    const stdout = error.stdout ? error.stdout.toString() : "";
    try {
      const results = JSON.parse(stdout);
      for (const res of results) {
        for (const msg of res.messages || []) {
          if (msg.severity >= 2) {
            report.lintErrors.push({
              file: res.filePath,
              line: msg.line,
              column: msg.column,
              ruleId: msg.ruleId,
              message: msg.message
            });
          }
        }
      }
    } catch (e) {
      report.lintErrors.push({
        file: "unknown",
        line: 0,
        column: 0,
        ruleId: "eslint-execution-failure",
        message: stdout || (error.stderr ? error.stderr.toString() : error.message)
      });
    }
  }
}

report.totalErrors = report.typeErrors.length + report.lintErrors.length;
if (report.totalErrors > 0) {
  report.status = "failed";
}

console.log(JSON.stringify(report, null, 2));
process.exit(report.status === "passed" ? 0 : 1);
'
