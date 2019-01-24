#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_ID="$1"

main() {
    tmux send-keys -t "${PANE_ID}" "$CURRENT_DIR/toggler.sh 'select_layout' '${PANE_ID}' 'default'" Enter
    return 0
}

main
