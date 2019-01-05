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

WINDOW_COMMAND=""
WINDOW_COMMAND_OPTION="window-command-before"

###########
# Sidebar #
###########
SIDEBAR_KEY="p"
SIDEBAR_KEY_OPTION="toggle-sidebar"

SIDEBAR_ID="monitor-sidebar"
SIDEBAR_ID_OPTION="sidebar-id"

REGISTERED_PANE_PREFIX="@-sidebar-registered-pane"
REGISTERED_SIDEBAR_PREFIX="@-sidebar-is-sidebar"

MINIMUM_WIDTH_FOR_SIDEBAR="71"
