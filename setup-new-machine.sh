# shellcheck shell=bash
# Copy paste this file in bit by bit.
# Don't run it.

echo "Do not run this script in one go. Hit Ctrl-C NOW"
read -r -n 1


###############################################################################
# Backup old machine's dotfiles                                               #
###############################################################################

mkdir -p "$HOME/migration/home"

# let's hold on to these

cp -R "$HOME/.ssh" "$HOME/migration/home/"


###############################################################################
# XCode Command Line Tools                                                    #
###############################################################################

if ! xcode-select --print-path &> /dev/null; then

  # Prompt user to install the XCode Command Line Tools
  xcode-select --install &> /dev/null

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &> /dev/null; do
    sleep 5
  done

  echo "XCode Command Line Tools installed"

  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10
  if sudo xcodebuild -license; then
    echo "Agreed to the Xcode license"
  else
    echo "Failed to agree to the Xcode license"
  fi

fi

###############################################################################
# Clone the dotfiles repo                                                     #
###############################################################################

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/ibrasho/dotfiles "$HOME/.dotfiles"
fi
cd "$HOME/.dotfiles" || exit 1


###############################################################################
# macOS defaults                                                              #
# https://github.com/hjuutilainen/dotfiles/blob/master/bin/osx-user-defaults.sh
###############################################################################

. "$HOME/.dotfiles/macos/set-defaults.sh"


###############################################################################
# Symlinks to link dotfiles into $HOME/                                       #
###############################################################################

"$HOME/.dotfiles/setup.sh"
