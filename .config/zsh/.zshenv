# env.sh is POSIX sh; emulate sh so an unmatched glob doesn't abort zsh. The
# -r check matters: in sh mode a failed `.` kills the shell, so an unstowed
# env.sh would make every zsh exit on startup.
if [[ -r "$HOME/.config/shell/env.sh" ]]; then
  emulate sh -c '. "$HOME/.config/shell/env.sh"'
fi

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
# History sizes and options live in history.zsh (sourced after oh-my-zsh)
