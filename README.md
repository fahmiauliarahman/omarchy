# Omarchy configuration

Personal Omarchy Quattro configuration managed with
[chezmoi](https://www.chezmoi.io/).

This repository restores:

- Hyprland configuration
- Omarchy shell, menu, hooks, branding, and custom plugins
- Arch and AUR applications listed in `.chezmoidata.yaml`
- Removal of unwanted packages listed in `.chezmoidata.yaml`

It intentionally excludes credentials, browser profiles, application data,
and timestamped configuration backups.

## Restore on a new Omarchy device

Authenticate with GitHub first because this repository is private:

```bash
gh auth login
gh auth setup-git
omarchy pkg add chezmoi
chezmoi init --apply fahmiauliarahman/omarchy
```

The initial apply can request your sudo password while installing or removing
packages. Log out and back in if every desktop setting has not refreshed.

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
    - brave-bin
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

## Update this device from GitHub

```bash
chezmoi update
```
