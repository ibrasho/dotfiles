set -e

if test ! $(which nvm)
then
  echo "Installing a stable version of Node..."

  # Install the latest stable version of node
  nvm install stable

  # Switch to the installed version
  nvm use node

  # Use the stable version of node by default
  nvm alias default node
fi

# Globally install with npm
# To list globally installed npm packages and version: npm list -g --depth=0
packages=(
  diff-so-fancy
  trash-cli
)

npm install -g "${packages[@]}"
