# Utils

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -n 1
  printf "\n"
}

execute() {
  $1 &> /dev/null

  if [ $? -eq 0 ]; then print_success "$2"; else print_error "$2"; fi
}

print_error() {
  # Print output in red
  printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
  # Print output in purple
  printf "\n\e[0;35m $1\e[0m\n"
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

safeSymlink() {
  if [ -f "$2" ]; then
    if [ "$(readlink "$2")" != "$1" ]; then
      ask_for_confirmation "'$2' already exists, move to $3?"
      if answer_is_yes; then
        mv "$2" "$3/"
        print_success "(file backup) $1 -> $3/"
        execute "ln -fs $1 $2" "(link created) $1 -> $2"
      else
        print_error "$1 -> $2"
      fi
    fi
  else
    execute "ln -fs $1 $2" "(link created) $1 -> $2"
  fi
}
