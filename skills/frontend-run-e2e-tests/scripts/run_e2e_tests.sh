#!/usr/bin/env bash
set -uo pipefail

# Run Playwright E2E tests with deterministic config and JSON reporter
RESULTS_DIR="test-results"
OUTPUT_FILE="${RESULTS_DIR}/results.json"
mkdir -p "${RESULTS_DIR}"

echo "Executing Level 3 Verification: Playwright E2E & visual tests..."

node -e '
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const resultsDir = "test-results";
const outputFile = path.join(resultsDir, "results.json");

try {
  execSync("npx playwright test --reporter=json", {
    encoding: "utf8",
    env: { ...process.env, PLAYWRIGHT_JSON_OUTPUT_NAME: outputFile },
    stdio: ["pipe", "pipe", "pipe"]
  });
  console.log(JSON.stringify({ status: "passed", outputFile }, null, 2));
  process.exit(0);
} catch (error) {
  let jsonOutput = null;
  if (fs.existsSync(outputFile)) {
    try {
      jsonOutput = JSON.parse(fs.readFileSync(outputFile, "utf8"));
    } catch (e) {}
  }

  const failures = [];
  if (jsonOutput && jsonOutput.suites) {
    function extractFailures(suite) {
      for (const spec of suite.specs || []) {
        for (const test of spec.tests || []) {
          for (const result of test.results || []) {
            if (result.status === "failed" || result.status === "timedOut") {
              const attachments = (result.attachments || []).map(a => ({
                name: a.name,
                path: a.path,
                contentType: a.contentType
              }));
              failures.push({
                title: spec.title,
                file: spec.file,
                line: spec.line,
                status: result.status,
                errors: result.errors || [],
                attachments: attachments
              });
            }
          }
        }
      }
      for (const childSuite of suite.suites || []) {
        extractFailures(childSuite);
      }
    }
    extractFailures(jsonOutput);
  }

  console.log(JSON.stringify({
    status: "failed",
    failureCount: failures.length,
    failures: failures,
    resultsFile: outputFile,
    rawStderr: error.stderr ? error.stderr.toString() : ""
  }, null, 2));
  process.exit(1);
}
'
