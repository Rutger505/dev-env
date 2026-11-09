if [[ -z "$TMUX" && $- == *i* && "$TERM" != tmux-256color && "$TERMINAL_EMULATOR" != *JetBrains* ]]; then
  # Reuse sessions left behind by closed terminals so they don't pile up, preferring session 0
  # and recreating it when its last pane was closed. Skip the ones dedicated to a single app
  detached=(${(f)"$(tmux list-sessions -f '#{&&:#{==:#{session_attached},0},#{!:#{m/r:^(system-update|spotatui)$,#{session_name}}}}' -F '#{session_name}' 2>/dev/null)"})
  if ! tmux has-session -t '=0' 2>/dev/null; then
    target=(new-session -s 0)
  elif (( ${detached[(Ie)0]} )); then
    target=(attach-session -t 0)
  elif (( ${#detached} )); then
    target=(attach-session -t "${detached[1]}")
  else
    # tmux names new sessions after a counter that never goes down, so pick the lowest free number
    sessions=(${(f)"$(tmux list-sessions -F '#{session_name}')"})
    n=1
    while (( ${sessions[(Ie)$n]} )); do (( n++ )); done
    target=(new-session -s $n)
    unset sessions n
  fi
  unset detached
  # Not exec, so a failing tmux leaves a usable shell
  tmux "${target[@]}" && exit
  unset target
fi
