#!/bin/bash

# Creates symlinks in parent directory to all specified files in current directory.
#   If a file with same name already exists in parent directory, it will be moved to "DOTFILES_COW_DIR".
#   If a symlink with same name already exists, it will be kept as it is.
# Also, the script will suggest a name and an email for your .gitconfig.

NOW=$(date +%Y%m%dT%H%M%S)
DOTFILES_DIR=$(pwd -P)
DOTFILES_COW_DIR="dotfiles_${NOW}"

MV=/bin/mv
LN=/bin/ln
GIT=/usr/bin/git

FILES=".ackrc .bash_aliases .bash_functions .bash_logout .bashrc .bazaar .gitconfig .inputrc
    .profile .psqlrc .pythonrc .screenrc .sqliterc .ssh/config .vim .vimrc"

for file in $FILES; do
    src="$DOTFILES_DIR/$file"
    target="../$file"

    if [ -e "$target" -a ! -L "$target" ]; then
        mkdir -p "$DOTFILES_COW_DIR/$(dirname "$file")"
        $MV -fv "$target" "$DOTFILES_COW_DIR/$file"
    fi

    if [ -L "$target" ]; then
        echo "$target is already a symlink, skipping"
    else
        $LN -sfv $src $target
    fi
done;

function config_git {
    USERNAME=$(finger $USER | head -n1 | sed 's/.*Name: //')
    echo "Changing your global .gitconfig user.name to $USERNAME"
    $GIT config --global user.name $USERNAME

    read -p "Type your email to put in .gitconfig: " USERMAIL
    echo "Changing your global .gitconfig user.email to $USERMAIL"
    $GIT config --global user.email $USERMAIL
}

