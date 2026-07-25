# Tmux Quick Reference

Prefix: **Ctrl+A**

---

## Hierarchy

| Object  | What it is         | When to create one      |
| ------- | ------------------ | ----------------------- |
| Session | A project          | Switching projects      |
| Window  | A task/tab         | Different task in project |
| Pane    | A split view       | Need to see 2+ things at once |

One session per project. One window per task. Split into panes only when you need simultaneous visibility.

## Panes

| Key             | Action                         |
| --------------- | ------------------------------ |
| `\\`            | Split vertical (current dir)   |
| `-`             | Split horizontal (current dir) |
| `h` `j` `k` `l` | Navigate (vim-style)           |
| `Alt+h/j/k/l`   | Navigate (no prefix)           |
| `Alt+Shift+h/j` | Swap panes left/right          |
| `Alt+z`         | Toggle zoom                    |
| `x`             | Kill pane                      |
| `o`             | Cycle panes                    |

## Windows

| Key     | Action                   |
| ------- | ------------------------ |
| `c`     | New window (current dir) |
| `n`     | Next window              |
| `p`     | Previous window          |
| `0-9`   | Jump to window           |
| `R`     | Rename window            |
| `K`     | Kill window (confirm)    |
| `<` `>` | Swap window              |

## Sessions

| Key | Action                   |
| --- | ------------------------ |
| `d` | Detach (keep running)    |
| `$` | Rename session           |
| `S` | Kill session (confirm)   |
| `s` | List/switch sessions     |
| `L` | Switch to last session   |
| `f` | Fuzzy-find session (fzf) |

## Copy Mode

| Key       | Action           |
| --------- | ---------------- |
| `Enter`   | Enter scrollback |
| `v`       | Start selection  |
| `y`       | Copy and exit    |
| `r`       | Rectangle toggle |
| `q` `Esc` | Exit             |
| `Alt+f`   | Search           |

## Other

| Key      | Action                    |
| -------- | ------------------------- |
| `r`      | Reload config             |
| `C`      | Clear history             |
| `?`      | Show this help            |
| `N`      | New session (current dir) |
| `Ctrl+s` | Save sessions             |
| `Ctrl+r` | Restore sessions          |

## Plugins

| Plugin             | What it does               |
| ------------------ | -------------------------- |
| tpack              | Plugin manager             |
| sensible           | Sensible defaults          |
| yank               | Prefix+y to copy           |
| resurrect          | Save/restore layouts       |
| continuum          | Auto-save every 15 min     |
| vim-tmux-navigator | Seamless vim/tmux pane nav |
| fzf                | Prefix+f fuzzy finder      |
| fzf-url            | Prefix+u URL selection     |
| thumbs             | Fast text selection        |

## Aliases

| Alias | Command                  |
| ----- | ------------------------ |
| `tls` | `tmux ls`                |
| `tll` | List sessions + commands |
| `tbg` | Kill server + restart    |

## Session Resurrect

- Auto-saves every 15 minutes
- Auto-restores on tmux start
- Manual save: `Prefix + Ctrl+S`
- Manual restore: `Prefix + Ctrl+R`
