set -U -x LANG en_US.UTF-8
set -U theme_nerd_fonts yes

# https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 5000
set -U __done_notify_sound 1

# https://github.com/laughedelic/pisces
set -U pisces_only_insert_at_eol 1

set -gx SSH_KEY_PATH $HOME/.ssh/ibrasho

# Make less the default pager, add some options and enable syntax highlight using source-highlight
set -g LESSPIPE (which src-hilite-lesspipe.sh)
[ -n "$LESSPIPE" ] && set -gx LESSOPEN "| $LESSPIPE %s"
set -gx LESS \
  --quit-if-one-screen \
  --no-init \
  --ignore-case \
  --chop-long-lines \
  --RAW-CONTROL-CHARS \
  --quiet \
  --dumb

set -gx PAGER less

set -gx HOMEBREW_CASK_OPTS --appdir=/Applications

# here's LS_COLORS
# github.com/trapd00r/LS_COLORS

set -gx GOPATH $HOME/Code/go

# export BASH_ENV='~/.bashenv'

set -gx NVM_DIR $HOME/.nvm

set -gx ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -gx ANDROID_HOME $HOME/Library/Android/sdk

set -gx GOPROXY https://proxy.golang.org

set -gx PYENV_ROOT "$HOME/.pyenv"

set -gx PATH \
  $HOME/Code/flutter/bin \
  $HOME/.krew/bin \
  ./vendor/bin \
  $HOME/.composer/vendor/bin \
  $HOME/Library/Android/sdk/platform-tools \
  $PYENV_ROOT/bin \
  $HOME/Library/Python/3.8/bin \
  ./node_modules/.bin \
  $HOME/.node/bin \
  ./vendor/bin \
  $HOME/.composer/bin \
  $HOME/.composer/vendor/bin \
  $HOME/.cargo/bin \
  $GOPATH/bin \
  /usr/local/opt/openjdk/bin \
  $HOME/bin \
  /usr/local/opt/coreutils/libexec/gnubin \
  $PATH

set -gx MANPATH \
  /usr/local/opt/coreutils/libexec/gnuman \
  $MANPATH


starship init fish | source

set HB_CNF_HANDLER (brew --prefix)"/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
if test -f $HB_CNF_HANDLER
   source $HB_CNF_HANDLER
end

complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

function git-refresh --on-variable PWD \
  --description "git pull automatically wherever inside a git repository"
    set --local hasGit (find . -maxdepth 1 -type d -name .git -print)
    if test "$hasGit" = "./.git"
        echo -e "\e[1m - git repo detected\e[0m"
        git pull --all --verbose
    end
end

eval (direnv hook fish)