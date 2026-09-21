# Environment shared by the terminal and the desktop session. zsh sources it
# from .zshenv, uwsm sources it for Hyprland through uwsm/env.d/50-dev-env, so
# GUI apps (VS Code, JetBrains) see the same variables as a shell.
#
# uwsm runs this with /bin/sh, so keep it POSIX. systemd user services don't
# go through uwsm and read environment.d/30-dev-env.conf instead: when adding
# a variable here, add it there too.

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

path_append() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="${PATH:+$PATH:}$1" ;;
  esac
}

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DEV_ENV="${DEV_ENV:-$XDG_DATA_HOME/dev-env}"
export DEV_ENV_ERROR_FILE="$XDG_STATE_HOME/dev-env-sync-error"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export OMNISHARPHOME="$XDG_CONFIG_HOME/omnisharp"

export NVM_DIR="$XDG_DATA_HOME/nvm"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export BUN_INSTALL="$XDG_DATA_HOME/.bun"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export VCPKG_ROOT="$XDG_DATA_HOME/vcpkg"

export KUBECONFIG="$HOME/.kube/config"

export FONTCONFIG_PATH="/etc/fonts/"
export FONTCONFIG_FILE="/etc/fonts/fonts.conf"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

path_append "$HOME/.local/bin"
path_append "$DEV_ENV/scripts"
path_append "$VCPKG_ROOT"
path_append "$PLATFORMIO_CORE_DIR/penv/bin"

path_prepend "$XDG_DATA_HOME/JetBrains/Toolbox/scripts"
path_prepend "$PNPM_HOME"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$XDG_DATA_HOME/opencode/bin"
path_prepend "/usr/libexec/imv"
path_prepend "$CARGO_HOME/bin"
path_prepend "$HOME/miniforge3/bin"

# espup installs the Xtensa toolchain under a versioned directory, which is
# why these can't live in environment.d. LIBCLANG_PATH is for bindgen /
# esp-idf-sys, the GCC bin directory is the Xtensa linker.
for esp_dir in "$RUSTUP_HOME"/toolchains/esp/xtensa-esp32-elf-clang/*/esp-clang/lib; do
  [ -d "$esp_dir" ] && export LIBCLANG_PATH="$esp_dir"
done
for esp_dir in "$RUSTUP_HOME"/toolchains/esp/xtensa-esp-elf/*/xtensa-esp-elf/bin; do
  [ -d "$esp_dir" ] && path_prepend "$esp_dir"
done
unset esp_dir

# espup / espflash / cargo-espflash live outside the dev-env repo so that
# dropping binaries in ~/.local/bin (which is stowed from this repo) cannot
# leave the working tree dirty and block dev-env-update-self.
path_prepend "$XDG_DATA_HOME/esp-tools/bin"

export PATH
unset -f path_prepend path_append
