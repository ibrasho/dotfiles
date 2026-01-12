# Load the shell dotfiles
local SHELL_DOTFILES=(
  .sh_path
  .sh_exports
  .sh_functions
  .sh_aliases
)
for file in ${SHELL_DOTFILES[@]}; do
  if [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ]; then
    source "$HOME/$file" || print_error "Failed to source $file"
  fi
done

# Mise version manager (replaces rbenv, nvm, etc.)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
