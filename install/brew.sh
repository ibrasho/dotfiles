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
  zsh

  fzf
  starship
  terminal-notifier
  thefuck

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

  go

  gpg
  gnupg

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
  direnv

  libyaml
  libffi

  curl
  git
  gnu-sed
  grep
  imagemagick
  ffmpeg
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
