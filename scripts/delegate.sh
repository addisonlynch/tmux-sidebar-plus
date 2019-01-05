#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# ensure that an argument was passed
if [ $# -ne 2 ]; then
    echo "Script requires 2 arguments"
    exit 1
fi

ARG="$1"
PANE_ID="$2"

main(){
    case "${ARG}" in
        'o')
                bash "$CURRENT_DIR/window/window.sh"
                return
                ;;
        'b')
                bash "$CURRENT_DIR/sidebar/toggle.sh" "${PANE_ID}"
                return
                ;;
        *)
                echo "enter valid command"
                return 1
    esac
}
main
