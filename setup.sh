#!/bin/bash

# This is safe to run multiple times and will prompt you about anything unclear
set -e

# Get the dotfiles directory's absolute path
export DOTFILES="$HOME/.dotfiles"
mkdir -p "$HOME/Tools"

source "$DOTFILES/utils.sh"

###############################################################################
# Copy files                                                                  #
###############################################################################

# Warn user this script will overwrite current dotfiles
while true; do
  print_question "Warning: this will overwrite your current dotfiles. Continue? [y/n] "
  read -p "" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

DOTFILES_BACKUP="$HOME/.dotfiles_backup"
BIN_BACKUP="$HOME/.bin_backup"

# Create dotfiles_old in homedir
print_info "Creating $DOTFILES_BACKUP for backup of any existing dotfiles in $HOME"
mkdir -p "$DOTFILES_BACKUP"

print_info "Creating $BIN_BACKUP for backup of any existing bin in $HOME/bin"
mkdir -p "$BIN_BACKUP"

# Change to the dotfiles directory
print_info "Changing to the $DOTFILES directory..."

# Actual symlink stuff
print_info "Creating symlinks"

for file in "$DOTFILES/home"/.[^.]* "$DOTFILES/home"/*; do
  [ -e "$file" ] || continue
  [ -f "$file" ] || continue

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
# dircolors                                                                   #
###############################################################################

print_info "Installing dircolors"
if [ ! -d "$HOME/Tools/dircolors" ]; then
  git clone "https://github.com/gibbling666/dircolors.git" "$HOME/Tools/dircolors"
  print_success "Installed dircolors"
fi


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
defaults write "com.googlecode.iterm2.plist" "LoadPrefsFromCustomFolder" -bool true

# Specify the preferences directory
defaults write "com.googlecode.iterm2.plist" "PrefsCustomFolder" -string "$DOTFILES/iterm2"


###############################################################################
# Cloudflared                                                                 #
###############################################################################

print_info "Installing cloudflared"

mkdir -p "/usr/local/etc/cloudflared"
if [ ! -f "/usr/local/etc/cloudflared/config.yaml" ]; then
  ln -s "$DOTFILES/cloudflared/config.yaml" "/usr/local/etc/cloudflared/config.yaml"
fi

if [ ! -f "$HOME/Library/LaunchAgents/com.cloudflare.cloudflared.plist" ]; then
  cloudflared service install
fi


###############################################################################
# Zsh                                                                         #
###############################################################################

source "$DOTFILES/install/zsh.sh"

###############################################################################
# Reload zsh settings                                                         #
###############################################################################

zsh
