
######################
# GET/SET tmux options

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value
	option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

######################
# Handling stored options

stored_key_vars() {
	# Get currently stored gitplus tmux options
	tmux show-options -g |
		\grep -i "^${VAR_PREFIX}-" |
		cut -d ' ' -f1 |               # cut just the variable names
		xargs                          # splat var names in one line
}

get_value_from_option_name() {
	local option="$1"
	get_tmux_option "$option" ""
}

######################
# Dependency checks

glances_installed() {
	type -p "glances" > /dev/null
}

htop_installed() {
	type -p "htop" > /dev/null
}
