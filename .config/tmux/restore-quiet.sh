#!/usr/bin/env bash
# Wrapper around tmux-resurrect's restore.sh for continuum's auto-restore.
# resurrect ends with display_message, which forces display-time to 5000ms and
# leaves "Tmux restore complete!" sitting on the status line at every server
# start. Clearing it with a 1ms empty message gives the status line back.

"$HOME/.local/share/tmux/plugins/tmux-resurrect/scripts/restore.sh"

# The spinner's SIGTERM trap can print its end message just after restore.sh
# returns, so let it land before clearing.
sleep 0.3
tmux display-message -d 1 ""
