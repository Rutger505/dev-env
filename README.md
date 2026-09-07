# Development environment

Cross-distribution development environment setup for Arch Linux (including Omarchy) and Debian/Ubuntu. It installs all the necessary tools and configurations to get started with development.

## Supported Distributions

- **Arch Linux** (including Omarchy/Hyprland)
- **Debian/Ubuntu**

The install scripts automatically detect your distribution and install the appropriate packages.

## Installation

### Prerequisites

1. Generate ssh key:

```bash
ssh-keygen -t ed25519
```

2. Copy the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

3. [Set ssh key in Github](https://github.com/settings/ssh/new)

### Install

1. Clone the repository (default location is `~/.local/share/dev-env`).

```bash
git clone git@github.com:Rutger505/dev-env.git ~/.local/share/dev-env
```

> **Custom location:** You can clone to any location. Set `DEV_ENV` in your environment before running scripts:
> ```bash
> export DEV_ENV="$HOME/my-custom-location"
> ```

2. Run applications installer script.

```bash
~/.local/share/dev-env/applications/install.sh
```

The script will:
- Detect your distribution (Arch or Debian)
- Install base packages using the appropriate package manager
- Let you select optional packages (gaming, kubernetes, etc.)
- Run post-install configuration scripts

3. Use GNU Stow to symlink the config files to the home directory.

```bash
cd ~/.local/share/dev-env
stow --target="$HOME" .
```

Do a **full system restart** for changing default shell and showing desktop application.

## Directory Structure

```
applications/
├── packages/
│   ├── *.lst              # Common package lists
│   ├── *.sh/*.py          # Common package scripts
│   ├── arch/              # Arch-specific packages and scripts
│   ├── debian/            # Debian-specific packages and scripts
│   └── optional/          # Optional package groups
│       ├── *.sh           # Common optional scripts
│       ├── arch/          # Arch-specific optional packages
│       └── debian/        # Debian-specific optional packages
├── pre-install/
│   ├── arch/              # Arch pre-install (chaotic-aur, etc.)
│   └── debian/            # Debian pre-install (PPAs, etc.)
└── post-install/
    ├── *.sh               # Common post-install
    └── arch/              # Arch-specific post-install
```

## Post install manual steps

### Jetbrains editors

1. Open jetbrains toolbox
2. Login to jetbrains toolbox
3. Install editor(s)
4. Open an editor
5. In the bottom left click the gear > Edit Custom VM Options
6. Add: `-Dawt.toolkit.name=WLToolkit` To enable wayland (Arch/Hyprland only)
6. Go to settings > Backup and Sync > Enable Backup and Sync -> true
7. Go to settings > plugins > plugin settings > update automatically


### Zen browser (Arch only)

1. Open
2. Login to sync extensions, spaces etc.
3. Login to bitwarden


### VsCode

1. Open
2. Login and sync all settings


### Steam (optional gaming packages)

1. Open & signin
2. Install wanted games


## Removing Omarchy preinstalls (Arch/Omarchy only)

Omarchy pacstraps ~140 packages from
`~/.local/share/omarchy/install/omarchy-base.packages`. A chunk of that is
duplicated or unused here. `applications/omarchy-bloat.lst` lists the ones we
drop, annotated with the reason for each.

`applications/post-install/arch/remove-unused-applications.sh` reads that list
and removes whatever is installed with `pacman -Rns` (~880 MB on this machine,
more once orphaned dependencies go too), then prunes the seeded web-app
`.desktop` launchers. It's guarded and safe to re-run.

It also touches `~/.local/state/omarchy/preinstalls-removed` so Omarchy's
migrations don't reinstall the packages on the next `omarchy-update`.
Deliberately not a wrapper around Omarchy's own `omarchy-remove-preinstalls`:
that also deletes *every* installed web app and TUI launcher, and which ones to
keep is decided here. To undo, run `omarchy-install-preinstalls`.

## clipcdn — upload clips & artifacts to my CDN

`clipcdn` (in `.local/bin`) uploads files to my self-hosted MinIO CDN
(`cdn.rutgerpronk.com`, deployed from `kubernetes-infrastructure/5-minio`) and
prints a shareable URL. Handy for sharing clips with mates and for grabbing
build artifacts (e.g. the soundboard APK) straight onto a phone.

It uses the MinIO client (`mc`), installed via the optional `clipcdn` package
group (`minio-client`).

### Setup

```bash
cp ~/.config/clipcdn/config.example ~/.config/clipcdn/config
chmod 600 ~/.config/clipcdn/config      # holds a secret key
$EDITOR ~/.config/clipcdn/config         # fill in endpoint + credentials
clipcdn --setup                          # register the mc alias
```

The real `config` is gitignored; only `config.example` is tracked.

### Usage

```bash
clipcdn clip.mp4                  # -> https://cdn.rutgerpronk.com/cdn/clip.mp4
clipcdn clip.mp4 clips/funny.mp4  # custom remote path
clipcdn --clips                   # sync ~/Videos/Clips -> <bucket>/clips
clipcdn --artifact app-debug.apk  # upload to <bucket>/artifacts (for testing)
clipcdn --list                    # list what's on the CDN
```

## Adding Support for New Distributions

To add support for a new distribution:

1. Update `detect_distro()` in `applications/functions.sh`
2. Add package manager support in `pkg_install()` and `pkg_update()`
3. Create `packages/<distro>/` directory with distro-specific package lists (`.lst`) and scripts (`.sh`)
4. Create `pre-install/<distro>/` for repository setup
5. Create `post-install/<distro>/` for distro-specific configuration

## TODO

- Create a way to persist not locking on idle (Omarchy)
- discord to seperate optional config
- When selecting no preset there is still a preset selected
