# dev-env

Setup for my Omarchy (Arch + Hyprland) machines: packages, dotfiles linked with GNU Stow, and a few scripts. Omarchy is the only target. Don't add distro detection or abstractions for other systems.

## Git workflow

Commit directly to `main`, no feature branch needed. This overrides the global branch-first rule for this repo.

The live checkout is `~/.local/share/dev-env`. The `dev-env-update-self` timer runs every minute there: it commits the nvim spell file, pushes local commits, fast-forwards to `origin/main` and restows. It refuses to run on a dirty tree and then touches `$DEV_ENV_ERROR_FILE`, which makes every new zsh print a sync error. Don't leave uncommitted changes in the live checkout.

## Layout

- `install.sh`: the installer. Adds chaotic-aur, picks optional groups with fzf, installs `install/packages.lst` plus the chosen lists with yay, then runs `install/*.sh` and the chosen `install/optional/*.sh`.
- `install/packages.lst`: packages every machine gets. One per line.
- `install/optional/<group>.lst` / `<group>.sh`: optional groups. The group name is the file name, a group can have a list, a script, or both.
- `install/*.sh`: setup steps, run alphabetically after the packages are installed.
- `install/omarchy-bloat.lst`: Omarchy packages that `install/remove-unused-applications.sh` removes.
- `scripts/`: on `PATH`, not stowed.
- Everything else (`.config/`, `.local/`, `.claude/`, `.ssh/`) is stowed into `$HOME`. `.stow-local-ignore` lists what isn't.

## Rules

- Keep it minimal. No comments unless they explain a non-obvious why, no logging, no feature flags, no fallbacks for situations that can't happen on Omarchy.
- Every install script must be safe to rerun.
- Environment variables live in both `.config/shell/env.sh` (zsh and uwsm) and `.config/environment.d/dev-env.conf` (systemd user services). Change both.
- Host-specific Hyprland config goes in `.config/hypr/<hostname>.lua`, which `hyprland.lua` loads automatically.
- nvim has its own rules in `.config/nvim/CLAUDE.md`.

## Commands

- `dev-env-stow`: restow the configs, which also prunes links to deleted files. Add `--adopt` when stow reports conflicts with existing files, then check `git diff` since the adopted files overwrite the repo copies.
- `hyprctl reload`: apply changes in `.config/hypr/`.
- `bash -n` and `shellcheck` (via `bunx shellcheck`) for scripts.
