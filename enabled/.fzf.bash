#!/bin/bash

UNAMESTR=$(uname)

if ! hash fzf 2>/dev/null; then
    exit;
fi

if [[ "$UNAMESTR" == 'Darwin' ]]; then
    sd() {
        if [ -d "$1" ]; then
            command cd $1
        else
            echo "fzf on $(dirname ${1:-.})"
            DIR=`(echo ".."; \
                find $(dirname ${1:-.}) -maxdepth 1 -path '*/\.*' -type d; \
                mdfind -onlyin . "kind:folder") \
                | fzf -e -q $(basename ${1:-" "}) -1`
            command cd "$DIR"
        fi
    };
fi

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --smart-case --hidden --no-ignore'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
