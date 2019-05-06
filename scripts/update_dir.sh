#!/usr/bin/env bash

# Updates the directory of running watch commands to
# current directory of the base pane

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$(dirname "$CURRENT_DIR")"

BASE_ID="$1" # ID of base pane
CHILD_ID="$2"
COMMAND="$3" # command to watch

get_base_pane_dir() {
    tmux list-panes -F "#{pane_current_path} #{pane_id}" | grep $BASE_ID | cut -d' ' -f1
}

check_directory_match() {
    local base_pane_dir="$(get_base_pane_dir)"
    if [ "$base_pane_dir" == "$CURRENT_DIR" ]; then
        return
    else
        cd "$base_pane_dir"
        eval "${COMMAND}" 2>/dev/null || echo "Not a git repository"
    fi
}

main_loop() {
    while :
    do
        clear
        check_directory_match
        clear
        eval "${COMMAND}" 2>/dev/null || echo "Not a git repository"
        sleep 3
    done
}

main() {
    main_loop
}

main
