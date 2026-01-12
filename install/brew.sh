#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for
# software development.

# Check for Homebrew and install it if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

apps=(
  bash-completion2

  zsh
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

  curl
  git
  gnu-sed
  imagemagick
  ffmpeg

  jq
  source-highlight
  shellcheck         # Shell script linter

  # Version manager - replaces rbenv, nvm, etc.
  mise

  # Modern CLI tools
  starship           # Fast, customizable shell prompt
  zoxide             # Smarter cd
  bat                # Better cat with syntax highlighting
  eza                # Modern ls replacement
  fd                 # Better find
  procs              # Modern ps
  lazygit            # TUI for git
  git-delta          # Better git diff
  ripgrep            # Better grep (rg)

  aws-shell

  direnv
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
