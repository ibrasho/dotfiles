#!/bin/bash

# Install Caskroom
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# Install packages
apps=(
    caskroom/fonts/font-fira-code
    caskroom/fonts/font-robotomono-nerd-font

    tunnelblick
    1password
    docker
    authy-desktop
    dropbox
    google-chrome
    iterm2
    java
    authy
    flux
    firefox
    bestres
    spotify
    slack
    jetbrains-toolbox
    visual-studio-code
    microsoft-office
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv qlimagesize webpquicklook suspicious-package
