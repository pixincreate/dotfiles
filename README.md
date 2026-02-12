# Dotfiles

Personal dotfiles managed with GNU Stow.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/pixincreate/dotfiles.git ~/.dotfiles

# Install GNU Stow if not already installed
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
│   ├── ssh/               # SSH configuration (~/.ssh/)
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
