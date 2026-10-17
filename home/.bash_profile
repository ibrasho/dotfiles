# Bash login shell (every new Terminal/iTerm tab on macOS is a login shell).
# Mirrors .zprofile: PATH prepends live here because /etc/profile runs
# path_helper BEFORE this file and would demote anything set earlier.
# Interactive config lives in .bashrc, sourced at the bottom.

# Homebrew — hardcoded copy of `brew shellenv bash` output (Homebrew 7.0.9)
# instead of eval'ing it: that forks brew (~10ms) on every login shell, the
# same reason .sh_path hardcodes /opt/homebrew. Re-sync if a brew upgrade
# changes what `brew shellenv` prints.
if [ -d /opt/homebrew/bin ]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
  # Trailing ':' stripped, leading ':' ensured: keeps man's default search path.
  [ -z "${MANPATH-}" ] || { export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"; export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"; }
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
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
