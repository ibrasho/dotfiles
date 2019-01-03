#!/bin/bash

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/versions

# Install packages
apps=(
  1password
  authy
  bestres
  docker
  dropbox
  electrum
  firefox
  flux
  caskroom/fonts/font-fira-code
  caskroom/fonts/font-firacode-nerd-font
  caskroom/fonts/font-robotomono-nerd-font
  google-chrome
  google-cloud-sdk
  iterm2
  java
  jetbrains-toolbox
  keybase
  microsoft-office
  minikube
  paw
  slack
  spotify
  tunnelblick
  visual-studio-code
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
