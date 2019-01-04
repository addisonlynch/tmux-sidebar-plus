window_key(){
    get_tmux_option "$WINDOW_OPTION" "$WINDOW_KEY"
}

window_id(){
    get_tmux_option "$WINDOW_ID_OPTION" "$WINDOW_ID"
}

window_command_before() {
    get_tmux_option "$WINDOW_COMMAND_OPTION" "$WINDOW_COMMAND"
}
