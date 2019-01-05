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
SIDEBAR_KEY="b"
SIDEBAR_KEY_OPTION="toggle-sidebar"

SIDEBAR_ID="monitor-sidebar"
SIDEBAR_ID_OPTION="sidebar-id"

REGISTERED_PANE_PREFIX="@-sidebar-registered-pane"
REGISTERED_SIDEBAR_PREFIX="@-sidebar-is-sidebar"
SIDEBAR_PANES_LIST_PREFIX="@-sidebar-panes-sidebar"

MINIMUM_WIDTH_FOR_SIDEBAR="80"

##########
# CONFIG #
##########

# Git
declare -A GIT_CONFIG

LAYOUT='1'
PAGE="no"
WATCH="yes"
COMMAND_1='top -c'
COMMAND_2='git status'
COMMAND_3='git log --all --decorate --oneline --graph'


###########
# LAYOUTS #
###########

# Layout 1
declare -A LAYOUT_1
LAYOUT_1["panes"]=3
LAYOUT_1=
