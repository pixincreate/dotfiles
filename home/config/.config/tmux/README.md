# Tmux Guide

## First Time Setup

After stowing dotfiles, run these once:

```bash
# Initialize git submodules (tpack + plugins)
cd ~/.dotfiles && git submodule update --init --recursive

# Reload tmux config and install plugins
tmux source ~/.config/tmux/tmux.conf

# Press Prefix + I to install all plugins
```

---

## Quick Start

```bash
tmux new -s work     # start session with name
tmux a               # attach to last session
tmux a -t work       # attach to specific session
tls                  # list all sessions
```

---

## Prefix

**Prefix = `Ctrl+A`** (changed from Ctrl+B)

---

## Panes

| Key             | Action               |
| --------------- | -------------------- |
| `\`             | Split vertical       |
| `-`             | Split horizontal     |
| `h/j/k/l`       | Navigate (vim-style) |
| `Alt+H/J/K/L`   | Navigate (no prefix) |
| `Alt+Z`         | Toggle zoom          |
| `Alt+Shift+H/J` | Swap with pane       |
| `o`             | Cycle panes          |
| `x`             | Kill pane            |

---

## Windows

| Key     | Action                 |
| ------- | ---------------------- |
| `c`     | New window             |
| `n`     | Next window            |
| `p`     | Previous window        |
| `R`     | Rename window          |
| `K`     | Close window           |
| `,`/`.` | Swap window left/right |
| `<`/`>` | Swap window left/right |
| `0-9`   | Go to window           |

---

## Sessions

| Key | Action         |
| --- | -------------- |
| `d` | Detach         |
| `$` | Rename session |
| `S` | Kill session   |

---

## Copy Mode

| Key      | Action           |
| -------- | ---------------- |
| `Enter`  | Enter copy mode  |
| `v`      | Start selection  |
| `y`      | Copy selection   |
| `r`      | Rectangle toggle |
| `q`      | Exit             |
| `Escape` | Exit             |
| `Alt+F`  | Search           |

**Mouse**: Scroll up enters copy mode

---

## Other

| Key | Action        |
| --- | ------------- |
| `r` | Reload config |
| `C` | Clear history |
| `?` | Show README   |

---

## Session Resurrect (Continuum)

- Auto-saves every 15 minutes
- Auto-restores on tmux start
- Manual save: `Prefix + Ctrl+S`
- Manual restore: `Prefix + Ctrl+R`
- Auto-boots into Ghostty terminal

---

## Plugins Loaded

- **tpack** - Plugin manager
- **tmux-sensible** - Sensible defaults
- **tmux-yank** - Enhanced yanking (Prefix + y to copy)
- **tmux-resurrect** - Session save/restore
- **tmux-continuum** - Auto-save/restore
- **catppuccin** - Theme
- **vim-tmux-navigator** - Vim integration
- **tmux-fzf** - Fuzzy session/window finder (Prefix + f)
- **tmux-fzf-url** - URL selection (Prefix + u)
- **tmux-thumbs** - Fast text selection with thumbnails

---

## Status Bar

Light, minimal status bar with muted colors and useful information.

**Left side:**

- Session name (muted teal on medium light gray)

**Right side:**

- Hostname
- Date and time (`YYYY-MM-DD HH:MM`)

**Windows:**

- Simple text format: `#I:#W` (window number:name)
- Active window highlighted with teal background and light text
- Windows separated by double spaces

The status bar refreshes every 5 seconds. Continuum's auto-save runs silently in the background.

---

## Workflow

1. `tmux new -s work` - start session
2. Run servers in panes
3. Close terminal - tmux keeps running
4. `tmux a` - restore everything
5. `Prefix + d` - detach (leave running)

---

## Aliases

```bash
tls                     # list sessions
tll                     # list sessions with running commands
tmux kill-session -t 5  # kill session 5
tmux attach -t 5        # attach to session 5
```
