# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# export TERM="xterm-256color"

[ -f $HOME/.zsh_theme ] && source $HOME/.zsh_theme

# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

# source $ZSH/oh-my-zsh.sh

# Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General
setopt BRACE_CCL          # Allow brace character class list expansion.
setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.

setopt CORRECT                   # Correct commands.

setopt COMPLETE_IN_WORD          # Complete from both ends of a word.
setopt ALWAYS_TO_END             # Move cursor to the end of a completed word.
setopt PATH_DIRS                 # Perform path search even on command names with slashes.
setopt AUTO_MENU                 # Show completion menu on a succesive tab press.
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH          # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE           # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL            # Disable start/stop characters in shell editor.

setopt LONG_LIST_JOBS            # List jobs in the long format by default.
setopt AUTO_RESUME               # Attempt to resume existing job before creating a new process.
setopt NOTIFY                    # Report status of background jobs immediately.
unsetopt BG_NICE                 # Don't run all background jobs at a lower priority.
unsetopt HUP                     # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS              # Don't report on jobs when shell exit.

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

setopt AUTO_CD                   # Auto cd to a directory without typing cd.
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS         # Don't store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME             # Push to home directory when no argument is given.
setopt CDABLE_VARS               # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS            # Auto add variable-stored paths to ~ list.
setopt MULTIOS                   # Write to multiple descriptors.
setopt EXTENDED_GLOB             # Use extended globbing syntax.
unsetopt CLOBBER                 # Don't overwrite existing files with > and >>.
                                 # Use >! and >>! to bypass.

unsetopt RM_STAR_SILENT

# load auto completion
autoload -Uz compinit
compinit


zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Source local extra (private) settings specific to machine if it exists
[ -f $HOME/.zsh.local ] && source $HOME/.zsh.local

# Load the generic shell profile
[ -f $HOME/.profile ] && source $HOME/.profile

export NVM_DIR="/Users/ibrasho/Library/Application Support/Herd/config/nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP binary.
export PATH="/Users/ibrasho/Library/Application Support/Herd/bin/":$PATH

eval "$(direnv hook zsh)"

eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ibrasho/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ibrasho/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ibrasho/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ibrasho/google-cloud-sdk/completion.zsh.inc'; fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/ibrasho/Library/Application Support/Herd/config/php/84/"

# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/ibrasho/Library/Application Support/Herd/config/php/85/"

# Added by Antigravity
export PATH="/Users/ibrasho/.antigravity/antigravity/bin:$PATH"

. "$HOME/.local/bin/env"
