# Load the shell dotfiles
local SHELL_DOTFILES=(
  .sh_exports
  .sh_path
  .sh_functions
  .sh_aliases
  .sh_aliases_docker
  .sh_aliases_kubectl
)
for file in ${SHELL_DOTFILES[@]}; do
  [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ] && source "$HOME/$file"
done

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
