# Dotfiles

Personal dotfiles managed with GNU Stow.

## Installation

### Recommended (with Rig)

```bash
# One-line installer (recommended)
eval "$(curl -fsSL \
  https://raw.githubusercontent.com/pixincreate/rig/main/unix/setup)"

# Or manually clone both repos
git clone --recurse-submodules -j8 \
  https://github.com/pixincreate/dotfiles.git ~/.dotfiles
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
stow --no-folding --restow --target=$HOME \
  home/cargo home/config home/local home/Pictures home/ssh home/zsh
```

## Structure

```text
.
├── home/                   # Dotfiles organized by package
│   ├── cargo/             # Cargo configuration (~/.cargo/)
│   ├── config/            # App configs (~/.config/), git config
│   ├── local/             # Local binaries (~/.local/)
│   ├── Pictures/          # Wallpapers and screenshots
│   ├── ssh/               # SSH keys and config
│   └── zsh/               # ZSH configuration (~/.zsh/)
└── fonts/                  # Font files
```

## Packages

- **cargo** - Cargo configuration
- **config** - Application configs (zed, alacritty, starship, tmux, git, etc.)
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
rig stow --all

# Stow specific packages
rig stow config zsh

# Restow
rig stow -R --all
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

## Secrets (age)

Local shell secrets (API tokens, cookies) are stored encrypted with
[age](https://age-encryption.org/) in `~/.zsh/.env.age`. They are decrypted at
shell start by `~/.zsh/.zshenv` and exported into the environment.

- Generated with: `age-keygen -o ~/.config/age/key.txt` (private key,
  `chmod 600`, dir `700`).
- `~/.config/age/key.txt` is your **PRIVATE** key. Never commit it,
  never share it,
  back it up (password manager / encrypted USB). If you lose it, your `.env.age`
  is unrecoverable.
- `~/.config/age/key.pub` (the `age1w565…` identifier) is **PUBLIC** —
  that's what
  encrypts: `age --encrypt -r $(cat key.pub) -o .env.age file`.
- It already lives outside the dotfiles repo (not stowed), so it won't
  get committed.

Add a new variable:

```bash
# decrypt → edit → re-encrypt
age --decrypt -i ~/.config/age/key.txt ~/.zsh/.env.age > /tmp/env
$EDITOR /tmp/env            # add: export NEW_VAR=value
age --encrypt -r "$(cat ~/.config/age/key.pub)" -o ~/.zsh/.env.age /tmp/env
```

(Appending a second age stanza with `echo 'export FOO=bar' |
age --encrypt -r $(cat key.pub) >> .env.age` also works since decrypt
reads all stanzas, but re-encrypt is cleaner.)

## License

CC0 1.0 Universal
