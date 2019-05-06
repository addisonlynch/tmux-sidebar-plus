#! /usr/bin/env bash

__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_ID="$1"

source "$__dir/helpers.sh"
source "$__dir/variables.sh"

sidebar_registration() {
    get_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" ""
}

sidebar_exists() {
    local pane_id="$(sidebar_pane_id)"
    tmux list-panes -F "#{pane_id}" 2>/dev/null |
        \grep -q "^${pane_id}$"
}

sidebar_pane_id() {
    sidebar_registration |
        cut -d',' -f1
}

has_sidebar() {
    if [ -n "$(sidebar_registration)" ] && sidebar_exists; then
        return 0
    else
        return 1
    fi
}

main() {
    if has_sidebar; then
        tmux send-keys -t "${PANE_ID}" "$__dir/toggler.sh 'select_layout' '${PANE_ID}' 'default'" Enter
    fi
    return 0
}

main
