#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$CURRENT_DIR")"

source "$ROOT_DIR/helpers.sh"
source "$ROOT_DIR/variables.sh"
source "$CURRENT_DIR/helpers.sh"

ARGS=""
PANE_ID="$1"
COMMAND='top -c | sh -c "LESS= less --dumb --chop-long-lines --tilde --IGNORE-CASE --RAW-CONTROL-CHARS"'
POSITION="left"   # "right"

PANE_WIDTH="$(get_pane_info "$PANE_ID" "#{pane_width}")"
PANE_CURRENT_PATH="$(get_pane_info "$PANE_ID" "#{pane_current_path}")"

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

current_pane_too_narrow() {
    [ $PANE_WIDTH -lt $MINIMUM_WIDTH_FOR_SIDEBAR ]
}

sidebar_left() {
    [[ $POSITION =~ "left" ]]
}

has_sidebar() {
    if [ -n "$(sidebar_registration)" ] && sidebar_exists; then
        return 0
    else
        return 1
    fi
}

exit_if_pane_too_narrow() {
    if current_pane_too_narrow; then
        display_message "Pane too narrow for the sidebar"
        exit
    fi
}

register_sidebar() {
    # Stores the sidebar data as tmux options
    #
    local sidebar_id="$1"
    set_tmux_option "${REGISTERED_SIDEBAR_PREFIX}-${sidebar_id}" "$PANE_ID"
    set_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" "${sidebar_id},${ARGS}"
}

desired_sidebar_size() {
    local half_pane="$((PANE_WIDTH / 2))"
    if [ -n "$SIZE" ] && [ $SIZE -lt $half_pane ]; then
        echo "$SIZE"
    else
        echo "$half_pane"
    fi
}

use_inverted_size() {
    local tmux_version_int="$(tmux_version_int)"
    [ tmux_version_int -le 20 ]
}

no_focus() {
    if [[ $FOCUS =~ (^focus) ]]; then
        return 1
    else
        return 0
    fi
}

split_sidebar_left() {
    local sidebar_size=$(desired_sidebar_size)
    # if use_inverted_size; then
    #     sidebar_size=$((PANE_WIDTH - $sidebar_size - 1))
    # fi
    local sidebar_id="$(tmux new-window -c "$PANE_CURRENT_PATH" -P -F "#{pane_id}" "$COMMAND")"
    tmux join-pane -hb -l "$sidebar_size" -t "$PANE_ID" -s "$sidebar_id"
    echo "$sidebar_id"
}

split_sidebar_right() {
    echo "HELLO"
    local sidebar_size=$(desired_sidebar_size)
    tmux split-window -h -l "$sidebar_size" -c "$PANE_CURRENT_PATH" -P -F "#{pane_id}" "$COMMAND"
}

kill_sidebar() {
    # get data before killing the sidebar
    local sidebar_pane_id="$(sidebar_pane_id)"
    # kill the sidebar
    tmux kill-pane -t "$sidebar_pane_id"


    PANE_WIDTH="$new_current_pane_width"
}


create_sidebar() {
    local position="$1" # left / right
    local sidebar_id="$(split_sidebar_${position})"
    register_sidebar "$sidebar_id"
    if no_focus; then
        tmux last-pane
    fi
}

toggle_sidebar() {
    if sidebar_exists; then
        kill_sidebar
        # if using different sidebar command automatically open a new sidebar
        # if registration_not_for_the_same_command; then
        #   create_sidebar
        # fi
    else
        exit_if_pane_too_narrow
        if sidebar_left; then
            create_sidebar "left"
        else
            create_sidebar "right"
        fi
    fi
}

execute_command_from_main_pane() {
    # get pane_id for this sidebar
    local main_pane_id="$(get_tmux_option "${REGISTERED_SIDEBAR_PREFIX}-${PANE_ID}" "")"
    # execute the same command as if from the "main" pane
    $CURRENT_DIR/toggle.sh "$ARGS" "$main_pane_id"
}

current_pane_is_sidebar() {
    local var="$(get_tmux_option "${REGISTERED_SIDEBAR_PREFIX}-${PANE_ID}" "")"
    [ -n "$var" ]
}

main() {
    if current_pane_is_sidebar; then
        execute_command_from_main_pane
    else
        toggle_sidebar
    fi
}
main
