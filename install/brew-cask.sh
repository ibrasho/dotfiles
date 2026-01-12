#!/bin/bash

# Install packages
apps=(
  1password
  docker
  font-fira-code
  font-firacode-nerd-font
  font-robotomono-nerd-font
  google-chrome
  google-cloud-sdk
  iterm2
  java
  jetbrains-toolbox
  microsoft-office
  postman
  slack
  spotify
  visual-studio-code
  whatsapp
)

brew install --cask "${apps[@]}"

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

brew install --cask "${qlplugins[@]}"
