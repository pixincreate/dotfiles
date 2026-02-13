# Dotfiles

Personal dotfiles managed with GNU Stow.

## Installation

### Recommended (with Omaforge)

```bash
# One-line installer (recommended)
eval "$(curl -fsSL https://raw.githubusercontent.com/pixincreate/omaforge/main/unix/setup)"

# Or manually clone both repos
git clone https://github.com/pixincreate/dotfiles.git ~/.dotfiles
git clone https://github.com/pixincreate/omaforge.git ~/.omaforge

# Then run setup
cd ~/.omaforge/unix/macos && ./macos-setup   # macOS
cd ~/.omaforge/unix/fedora && ./fedora-setup # Fedora
```

### Manual (Stow only)

```bash
# Install GNU Stow
# macOS: brew install stow
# Fedora: sudo dnf install stow

# Apply dotfiles
cd ~/.dotfiles
stow --no-folding --restow --target=$HOME home/cargo home/config home/git home/local home/Pictures home/ssh home/zsh
```

## Structure

```
.
├── home/                   # Dotfiles organized by package
│   ├── cargo/             # Cargo configuration (~/.cargo/)
│   ├── config/            # Application configs (~/.config/)
│   ├── git/               # Git configuration (~/.gitconfig)
│   ├── local/             # Local binaries (~/.local/)
│   ├── Pictures/          # Wallpapers and screenshots
│   ├── ssh/               # SSH keys and config
│   └── zsh/               # ZSH configuration (~/.zsh/)
└── fonts/                  # Font files
```

## Packages

- **cargo** - Cargo configuration
- **config** - Application configs (zed, alacritty, starship, tmux, etc.)
- **git** - Git configuration and aliases
- **local** - Local binaries and scripts
- **Pictures** - Wallpapers
- **ssh** - SSH keys and config
- **zsh** - ZSH shell configuration

## Managing Dotfiles

### Add a new dotfile

```bash
# Copy the file to the appropriate package directory
cp ~/.config/some-app ~/.dotfiles/home/config/.config/

# Restow the package
stow --no-folding --restow --dir=home --target=$HOME config
```

### Update existing dotfiles

```bash
cd ~/.dotfiles
stow --no-folding --restow --dir=home --target=$HOME <package-name>
```

### Remove a package

```bash
stow --delete --dir=home --target=$HOME <package-name>
```

### Using Omaforge utilities

```bash
# Stow all packages
omaforge-stow --all

# Stow specific packages
omaforge-stow config zsh

# Restow
omaforge-stow -R --all
```

## Fonts

Fonts are included in the `fonts/` directory. Install them with:

```bash
# macOS
cp -r ~/.dotfiles/fonts/* ~/Library/Fonts/

# Linux
mkdir -p ~/.local/share/fonts
cp -r ~/.dotfiles/fonts/* ~/.local/share/fonts/
fc-cache -fv
```

## License

GPL 3.0
