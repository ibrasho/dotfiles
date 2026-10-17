# Keep PATH/fpath free of duplicates no matter how many times things prepend
typeset -U path PATH fpath FPATH

# General
unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.

# Bash compatibility: commands pasted from docs/scripts are written for bash,
# and each of these zsh-isms makes valid bash fail or silently differ.
setopt CLOBBER                   # `>` overwrites and `>>` creates, as in bash (NO_CLOBBER refused both).
unsetopt NOMATCH                 # Unmatched globs pass through literally: `pip install x[dev]`, URLs with `?`, `HEAD^`.
unsetopt EQUALS                  # `=word` is plain text, not a command lookup (`echo ===` failed with "not found").
unsetopt BRACE_CCL               # `{1}` stays literal: BRACE_CCL turned `git show stash@{1}` into `stash@1`.
unsetopt RC_QUOTES               # `'a''b'` is `ab` as in bash, not `a'b`.
unsetopt CORRECT                 # No "zsh: correct 'x' to 'y' [nyae]?" prompts.
setopt INTERACTIVE_COMMENTS      # `cmd  # comment` works at the prompt, as in pasted snippets.

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
setopt SHARE_HISTORY             # Share history between all sessions (implies INC_APPEND_HISTORY).
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
# EXTENDED_GLOB is deliberately OFF (bash-like): it makes `^`, `#` and `~`
# glob operators, so `git reset HEAD^` or `curl ...#frag` can misfire. It is
# enabled only around the compinit check below, whose (#q...) needs it.

unsetopt RM_STAR_SILENT

# load auto completion
# Extra completions must be in fpath before compinit runs. The second dir holds
# `_dcg` and `_lerd`.
fpath=(/opt/homebrew/share/zsh/site-functions "$HOME/.local/share/zsh/site-functions" $fpath)

# Do a full (slow) compinit only if the dump is older than 24h; otherwise
# trust the cache with -C and skip the security audit. The `touch` is load-
# bearing: plain compinit does not rewrite a still-valid dump, so without it
# the mtime never refreshes and every shell takes the slow path forever.
autoload -Uz compinit
setopt EXTENDED_GLOB
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
  touch "${ZDOTDIR:-$HOME}/.zcompdump"
else
  compinit -C
fi
unsetopt EXTENDED_GLOB

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Load the generic shell profile
[ -f $HOME/.profile ] && source $HOME/.profile

# ---------------------------------------------------------------------------
# Herd's NVM — lazy-loaded. Eagerly sourcing nvm.sh costs ~450ms per shell
# (it forks dozens of subshells resolving the default version), which was
# ~70% of total startup. Instead: put the default node on PATH directly,
# and only source nvm.sh when `nvm` is invoked or a .nvmrc directory is
# entered (replicating Herd's auto-switch hook).
# ---------------------------------------------------------------------------
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"

# Resolve the default alias (e.g. "22") to the newest installed match and
# prepend its bin dir — same result as nvm.sh's auto-use, without the forks.
if [[ -r "$NVM_DIR/alias/default" ]]; then
  _nvm_default="$(<"$NVM_DIR/alias/default")"
  _nvm_matches=("$NVM_DIR/versions/node/v${_nvm_default#v}"*(Nn/))
  (( ${#_nvm_matches} )) && path=("${_nvm_matches[-1]}/bin" $path)
  unset _nvm_default _nvm_matches
fi

_load_nvm() {
  unfunction nvm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && builtin source "$NVM_DIR/nvm.sh"
}

nvm() {
  _load_nvm
  nvm "$@"
}

# Herd's auto-switch-on-cd (zshrc.zsh) needs the real nvm functions, so use a
# cheap stand-in hook: walk up looking for .nvmrc (pure zsh, no forks) and
# only then load nvm + Herd's real hook, which takes over from there.
autoload -U add-zsh-hook
_herd_nvmrc_hook() {
  local dir=$PWD
  while [[ -n $dir ]]; do
    if [[ -e $dir/.nvmrc ]]; then
      add-zsh-hook -d chpwd _herd_nvmrc_hook
      _load_nvm
      [[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && \
        builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"
      return
    fi
    dir=${dir%/*}
  done
}
add-zsh-hook chpwd _herd_nvmrc_hook
_herd_nvmrc_hook  # cover shells that open directly inside a node project

export PATH="$HOME/Library/Application Support/Herd/bin:$PATH"

# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"

# Mise version manager (replaces rbenv, nvm, etc.)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Direnv - load environment variables per directory
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Zoxide - smarter cd command
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# fzf - fuzzy finder (ctrl-r history, ctrl-t files; also powers zoxide's zi)
# [[ -o zle ]] guards: these need the line editor, which is unavailable in
# tty-less shells (scripts, IDE probes) and would warn there.
if [[ -o zle && -t 0 ]] && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Fish-style inline suggestions from history
[[ -o zle && -t 0 ]] && [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# pnpm (typeset -U at the top dedupes PATH, so a plain prepend is safe)
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

# Source local extra (private) settings specific to machine if it exists.
# Loaded LAST so machine-local settings can override everything above.
[ -f $HOME/.zsh.local ] && source $HOME/.zsh.local

# Syntax highlighting must be sourced at the very end of .zshrc
[[ -o zle && -t 0 ]] && [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Installers (pnpm, Herd, Vite+) append blocks BELOW this line on
# install/upgrade. Fold them into the sections above instead: anything sourced
# after syntax highlighting breaks it. Vite+ (.vite-plus/env) is in .zprofile.
