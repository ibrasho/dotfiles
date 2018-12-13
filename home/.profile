
# Load the shell dotfiles
local SHELL_DOTFILES=(
  .sh_path
  .sh_exports
  .sh_functions
  .sh_aliases
  .sh_aliases_docker
)
for file in ${SHELL_DOTFILES[@]}; do
  [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ] && source "$HOME/$file"
done
