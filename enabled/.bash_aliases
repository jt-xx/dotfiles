# vim: set syn=sh
#VIMRUNTIME=/usr/share/vim/vimcurrent

# enable color support of ls and also add handy aliases
#[ -f ~/.dir_colors ] && eval `dircolors -b ~/.dir_colors `
#if [ -x /usr/bin/dircolors ]; then

DIRCOLORS=$(type -P dircolors gdircolors | head -n 1)

if type -P gdircolors &>/dev/null; then
    eval "`gdircolors -b`"
    #if gnu ls
    alias ls='ls --color=auto'
    alias l='ls -AlF --color=auto'
    #if bsd ls
    #alias ls='ls -G'
    #alias l='ls -AFGlv'
elif [[ $(uname) == 'Darwin' ]]; then
    export LSCOLORS='Exfxcxdxbxegedabagacad'
    echo $LSCOLORS
    alias l=' ls -alG'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#alias u='cd ..'
# "u n" goes n dirs upwards even if they don't exist anymore
function u() {
    local dir=`pwd`;
    local n=${1:-1};
    for ((; n>0; n--)) {
        dir=`dirname "$dir"`;
    };
    cd "$dir";
}

alias cp='cp -i'
alias mv='mv -i'
#alias mc='command mc -c --printwd=/tmp/mc-$USER/dir; cd "`cat /tmp/mc-$USER/dir`"; rm -f "/tmp/mc-$USER/dir"; :'
alias mc='command mc --nosubshell'
alias rm='rm -i'
alias psg='ps aux | grep'
#alias go='gnome-open'
alias f='find . -iname'
#alias g='ack --nogroup --column --ignore-dir=i18n'
#alias g='ag --ignore *.js --ignore *.map --ignore-dir=i18n --ignore-dir=translations'
alias g='rg -g "*py" -g \!tests'
# ripgrep, no test files
alias rgnt="rg --iglob '!**/{test,tests}/*' --iglob '!**/*[._-]{test,spec}[._-]*'"
# ripgrep, only in test files
alias rgt="rg --iglob '**/{test,tests}/*' --iglob '**/*[._-]{test,spec}[._-]*'"

function g() {
    ag $* --ignore=*.js --ignore=*.map --ignore-dir=i18n --ignore-dir=translations
}

alias now='date +%Y%m%dT%H%M%S'
alias bd='bzr diff|v'
alias s='du -s * | sort -n'
alias csv='column -s "," -t < '

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
