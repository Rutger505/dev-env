if command -v tmux > /dev/null 2>&1; then
  if [[ -z "$TMUX" ]] && [[ $- == *i* ]] && [[ "$TERM" != "tmux-256color" ]] && [[ "$TERMINAL_EMULATOR" != *JetBrains* ]]; then
    # Reuse a session left behind by a closed terminal so sessions don't pile up
    # (resurrect saves and restores every one of them).
    detached=$(tmux list-sessions -f '#{&&:#{==:#{session_attached},0},#{!=:#{session_name},system-update}}' -F '#{session_name}' 2>/dev/null | head -n1)
    if [[ -n "$detached" ]]; then
      tmux attach-session -t "$detached"
    else
      tmux new-session
    fi
    unset detached
  fi
fi
