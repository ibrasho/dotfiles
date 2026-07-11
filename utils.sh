# shellcheck shell=bash
# Utils — sourced by setup.sh

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]]
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -r -n 1
  printf "\n"
}

print_error() {
  # Print output in red
  printf "\e[0;31m  [✖] %s %s\e[0m\n" "$1" "$2"
}

print_info() {
  # Print output in purple
  printf "\n\e[0;35m %s\e[0m\n" "$1"
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] %s\e[0m" "$1"
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] %s\e[0m\n" "$1"
}

# Create a symlink at $2 pointing to $1, backing up any existing file to $3.
# Handles regular files, existing symlinks (including broken ones) and
# refuses to touch directories. Safe under `set -e`.
safeSymlink() {
  local source_file="$1"
  local target_file="$2"
  local backup_dir="$3"

  # Already linked to the right place — nothing to do.
  if [ "$(readlink "$target_file" 2>/dev/null)" = "$source_file" ]; then
    return 0
  fi

  if [ -d "$target_file" ] && [ ! -L "$target_file" ]; then
    print_error "$target_file is a directory; skipping" ""
    return 0
  fi

  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    ask_for_confirmation "'$target_file' already exists, move to $backup_dir?"
    if answer_is_yes; then
      mv "$target_file" "$backup_dir/"
      print_success "(file backup) $target_file -> $backup_dir/"
    else
      print_error "$source_file -> $target_file" "(skipped)"
      return 0
    fi
  fi

  if ln -fs "$source_file" "$target_file"; then
    print_success "(link created) $source_file -> $target_file"
  else
    print_error "(link failed) $source_file -> $target_file" ""
  fi
}
