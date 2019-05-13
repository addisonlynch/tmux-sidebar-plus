#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname $CURRENT_DIR)"

# bash helpers provided by 'tmux-test'
source $CURRENT_DIR/helpers/helpers.sh
source $CURRENT_DIR/helpers/custom_helpers.sh

# tmux-sidebar variables
source $ROOT_DIR/scripts/variables.sh

# installs plugin from current repo in Vagrant (or on Travis)
install_tmux_plugin_under_test_helper

# start tmux in background (plugin under test is sourced)
tmux new -d


test_key_bindings() {
  local default_sidebar_key="${SIDEBAR_KEY}"
  local default_layout_key="${LAYOUT_KEY}"
  local sidebar_key=$(get_tmux_option "@-sidebar-plus-sidebar-key")
  local layout_key=$(get_tmux_option "@-sidebar-plus-layout-key")

  # Layout key
  if [ "$layout_key" != $default_layout_key ]; then
      # fail_helper is also provided by 'tmux-test'
      fail_helper "Default layout key is ${default_layout_key}. Layout set to
                   ${layout_key}."
  fi

  # Sidebar key
  if [ "$sidebar_key" != $default_sidebar_key ]; then
      fail_helper "Default layout key is ${default_sidebar_key}. Layout set to
                   ${sidebar_key}."
  fi

}


test_open_sidebar() {
  local pane_size_before=$(get_pane_size "%0")

  # open the sidebar
  bash $ROOT_DIR/scripts/toggler.sh "sidebar" "%0" "default" "default"

  local all_panes=$(get_tmux_option "${ALL_PANES_PREFIX}")
  local sidebar_parent=$(get_tmux_option "${PANE_PARENT_PREFIX}-%1")
  local sidebar_layout=$(get_tmux_option "${REGISTERED_LAYOUT_PREFIX}-%0")

  # ensure sidebar panes are added to all_panes
  if [ "$all_panes" != "%1" ]; then
    fail_helper "Sidebar pane %1 not registered in all-panes"
  fi

  # ensure sidebar parent is registered
  if [ "$sidebar_parent" != "%0" ]; then
    fail_helper "Sidebar pane %1 not listed as parent of %0"
  fi

  # ensure default layout is registered for sidebar
  if [ "$sidebar_layout" != "default" ]; then
    fail_helper "Default layout not registered to sidebar pane %1"
  fi
}


test_key_bindings
test_open_sidebar

# sets the right script exit code ('tmux-test' helper)
exit_helper
