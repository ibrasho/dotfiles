# Bash interactive config — the bash counterpart of .zshrc.
# Reached directly by non-login interactive shells (`bash`, some IDE
# terminals) and via .bash_profile for login shells.

# Non-interactive shells (scripts, `bash -c`) must stay silent and fast.
[[ $- == *i* ]] || return

# ---------------------------------------------------------------------------
# Shell options (closest bash equivalents of the zsh setopts)
# ---------------------------------------------------------------------------
shopt -s autocd cdspell dirspell cdable_vars  # AUTO_CD, CORRECT-ish, CDABLE_VARS
shopt -s extglob globstar                     # EXTENDED_GLOB-ish, ** recursion
shopt -s checkwinsize                         # keep LINES/COLUMNS right after resize
shopt -s histappend cmdhist histverify        # append (don't clobber) history; HIST_VERIFY
stty -ixon 2>/dev/null                        # FLOW_CONTROL off: frees ctrl-s for search
# noclobber deliberately stays off, matching .zshrc's CLOBBER.

# ---------------------------------------------------------------------------
# Completion — bash-completion@2 lazy-loads per command, so this is cheap.
# Needs bash >= 4.2: the Homebrew bash, not macOS's /bin/bash 3.2.
# ---------------------------------------------------------------------------
# EXCEPT the legacy etc/bash_completion.d dir, which is sourced eagerly; gdal
# (a dependency, not a tool used by hand) drops 53 files there at ~12ms each,
# which alone took startup from ~120ms to ~750ms. Value is an extglob pattern.
# shellcheck disable=SC2034  # read by bash_completion
BASH_COMPLETION_COMPAT_IGNORE='gdal*|ogr*|gnm*|sozip|nearblack'
if [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
  . /opt/homebrew/etc/profile.d/bash_completion.sh
fi
bind 'set completion-ignore-case on' 2>/dev/null
bind 'set show-all-if-ambiguous on' 2>/dev/null
bind 'set mark-symlinked-directories on' 2>/dev/null

# Load the generic shell profile (PATH, exports incl. history, functions,
# aliases, mise).
[ -f "$HOME/.profile" ] && . "$HOME/.profile"

# Bash history settings. HISTFILE itself is set per-shell in .sh_exports.
HISTCONTROL=ignoreboth:erasedups   # HIST_IGNORE_SPACE + HIST_IGNORE_DUPS
HISTTIMEFORMAT='%F %T  '           # EXTENDED_HISTORY
# Write each command as it runs so new tabs see it (approximates SHARE_HISTORY).
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# ---------------------------------------------------------------------------
# Herd's NVM — lazy-loaded, same reasoning as in .zshrc: sourcing nvm.sh
# eagerly costs ~450ms per shell. Put the default node on PATH via globbing
# (no forks) and source nvm.sh only when `nvm` is called.
# ---------------------------------------------------------------------------
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"

if [[ -r "$NVM_DIR/alias/default" ]]; then
  _nvm_default="$(<"$NVM_DIR/alias/default")"
  _nvm_nullglob=$(shopt -p nullglob)
  shopt -s nullglob
  _nvm_matches=("$NVM_DIR/versions/node/v${_nvm_default#v}"*/)
  eval "$_nvm_nullglob"
  # Glob sorts lexically, so v22.9 would beat v22.10. Only matters if the
  # default major ever has minors of differing digit counts installed.
  (( ${#_nvm_matches[@]} )) && PATH="${_nvm_matches[-1]%/}/bin:$PATH"
  unset _nvm_default _nvm_matches _nvm_nullglob
fi

nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && builtin source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# .nvmrc auto-switch — bash port of Herd's zsh-only chpwd hook. Runs every
# prompt, so the common path must not fork: bail unless PWD changed, then walk
# up for .nvmrc in pure bash. nvm itself (slow) runs only when the governing
# .nvmrc changes: `nvm use` on entering a project, `nvm use default` on
# leaving one.
_nvmrc_hook() {
  [[ $PWD == "${_nvmrc_pwd-}" ]] && return
  _nvmrc_pwd=$PWD
  local dir=$PWD found=
  while [[ -n $dir ]]; do
    [[ -e $dir/.nvmrc ]] && { found=$dir/.nvmrc; break; }
    dir=${dir%/*}
  done
  [[ $found == "${_nvmrc_active-}" ]] && return
  if [[ -n $found ]]; then
    # nvm reads .nvmrc from PWD upward, i.e. the same file found above.
    # Try `use` first; a separate `nvm version` probe costs ~1s on its own.
    nvm use --silent >/dev/null 2>&1 || nvm install
  elif [[ -n ${_nvmrc_active-} ]]; then
    echo "Reverting to nvm default version"
    nvm use --silent default
  fi
  _nvmrc_active=$found
}
# Registered before `starship init`, which moves PROMPT_COMMAND into
# STARSHIP_PROMPT_COMMAND and runs it after saving $? but before drawing the
# prompt, so the node module shows the switched version on the same prompt.
PROMPT_COMMAND="_nvmrc_hook${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

export PATH="$HOME/Library/Application Support/Herd/bin:$PATH"
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"

# ---------------------------------------------------------------------------
# Tool init (mise is activated in .profile)
# ---------------------------------------------------------------------------
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

# Starship prompt; the hand-rolled .bash_prompt is only a fallback — it forks
# git ~6 times per prompt, which is noticeably slow in big repos.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
elif [ -f "$HOME/.bash_prompt" ]; then
  . "$HOME/.bash_prompt"
fi

# fzf — ctrl-r history, ctrl-t files, alt-c cd
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

# Google Cloud SDK
[ -f "$HOME/google-cloud-sdk/path.bash.inc" ] && . "$HOME/google-cloud-sdk/path.bash.inc"
[ -f "$HOME/google-cloud-sdk/completion.bash.inc" ] && . "$HOME/google-cloud-sdk/completion.bash.inc"

# pnpm, bun
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
PATH="$PNPM_HOME/bin:$BUN_INSTALL/bin:$PATH"

# micromamba — lazy-loaded like nvm: the shell hook forks micromamba on every
# startup (~15ms) for a tool used rarely. The stub runs the real hook on first
# call; the hook defines the real `micromamba` function, replacing this one.
if [ -x "$HOME/.micromamba/bin/micromamba" ]; then
  export MAMBA_EXE="$HOME/.micromamba/bin/micromamba"
  export MAMBA_ROOT_PREFIX="$HOME/micromamba"
  micromamba() {
    unset -f micromamba
    local hook
    if hook="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"; then
      eval "$hook"
      micromamba "$@"
    else
      # Without the hook, `activate` can't modify this shell; the rest works.
      "$MAMBA_EXE" "$@"
    fi
  }
fi

# Bash has no `typeset -U`: nested shells re-run the prepends above, so dedupe
# PATH in pure bash (no forks), keeping the first occurrence of each entry.
_dedup_path() {
  local IFS=: dir out=
  local -A seen=()
  for dir in $PATH; do
    [[ -z $dir || -n ${seen[$dir]} ]] && continue
    seen[$dir]=1
    out+=${out:+:}$dir
  done
  PATH=$out
}
_dedup_path
unset -f _dedup_path
export PATH

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

# Machine-local overrides, loaded LAST (the bash twin of ~/.zsh.local).
[ -f "$HOME/.bash.local" ] && . "$HOME/.bash.local"
