# vim: set syn=sh
VIMRUNTIME=/usr/share/vim/vimcurrent

# enable color support of ls and also add handy aliases
#[ -f ~/.dir_colors ] && eval `dircolors -b ~/.dir_colors `
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    #if gnu ls
    alias ls='ls --color=auto'
    alias l='ls -AlF --color=auto'
    #if bsd ls
    #alias ls='ls -G'
    #alias l='ls -AFGlv'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias u='cd ..'
alias cp='cp -i'
alias mv='mv -i'
alias mc='command mc -c --printwd=/tmp/mc-$USER/dir; cd "`cat /tmp/mc-$USER/dir`"; rm -f "/tmp/mc-$USER/dir"; :'
alias rm='rm -i'
alias v=$VIMRUNTIME/macros/less.sh
alias psg='ps aux | grep'
alias go='gnome-open'
alias g='ack-grep --nocolor --nogroup --column'
alias now='date +%Y%m%dT%H%M%S'
alias bd='bzr diff|v'
alias s='du -s * | sort -n'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

