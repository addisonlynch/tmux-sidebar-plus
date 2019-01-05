#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# ensure that an argument was passed
if [ $# -ne 3 ]; then
    echo "Script requires 3 arguments"
    exit 1
fi

ARG="$1"
PANE_ID="$2"
LAYOUT="$3"

main(){
    case "${ARG}" in
        'o')
                bash "$CURRENT_DIR/window/window.sh"
                return
                ;;
        'b')
                bash "$CURRENT_DIR/sidebar/toggle.sh" "${PANE_ID}" "${LAYOUT}"
                return
                ;;
        *)
                echo "enter valid command"
                return 1
    esac
}
main
