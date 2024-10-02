#!/bin/bash

UNAMESTR=$(uname)

if ! hash fzf 2>/dev/null; then
    exit;
fi

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

ccd() {
  if [[ -z "$1" ]]; then
    local recent_dirs=$(dirs -p)

    # breadth-first search (level 1 gets duplicated in level 2 but that's actually nice)
    local find_dirs=""
    for depth in 1 2; do
      find_dirs="$find_dirs$(find . -maxdepth "$depth" -type d)\n"
    done

    local selection=$(echo -e "$recent_dirs\n$find_dirs" | fzf)

    if [[ -n "$selection" ]]; then
      builtin cd "$selection"
    fi
  else
    builtin cd "$1"
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
