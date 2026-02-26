# Tmux Guide

## Quick Start

```bash
tmux new -s work     # start with name
tmux a               # attach to last session
tmux a -t work       # attach to specific session
```

---

## Prefix

**Prefix = `Ctrl+A`** (changed from Ctrl+B)

---

## Panes

| Key              | Action               |
| ---------------- | ------------------- |
| `\`              | Split vertical      |
| `-`              | Split horizontal    |
| `h/j/k/l`        | Navigate (vim-style)|
| `Alt+H/J/K/L`    | Navigate (no prefix)|
| `Alt+Z`          | Toggle zoom         |
| `Alt+Shift+H/J`  | Swap with pane      |
| `o`              | Cycle panes         |

---

## Windows

| Key   | Action              |
| ----- | ------------------ |
| `c`   | New window         |
| `n`   | Next window        |
| `p`   | Previous window    |
| `R`   | Rename window      |
| `K`   | Close window       |
| `,`/`.` | Swap window left/right |
| `<`/`>` | Swap window left/right |
| `0-9` | Go to window       |

---

## Sessions

| Key | Action          |
| --- | ---------------|
| `d` | Detach         |
| `$` | Rename session |
| `S` | Kill session   |

---

## Copy Mode

| Key        | Action              |
| ---------- | ------------------ |
| `Enter`    | Enter copy mode    |
| `v`        | Start selection    |
| `y`        | Copy selection    |
| `r`        | Rectangle toggle  |
| `q`        | Exit              |
| `Escape`   | Exit              |
| `Alt+F`    | Search            |

**Mouse**: Scroll up enters copy mode

---

## Other

| Key        | Action           |
| ---------- | ---------------- |
| `r`        | Reload config    |
| `C`        | Clear history    |
| `?`        | Show README      |

---

## Session Resurrect

- Auto-saves every 15 minutes
- Auto-restores on tmux start
- Manual save: `Prefix + Ctrl+S`
- Manual restore: `Prefix + Ctrl+R`

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
