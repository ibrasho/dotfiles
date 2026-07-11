# shellcheck shell=bash
# Ensure zsh is the default shell.
# macOS ships zsh as the default since Catalina; this only matters if the
# account was migrated from an older system or the shell was changed.

# `|| true` matters: this is sourced under setup.sh's set -e, and a failing
# command substitution in an assignment would abort before the guard below.
ZSH_PATH="$(command -v zsh || true)"

if [ -n "$ZSH_PATH" ]; then
  # Make sure zsh is in the allowed shells list
  grep -q -F "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null

  # Set the default shell to zsh if it isn't already
  # (a mistyped chsh password must not abort the whole setup)
  if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH" || echo "chsh failed; run 'chsh -s $ZSH_PATH' manually"
  fi
else
  echo "zsh not found; install it first (brew install zsh)"
fi
