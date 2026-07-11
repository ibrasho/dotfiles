#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for
# software development.

# Check for Homebrew and install it if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# The installer does NOT put brew on the running process's PATH (it only
# prints "next steps"), so on a fresh machine every brew call below would
# exit 127 and set -e would kill the whole setup right here.
if ! command -v brew >/dev/null 2>&1; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Make sure we’re using the latest Homebrew
brew update || echo "brew update failed; continuing with existing state"

# Upgrade any already-installed formulae — a single failing formula must not
# abort the entire setup (this runs under setup.sh's set -e)
brew upgrade || echo "brew upgrade had failures; continuing"

apps=(
  bash-completion@2

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

  gnupg

  curl
  git
  gnu-sed
  imagemagick
  ffmpeg

  jq
  source-highlight
  shellcheck         # Shell script linter
  difftastic         # Syntax-aware diffs (gitconfig's diff.external)

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
  fzf                # Fuzzy finder (ctrl-r/ctrl-t, zoxide's zi)
  zsh-autosuggestions     # Fish-style inline history suggestions
  zsh-syntax-highlighting # Command coloring as you type

  awscli

  direnv
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
