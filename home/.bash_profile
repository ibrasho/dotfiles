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

source $HOME/.profile
source $HOME/.bash_prompt

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



# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/Users/ibrasho/.micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/ibrasho/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ibrasho/micromamba/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ibrasho/micromamba/etc/profile.d/conda.sh" ]; then
        . "/Users/ibrasho/micromamba/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ibrasho/micromamba/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"

. "$HOME/.local/bin/env"
