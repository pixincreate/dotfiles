# shellcheck shell=bash

# A function to check if a command exists
command_exists() {
  command -v "$1" > /dev/null 2>&1
}

# Auto-start tmux in all terminals unless explicitly opted out
__start_tmux() {
  if [ -n "$TMUX" ] || [ -n "$NO_TMUX" ] || ! command -v tmux &> /dev/null; then
    return 0
  fi

  local _session
  case "$TERM_PROGRAM" in
    vscode)
      _session="vscode"
      ;;
    zed)
      # Derive session name from project root. Falls back to generic "zed" if
      # we can't determine a meaningful directory (avoids "zed-/" garbage).
      local _dir="${ZED_WORKTREE_ROOT:-$PWD}"
      if [ "$_dir" = "/" ] || [ "$_dir" = "$HOME" ] || [ -z "$_dir" ]; then
        _session="zed"
      else
        _session="zed-$(basename "$_dir" | tr '.' '_')"
      fi
      ;;
    *)
      _session="main"
      ;;
  esac

  # -A = attach if exists, create if not.
  # On a fresh server, start it detached and let continuum auto-restore the
  # saved sessions first (single creation source). Otherwise we race resurrect:
  # our session creation + continuum's restore both fire in the 10s window and
  # scramble the layout. Wait for our target session to appear (or the window
  # to elapse) before attaching/creating.
  if ! tmux has-session 2>/dev/null; then
    tmux start-server
    local _i=0
    while [ "$_i" -lt 20 ] && ! tmux has-session -t "$_session" 2>/dev/null; do
      sleep 0.5
      _i=$((_i + 1))
    done
  fi
  exec tmux new-session -A -s "$_session"
}
__start_tmux
unset -f __start_tmux

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# Zstyle
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

# History
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=100000

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Options
setopt append_history         # Append history list to the history file, rather than replace it
setopt inc_append_history     # Write to the history file immediately, not when the shell exits
setopt share_history          # Share history between all sessions
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history
setopt hist_ignore_dups       # Do not record an event that was just recorded again
setopt hist_ignore_all_dups   # Delete an old recorded event if a new event is a duplicate
setopt hist_find_no_dups      # Do not display a previously found event
setopt hist_ignore_space      # Do not record an event starting with a space
setopt hist_save_no_dups      # Do not write a duplicate event to the history file
setopt hist_verify            # Do not execute immediately upon history expansion
setopt extended_history       # Show timestamp in history
setopt extended_glob          # Use extended globbing
setopt auto_cd                # Automatically change directory if a directory is entered
setopt notify                 # Report the status of background jobs immediately

# Aliases
alias cd='z'
alias ls='eza -lh --group-directories-first --icons --hyperlink'
alias lsa='ls -a'
alias ll='ls --color=auto -l --almost-all --human-readable'
alias exal='eza --long --all --binary --header'
alias ip='ip --color'
alias ncdu='ncdu -rr --color dark'
alias cat='bat'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias cls='clear'
alias multitail='multitail --no-repeat -c'
alias vi='nvim'
alias reload='echo "Reloading shell...";sleep 1;clear;exec ${SHELL} -l'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'  # Open files in nvim with fzf

# Load zsh_history with fzf
alias hish='cat $ZDOTDIR/.zsh_history | fzf'

# Tmux aliases
alias tbg='tmux kill-server && tmux -f ~/.config/tmux/tmux.conf > tmux.log 2>&1'
alias tls='tmux ls'
alias tll='tmux list-panes -s -F "#{session_name}: #{pane_current_command}" 2>/dev/null || tmux list-windows -F "#{session_name}: #{window_name}"'

## Directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

### Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

### Alias's for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -lcrh'               # sort by change time
alias lu='ls -lurh'               # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | grep -Ev '^d'"  # files only
alias ldir="ls -l | grep -E '^d'" # directories only

## Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias treef='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

## Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

## Git specific aliases
alias gs='git status'

## SHA1
alias sha1='openssl sha1'

## Search files in the current folder
alias f="find . | grep "

## Count all files (recursively) in the current folder
countfiles() {
  for t in files links directories; do
    echo "$(find . -type "${t:0:1}" | wc -l) $t"
  done 2>/dev/null
}

## To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

## Show open ports
alias openports='netstat -nape --inet'

# IP address lookup
alias whatismyip="whatsmyip"

# Linux version of OSX pbcopy and pbpaste
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
elif [[ "$OSTYPE" == "linux-android" ]]; then
  pbcopy() { termux-clipboard-set "$1"; }
  alias pbpaste='termux-clipboard-get'
fi

function whatsmyip() {
  # Internal IP Lookup.
  if [ -e /sbin/ip ]; then
    echo -n "Internal IP: "
    /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
  else
    echo -n "Internal IP: "
    /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
  fi

  # External IP Lookup
  echo -n "External IP: "
  curl -s ifconfig.me
}
# Extracts any archive(s) (if unp isn't installed)
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      # shellcheck disable=SC2086
      case $archive in
        *.tar.bz2) tar xvjf "$archive" ;;
        *.tar.gz) tar xvzf "$archive" ;;
        *.bz2) bunzip2 "$archive" ;;
        *.rar) rar x "$archive" ;;
        *.gz) gunzip "$archive" ;;
        *.tar) tar xvf "$archive" ;;
        *.tbz2) tar xvjf "$archive" ;;
        *.tgz) tar xvzf "$archive" ;;
        *.zip) unzip "$archive" ;;
        *.Z) uncompress "$archive" ;;
        *.7z) 7z x "$archive" ;;
        *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# Create an archive from the supplied paths
compress() {
  local archive="$1"
  shift
  case "$archive" in
    *.tar.bz2) tar --create --verbose --bzip2 --file "$archive" "$@" ;;
    *.tar.gz) tar --create --verbose --gzip --file "$archive" "$@" ;;
    *.tar.xz) tar --create --verbose --xz --file "$archive" "$@" ;;
    *.tar) tar --create --verbose --file "$archive" "$@" ;;
    *.zip) zip --recurse-paths "$archive" "$@" ;;
    *.7z) 7z a "$archive" "$@" ;;
    *) echo "Unsupported archive extension: $archive" ;;
  esac
}

# SSH port forwards
# fip host [remote_port] [local_port] - forward a remote port to localhost
fip() {
  local host="$1"
  local remote_port="${2:-8080}"
  local local_port="${3:-$remote_port}"
  echo "Forwarding localhost:${local_port} -> ${host}:${remote_port} (Ctrl+C to stop)"
  ssh -N -L "${local_port}:localhost:${remote_port}" "$host"
}

# lip - list active ssh port forwards
lip() {
  ps aux | grep --extended-regexp 'ssh .*-(L|D)' | grep --invert-match grep
}

# dip <port> <host> - dynamic SOCKS proxy
dip() {
  local port="${1:-1080}"
  local host="${2:-}"
  if [[ -z "$host" ]]; then
    echo "Usage: dip <port> <host>"
    return 1
  fi
  echo "SOCKS proxy on localhost:${port} (Ctrl+C to stop)"
  ssh -N -D "${port}" "$host"
}

# Returns the last 2 fields of the working directory
pwdtail() {
  pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Copy file with a progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
  if [ -d "$2" ]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

# Move and go to the directory
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Create and go to the directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
  local d="" limit="$1"
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd "$d"
}

# ZGenom
if [[ ! -f "$ZDOTDIR/.zgenom/zgenom.zsh" ]]; then
  command git clone https://github.com/jandamm/zgenom.git "$ZDOTDIR/.zgenom"
  command mkdir -p "$ZDOTDIR" && command chmod g-rwX "$ZDOTDIR/.zgenom"
fi

# Source zgenom
source "${ZDOTDIR}/.zgenom/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

# use zgenom reset to delete init.zsh
# If the zgenom init script doesn't exist
if ! zgenom saved; then
  zgenom compdef

  # ohmyzsh keybindings
  zgenom ohmyzsh lib/key-bindings.zsh

  # Library files from ohmyzsh
  zgenom ohmyzsh lib/functions.zsh
  zgenom ohmyzsh lib/termsupport.zsh
  zgenom ohmyzsh plugins/eza
  zgenom ohmyzsh plugins/git
  zgenom ohmyzsh plugins/gitignore

  # LS_COLORS
  zgenom load trapd00r/LS_COLORS lscolors.sh

  # Plugins files from zsh-users
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions

  # Save plugins to init script
  zgenom save

  # Compile files
  zgenom compile "${ZDOTDIR}/zgenom/zgenom.zsh"
fi

# zoxide
eval "$(zoxide init zsh)"

# direnv
eval "$(direnv hook zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up atuin
eval "$(atuin init zsh)"

# Load Starship and transient prompt
[[ -f ~/.zsh/.starship.sh ]] && source ~/.zsh/.starship.sh

# Load local platform/machine-specific configuration
[[ -f ~/.zsh/local.zsh ]] && source ~/.zsh/local.zsh
