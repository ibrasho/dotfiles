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

for file in $(ls -a $DOTFILES/home); do
  SOURCE_FILE="${DOTFILES}/home/$file"
  TARGET_FILE="$HOME/$file"

  if [ -f $SOURCE_FILE ]; then
    safeSymlink "$SOURCE_FILE" "$TARGET_FILE" "$DOTFILES_BACKUP"
  fi
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


for file in $(ls $DOTFILES/gnupg); do
  SOURCE_FILE="${DOTFILES}/gnupg/$file"
  TARGET_FILE="$HOME/.gnupg/$file"

  safeSymlink "$SOURCE_FILE" "$TARGET_FILE" "$DOTFILES_BACKUP"
done


safeSymlink "$DOTFILES/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf" "$DOTFILES_BACKUP"
safeSymlink "$DOTFILES/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf" "$DOTFILES_BACKUP"


# Copy scripts
SOURCE_DIR="$DOTFILES/scripts"
TARGET_DIR="$HOME/bin"
mkdir -p "$TARGET_DIR"

print_info "Copying scripts from $SOURCE_DIR to $TARGET_DIR"

for file in $(ls $SOURCE_DIR); do
  SOURCE_FILE="$SOURCE_DIR/$file"
  TARGET_FILE="$TARGET_DIR/$file"

  safeSymlink "$SOURCE_FILE" "$TARGET_FILE" "$BIN_BACKUP"
  chmod +x "$HOME/bin/${i##*/}"
done


###############################################################################
# Crontab                                                                     #
###############################################################################

print_info "Updating crontab"

# Write out current crontab
crontab -l > /tmp/mycron

# Echo new cron into cron file
for cmd in online_check battery_check.py; do
  cron="* * * * * $HOME/bin/$cmd &> /dev/null"
  grep -q "$cron" /tmp/mycron
  if [ $? -eq 1 ]; then
    echo "$cron" >> /tmp/mycron
    print_success "Added $cmd to crontab"
  fi
done

# Install new cron file
crontab /tmp/mycron
rm /tmp/mycron


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

# print_info "Installing npm packages"
# source "$DOTFILES/install/npm.sh"

# print_info "Installing brew packages"
source "$DOTFILES/install/brew.sh"

if [ "$(uname)" == "Darwin" ]; then
    print_info "Installing brew casks"
    source "$DOTFILES/install/brew-cask.sh"
fi


###############################################################################
# VS Code                                                                     #
###############################################################################

# Copy over sync settings
VSCODE_USER_DIR="$HOME/Library/Application\ Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"

if [ ! -f "$VSCODE_USER_DIR/syncLocalSettings.json" ]; then
  cp "vscode/syncLocalSettings.json" "$VSCODE_USER_DIR/syncLocalSettings.json"
  print_info "Add your Github token to $VSCODE_USER_DIR/syncLocalSettings.json and install the Settings Sync extension"
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
  ln -s "/usr/local/etc/cloudflared/config.yaml" "$DOTFILES/cloudflared/config.yaml"
fi

if [ ! -f "$HOME/Library/LaunchAgents/com.cloudflare.cloudflared.plist" ]; then
  cloudflared service install
fi


###############################################################################
# Zsh                                                                         #
###############################################################################

source "$DOTFILES/install/zsh.sh"

# Install Zsh settings
mkdir -p "$HOME/.oh-my-zsh/custom/themes"

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]; then
  git clone "https://github.com/bhilburn/powerlevel9k.git" "$HOME/.oh-my-zsh/custom/themes/powerlevel9k"
fi


###############################################################################
# Reload zsh settings                                                         #
###############################################################################

zsh
