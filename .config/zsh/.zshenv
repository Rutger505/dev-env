# XDG Standards
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Dev-env location (can be overridden before sourcing)
export DEV_ENV="${DEV_ENV:-$XDG_DATA_HOME/dev-env}"

# Application specific environment variables
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
# History sizes and options live in history.zsh (sourced after oh-my-zsh)

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose

export NVM_DIR="$XDG_DATA_HOME"/nvm
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export BUN_INSTALL="$XDG_DATA_HOME/.bun"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp
export VCPKG_ROOT="$XDG_DATA_HOME/vcpkg"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export FONTCONFIG_PATH="/etc/fonts/"
export FONTCONFIG_FILE="/etc/fonts/fonts.conf"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$DEV_ENV/scripts"
export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$XDG_DATA_HOME/opencode/bin:$PATH"
export PATH="/usr/libexec/imv:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"

export DEV_ENV_ERROR_FILE="$XDG_STATE_HOME/dev-env-sync-error"


