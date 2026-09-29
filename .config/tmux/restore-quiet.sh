#!/usr/bin/env bash
# resurrect leaves "Tmux restore complete!" on the status line for 5s after every auto-restore

"$HOME/.local/share/tmux/plugins/tmux-resurrect/scripts/restore.sh"

# The spinner can print its end message just after restore.sh returns
for _ in {0..6}; do
		sleep 0.05
		tmux display-message -d 1 ""
done
