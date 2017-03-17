#!/bin/bash

# Creates symlinks in parent directory to all specified files in "enabled" directory.
#   If a file with same name already exists in parent directory, it will be moved to "DOTFILES_COW_DIR".
#   If a symlink with same name already exists, it will be kept as it is.
#   Then proceeds with .vim and vim pluggins.
# Also sets name and email for your .gitconfig.

NOW=$(date +%Y%m%dT%H%M%S)
DOTFILES_DIR=$(pwd -P)
DOTFILES_COW_DIR="dotfiles_${NOW}"

MV=/bin/mv
LN=/bin/ln
MKDIR=/bin/mkdir
GIT="/usr/bin/env git"

function install_to_parent_dir() {
    shopt -s dotglob
    src_dir=enabled/*
    for dir in $(find $src_dir -type d); do
        dir="$(echo $dir | cut -d '/' -f2-)"
        target="../$dir"
        $MKDIR -p $target
    done;
    for file in $(find $src_dir -type f); do
        src="$DOTFILES_DIR/$file"
        file="$(echo $file | cut -d '/' -f2-)"
        target="../$file"

        if [ -e "$target" -a ! -L "$target" ]; then
            $MKDIR -p "$DOTFILES_COW_DIR/$(dirname "$file")"
            $MV -fv "$target" "$DOTFILES_COW_DIR/$file"
        fi

        if [ -L "$target" ]; then
            echo "$target is already a symlink, skipping"
        else
            $MKDIR -p $(dirname $target)
            $LN -sfv $src $target
        fi
    done;
}

function install_global_vim() {
    # this only works for global ~/.vim runtimepath
    export GIT_SSL_NO_VERIFY=true
    src=https://raw.github.com/junegunn/vim-plug/master/plug.vim
    target=../.vim/autoload/plug.vim
    $MKDIR -p $(dirname $target)
    curl --insecure -fLo $target $src
    vim +PlugInstall +qall
}

function git_global_config() {
    #USERNAME=$(finger $USER | head -n1 | sed 's/.*Name: //')
    USERNAME="Julien Thewys"
    echo "Changing your global .gitconfig user.name to $USERNAME"
    $GIT config --global user.name "$USERNAME"

    #read -p "Type your email to put in .gitconfig: " USERMAIL
    USERMAIL="julien.thewys@gmail.com"
    echo "Changing your global .gitconfig user.email to $USERMAIL"
    $GIT config --global user.email $USERMAIL
}

install_to_parent_dir
git_global_config
install_global_vim
