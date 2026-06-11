# Dotfiles

Personal dotfiles managed with GNU Stow.

## Installation

### Recommended (with Rig)

```bash
# One-line installer (recommended)
eval "$(curl -fsSL https://raw.githubusercontent.com/pixincreate/rig/main/unix/setup)"

# Or manually clone both repos
git clone --recurse-submodules -j8 https://github.com/pixincreate/dotfiles.git ~/.dotfiles
git clone https://github.com/pixincreate/rig.git ~/.rig

# Then run setup
cd ~/.rig/unix/macos && ./macos-setup   # macOS
cd ~/.rig/unix/fedora && ./fedora-setup # Fedora
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

### Using Rig utilities

```bash
# Stow all packages
rig-stow --all

# Stow specific packages
rig-stow config zsh

# Restow
rig-stow -R --all
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

CC0 1.0 Universal
