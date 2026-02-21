# Tmux Guide

## Why Tmux?

Run servers (tailscale, work projects) in tmux panes. They survive:

- Terminal restarts (Zed, Ghostty)
- Mac restarts

## Quick Start

```bash
tmux                  # start tmux
tmux new -s work     # start with name
tmux a               # attach to last session
tmux a -t work      # attach to specific session
```

---

## Prefix

**Prefix = `Ctrl+A`**

All commands below use Prefix.

---

## Panes

| Key         | Action               |
| ----------- | -------------------- |
| `\`         | Split vertical       |
| `-`         | Split horizontal     |
| `h/j/k/l`   | Navigate (vim-style) |
| `Alt+Arrow` | Navigate (no prefix) |
| `x`         | Close pane           |
| `z`         | Zoom pane            |
| `o`         | Cycle panes          |

---

## Windows

| Key   | Action          |
| ----- | --------------- |
| `c`   | New window      |
| `n`   | Next window     |
| `p`   | Previous window |
| `,`   | Rename window   |
| `&`   | Close window    |
| `0-9` | Go to window    |

---

## Sessions

| Key | Action         |
| --- | -------------- |
| `d` | Detach         |
| `$` | Rename session |

---

## Copy Mode

| Key      | Action          |
| -------- | --------------- |
| `Enter`  | Enter copy mode |
| `v`      | Start selection |
| `y`      | Copy selection  |
| `Enter`  | Copy selection  |
| `Ctrl+C` | Copy + exit     |
| `q`      | Exit            |
| `Escape` | Exit            |

---

## Copy/Paste (System Clipboard)

| Key            | Action               |
| -------------- | -------------------- |
| `Ctrl+Shift+C` | Copy to clipboard    |
| `Ctrl+Shift+V` | Paste from clipboard |

**Mouse**: Drag to select → auto-copies to clipboard

---

## Other

| Key      | Action        |
| -------- | ------------- |
| `r`      | Reload config |
| `Meta+K` | Clear screen  |

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
