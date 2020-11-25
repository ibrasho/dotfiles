# if status --is-interactive && not set -q TMUX
#   set -l TMUX tmux new-session -s main
#   eval $TMUX
#   tmux attach-session -t main
# end
