##########
# Common #
##########
VAR_PREFIX="@tmux-monitor"
KEY_SUFFIX="-key"
SUPPORTED_TMUX_VERSION="1.9"
GITPLUS_DIR="$HOME/.tmux/git-monitor"

##########
# Window #
##########
WINDOW_ID="toggle-monitor"
WINDOW_ID_OPTION="window-id"

WINDOW_KEY="o"
WINDOW_KEY_OPTION="toggle-window"

REGISTERED_WINDOW_PANE_PREFIX="@-window-registered-pane"
REGISTERED_WINDOW_PREFIX="@-window-is-window"
WINDOW_PANES_LIST_PREFIX="@-window-panes-window"

###########
# Sidebar #
###########
SIDEBAR_KEY="b"
SIDEBAR_KEY_OPTION="toggle-sidebar"

SIDEBAR_ID="monitor-sidebar"
SIDEBAR_ID_OPTION="sidebar-id"

REGISTERED_PANE_PREFIX="@-sidebar-registered-pane"
REGISTERED_SIDEBAR_PREFIX="@-sidebar-is-sidebar"


SIDEBAR_PANES_LIST_PREFIX="@-sidebar-panes-sidebar"

MINIMUM_WIDTH_FOR_SIDEBAR="40"

##########
# CONFIG #
##########

declare -A DIRECTION

DIRECTION=(
    [horizontal]="-h"
    [vertical]="-v"
)
