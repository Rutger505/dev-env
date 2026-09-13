# Espressif (ESP32) Rust toolchain environment.
#
# espup installs the Xtensa toolchain into $RUSTUP_HOME. Resolve everything
# from that instead of a hardcoded home directory, so this works for any user
# (the openclaw VM runs as `openclaw`, not `rutger`).

_esp_rustup_home="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
_esp_toolchain="$_esp_rustup_home/toolchains/esp"

if [ -d "$_esp_toolchain" ]; then
  # Xtensa LLVM (needed by bindgen / esp-idf-sys).
  _esp_clang_lib=("$_esp_toolchain"/xtensa-esp32-elf-clang/*/esp-clang/lib(N))
  [ -n "$_esp_clang_lib" ] && export LIBCLANG_PATH="$_esp_clang_lib[1]"

  # GCC for the Xtensa target.
  _esp_gcc_bin=("$_esp_toolchain"/xtensa-esp-elf/*/xtensa-esp-elf/bin(N))
  [ -n "$_esp_gcc_bin" ] && export PATH="$_esp_gcc_bin[1]:$PATH"

  unset _esp_clang_lib _esp_gcc_bin
fi

# espup / espflash / cargo-espflash live outside the dev-env repo so that
# dropping binaries in ~/.local/bin (which is stowed from this repo) cannot
# leave the working tree dirty and block dev-env-update-self.
[ -d "$XDG_DATA_HOME/esp-tools/bin" ] && export PATH="$XDG_DATA_HOME/esp-tools/bin:$PATH"

unset _esp_rustup_home _esp_toolchain
