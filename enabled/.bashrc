#echo "in .bashrc"  # comment echo if rsync protocol mismatch
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}erasedups
# ... or force ignoredups and ignorespace
#export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "

# Ignore some controlling instructions
export HISTIGNORE="[ ]*:&:bg:fg:exit"
export MYSQL_HISTIGNORE=" *"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=30000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [[ $(uname) == 'Darwin' ]]; then
    BREW_PREFIX=$(brew --prefix)
fi

export USER_COLOR=`expr $RANDOM % 7 + 1`
export PWD_COLOR=`expr $RANDOM % 7 + 1`
export BRANCH_COLOR=`expr $RANDOM % 7 + 1`
export NUM_COLOR=`expr $RANDOM % 7 + 1`

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[3${USER_COLOR};1m\]\u@\h\[\033[3${PWD_COLOR};1m\] \w \[\033[3${BRANCH_COLOR};1m\]$(__git_ps1 "(%s)")\n\#\$\[\033[0m\] '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(__git_ps1 "(%s)")\n\#\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Functions definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# if uname==cygwin then unset DISPLAY # speeds up mc start

#function gvim() {
#    local_gvim=`which gvim`
#    if [ -x ${local_gvim} ] ; then
#        eval ${local_gvim} $*;
#    else
#        if [ $# -gt 0 ] ; then
#            file=$(cygpath -aw $1)
#            shift
#        fi
#    env VIMRUNTIME="$GVIMRUNTIME" cygstart "$GVIMRUNTIME"/gvim.exe -c \"set shell=c:/cygwin/bin/bash.exe\" $file $*
#    fi
#}

export PYTHONSTARTUP=~/.pythonrc

alias mc='command mc -c --printwd=/tmp/mc-$USER/dir; cd "`cat /tmp/mc-$USER/dir`"; rm -f "/tmp/mc-$USER/dir"; :'

#export LC_TIME=en_DK.utf8 # uses iso date format
#export LC_CTYPE=en_US.UTF-8 # fix perl warning on OSX
#export LC_ALL=en_US.UTF-8 # fix perl warning on OSX

export EDITOR='vim'
export PSQL_EDITOR='vim -c "set ft=sql"'
#export http_proxy="http://thewyju:abcd1234@147.67.138.13:8012"

# docker
#eval $(docker-machine env dockerbox)
#alias doco='docker-compose'
#alias docu='docker-compose up -d'
#alias docl='docker-compose logs'
#alias docsh='docker-compose run --rm odoo ./src/odoo.py shell'
#export ODOO_URL=$(docker-machine ip dockerbox)":"$(docker-compose port odoo 8069 | cut -f 2 -d ':')
##alias bro='chromium-browser --incognito ${ODOO_URL}'
#alias bro='open "/Applications/Google Chrome.app" -n --args --incognito ${ODOO_URL}'

os_notification() {
    if [[ $(uname) == 'Darwin' ]]; then
        cmd="display notification \"$2\" with title \"$1\" subtitle \"$3\""
        echo "$cmd"
        osascript -e "$cmd"
    else
        notify-send "$1" "$3 $2"
    fi
}

long_run() {
    tic=$(date +%s)
    "$@"
    elapsed=$(($(date +%s) - tic))
    if [[ $elapsed -ge 15 ]]; then
        os_notification "Long running command" "took $elapsed seconds to finish" "$(echo $@)"
    fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(direnv hook bash)"

function venv {
    # Check if already in virtualenv
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "Already in a virtualenv"
        return 1
    fi

    # Find the first directory in the hierarchy that contains a .venv directory
    venv_dir=$(pwd)
    while [[ "$venv_dir" != "/" ]]; do
        if [[ -d "$venv_dir/.venv" ]]; then
            break
        fi
        venv_dir=$(dirname "$venv_dir")
    done

    # If a virtualenv was found, activate it and store its path
    if [[ -d "$venv_dir/.venv" ]]; then
        source "$venv_dir/.venv/bin/activate"
        #echo "$venv_dir/.venv" > "$HOME/.venvpath"
    else
        echo "No virtualenv found in directory hierarchy"
        return 1
    fi

    # Run the specified command within the virtualenv
    #shift
    #eval "$@"
}

# In order for gpg to find gpg-agent, gpg-agent must be running, and there must be an env
# variable pointing GPG to the gpg-agent socket. This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever), will either start
# gpg-agent or set up the GPG_AGENT_INFO variable if it's already running.

# Add the following to your shell init to set up gpg-agent automatically for every shell
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi

gi () {
	curl -sL https://www.gitignore.io/api/$@ | dos2unix
}

# Created by `pipx` on 2024-03-18 09:27:16
export PATH="$PATH:/Users/julien/.local/bin"
