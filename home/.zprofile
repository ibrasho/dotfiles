# Login-shell PATH setup. These prepends MUST live here (not .zshenv):
# macOS path_helper runs in /etc/zprofile AFTER .zshenv and rebuilds PATH
# with system dirs first, demoting anything .zshenv prepended.

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Flutter
[ -d "$HOME/Code/flutter/bin" ] && PATH="$HOME/Code/flutter/bin:$PATH"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# JetBrains Toolbox scripts
PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH
