# vim: set syn=sh
VIMRUNTIME=/usr/share/vim/vimcurrent

function ww {
    if [ $# -gt 0 ]; then 
        which $1 || alias | grep -P "(?:\s)$1(?=\s*=)"
    else
        echo "Usage: $FUNCNAME callable"
    fi
}

