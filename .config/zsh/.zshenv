# In sh emulation a failed `.` kills the shell, so an unstowed env.sh would break every zsh
if [[ -r "$HOME/.config/shell/env.sh" ]]; then
  emulate sh -c '. "$HOME/.config/shell/env.sh"'
fi

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
