#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$(dirname "$CURRENT_DIR")"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"

source "$SCRIPTS_DIR/helpers.sh"
source "$SCRIPTS_DIR/variables.sh"
source "$CURRENT_DIR/helpers.sh"

PANE_ID="$1"
LAYOUT="$ROOT_DIR/layouts/$2"
COMMAND="bash -i"

source "$LAYOUT" # this can't be safe to do

window_exists() {
    local window_id="$(window_id)"
    tmux list-windows -F "#W" 2>/dev/null |
        grep -q "^${window_id}$"
}

kill_window() {
    local window_id="$(window_id)"
    tmux kill-window -t "${window_id}" || return 1
}

create_window() {
    local window_id="$(window_id)"
    tmux new-window -d -n "${window_id}"
    populate_window "$(window_id)"
}

main() {
    if window_exists; then
        kill_window
    else
        create_window
    fi
}
main
