#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew); then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap Goles/battery

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade --all

apps=(
  openssl
  bash-completion2
  zsh-completions
  coreutils
  moreutils
  findutils
  cloudflare/cloudflare/cloudflared
  grep
  openssh
  mtr
  source-highlight
  tree
  tmux
  wget
  node
  go
  gpg
  gnupg
  mas					# Mac App Store CLI
  pinentry-mac
)

brew install "${apps[@]}"

brew install curl --with-openssl
brew install git --with-openssl --with-curl
brew install gnu-sed --with-default-names
brew install grep --with-default-names
brew install imagemagick --with-webp
brew install ffmpeg --with-libvpx

# Remove outdated versions from the cellar
brew cleanup
