if [[ -z "$TMUX" && $- == *i* && "$TERM" != tmux-256color && "$TERMINAL_EMULATOR" != *JetBrains* ]]; then
  # Reuse sessions left behind by closed terminals so they don't pile up, preferring session 0
  # and recreating it when its last pane was closed
  detached=(${(f)"$(tmux list-sessions -f '#{&&:#{==:#{session_attached},0},#{!=:#{session_name},system-update}}' -F '#{session_name}' 2>/dev/null)"})
  if ! tmux has-session -t '=0' 2>/dev/null; then
    target=(new-session -s 0)
  elif (( ${detached[(Ie)0]} )); then
    target=(attach-session -t 0)
  elif (( ${#detached} )); then
    target=(attach-session -t "${detached[1]}")
  else
    target=(new-session)
  fi
  unset detached
  # Not exec, so a failing tmux leaves a usable shell
  tmux "${target[@]}" && exit
  unset target
fi
