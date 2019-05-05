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
    get_tmux_option "$SIDEBAR_KEY_OPTION" "$SIDEBAR_KEY"
}

layout_key(){
    get_tmux_option "$SIDEBAR_LAYOUT_OPTION" "$LAYOUT_KEY"
}

custom_layouts_dir() {
    get_tmux_option "$CUSTOM_LAYOUTS_DIR_OPTION" ""
}

######################
# Handling stored options

stored_key_vars() {
    # Get currently stored sidebar-plus tmux options
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

##############
# tree helpers
##############

custom_tree_command="$CURRENT_DIR/custom_tree_command.sh"


command_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}

tree_command() {
    local user_command="$(tree_user_command)"
    if [ -n "$user_command" ]; then
        echo "$user_command"
    elif command_exists "tree"; then
        echo "$TREE_COMMAND"
    else
        echo "$custom_tree_command"
    fi
}

tree_user_command() {
    get_tmux_option "$TREE_COMMAND_OPTION" ""
}


# coloring utility
c_echo(){
    RED="\033[0;31m"
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color

    printf "${!1}${2} ${NC}\n"
}
