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

sidebar_key(){
    get_tmux_option "$SIDEBAR_KEY_OPTION" "$SIDEBAR_KEY"
}

window_key(){
    get_tmux_option "$WINDOW_KEY_OPTION" "$WINDOW_KEY"
}

window_id(){
    get_tmux_option "$WINDOW_ID_OPTION" "$WINDOW_ID"
}

window_command_before() {
    get_tmux_option "$WINDOW_COMMAND_OPTION" "$WINDOW_COMMAND"
}

######################
# Handling stored options

stored_key_vars() {
    # Get currently stored gitplus tmux options
    tmux show-options -g |
        \grep -i "^${VAR_PREFIX}-.*\-key" |
        cut -d ' ' -f1 |               # cut just the variable names
        xargs                          # splat var names in one line
}

get_value_from_option_name() {
    local option="$1"
    get_tmux_option "$option" ""
}

######################
# Dependency checks

glances_installed() {
    type -p "glances" > /dev/null
}

htop_installed() {
    type -p "htop" > /dev/null
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

    tmux send-keys -t "${target}" "$CURRENT_DIR/update_dir.sh '${PANE_ID}' '${target}' '${command}'" Enter
}

select_base_pane() {
    tmux select-pane -t "${PANE_ID}"
}
