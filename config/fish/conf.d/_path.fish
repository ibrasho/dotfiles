if test -e /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
else if test -e /usr/local/bin/brew
  eval (/usr/local/bin/brew shellenv)
end

# export BASH_ENV='~/.bashenv'

set -gx NVM_DIR $HOME/.nvm

set -gx ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -gx ANDROID_HOME $HOME/Library/Android/sdk

set -gx GOPROXY https://proxy.golang.org

set -gx PYENV_ROOT "$HOME/.pyenv"

set -g BREW_PREFIX (brew --prefix)

set -gx PATH \
  ./bin \
  ./vendor/bin \
  ./node_modules/.bin \
  $HOME/Code/flutter/bin \
  $HOME/go/bin \
  $HOME/.node/bin \
  $HOME/.composer/vendor/bin \
  $HOME/.composer/bin \
  $HOME/Library/Android/sdk/platform-tools \
  $HOME/bin \
  $PYENV_ROOT/bin \
  $HOME/Library/Python/3.8/bin \
  $BREW_PREFIX/opt/openjdk/bin \
  $BREW_PREFIX/opt/coreutils/libexec/gnubin \
  $GOPATH/bin \
  $PATH

set -gx MANPATH \
  $BREW_PREFIX/opt/coreutils/libexec/gnuman \
  $MANPATH
