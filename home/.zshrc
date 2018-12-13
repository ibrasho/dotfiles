# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export TERM="xterm-256color"

[ -f $HOME/.zsh_theme ] && source $HOME/.zsh_theme

# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

unsetopt RM_STAR_SILENT

# Source local extra (private) settings specific to machine if it exists
[ -f $HOME/.zsh.local ] && source $HOME/.zsh.local

# Load the shell dotfiles
local SHELL_DOTFILES=(
  .sh_config
  .sh_exports
  .sh_path
  .sh_functions
  .sh_aliases
  .sh_aliases_docker
)
for file in ${SHELL_DOTFILES[@]}; do
  [ -r "$HOME/$file" ] && [ -f "$HOME/$file" ] && source "$HOME/$file"
done

eval "$(direnv hook zsh)"

# Z beats cd most of the time
source $HOME/Tools/z/z.sh

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
. "/usr/local/opt/nvm/nvm.sh"

# The next line enables shell command completion for gcloud.
. $HOME/Tools/google-cloud-sdk/completion.zsh.inc
