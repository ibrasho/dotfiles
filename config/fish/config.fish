set -U -x LANG en_US.UTF-8
set -U theme_nerd_fonts yes

# https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 5000
set -U __done_notify_sound 1

# https://github.com/laughedelic/pisces
set -U pisces_only_insert_at_eol 1

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

# here's LS_COLORS (github.com/trapd00r/LS_COLORS)
command -v gdircolors >/dev/null 2>&1 || alias gdircolors="dircolors"
eval (gdircolors -c $HOME/Tools/dircolors/dircolors.256dark | sed 's/^setenv LS_COLORS/set -Ux LSCOLORS/')

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

# eval (rbenv init -  fish)
set -gx PATH '/Users/ibrasho/.rbenv/shims' $PATH
set -gx RBENV_SHELL fish
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    rbenv "sh-$command" $argv|source
  case '*'
    command rbenv "$command" $argv
  end
end

set -x THEFUCK_OVERRIDDEN_ALIASES 'gsed,git'

# ssh-add

# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ibrasho/google-cloud-sdk/path.fish.inc' ]; . '/Users/ibrasho/google-cloud-sdk/path.fish.inc'; end
