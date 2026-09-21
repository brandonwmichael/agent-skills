#!/usr/bin/env bash
set -uo pipefail

# Run Vitest with JSON reporter and extract failing suites and stack traces
OUTPUT_FILE="${1:-test-results/vitest-results.json}"
mkdir -p "$(dirname "${OUTPUT_FILE}")"

echo "Executing Level 2 Verification: Vitest unit & component tests..."

node -e '
const { execSync } = require("child_process");
const fs = require("fs");

const outputFile = process.argv[1] || "test-results/vitest-results.json";

try {
  const stdout = execSync(`npx vitest run --reporter=json --outputFile=${outputFile}`, {
    encoding: "utf8",
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
  if (jsonOutput && jsonOutput.testResults) {
    for (const suite of jsonOutput.testResults) {
      for (const test of suite.assertionResults || []) {
        if (test.status === "failed") {
          failures.push({
            suite: suite.name,
            testName: test.fullName || test.title,
            messages: test.failureMessages || []
          });
        }
      }
    }
  }

  console.log(JSON.stringify({
    status: "failed",
    numFailedTests: failures.length,
    failures: failures,
    rawStderr: error.stderr ? error.stderr.toString() : "",
    outputFile
  }, null, 2));
  process.exit(1);
}
' "${OUTPUT_FILE}"
