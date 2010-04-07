#!/bin/bash

CONFIG_DIR="config"

CP=/bin/cp
GIT=/usr/bin/git

if [ $(pwd) == $HOME ]; then
    echo "Already in \$HOME, nothing to do."
    exit 0
fi

echo "Copying all config files to $HOME"
case $1 in
    -f)
        CP_ARGS="-afv"
    ;;
    *)
        CP_ARGS="-aiuv"
    ;;
esac
for file in .[^.]*; do
    $CP $CP_ARGS $file $HOME
done
for file in *; do
    if [ $file != ${CONFIG_DIR} ]; then
        $CP $CP_ARGS $file $HOME
    fi
done

USERNAME=$(finger $USER | head -n1 | sed 's/.*Name: //')
echo "Changing your global .gitconfig user.name to $USERNAME"
$GIT config --global user.name $USERNAME

read -p "Type your email to put in .gitconfig: " USERMAIL
echo "Changing your global .gitconfig user.email to $USERMAIL"
$GIT config --global user.email $USERMAIL

