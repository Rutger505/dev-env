#!/usr/bin/env bash
# resurrect only saves a pane's command line, which doesn't say which conversation claude has open

save_file="$1"

claude_restore_command() {
	local pane_pid pid session_file session_id
	pane_pid=$(tmux display-message -p -t "$1" '#{pane_pid}')
	for pid in $(pgrep -P "$pane_pid"); do
		session_file="$HOME/.claude/sessions/$pid.json"
		[[ -f $session_file ]] || continue
		session_id=$(jq -r .sessionId "$session_file")
		# A session without messages has no transcript yet, and resuming it would exit with an error
		if compgen -G "$HOME/.claude/projects/*/$session_id.jsonl" >/dev/null; then
			echo "claude --resume $session_id"
		else
			echo "claude"
		fi
		return 0
	done
	return 1
}

own_process_command() {
	local pane_pid args
	pane_pid=$(tmux display-message -p -t "$1" '#{pane_pid}')
	args=$(ps -o args= -p "$pane_pid")
	# A pane started as `new-session <cmd>` runs the command as the pane's own process, which resurrect's ps strategy never records
	case "${args%% *}" in
		zsh | -zsh | bash | -bash | sh | "") return 1 ;;
	esac
	echo "$args"
}

while IFS= read -r line; do
	IFS=$'\t' read -r type session window _ _ pane _ <<<"$line"
	if [[ $type == pane ]] && command=$(claude_restore_command "$session:$window.$pane"); then
		line="${line%$'\t'*}"$'\t'":$command"
	elif [[ $type == pane && $line == *$'\t:' ]] && command=$(own_process_command "$session:$window.$pane"); then
		line="${line%$'\t'*}"$'\t'":$command"
	fi
	printf '%s\n' "$line"
done <"$save_file" >"$save_file.tmp"
mv "$save_file.tmp" "$save_file"
