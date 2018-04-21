# Test to see if zshell is installed.
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
  # Install Oh My Zsh if it isn't already present
  if [ ! -d $HOME/.oh-my-zsh/ ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  # Make sure zsh is in the allowed shells list
  grep -q -F "$(which zsh)" /etc/shells || sudo sh -c "echo $(which zsh) >> /etc/shells"

  # Set the default shell to zsh if it isn't currently set to zsh
  if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
  fi
else
  # If zsh isn't installed, get the platform of the current machine
  platform=$(uname);
  # If the platform is Linux, try an apt-get to install zsh and then recurse
  if [[ $platform == 'Linux' ]]; then
    if [[ -f /etc/redhat-release ]]; then
    sudo yum install zsh
    install_zsh
    fi
    if [[ -f /etc/debian_version ]]; then
    sudo apt-get install zsh
    install_zsh
    fi
  # If the platform is OS X, tell the user to install zsh :)
  elif [[ $platform == 'Darwin' ]]; then
    echo "We'll install zsh, then re-run this script!"
    brew install zsh
    exit
  fi
fi
