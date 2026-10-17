# Login-shell PATH setup. These prepends MUST live here (not .zshenv):
# macOS path_helper runs in /etc/zprofile AFTER .zshenv and rebuilds PATH
# with system dirs first, demoting anything .zshenv prepended.

# Homebrew — hardcoded copy of `brew shellenv zsh` output (Homebrew 7.0.9)
# instead of eval'ing it: that forks brew (~10ms) on every login shell, the
# same reason .sh_path hardcodes /opt/homebrew. Re-sync if a brew upgrade
# changes what `brew shellenv` prints.
if [ -d /opt/homebrew/bin ]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
  export FPATH
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
