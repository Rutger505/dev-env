# dev-env

Packages, dotfiles and scripts for my Omarchy (Arch + Hyprland) machines.

## Install

1. Add an SSH key to GitHub:

   ```bash
   ssh-keygen -t ed25519
   cat ~/.ssh/id_ed25519.pub # paste at https://github.com/settings/ssh/new
   ```

2. Clone and install:

   ```bash
   git clone git@github.com:Rutger505/dev-env.git ~/.local/share/dev-env
   ~/.local/share/dev-env/install.sh
   ```

3. Reboot.

`install.sh` also links the configs, replacing Omarchy's defaults, and is safe to rerun. It opens an fzf picker for the optional groups in `install/optional/` with your previous choice preselected (stored in `~/.config/dev-env/optional-packages.conf`).

## Manual steps

- **JetBrains**: log in to Toolbox, install the editors. In each editor: Edit Custom VM Options, add `-Dawt.toolkit.name=WLToolkit`. Enable Backup and Sync and automatic plugin updates.
- **Zen**: log in to sync and Bitwarden.
- **VS Code**: log in and sync settings.
- **Steam** (gaming group): sign in, install games.

## clipcdn

`clipcdn` uploads files to my MinIO CDN (`cdn.rutgerpronk.com`) and prints the URL. Needs the `clipcdn` optional group.

```bash
cp ~/.config/clipcdn/config.example ~/.config/clipcdn/config
chmod 600 ~/.config/clipcdn/config
$EDITOR ~/.config/clipcdn/config
clipcdn --setup
```

```bash
clipcdn clip.mp4                  # -> https://cdn.rutgerpronk.com/cdn/clip.mp4
clipcdn clip.mp4 clips/funny.mp4  # custom remote path
clipcdn --clips                   # sync ~/Videos/Clips -> <bucket>/clips
clipcdn --artifact app-debug.apk  # upload to <bucket>/artifacts
clipcdn --list
```

## TODO

Notes on things that still need fixing. Remove an item once it's fixed.

- tmux: a new terminal should always take session `0` when it is free: create and attach it if it doesn't exist (e.g. after closing its last pane), or attach it if no client is attached. Otherwise keep the current highest attached session number + 1 logic
