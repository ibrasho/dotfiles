#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for
# software development.

# Check for Homebrew and install it if missing
if test ! $(which brew); then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap Goles/battery
brew tap homebrew/command-not-found

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

apps=(
  fish

  fzf
  starship
  terminal-notifier
  thefuck

  bash-completion2

  curl
  git
  gnu-sed
  coreutils
  moreutils
  findutils
  openssl
  openssh
  grep
  tree
  tmux
  wget
  diff-so-fancy
  
  go
  java

  gpg
  gnupg
  jq

  cloudflare/cloudflare/cloudflared
  source-highlight
  
  mas # Mac App Store CLI

  go
  nvm
  rbenv

  aws-shell
  terraform

  direnv

  libyaml
  libffi
  
  imagemagick
  ffmpeg
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
