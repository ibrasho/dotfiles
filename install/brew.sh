#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for
# software development.

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
  zsh

  bash-completion2
  zsh-completions

  coreutils
  moreutils
  findutils
  openssl
  openssh
  grep
  tree
  tmux
  wget

  gpg
  gnupg
  pinentry-mac

  cloudflare/cloudflare/cloudflared
  jq
  source-highlight
  mas					# Mac App Store CLI

  bazel

  go
  nvm
  rbenv

  azure-cli
  aws-shell
  terraform

  kubernetes-cli
  kubernetes-helm
  kubectx
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
