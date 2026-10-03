# Omarchy configuration

Personal Omarchy Quattro configuration managed with
[chezmoi](https://www.chezmoi.io/).

This repository restores:

- Hyprland configuration
- Omarchy shell, menu, hooks, branding, and custom plugins
- Linuxbrew
- Arch and AUR applications listed in `.chezmoidata.yaml`
- Removal of unwanted packages listed in `.chezmoidata.yaml`

It intentionally excludes credentials, browser profiles, application data,
and timestamped configuration backups.

## Quickstart: sync a new device

Run these commands once on each of your three Omarchy devices.
GitHub authentication is required because this repository is private.

```bash
gh auth login
gh auth setup-git
omarchy pkg add chezmoi
chezmoi init --apply fahmiauliarahman/omarchy
```

The initial apply can request your sudo password while installing Linuxbrew and changing packages.
Log out and back in if every desktop setting has not refreshed.

Before changing configuration on any device, pull and apply the latest version:

```bash
chezmoi update -v
```

After committing and pushing changes from one device, run `chezmoi update -v` on the other two devices.
Use `chezmoi apply` only for local source changes because it does not fetch updates from GitHub.

The bar clock is provided by the `fahmi.clock` plugin and is configured in
`dot_config/omarchy/shell.json` as:

```json
"format": "ddd dd/MM/yyyy HH:mm:ss"
```

This renders as `Sun 20/09/2026 14:05:09`. Apply it on an existing device with:

```bash
chezmoi apply ~/.config/omarchy/shell.json
omarchy restart shell
```

## Save configuration changes

After changing a managed configuration file, update chezmoi's source state:

```bash
chezmoi add ~/.config/hypr
chezmoi add ~/.config/omarchy/shell.json
chezmoi add ~/.config/omarchy/extensions
chezmoi add ~/.config/omarchy/plugins
chezmoi add ~/.config/omarchy/hooks
chezmoi add ~/.config/omarchy/branding
chezmoi add ~/.config/omarchy/themed
chezmoi cd
git add .
git commit -m "Update Omarchy configuration"
git push
```

Review pending changes before committing:

```bash
chezmoi diff
git -C "$(chezmoi source-path)" diff --staged
```

## Add or remove applications

Edit `.chezmoidata.yaml` in the chezmoi source directory:

```yaml
apps:
  arch:
    - bitwarden
  aur:
    - bruno-bin
  remove:
    - chromium
```

Then apply and publish the change:

```bash
chezmoi apply
chezmoi cd
git add .chezmoidata.yaml
git commit -m "Update applications"
git push
```

Use `arch` for official repository packages and `aur` for AUR packages.

## Sync an existing device

```bash
chezmoi update -v
```

This pulls the latest Git changes and applies them in one command.
