set -e

if test ! $(which pip3)
then
  echo "Installing a stable version of Pyhton..."
  brew install python@3.8
fi

packages=(
  powerline
  thefuck
)

pip3 install --user "${packages[@]}"
