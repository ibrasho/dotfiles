# Path to your oh-my-zsh installation.
# export ZSH=$HOME/.oh-my-zsh

export TERM="xterm-256color"

[ -f $HOME/.zsh_theme ] && source $HOME/.zsh_theme

# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

# source $ZSH/oh-my-zsh.sh

unsetopt RM_STAR_SILENT

# Source local extra (private) settings specific to machine if it exists
[ -f $HOME/.zsh.local ] && source $HOME/.zsh.local

# Load the generic shell profile
[ -f $HOME/.profile ] && source $HOME/.profile

# eval "$(direnv hook zsh)"

# zsh completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Make Ruby use Homebrew OpenSSL
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Enable pyenv shims
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
