# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Load the shell dotfiles
declare -a SHELL_DOTFILES=(
  .sh_path
  .sh_config
  .sh_exports
  .sh_functions
  .sh_aliases
  .sh_aliases_docker
)
for file in ${SHELL_DOTFILES[@]}; do
  # [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ] && source "$HOME/$file"
done
unset SHELL_DOTFILES

# Z beats cd most of the time
source $HOME/.dotfiles/z/z.sh


[ -f `brew --prefix`/etc/bash_completion ] && source `brew --prefix`/etc/bash_completion

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

[ -f $HOME/.zsh_theme ] && source $HOME/.zsh_theme

# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Source local extra (private) settings specific to machine if it exists
[ -f $HOME/.zsh.local ] && source $HOME/.zsh.local
