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

## CDN

`Super + C` saves the GSR replay, uploads it to my SeaweedFS CDN and copies the URL. Needs the `cdn` optional group and a one-time alias with the admin keys from the `seaweedfs-s3-credentials` secret:

```bash
key() { kubectl -n seaweedfs get secret seaweedfs-s3-credentials -o jsonpath="{.data.$1}" | base64 -d; }
mcli alias set homecdn https://cdn.rutgerpronk.com "$(key admin_access_key_id)" "$(key admin_secret_access_key)"
```

One bucket per use case, `clips` and `artifacts`:

```bash
mcli cp app-debug.apk homecdn/artifacts/  # -> https://cdn.rutgerpronk.com/artifacts/app-debug.apk
mcli ls --recursive homecdn
```

## TODO

Notes on things that still need fixing. Remove an item once it's fixed.

- Discord config, it constantly changes, better to edit in place once with a script
