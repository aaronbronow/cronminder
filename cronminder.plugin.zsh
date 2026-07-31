# Oh My Zsh Plugin: cronminder
# Stateful scheduled task and backup reminders for Zsh / Oh My Zsh
# Version: 1.0.0

_CRONMINDER_DIR="${${(%):-%x}:A:h}"

function cronminder() {
    local script_path="$_CRONMINDER_DIR/cronminder"
    if [[ ! -f "$script_path" ]]; then
        echo "Error: cronminder executable not found at $script_path" >&2
        return 1
    fi
    "$script_path" "$@"
}

function cronminder_check() {
    local script_path="$_CRONMINDER_DIR/cronminder"
    if [[ -f "$script_path" && -o interactive ]]; then
        "$script_path" check
    fi
}

# Run check once per shell session if interactive
if [[ -z "$_CRONMINDER_RAN" ]]; then
    export _CRONMINDER_RAN=1
    cronminder_check
fi
