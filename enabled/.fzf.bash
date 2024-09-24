#!/bin/bash

UNAMESTR=$(uname)

if ! hash fzf 2>/dev/null; then
    exit;
fi

cd() {
  if [[ -z "$1" ]]; then
    # Get recent directories using `dirs`
    local recent_dirs=$(dirs -v | awk '{print $2}')

    # Use find to get directories up to maxdepth 2 in breadth-first order
    local find_dirs=$(find . -maxdepth 2 -type d | awk -F/ '{print NF-1, $0}' | sort -n | cut -d' ' -f2-)

    # Combine recent dirs and find results, display in fzf
    local selection=$(echo -e "$recent_dirs\n$find_dirs" | fzf | awk '{print $1}')

    if [[ -n "$selection" ]]; then
      # Expand ~ to the full path
      selection=$(eval echo "$selection")
      pushd "$selection" > /dev/null
    fi
  else
    # Use pushd to change directory and track the stack
    pushd "$1" > /dev/null
  fi
}

#if [[ "$UNAMESTR" == 'Darwin' ]]; then
#    sd() {
#        if [ -d "$1" ]; then
#            command cd $1
#        else
#            echo "fzf on $(dirname ${1:-.})"
#            DIR=`(echo ".."; \
#                find $(dirname ${1:-.}) -maxdepth 1 -path '*/\.*' -type d; \
#                mdfind -onlyin . "kind:folder") \
#                | fzf -e -q $(basename ${1:-" "}) -1`
#            command cd "$DIR"
#        fi
#    };
#fi

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --smart-case --hidden --no-ignore'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
