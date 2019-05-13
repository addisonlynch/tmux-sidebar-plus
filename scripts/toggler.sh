#!/usr/bin/env bash

__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
__root_dir="$(dirname "$__dir")"

ARG="$1"
PANE_ID="$2"
L="$3"
L_TYPE="$4"

set -v

source "${__dir}/helpers.sh"
source "${__dir}/variables.sh"

readonly POSITION="left"   # "right"

PANE_WIDTH="$(get_pane_info "$PANE_ID" "#{pane_width}")"
readonly PANE_CURRENT_PATH="$(get_pane_info "$PANE_ID" "#{pane_current_path}")"

readonly CUSTOM_LAYOUTS_DIR=$(custom_layouts_dir)

if [[ $L_TYPE == 'custom' ]]; then
    LAYOUT="${CUSTOM_LAYOUTS_DIR}/${L}"
else
    LAYOUT="$__root_dir/layouts/${L}"
fi
# Default minimum width
MINIMUM_WIDTH="${MINIMUM_WIDTH_FOR_SIDEBAR}"

source "${LAYOUT}" # this can't be safe to do

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
    [[ "${PANE_WIDTH}" -lt "${MINIMUM_WIDTH}" ]]
}

sidebar_left() {
    [[ "${POSITION}" =~ "left" ]]
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
    # registers the main pane of the sidebar to the sidebar
    set_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" "${sidebar_id}"
    # initialize the sidebar panes list
    set_tmux_option "${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_id}" ""
    # register pane to parent sidebar
    set_tmux_option "${PANE_PARENT_PREFIX}-${sidebar_id}" "${PANE_ID}"

    # register sidebar layout
    # only if layout is not select_layout
    if [ "${L}" != "select_layout" ]; then
        set_tmux_option "${REGISTERED_LAYOUT_PREFIX}-${PANE_ID}" "${L}"
    fi
    # add to list of all sidebar panes
    add_to_all_panes "${sidebar_id}"
}

add_to_all_panes() {
    # Adds sidebar panes to the list of all sidebar panes
    local pane_id="$1"
    local all_panes="$(get_tmux_option "${ALL_PANES_PREFIX}" "")"
    if [ -n "${all_panes}" ]; then
        all_panes+=" "
    fi
    all_panes+="${pane_id}"
    set_tmux_option "${ALL_PANES_PREFIX}" "${all_panes}"
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

    # register pane to sidebar's parent
    set_tmux_option "${PANE_PARENT_PREFIX}-${pane_id}" "${PANE_ID}"

    # add pane to list of all panes
    add_to_all_panes "${pane_id}"
}

desired_sidebar_size() {
    local half_pane="$((PANE_WIDTH / 2))"
    if [ -n "${SIZE}" ] && [ "${SIZE}" -lt "${half_pane}" ]; then
        echo "${SIZE}"
    else
        echo "${half_pane}"
    fi
}

use_inverted_size() {
    local tmux_version_int="$(tmux_version_int)"
    [ "${tmux_version_int}" -le 20 ]
}

no_focus() {
    if [[ "${FOCUS}" =~ (^focus) ]]; then
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
    local sidebar_id="$(tmux new-window -c "${PANE_CURRENT_PATH}" -P -F "#{pane_id}")"
    tmux join-pane -hb -l "${sidebar_size}" -t "${PANE_ID}" -s "${sidebar_id}"
    echo "${sidebar_id}"
}

split_sidebar_right() {
    local sidebar_size=$(desired_sidebar_size)
    tmux split-window -h -l "${sidebar_size}" -c "${PANE_CURRENT_PATH}" -P -F "#{pane_id}"
}

current_pane_width_not_changed() {
    if [ "${PANE_WIDTH}" -eq $1 ]; then
        return 0
    else
        return 1
    fi
}

kill_sidebar() {
    # get data before killing the sidebar
    local sidebar_pane_id="$(sidebar_pane_id)"
    # kill the sidebar's nested panes
    kill_child_panes
    # kill the sidebar
    tmux kill-pane -t "${sidebar_pane_id}"

    # check current pane "expanded" properly
    local new_current_pane_width="$(get_pane_info "${PANE_ID}" "#{pane_width}")"
    if current_pane_width_not_changed "${new_current_pane_width}"; then
        # need to expand current pane manually
        local direction_flag
        if [[ "${POSITION}" =~ "right" ]]; then
            direction_flag="-R"
        else
            direction_flag="-L"
        fi
        # compensate 1 column
        tmux resize-pane "${direction_flag}" "$((PANE_WIDTH + 1))"
    fi
    PANE_WIDTH="${new_current_pane_width}"

    # deregister the sidebar
    deregister_sidebar
}

deregister_sidebar() {
    local sidebar_pane_id="$(sidebar_pane_id)"

    unset_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}"
    unset_tmux_option "${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_pane_id}"
    unset_tmux_option "${PANE_PARENT_PREFIX}-${sidebar_pane_id}"
    # no need to remove from all-panes
}

deregister_pane() {
    local pane_id="$1"
    unset_tmux_option "${PANE_PARENT_PREFIX}-${pane_id}"
}

kill_child_panes() {
    local cp="$(get_child_panes)"
    local child_panes=($cp)
    for child_pane in "${child_panes[@]}"; do
        tmux kill-pane -t "${child_pane}"
        deregister_pane "${child_pane}"
    done
}

get_child_panes() {
    local sidebar_pane_id="$(sidebar_pane_id)"
    local child_panes="$(get_tmux_option "${SIDEBAR_PANES_LIST_PREFIX}-${sidebar_pane_id}" "")"
    echo "${child_panes}"
}


create_sidebar() {
    local position="$1" # left / right

    # check if has cached layout for select_layout
    if [ "${L}" = "select_layout" ]; then
        local cached_layout="$(get_cached_layout | tr -d ' ')"
        # if there is a cached layout
        if [ -n "${cached_layout// }" ] && [ "${cached_layout}" != "select_layout" ];
        then
           # open a sidebar with that layout
           $__dir/toggler.sh "sidebar" "${PANE_ID}" "${cached_layout}"
        else
            # open the default layout (directory tree)
            $__dir/toggler.sh "sidebar" "${PANE_ID}" "default"
        fi
        return
    fi
    local sidebar_id="$(split_sidebar_${position})"
    register_sidebar "${sidebar_id}"
    tmux last-pane
    populate_sidebar "${sidebar_id}"
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
    local main_pane_id="$(get_tmux_option "${PANE_PARENT_PREFIX}-${PANE_ID}" "")"
    # execute the same command as if from the "main" pane
    $__dir/toggler.sh "${ARG}" "${main_pane_id}" "${L}"
}

current_pane_is_sidebar() {
    local all_panes="$(get_tmux_option "${ALL_PANES_PREFIX}" "")"
    local retval=$(echo "${all_panes}" | grep "${PANE_ID}" | tr -d ' ')
    [ -n "${retval}" ]
}

split() {
    # simple splitter for either horizontal or vertical
    local pane_id="$1"
    local direction="${DIRECTION["$2"]}"

    local new_pane_id="$(tmux new-window -P -F "#{pane_id}" )"
    tmux join-pane "${direction}" -p 50 -t "${pane_id}" -s "${new_pane_id}"
    echo "${new_pane_id}"
}


sidebar() {
    if current_pane_is_sidebar; then
        execute_command_from_main_pane
    else
        toggle_sidebar
    fi
}

###################
# LAYOUT SELECTOR #
###################

get_cached_layout() {
    local pane_id="${PANE_ID}"
    local cached_layout="$(get_tmux_option "${REGISTERED_LAYOUT_PREFIX}-${pane_id}" "")"
    echo "${cached_layout}"
}

execute_main_and_switch() {
    local parent_id="$(get_tmux_option "${PANE_PARENT_PREFIX}-${PANE_ID}" "")"
    tmux send-keys -t "${parent_id}" "$__dir/toggler.sh 'select_layout' '${parent_id}' '${L}'" Enter
    tmux select-pane -t "${parent_id}"
}

select_layout() {
    if current_pane_is_sidebar; then
        execute_main_and_switch
    else
        select_menu
    fi
}

select_menu() {
    # TODO: refactor

    # Get all default layouts
    local DEFAULT_LAYOUTS=$(find "${__root_dir}/layouts" -type f -exec basename {} \;)

    local CUSTOM_LAYOUTS
    # If there is a custom layouts directory
    if [[ -n "${CUSTOM_LAYOUTS_DIR}" ]]; then
      # Add the layouts to the list
      CUSTOM_LAYOUTS=$(find "${CUSTOM_LAYOUTS_DIR}" -type f -exec basename {} \;)
    fi

    echo ""
    echo ""
    echo "Default layouts:"
    echo ""
    echo "${DEFAULT_LAYOUTS[@]}"
    if [[ -n $CUSTOM_LAYOUTS ]]; then
        echo ""
        echo "Custom Layouts:"
        echo ""
        echo "${CUSTOM_LAYOUTS[@]}"
    fi
    echo ""
    echo ""
    echo -n "Enter layout and press [ENTER]: "
    read -r layout
    local selected_layout="${layout}"
    local found_default_layout=0
    local found_custom_layout=0

    # check if selected layout is available in default layouts
    for l in $DEFAULT_LAYOUTS; do
        if [[ $l == $selected_layout ]]; then
            found_default_layout=1
        fi
    done

    # check if selected layout is available in custom layouts
    if [[ -n $CUSTOM_LAYOUTS ]]; then
        for l in $CUSTOM_LAYOUTS; do
            if [[ $l == $selected_layout ]]; then
                found_custom_layout=1
                found_default_layout=0
            fi
        done
    fi

    if [[ $found_custom_layout -eq 1 ]] || [[ $found_default_layout -eq 1 ]];
    then
        if has_sidebar; then
            kill_sidebar
        fi
        if [[ $found_custom_layout -eq 1 ]]; then
            $__dir/toggler.sh "sidebar" "${PANE_ID}" "${selected_layout}" "custom"
        else
            $__dir/toggler.sh "sidebar" "${PANE_ID}" "${selected_layout}" "d"
        fi
    else
        echo "ERROR: ${selected_layout} not found."
        exit 1
    fi
}


##############
# DELEGATION #
##############

main(){
    case "${ARG}" in
        'sidebar')
                sidebar
                return
                ;;
        'select_layout')
                select_layout
                return
                ;;
        *)
                echo "enter valid command. ${ARG} not valid."
                return 1
    esac
}
main
