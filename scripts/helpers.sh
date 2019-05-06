#!/usr/bin/env bash


######################
# GET/SET tmux options

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value
    option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}

unset_tmux_option() {
    local option=$1
    tmux set-option -gu "$option"
}

sidebar_key(){
    get_tmux_option "${VAR_PREFIX}-${SIDEBAR_KEY_OPTION}" "$SIDEBAR_KEY"
}

layout_key(){
    get_tmux_option "${VAR_PREFIX}-${SIDEBAR_LAYOUT_OPTION}" "$LAYOUT_KEY"
}

custom_layouts_dir() {
    get_tmux_option "${VAR_PREFIX}-$CUSTOM_LAYOUTS_DIR_OPTION" ""
}

##############
# tmux version

# function is used to get "clean" integer version number. Examples:
# `tmux 1.9` => `19`
# `1.9a`     => `19`
_get_digits_from_string() {
    local string="$1"
    local only_digits="$(echo "$string" | tr -dC '[:digit:]')"
    echo "$only_digits"
}

tmux_version_int() {
    local tmux_version_string=$(tmux -V)
    _get_digits_from_string "$tmux_version_string"
}

###########
# Utilities

get_pane_info() {
    local pane_id="$1"
    local format_strings="#{pane_id},$2"
    tmux list-panes -t "$pane_id" -F "$format_strings" |
        \grep "$pane_id" |
        cut -d',' -f2-
}

watched_dir_command() {
    local target="$1"
    local command="$2"

    tmux send-keys -t "${target}" "$__dir/update_dir.sh '${PANE_ID}' '${target}' '${command}'" Enter
}

select_base_pane() {
    tmux select-pane -t "${PANE_ID}"
}

##############
# tree helpers
##############

custom_tree_command="$__dir/custom_tree_command.sh"


command_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}
