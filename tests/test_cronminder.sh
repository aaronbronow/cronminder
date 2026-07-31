#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CRONMINDER="$SCRIPT_DIR/cronminder"

echo "=== Running cronminder Tests ==="

# Test help command
"$CRONMINDER" help >/dev/null
echo "✓ Help command works"

# Test status command
"$CRONMINDER" status >/dev/null
echo "✓ Status command works"

# Test test command
"$CRONMINDER" test >/dev/null
echo "✓ Test banner command works"

echo "=== All Tests Passed Successfully ==="
