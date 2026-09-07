#!/bin/bash

OPTIONAL_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/optional-packages.conf"

# Distro detection
detect_distro() {
  if [ -f /etc/arch-release ]; then
    echo "arch"
  elif [ -f /etc/debian_version ]; then
    echo "debian"
  else
    echo "unknown"
  fi
}

DISTRO="$(detect_distro)"

# Package manager abstraction
pkg_install() {
  case "$DISTRO" in
    arch)
      # No -y here: the databases are only refreshed when they are actually
      # stale (first run, or right after a new repo was added).
      yay -S --needed "$@"
      ;;
    debian)
      sudo apt-get install -y "$@"
      ;;
    *)
      echo "Unsupported distro: $DISTRO" >&2
      return 1
      ;;
  esac
}

pkg_update() {
  case "$DISTRO" in
    arch)
      yay -Syu
      ;;
    debian)
      sudo apt-get update && sudo apt-get upgrade -y
      ;;
    *)
      echo "Unsupported distro: $DISTRO" >&2
      return 1
      ;;
  esac
}

# Bootstrap essential packages for install script
pkg_bootstrap() {
  case "$DISTRO" in
    arch)
      if ! command -v yay &> /dev/null; then
        sudo pacman -Sy --needed --noconfirm yay
      fi
      if ! command -v fzf &> /dev/null; then
        sudo pacman -S --needed --noconfirm fzf
      fi
      ;;
    debian)
      sudo apt-get update
      sudo apt-get install -y git curl fzf
      ;;
  esac
}

run_scripts_in_dir() {
  local script_dir=$1

  # Run common scripts
  for script in "$script_dir"/*.sh; do
    if [[ -f "$script" ]]; then
      echo "Running script: $(basename "$script")"
      "$script"
    fi
  done

  # Run distro-specific scripts
  local distro_dir="$script_dir/$DISTRO"
  if [[ -d "$distro_dir" ]]; then
    for script in "$distro_dir"/*.sh; do
      if [[ -f "$script" ]]; then
        echo "Running script ($DISTRO): $(basename "$script")"
        "$script"
      fi
    done
  fi
}

load_package_list_from_dir() {
  local array_name="$1"
  local dir="$2"

  if [[ ! -d "$dir" ]]; then
    echo "Directory not found: $dir" >&2
    return 1
  fi

  local tmp_file="/tmp/all-packages-$$.lst"
  > "$tmp_file"

  echo "Loading package lists from: $dir"

  # Load common packages (exclude optional and distro-specific directories)
  local common_count=0
  for lst in "$dir"/*.lst; do
    if [[ -f "$lst" ]]; then
      local pkg_count=$(grep -cvE '^\s*#|^\s*$' "$lst" 2>/dev/null || echo 0)
      if [[ "$pkg_count" -gt 0 ]]; then
        echo "  - $(basename "$lst"): $pkg_count package(s)"
        grep -vE '^\s*#' "$lst" | grep -vE '^\s*$' >> "$tmp_file"
        ((common_count += pkg_count))
      fi
    fi
  done

  # Load distro-specific packages
  local distro_dir="$dir/$DISTRO"
  local distro_count=0
  if [[ -d "$distro_dir" ]]; then
    for lst in "$distro_dir"/*.lst; do
      if [[ -f "$lst" ]]; then
        local pkg_count=$(grep -cvE '^\s*#|^\s*$' "$lst" 2>/dev/null || echo 0)
        if [[ "$pkg_count" -gt 0 ]]; then
          echo "  - $DISTRO/$(basename "$lst"): $pkg_count package(s)"
          grep -vE '^\s*#' "$lst" | grep -vE '^\s*$' >> "$tmp_file"
          ((distro_count += pkg_count))
        fi
      fi
    done
  fi

  mapfile -t "$array_name" < "$tmp_file"
  rm -f "$tmp_file"

  echo "Loaded $((common_count + distro_count)) total packages (common: $common_count, $DISTRO: $distro_count)"
}

select_optional_packages() {
  local packages_dir="$1"

  mkdir -p "$(dirname "$OPTIONAL_CONFIG_FILE")"

  # Get list of available optional packages from common and distro-specific directories
  local -A available_map

  # From common package lists and scripts
  if [[ -d "$packages_dir" ]]; then
    for lst in "$packages_dir"/*.lst; do
      if [[ -f "$lst" ]]; then
        available_map["$(basename "$lst" .lst)"]=1
      fi
    done
    for script in "$packages_dir"/*.sh; do
      if [[ -f "$script" ]]; then
        available_map["$(basename "$script" .sh)"]=1
      fi
    done
  fi

  # From distro-specific package lists and scripts
  local distro_dir="$packages_dir/$DISTRO"
  if [[ -d "$distro_dir" ]]; then
    for lst in "$distro_dir"/*.lst; do
      if [[ -f "$lst" ]]; then
        available_map["$(basename "$lst" .lst)"]=1
      fi
    done
    for script in "$distro_dir"/*.sh; do
      if [[ -f "$script" ]]; then
        available_map["$(basename "$script" .sh)"]=1
      fi
    done
  fi

  local available=("${!available_map[@]}")

  if [[ ${#available[@]} -eq 0 ]]; then
    echo "No optional packages available"
    return 0
  fi

  echo "Found ${#available[@]} optional packages available for $DISTRO"

  # Build preview command that checks both common and distro-specific locations
  local preview_cmd="
    pkg={}
    lst_common='$packages_dir/{}.lst'
    lst_distro='$packages_dir/$DISTRO/{}.lst'
    script_common='$packages_dir/{}.sh'
    script_distro='$packages_dir/$DISTRO/{}.sh'

    if [[ -f \"\$lst_distro\" ]]; then
      echo '=== Packages ($DISTRO) ==='
      cat \"\$lst_distro\"
    elif [[ -f \"\$lst_common\" ]]; then
      echo '=== Packages (common) ==='
      cat \"\$lst_common\"
    fi

    if [[ -f \"\$script_distro\" ]]; then
      echo -e '\n=== Script ($DISTRO) ==='
      cat \"\$script_distro\"
    elif [[ -f \"\$script_common\" ]]; then
      echo -e '\n=== Script (common) ==='
      cat \"\$script_common\"
    fi
  "

  # Use fzf to select packages
  local selected
  selected=$(printf '%s\n' "${available[@]}" | sort | fzf --multi --prompt="Select optional packages: " \
    --header="Press SPACE to select, ENTER to confirm" \
    --bind "j:down,k:up,ctrl-a:select-all,ctrl-d:deselect-all,space:toggle" \
    --preview "$preview_cmd" \
    --preview-window=right:50%) || true

  # Save selection to config file
  if [[ -n "$selected" ]]; then
    echo "$selected" > "$OPTIONAL_CONFIG_FILE"
    echo "Selected $(echo "$selected" | wc -l) optional package(s)"
  else
    # Empty selection - create empty config
    > "$OPTIONAL_CONFIG_FILE"
    echo "No optional packages selected"
  fi
}

load_optional_packages() {
  local array_name="$1"
  local optional_dir="$2"

  if [[ ! -f "$OPTIONAL_CONFIG_FILE" ]]; then
    echo "No optional packages configured"
    return 0
  fi

  local selected_count=$(grep -cvE '^\s*$' "$OPTIONAL_CONFIG_FILE" 2>/dev/null || echo 0)
  if [[ "$selected_count" -eq 0 ]]; then
    echo "No optional packages selected"
    return 0
  fi

  echo "Loading $selected_count optional package list(s):"

  local tmp_file="/tmp/optional-packages-$$.lst"
  > "$tmp_file"

  while IFS= read -r pkg_name; do
    [[ -z "$pkg_name" ]] && continue

    # Try distro-specific list first, then common list
    local distro_lst_file="$optional_dir/$DISTRO/$pkg_name.lst"
    local common_lst_file="$optional_dir/$pkg_name.lst"

    if [[ -f "$distro_lst_file" ]]; then
      local pkg_count=$(grep -cvE '^\s*#|^\s*$' "$distro_lst_file" 2>/dev/null || echo 0)
      if [[ "$pkg_count" -gt 0 ]]; then
        echo "  - $pkg_name ($DISTRO): $pkg_count package(s)"
        grep -vE '^\s*#' "$distro_lst_file" | grep -vE '^\s*$' >> "$tmp_file"
      else
        echo "  - $pkg_name: (script only, no packages)"
      fi
    elif [[ -f "$common_lst_file" ]]; then
      local pkg_count=$(grep -cvE '^\s*#|^\s*$' "$common_lst_file" 2>/dev/null || echo 0)
      if [[ "$pkg_count" -gt 0 ]]; then
        echo "  - $pkg_name (common): $pkg_count package(s)"
        grep -vE '^\s*#' "$common_lst_file" | grep -vE '^\s*$' >> "$tmp_file"
      else
        echo "  - $pkg_name: (script only, no packages)"
      fi
    else
      echo "  - $pkg_name: (script only, no packages)"
    fi
  done < "$OPTIONAL_CONFIG_FILE"

  # Append to existing array
  local -n arr="$array_name"
  local added_count=0
  while IFS= read -r pkg; do
    arr+=("$pkg")
    ((added_count++))
  done < "$tmp_file"

  rm -f "$tmp_file"

  echo "Added $added_count optional packages to install list"
}

run_optional_scripts() {
  local scripts_dir="$1"

  if [[ ! -f "$OPTIONAL_CONFIG_FILE" ]]; then
    return 0
  fi

  while IFS= read -r pkg_name; do
    [[ -z "$pkg_name" ]] && continue

    # Try distro-specific script first, then common script
    local distro_script="$scripts_dir/$DISTRO/$pkg_name.sh"
    local common_script="$scripts_dir/$pkg_name.sh"

    if [[ -f "$distro_script" ]]; then
      echo "Running optional script ($DISTRO): $pkg_name"
      "$distro_script"
    elif [[ -f "$common_script" ]]; then
      echo "Running optional script: $pkg_name"
      "$common_script"
    fi
  done < "$OPTIONAL_CONFIG_FILE"
}
