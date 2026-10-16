# dev-env

Packages, dotfiles and scripts for my Omarchy (Arch + Hyprland) machines.

## Install

```bash
ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub   # add at https://github.com/settings/ssh/new
git clone git@github.com:Rutger505/dev-env.git ~/.local/share/dev-env
~/.local/share/dev-env/install.sh                     # then reboot
```

`install.sh` is safe to rerun. It replaces Omarchy's configs with these and asks for the optional groups (`install/optional/`), remembering the choice in `~/.config/dev-env/optional-packages.conf`.

## Manual steps

- JetBrains: log in to Toolbox, install the editors. Per editor: Edit Custom VM Options → `-Dawt.toolkit.name=WLToolkit`; enable Backup and Sync and plugin auto-updates.
- Zen: log in to sync and Bitwarden. VS Code: log in and sync settings. Steam: sign in.
- Tailscale group: log in through the URL the installer prints.
- `sunshine` group (desktop): after the reboot open https://localhost:47990, create the admin login, and enter the PIN Moonlight shows when pairing. The `moonlight` group is the client only (laptop).
- `cdn` group: one-time `mcli` alias with the SeaweedFS admin keys:
  ```bash
  read -r access secret < <(ssh debian@192.168.178.214 sudo cat /etc/seaweedfs/s3.json \
    | jq -r '.identities[0].credentials[0] | "\(.accessKey) \(.secretKey)"')
  mcli alias set homecdn https://cdn.rutgerpronk.com "$access" "$secret"
  ```
  `Super + C` then uploads the GSR replay to `homecdn/clips` and copies the URL. Other files: `mcli cp <file> homecdn/artifacts/`.

## TODO

Remove an item once it's fixed.

- Remove lazygit prompt to force push
