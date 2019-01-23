#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

source "$SCRIPTS_DIR/helpers.sh"
source "$SCRIPTS_DIR/variables.sh"


set_default_key_options() {
    local window_key="$(window_key)"
    local sidebar_key="$(sidebar_key)"

    set_tmux_option "${VAR_PREFIX}-${WINDOW_KEY_OPTION}-${KEY_SUFFIX}" "${window_key}"
    set_tmux_option "${VAR_PREFIX}-${SIDEBAR_KEY_OPTION}-${KEY_SUFFIX}" "${sidebar_key}"
    set_tmux_option "${ALL_PANES_PREFIX}" ""
}

set_key_bindings() {
    local stored_key_vars="$(stored_key_vars)"

    for option in $stored_key_vars; do
        value="$(get_value_from_option_name "$option")"
        tmux bind-key "$value" run-shell "$SCRIPTS_DIR/toggler.sh '$value' '#{pane_id}' 'git'"
    done
}

main() {
   set_default_key_options
   set_key_bindings
}
main
