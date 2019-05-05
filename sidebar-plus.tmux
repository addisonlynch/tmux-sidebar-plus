#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

source "$SCRIPTS_DIR/helpers.sh"
source "$SCRIPTS_DIR/variables.sh"

set_default_key_options() {
    local sidebar_key="$(sidebar_key)"
    local layout_key="$(layout_key)"

    # Set sidebar key
    set_tmux_option "${VAR_PREFIX}-${SIDEBAR_KEY_OPTION}-${KEY_SUFFIX}" "${sidebar_key}"

    # Set layout selection key
    set_tmux_option "${VAR_PREFIX}-${SIDEBAR_LAYOUT_OPTION}-${KEY_SUFFIX}" "${layout_key}"
}

set_key_bindings() {
    tmux bind-key 'g' run-shell "$SCRIPTS_DIR/delegate.sh '#{pane_id}'"
    tmux bind-key 'b' run-shell "$SCRIPTS_DIR/toggler.sh 'sidebar' '#{pane_id}' 'select_layout'"
}

main() {
   set_default_key_options
   set_key_bindings
}
main
