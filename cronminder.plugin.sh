# Generic Bash / POSIX Shell Plugin Loader for cronminder
# Version: 1.0.0

_CRONMINDER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"

cronminder() {
    local script_path="$_CRONMINDER_DIR/cronminder"
    if [ ! -f "$script_path" ]; then
        echo "Error: cronminder executable not found at $script_path" >&2
        return 1
    fi
    "$script_path" "$@"
}

cronminder_check() {
    local script_path="$_CRONMINDER_DIR/cronminder"
    if [ -f "$script_path" ]; then
        "$script_path" check
    fi
}

if [ -z "${_CRONMINDER_RAN:-}" ]; then
    export _CRONMINDER_RAN=1
    cronminder_check
fi
