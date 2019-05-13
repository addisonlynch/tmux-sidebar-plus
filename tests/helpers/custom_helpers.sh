#! /usr/bin/env bash

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

get_pane_size(){
    local pane_id="$1"
    local pane_width=$(tmux list-panes | grep "$pane_id" | cut -d' ' -f2)
    echo "$pane_width"
}
