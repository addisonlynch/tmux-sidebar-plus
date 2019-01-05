sidebar_key(){
    get_tmux_option "$SIDEBAR_KEY_OPTION" "$SIDEBAR_KEY"
}

sidebar_pane_id() {
    get_tmux_option "$SIDEBAR_ID_OPTION" "$SIDEBAR_ID"
}
