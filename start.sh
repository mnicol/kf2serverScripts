# Script to start a kf server. If the server is already running it will restart it

########## Config ##########
TMUX_SERVER_NAME="kf_server"
DEFAULT_MAP="startBioticsLab.sh"

# Prompt what to do
echo "Select what you want to do:"
echo "\t0: Start Server"
echo "\t1: Stop Server"
echo "\t2: Restart"
echo "\t3: List active servers"
echo "\t4: Quit"

read USER_CHOICE

case $USER_CHOICE in
	0 ) date +"%R: Starting Server"
		is_server_running
		if ((!$)); then
			start_server
			exit 1
		fi
		while (($)); do
			echo -n  "The server is already running. Do you want to RESTART it [Y/n]:"
			read SHOULD_RESTART

			if (("$SHOULD_RESTART" == "Y")); then
				restart_server
			elif (("$SHOULD_RESTART" == "n")); then
				date +"%R: Quitting"
				exit 1
			else
				echo "ERROR: Invalid command: $SHOULD_RESTART"
			fi
			is_server_running
		done
		;;
	1 ) date +"%R: Stopping Server"
		;;
	2 ) date +"%R: Restarting Server"
		;;
	3 ) date +"%R: Listing Servers"
		tmux ls;;
	4 ) date +"%R: Quitting"
		exit 1;;
	* ) date +"%R: Unknown Command (quitting)"
		exit 1;;
esac

# Check if server is already running
SERVER_STATUS=$(tmux ls | egrep -c "kf_server")
if (($SERVER_STATUS > 0))
then
	date +"%R: Existing server found: $TMUX_SERVER_NAME"
	date +"%R: Shutting down server..."
	tmux kill-session -t $TMUX_SERVER_NAME
else
	date +"%R: No server found."
fi

# Start the server
date +"%R: Starting server: $TMUX_SERVER_NAME"
tmux new-session -d -s $TMUX_SERVER_NAME './startScripts/startBioticsLab.sh'
date +"%R: Server started"

# Helper Functions
function start_server() {
	tmux new-session -d -s $TMUX_SERVER_NAME './startScripts/startBioticsLab.sh'
}

function restart_server() {
	is_server_running
	if (($)); then
        	date +"%R: Existing server found: $TMUX_SERVER_NAME"
        	date +"%R: Shutting down server..."
        	tmux kill-session -t $TMUX_SERVER_NAME
		date +"%R: Starting server..."
		start_server
	else
        	date +"%R: No server found"
		date +"%R: Starting server..."
		start_server
	fi
}

funciton is_server_running() {
	SERVER_STATUS=$(tmux ls | egrep -c "kf_server")
	if (($SERVER_STATUS > 0))
	then
        	return true
		#date +"%R: Existing server found: $TMUX_SERVER_NAME"
        	#date +"%R: Shutting down server..."
        	#tmux kill-session -t $TMUX_SERVER_NAME
	else
		return false
	fi
}
