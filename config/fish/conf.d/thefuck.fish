# if type -q /usr/local/bin/thefuck || type -q /opt/homebrew/bin/thefuck
if type -q thefuck
  set -q __tf_func; or __tf_updt
  eval $__tf_func
else
  echo "Please install thefuck first. Check https://github.com/nvbn/thefuck"
end
