typeset -U PATH path
path=(
  $path
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
)

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

export EDITOR=nvim
export VISUAL=nvim

# Opt-out flags for tooling (npm/ads telemetry)
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# Decrypt machine-local secrets if age key and encrypted env exist
if [[ -f "$HOME/.config/age/key.txt" ]] && [[ -f "$HOME/.zsh/.env.age" ]]; then
  eval "$(age --decrypt --identity "$HOME/.config/age/key.txt" "$HOME/.zsh/.env.age" 2>/dev/null)"
fi
