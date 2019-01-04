#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/window_helpers.sh"

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
    tmux new-window -d -n "${window_id}" || return 1
}

populate_window() {
    local window_id="$(window_id)"
    local window_command_before="$(window_command_before)"

    # run shell_command_before
    tmux select-window -t "${window_id}"
    tmux send-keys "${window_command_before}" Enter

    # check if glance exists
    if glances_installed; then
        populate_window_glances
    elif htop_installed; then
        populate_window_htop
    else
        populate_window_top
    fi
}

populate_window_glances() {
    local window_id="$(window_id)"
    tmux select-window -t "${window_id}"
    tmux send-keys -t "${window_id}" "glances" Enter
}

populate_window_top() {
    local window_id="$(window_id)"
    tmux select-window -t "${window_id}"
    tmux send-keys -t "${window_id}" "top" Enter
}

populate_window_htop() {
    local window_id="$(window_id)"
    tmux select-window -t "${window_id}"
    tmux send-keys -t "${window_id}" "htop" Enter
}

run_commands() {
    tmux send-keys -t 5 "top" Enter
}

main() {
    if window_exists; then
        kill_window
    else
        create_window
        populate_window
    fi
}
main
