#!/usr/bin/env bash

if command -v curl >/dev/null 2>&1; then
  CMD="curl -#L"
elif command -v wget >/dev/null 2>&1; then
  CMD="wget -O -"
fi

if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting."
  exit 1
fi

echo "Installing dotfiles"
# Execute (not source) setup.sh: sourcing would leak its `set -e` and `exit`
# into the invoking shell. </dev/tty reattaches the prompts to the terminal,
# which is required when this script itself arrives via `curl | bash`
# (stdin is the pipe, so every `read` would see script text/EOF).
mkdir -p "$HOME/.dotfiles" \
  && $CMD "https://github.com/ibrasho/dotfiles/tarball/master" | tar -xzv -C "$HOME/.dotfiles" --strip-components=1 \
  && bash "$HOME/.dotfiles/setup.sh" </dev/tty
