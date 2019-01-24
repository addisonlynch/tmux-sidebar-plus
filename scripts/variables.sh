##########
# Common #
##########
VAR_PREFIX="@-sidebar-plus"
KEY_SUFFIX="key"
SUPPORTED_TMUX_VERSION="1.9"

##########
# Window #
##########
WINDOW_ID="toggle-monitor"
WINDOW_ID_OPTION="window-id"

WINDOW_KEY="o"
WINDOW_KEY_OPTION="sidebar-plus-window"

REGISTERED_WINDOW_PANE_PREFIX="@-window-registered-pane"
REGISTERED_WINDOW_PREFIX="@-window-is-window"
WINDOW_PANES_LIST_PREFIX="@-window-panes-window"

###########
# Sidebar #
###########
SIDEBAR_KEY="b"
SIDEBAR_KEY_OPTION="sidebar-plus-sidebar"

SIDEBAR_ID="sidebar"
SIDEBAR_ID_OPTION="sidebar-id"

REGISTERED_PANE_PREFIX="@-sidebar-registered-pane"

ALL_PANES_PREFIX="@-sidebar-all-panes"
SIDEBAR_PANES_LIST_PREFIX="@-sidebar-panes-sidebar"

PANE_PARENT_PREFIX="@-sidebar-parent"

MINIMUM_WIDTH_FOR_SIDEBAR="40"

##########
# CONFIG #
##########

declare -A DIRECTION

DIRECTION=(
    [horizontal]="-h"
    [vertical]="-v"
)

###########
# Layouts #
###########

CUSTOM_LAYOUTS_DIR_OPTION="custom-layouts-dir"

REGISTERED_LAYOUT_PREFIX="@-sidebar-layout-pane"
