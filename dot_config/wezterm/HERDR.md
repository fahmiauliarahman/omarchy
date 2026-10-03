# Herdr Guide

Herdr owns workspaces, tabs, panes, and persistent terminal processes.
WezTerm only renders the terminal and provides macOS shortcuts.

## Prefix

Press `Cmd+B`, release it, then press an action key.
WezTerm translates `Cmd+B` to Herdr's internal `F12` prefix so Neovim keeps `Ctrl+B`.
Do not press `Ctrl+B` or `F12` for Herdr.

| Shortcut | Result |
|----------|--------|
| `Cmd+B` | Enter Herdr prefix mode for one action. |
| `Cmd+B ?` | Show live active-key help. |
| `Cmd+T` | Alias for `Cmd+B c`, create a tab. |
| `Cmd+W` | Alias for `Cmd+B Shift+X`, close the current tab. |

`Cmd+B ?` is source of truth if Herdr is updated or bindings change.

## Model

| Layer | Purpose |
|-------|---------|
| Workspace | Top-level project or task container. |
| Tab | One layout within a workspace. |
| Pane | One real terminal process. |
| Session | Persistent Herdr server namespace containing workspaces. |

Use a workspace per project or investigation.
Use tabs for views such as editor, agents, logs, server, or review.
Use panes for commands that must stay visible together.

New tabs and panes follow the active working directory by default.
`Cmd+T` may prompt for a tab name.

## General Keys

Press `Cmd+B`, then one key below.

| Key | Action |
|-----|--------|
| `?` | Show active-key help. |
| `s` | Open settings. |
| `q` | Detach client and leave server processes running. |
| `Shift+R` | Reload `~/.config/herdr/config.toml`. |
| `o` | Open the current notification target. |
| `b` | Toggle sidebar. |

## Workspace Keys

Press `Cmd+B`, then one key below.

| Key | Action |
|-----|--------|
| `w` | Open workspace picker. |
| `g` | Open goto picker. |
| `Shift+N` | Create workspace. |
| `Shift+G` | Create Git worktree workspace. |
| `Shift+W` | Rename workspace. |
| `Shift+D` | Close workspace. |

## Tab Keys

Press `Cmd+B`, then one key below, except tab selection uses `Cmd+1..9` directly.

| Key | Action |
|-----|--------|
| `c` | Create tab. |
| `Shift+T` | Rename tab. |
| `p` | Previous tab. |
| `n` | Next tab. |
| `Cmd+1..9` | Switch to tab 1 through 9. |
| `Shift+X` | Close tab. |

## Pane Keys

Press `Cmd+B`, then one key below.

| Key | Action |
|-----|--------|
| `h` | Focus pane left. |
| `j` | Focus pane down. |
| `k` | Focus pane up. |
| `l` | Focus pane right. |
| `Shift+H` | Swap focused pane left. |
| `Shift+J` | Swap focused pane down. |
| `Shift+K` | Swap focused pane up. |
| `Shift+L` | Swap focused pane right. |
| `Tab` | Cycle to next pane. |
| `Shift+Tab` | Cycle to previous pane. |
| `v` | Split focused pane right. |
| `-` | Split focused pane down. |
| `x` | Close focused pane. |
| `Shift+P` | Rename focused pane. |
| `z` | Toggle focused-pane zoom. |
| `r` | Enter resize mode. |
| `[` | Enter copy mode. |
| `e` | Edit focused pane scrollback. |

Resize-mode movement is shown in Herdr's live help panel.
Use `Cmd+B ?` if a version changes those mode-specific keys.

## Navigate Mode

Navigate mode is Herdr's persistent navigation surface.
Its keys win over terminal input only while that surface is open.

| Key | Action |
|-----|--------|
| `Up` | Previous workspace. |
| `Down` | Next workspace. |
| `h` | Focus pane left. |
| `j` | Focus pane down. |
| `k` | Focus pane up. |
| `l` | Focus pane right. |
| `Left` | Focus pane left. |
| `Right` | Focus pane right. |

## Copy Mode

Enter with `Cmd+B [`.
The pane process keeps running while you inspect scrollback.

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move by character. |
| `w/b/e` | Move by word. |
| `{` / `}` | Move through scrollback. |
| `PageUp` / `PageDown` | Move by page. |
| `Ctrl+B` / `Ctrl+F` | Move by page. |
| `Ctrl+U` / `Ctrl+D` | Move by half page. |
| `/` / `?` | Search forward / backward. |
| `n` / `N` | Repeat search forward / backward. |
| `v` or `Space` | Start selection. |
| `y` or `Enter` | Copy selection. |
| `q` or `Esc` | Leave copy mode. |

Mouse drag-select also copies without entering copy mode.

## Mouse

Click panes, tabs, workspaces, or agents to focus them.
Drag split borders to resize panes.
Use right-click menus for contextual actions.

## Remote Only

| Shortcut | Action |
|----------|--------|
| `Ctrl+V` | Paste remote image data when attached with `herdr --remote`. |

## Unbound By Default

These actions have no keybinding in your active default map: open worktree, remove worktree, previous workspace, next workspace, previous agent, next agent, focus agent, switch workspace, and last pane.

## Session Lifecycle

`Cmd+B q` detaches the UI while all panes and agents keep running.
Run `herdr` later to attach again.
Run `herdr server stop` only when you intend to stop the session.

## Configuration

Your Herdr overrides set the F12 prefix and terminal-derived Homunculus palette in `~/.config/herdr/config.toml`.
Reload changes with `herdr server reload-config`.
Check configuration with `herdr config check`.

Official v0.7.4 references: [keyboard](https://herdr.dev/docs/keyboard/) and [configuration](https://herdr.dev/docs/configuration/).
