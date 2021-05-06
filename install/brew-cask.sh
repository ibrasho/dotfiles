#!/bin/bash

# Install Caskroom
brew tap homebrew/cask
brew tap homebrew/cask-versions

# Install packages
apps=(
  1password
  authy
  alfred
  contexts
  docker
  dropbox
  electrum
  firefox
  font-fira-code
  font-fira-code-nerd-font
  font-roboto-mono-nerd-font
  google-chrome
  google-cloud-sdk
  iterm2
  jetbrains-toolbox
  keybase
  microsoft-office
  minikube
  postman
  paw
  slack
  spotify
  visual-studio-code
  whatsapp
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
qlplugins=(
  qlcolorcode
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  suspicious-package
  webpquicklook
)

brew cask install "${qlplugins[@]}"
