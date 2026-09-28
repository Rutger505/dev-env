if command -v tmux > /dev/null 2>&1; then
  if [[ -z "$TMUX" ]] && [[ $- == *i* ]] && [[ "$TERM" != "tmux-256color" ]] && [[ "$TERMINAL_EMULATOR" != *JetBrains* ]]; then
    # Prefer session 0 so the first terminal lands there, then reuse sessions left
    # behind by closed terminals so they don't pile up (resurrect restores them all).
    detached=(${(f)"$(tmux list-sessions -f '#{&&:#{==:#{session_attached},0},#{!=:#{session_name},system-update}}' -F '#{session_name}' 2>/dev/null)"})
    if (( ${detached[(Ie)0]} )); then
      target=(attach-session -t 0)
    elif (( ${#detached} )); then
      target=(attach-session -t "${detached[1]}")
    else
      target=(new-session)
    fi
    unset detached
    # Not exec, so a failing tmux leaves a usable shell instead of closing the terminal.
    tmux "${target[@]}" && exit
    unset target
  fi
fi
