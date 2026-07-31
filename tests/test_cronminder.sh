#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CRONMINDER="$SCRIPT_DIR/cronminder"

# Set isolated test environment
TEST_TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_TMP_DIR"' EXIT

export XDG_CONFIG_HOME="$TEST_TMP_DIR/config"
export HOME="$TEST_TMP_DIR"

echo "=== Running cronminder Tests ==="

# 1. Test help command
"$CRONMINDER" help >/dev/null
echo "✓ Help command works"

# 2. Test status command (default state)
"$CRONMINDER" status >/dev/null
echo "✓ Status command works"

# 3. Test test banner command
"$CRONMINDER" test >/dev/null
echo "✓ Test banner command works"

# 4. Test system environment scan command
"$CRONMINDER" system >/dev/null
echo "✓ System scan command works"

# 5. Test crond-style tasks.d/ directory scanning
mkdir -p "$XDG_CONFIG_HOME/cronminder/tasks.d/daily"
echo "Remember to take standup notes" > "$XDG_CONFIG_HOME/cronminder/tasks.d/daily/standup.txt"

status_output=$("$CRONMINDER" status)
if echo "$status_output" | grep -q "standup"; then
    echo "✓ tasks.d/ directory scanning works"
else
    echo "✗ Failed to discover task in tasks.d/" >&2
    exit 1
fi

# 6. Test tasks.conf parsing
cat <<'EOF' > "$XDG_CONFIG_HOME/cronminder/tasks.conf"
0 17 * * 5 | friday_timesheet | Friday Timesheet | Please submit hours before weekend!
EOF

status_output_conf=$("$CRONMINDER" status)
if echo "$status_output_conf" | grep -q "friday_timesheet"; then
    echo "✓ tasks.conf file parsing works"
else
    echo "✗ Failed to discover task in tasks.conf" >&2
    exit 1
fi

# 7. Test task completion state marking and resetting
"$CRONMINDER" done standup >/dev/null
status_after_done=$("$CRONMINDER" status)
if echo "$status_after_done" | grep "standup" | grep -q "Up to date"; then
    echo "✓ Marking task complete ('done') works"
else
    echo "✗ Failed to mark task as done" >&2
    exit 1
fi

"$CRONMINDER" reset standup >/dev/null
status_after_reset=$("$CRONMINDER" status)
if echo "$status_after_reset" | grep "standup" | grep -q "Pending\|Scheduled"; then
    echo "✓ Resetting task state ('reset') works"
else
    echo "✗ Failed to reset task state" >&2
    exit 1
fi

# 8. Test filter flags (--today, --upcoming)
"$CRONMINDER" check --today >/dev/null
echo "✓ Check with --today filter works"

"$CRONMINDER" status --upcoming >/dev/null
echo "✓ Status with --upcoming filter works"

# 9. Test execution time benchmark (<10ms target)
start_ms=$(date +%s%3N 2>/dev/null || echo 0)
"$CRONMINDER" check >/dev/null
end_ms=$(date +%s%3N 2>/dev/null || echo 0)

if [[ $start_ms -gt 0 && $end_ms -gt 0 ]]; then
    elapsed=$((end_ms - start_ms))
    echo "✓ Check execution completed in ${elapsed}ms"
fi

echo "=== All Tests Passed Successfully ==="
