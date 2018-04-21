
#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#
#  ---------------------------------------------------------------------------

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -f $HOME/.bash_aliases ]; then
  . $HOME/.bash_aliases
fi

# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------


#  export PS1="\n________________________________________________________________________________\n$BLUEBOLD\$(parse_git_branch) $RED\w $PURPLE@ $GREEN\h $GREENBOLD(\u) $RESETCOLOR=> $WHITE"


# Load the shell dotfiles, and then some:
# * $HOME/.path can be used to extend `$PATH`.
# * $HOME/.extra can be used for other settings you don’t want to commit.

source $HOME/.bash_prompt

for file in $HOME/.{bash_prompt}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;





#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
  export EDITOR=/usr/bin/vi

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
  export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced

