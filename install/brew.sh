#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/versions
brew tap homebrew/dupes
brew tap Goles/battery

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade --all

apps=(
  bash-completion2
  coreutils
  moreutils
  findutils
  cloudflare/cloudflare/cloudflared
  git
  "gnu-sed --with-default-names"
  "grep --with-default-names"
  grep
  openssh
  mtr
  "imagemagick --with-webp"
  source-highlight
  tree
  "ffmpeg --with-libvpx"
  wget
  node
  go
  python
  protobuf
  ansible
  gpg
  gpg-agent
  pinentry-mac
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
