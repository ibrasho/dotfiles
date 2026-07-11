#!/bin/bash

# This is safe to run multiple times and will prompt you about anything unclear
set -e

# Get the dotfiles directory's absolute path
export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/utils.sh"

# Every prompt below reads from stdin — fail fast (and clearly) when there is
# no terminal instead of dying on the first `read` with no explanation.
if [ ! -t 0 ]; then
  print_error "setup.sh needs an interactive terminal (its prompts read from stdin)" ""
  exit 1
fi

# set -e exits silently; say where it happened.
trap 'print_error "Setup failed at line $LINENO:" "$BASH_COMMAND"' ERR

###############################################################################
# Copy files                                                                  #
###############################################################################

# Warn user this script will overwrite current dotfiles
while true; do
  print_question "Warning: this will overwrite your current dotfiles. Continue? [y/n] "
  read -r yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Timestamped subdir so re-runs never clobber an earlier backup of the
# same filename (the backup can be the only copy).
DOTFILES_BACKUP="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

print_info "Creating $DOTFILES_BACKUP for backup of any existing dotfiles in $HOME"
mkdir -p "$DOTFILES_BACKUP"

# Actual symlink stuff
print_info "Creating symlinks"

for file in "$DOTFILES/home"/.[^.]* "$DOTFILES/home"/*; do
  [ -e "$file" ] || continue
  if [ ! -f "$file" ]; then
    print_error "skipping $file (directories in home/ are not symlinked)" ""
    continue
  fi

  SOURCE_FILE="$file"
  TARGET_FILE="$HOME/$(basename "$file")"

  safeSymlink "$SOURCE_FILE" "$TARGET_FILE" "$DOTFILES_BACKUP"
done

if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

safeSymlink "$DOTFILES/ssh/config" "$HOME/.ssh/config" "$DOTFILES_BACKUP"


# Copy GnuPG config files
if [ ! -d "$HOME/.gnupg" ]; then
  mkdir -p "$HOME/.gnupg"
  chmod 700 "$HOME/.gnupg"
fi

if [ -d "$DOTFILES/gnupg" ]; then
  for file in "$DOTFILES/gnupg"/*; do
    [ -f "$file" ] || continue

    SOURCE_FILE="$file"
    TARGET_FILE="$HOME/.gnupg/$(basename "$file")"

    safeSymlink "$SOURCE_FILE" "$TARGET_FILE" "$DOTFILES_BACKUP"
  done
fi


###############################################################################
# Claude Code config (~/.claude)                                              #
###############################################################################

if [ ! -e "$HOME/.claude" ]; then
  print_info "Installing Claude Code config from ibrasho/dotclaude"
  # https here: on a fresh machine SSH keys/1Password may not be set up yet.
  # Switch the remote to git@github.com:ibrasho/dotclaude.git afterwards.
  git clone https://github.com/ibrasho/dotclaude "$HOME/.claude" \
    || print_error "Failed to clone dotclaude; clone it manually" ""
elif [ ! -d "$HOME/.claude/.git" ]; then
  print_error "$HOME/.claude exists but is not a git clone of dotclaude; reconcile manually" ""
fi

###############################################################################
# dcg — destructive command guard                                             #
# https://github.com/Dicklesworthstone/destructive_command_guard              #
###############################################################################

# Installed AFTER ~/.claude exists so the installer can register its
# Claude Code PreToolUse hook in ~/.claude/settings.json (--easy-mode
# also puts the binary on PATH and configures other detected agents).
if ! command -v dcg >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/dcg" ]; then
  print_info "Installing dcg (destructive command guard)"
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/main/install.sh" \
    | bash -s -- --easy-mode \
    || print_error "dcg install failed; install manually" ""
fi

###############################################################################
# ~/.config tools (starship, mise)                                            #
###############################################################################

mkdir -p "$HOME/.config"
safeSymlink "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml" "$DOTFILES_BACKUP"

# mise only reads global config from ~/.config/mise/config.toml — the repo's
# .mise.toml is not in any project's parent path, so without this link it
# would never take effect.
mkdir -p "$HOME/.config/mise"
safeSymlink "$DOTFILES/.mise.toml" "$HOME/.config/mise/config.toml" "$DOTFILES_BACKUP"


###############################################################################
# Package managers & packages                                                 #
###############################################################################

# print_info "Installing brew packages"
source "$DOTFILES/install/brew.sh"

if [ "$(uname)" == "Darwin" ]; then
    print_info "Installing brew casks"
    source "$DOTFILES/install/brew-cask.sh"
fi


###############################################################################
# iTerm 2                                                                     #
###############################################################################

print_info "Configured iTerm to load config from $DOTFILES/iterm2"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm2"


###############################################################################
# Cloudflared                                                                 #
###############################################################################

if command -v cloudflared >/dev/null 2>&1; then
  print_info "Configuring cloudflared"

  # cloudflared reads per-user config from ~/.cloudflared (no sudo needed,
  # unlike /usr/local/etc which is root-owned on modern macOS)
  mkdir -p "$HOME/.cloudflared"
  safeSymlink "$DOTFILES/cloudflared/config.yaml" "$HOME/.cloudflared/config.yaml" "$DOTFILES_BACKUP"

  # The service can land as a user LaunchAgent or (with proxy-dns on port 53)
  # a root LaunchDaemon — check both before re-installing, and don't let a
  # failure kill the rest of setup.
  if [ ! -f "$HOME/Library/LaunchAgents/com.cloudflare.cloudflared.plist" ] \
     && [ ! -f "/Library/LaunchDaemons/com.cloudflare.cloudflared.plist" ]; then
    sudo cloudflared service install \
      || print_error "cloudflared service install failed; run it manually" ""
  fi
else
  print_info "cloudflared not installed; skipping (brew install cloudflared)"
fi


###############################################################################
# Zsh                                                                         #
###############################################################################

source "$DOTFILES/install/zsh.sh"

###############################################################################
# Done                                                                        #
###############################################################################

print_success "Setup complete. Restart your terminal (or run 'exec zsh') to load the new settings."
