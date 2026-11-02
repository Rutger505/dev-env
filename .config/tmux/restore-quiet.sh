#!/usr/bin/env bash

closed_last_pane="$HOME/.local/share/tmux/resurrect/closed-last-pane"
if [ -e "$closed_last_pane" ]; then
	rm "$closed_last_pane"
	exit 0
fi

# resurrect leaves "Tmux restore complete!" on the status line for 5s after every auto-restore

"$HOME/.local/share/tmux/plugins/tmux-resurrect/scripts/restore.sh"

# The spinner can print its end message just after restore.sh returns
for _ in {0..6}; do
		sleep 0.05
		tmux display-message -d 1 ""
done
