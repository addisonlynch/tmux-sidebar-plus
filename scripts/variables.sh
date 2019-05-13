##########
# Common #
##########
VAR_PREFIX="@-sidebar-plus"
KEY_SUFFIX="key"
SUPPORTED_TMUX_VERSION="1.9"

# used to save pane width before sidebar creation
BASE_PANE_WIDTH_OPTION="@-sidebar-parent-width"

###########
# Sidebar #
###########
SIDEBAR_KEY="b"
SIDEBAR_KEY_OPTION="sidebar-key"

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

LAYOUT_KEY="g"
SIDEBAR_LAYOUT_OPTION="layout-key"

CUSTOM_LAYOUTS_DIR_OPTION="custom-layouts-dir"

REGISTERED_LAYOUT_PREFIX="@-sidebar-layout-pane"
