#!/usr/bin/env bash

# ensure that an argument was passed
if [ $# -ne 3 ]; then
    echo "Script requires 3 arguments"
    exit 1
fi

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$CURRENT_DIR")"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"


ARG="$1"
PANE_ID="$2"
LAYOUT="$ROOT_DIR/layouts/$3"
COMMAND='bash -i'

source "${LAYOUT}" # this can't be safe to do

POSITION="left"   # "right"

PANE_WIDTH="$(get_pane_info "$PANE_ID" "#{pane_width}")"
PANE_CURRENT_PATH="$(get_pane_info "$PANE_ID" "#{pane_current_path}")"

###########
# SIDEBAR #
###########

# Derived from tmux-sidebar
# source: https://github.com/tmux-plugins/tmux-sidebar

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
    [ "${PANE_WIDTH}" -lt "${MINIMUM_WIDTH_FOR_SIDEBAR}" ]
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
        echo "Pane too narrow for the sidebar"
        exit
    fi
}

register_sidebar() {
    # Stores the sidebar data as tmux options
    #
    local sidebar_id="$1"
    # register the sidebar to the original pane
    set_tmux_option "${REGISTERED_SIDEBAR_PREFIX}-${sidebar_id}" "$PANE_ID"
    # registers the main pane of the sidebar to the sidebar
    set_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" "${sidebar_id}"
    # initialize the sidebar panes list
    set_tmux_option "${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_id}" ""
}

register_pane() {
    local sidebar_id="$1"
    local pane_id="$2"
    local option="${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_id}"
    local panes_list="$(get_tmux_option "${option}" "")"
    if [ -n "${panes_list}" ]; then
        panes_list+=" "
    fi
    panes_list+="${pane_id}"
    set_tmux_option "${option}" "${panes_list}"
}

desired_sidebar_size() {
    local half_pane="$((PANE_WIDTH / 2))"
    if [ -n "$SIZE" ] && [ "$SIZE" -lt "$half_pane" ]; then
        echo "$SIZE"
    else
        echo "$half_pane"
    fi
}

use_inverted_size() {
    local tmux_version_int="$(tmux_version_int)"
    [ "$tmux_version_int" -le 20 ]
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
    local sidebar_size=$(desired_sidebar_size)
    tmux split-window -h -l "$sidebar_size" -c "$PANE_CURRENT_PATH" -P -F "#{pane_id}" "$COMMAND"
}

kill_sidebar() {
    # get data before killing the sidebar
    local sidebar_pane_id="$(sidebar_pane_id)"
    # kill the sidebar's nested panes
    kill_child_panes
    # kill the sidebar
    tmux kill-pane -t "$sidebar_pane_id"
}

kill_child_panes() {
    local cp="$(get_child_panes)"
    local child_panes=($cp)
    for child_pane in "${child_panes[@]}"; do
        tmux kill-pane -t "$child_pane"
    done

}

get_child_panes() {
    local sidebar_pane_id="$(sidebar_pane_id)"
    local child_panes="$(get_tmux_option "${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_pane_id}" "")"
    echo $child_panes
}


create_sidebar() {
    local position="$1" # left / right
    local sidebar_id="$(split_sidebar_${position})"
    register_sidebar "$sidebar_id"
    tmux last-pane
    populate_sidebar "$sidebar_id"
    # if no_focus; then
    #     tmux last-pane
    # fi
}

toggle_sidebar() {
    if has_sidebar; then
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

split() {
    # simple splitter for either horizontal or vertical
    local pane_id="$1"
    local direction="${DIRECTION["$2"]}"

    local new_pane_id="$(tmux new-window -P -F "#{pane_id}" "$COMMAND")"
    tmux join-pane "$direction" -p 50 -t "$pane_id" -s "$new_pane_id"
    echo "$new_pane_id"
}


sidebar() {
    if current_pane_is_sidebar; then
        execute_command_from_main_pane
    else
        toggle_sidebar
    fi
}

##########
# WINDOW #
##########

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

window() {
    if window_exists; then
        kill_window
    else
        create_window
    fi
}

##############
# DELEGATION #
##############

main(){
    case "${ARG}" in
        'o')
                window
                return
                ;;
        'b')
                sidebar
                return
                ;;
        *)
                echo "enter valid command"
                return 1
    esac
}
main
