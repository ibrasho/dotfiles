# Bash login shell (every new Terminal/iTerm tab on macOS is a login shell).
# Mirrors .zprofile: PATH prepends live here because /etc/profile runs
# path_helper BEFORE this file and would demote anything set earlier.
# Interactive config lives in .bashrc, sourced at the bottom.

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# JetBrains Toolbox scripts
PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH

# Login shells don't read .bashrc on their own. Non-interactive login shells
# (`bash -lc ...`) still need the shared PATH/exports, but not the prompt and
# completion setup, so they get .profile only.
if [[ $- == *i* ]]; then
  [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
else
  [ -f "$HOME/.profile" ] && . "$HOME/.profile"
fi
