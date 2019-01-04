#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ensure that an argument was passed
if [ $# -ne 1 ]; then
    echo "Script requires 1 argument"
    exit 1
fi

ARG="$1"

case "${ARG}" in
    'o')
            bash "$CURRENT_DIR/window.sh"
            ;;
    *)
            echo "enter valid command"
            exit 1
esac

