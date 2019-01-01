# Copy paste this file in bit by bit.
# Don't run it.

echo "Do not run this script in one go. Hit Ctrl-C NOW"
read -n 1


###############################################################################
# Backup old machine's dotfiles                                               #
###############################################################################

mkdir -p $HOME/migration/home

# let's hold on to these

cp -R $HOME/.ssh $HOME/migration/home/


###############################################################################
# XCode Command Line Tools                                                    #
###############################################################################

if ! xcode-select --print-path &> /dev/null; then

  # Prompt user to install the XCode Command Line Tools
  xcode-select --install &> /dev/null

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &> /dev/null; do
    sleep 5
  done


  msg="Install XCode Command Line Tools"
  if [ $1 -eq 0 ]; then print_success "$msg"; else print_error "$msg"; fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Point the `xcode-select` developer directory to
  # the appropriate directory from within `Xcode.app`
  # https://github.com/alrra/dotfiles/issues/13

  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
  msg="Make 'xcode-select' developer directory point to Xcode"
  if [ $1 -eq 0 ]; then print_success "$msg"; else print_error "$msg"; fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10

  sudo xcodebuild -license
  msg="Agree with the XCode Command Line Tools licence"
  if [ $1 -eq 0 ]; then print_success "$msg"; else print_error "$msg"; fi

fi

###############################################################################
# OSX defaults                                                                #
# https://github.com/hjuutilainen/dotfiles/blob/master/bin/osx-user-defaults.sh
###############################################################################

. osx/set-defaults.sh


###############################################################################
# Symlinks to link dotfiles into $HOME/                                           #
###############################################################################

./setup.sh
