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

# Load the generic shell profile
[ -f $HOME/.profile ] && source $HOME/.profile

eval "$(direnv hook zsh)"

# The next line enables shell command completion for gcloud.
source $HOME/Tools/google-cloud-sdk/completion.zsh.inc
