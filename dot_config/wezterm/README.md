# WezTerm Config Summary

WezTerm provides terminal rendering and macOS shortcuts.
Herdr owns workspaces, tabs, panes, and persistence.

## Appearance
- Frontend: OpenGL, translucent Homunculus palette, WezTerm tab bar hidden
- Fonts: bold JetBrains Mono -> Fira Code iScript -> BlexMono Nerd Font -> CaskaydiaCove Nerd Font -> Apple Color Emoji (0.8 scale)
- Font size: 13.5, line height: 1.9

## Herdr

| Shortcut | Action |
|----------|--------|
| `Cmd+B` | Herdr prefix |
| `Cmd+1..9` | Switch to Herdr tab 1 through 9 |
| `Cmd+T` | Create Herdr tab |
| `Cmd+W` | Close current Herdr tab |

`Cmd+B` sends an internal `F12` prefix to Herdr, leaving `Ctrl+B` available to Neovim.
These shortcuts apply after starting Herdr.

## Sessions

WezTerm opens the default shell.
Start Herdr manually with `herdr` for the default persistent session, or `herdr --session <name>` to create or attach a named session.
Herdr persists session state automatically; no save command is needed.

```sh
herdr session list
herdr session attach <name>
herdr --session <new-name>
```

Herdr 0.7.4 has no session-rename command.
Create a replacement named session, verify it, then stop or delete the old session if no longer needed:

```sh
herdr session stop <old-name>
herdr session delete <old-name>
```

## WezTerm

- `Cmd+C/V`: Copy/paste
- `Cmd+F`: Search scrollback
- `Cmd+H`: Hide application
- `Cmd+K`: Clear scrollback
- `Cmd+N`: New WezTerm window
- `Cmd+Opt+W`: Close native WezTerm pane
- `Cmd+Q`: Quit application
- `Cmd+R`: Reload configuration
- `Cmd+Up/Down`: Scroll to top/bottom
- `Opt+Left/Right`: Word jump

WezTerm default bindings are disabled so it does not intercept control-key input intended for terminal applications.

## Startup
- Window maximizes on launch.
- New windows open the default shell.
