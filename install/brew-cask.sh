#!/bin/bash

# Install packages
apps=(
  1password
  docker-desktop
  font-fira-code
  font-fira-code-nerd-font
  font-roboto-mono-nerd-font
  google-chrome
  google-cloud-sdk
  iterm2
  jetbrains-toolbox
  microsoft-office
  postman
  slack
  spotify
  temurin
  visual-studio-code
  whatsapp
)

# --adopt takes over apps already present in /Applications (hand-installed
# Chrome/Slack/etc.) instead of erroring out; a failed cask must not abort
# the rest of setup (this runs under setup.sh's set -e).
brew install --cask --adopt "${apps[@]}" \
  || echo "Some casks failed to install; continuing"
