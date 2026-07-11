# Load the shell dotfiles (POSIX sh compatible: no arrays, no `local`)
for file in .sh_path .sh_exports .sh_functions .sh_aliases; do
  if [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ]; then
    . "$HOME/$file"
  fi
done
unset file

# Mise version manager (replaces rbenv, nvm, etc.)
# Zsh activates mise itself in .zshrc; only handle bash here.
if [ -z "$ZSH_VERSION" ] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
