#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DOTFILE_BACKUP_DIR=$SCRIPT_DIR/backups
DOTFILE_HOME_DIR=$SCRIPT_DIR/home
DOTFILE_CONFIG_DIR=$SCRIPT_DIR/config

HOME_DIR=~
CONFIG_DIR=$HOME_DIR/.config

if [ "$#" -ne 1 ]; then
    echo "[x] 1 arguments (install/remove) is needed"  
    exit 1
fi

setupLink(){
    if [ -e $2 ]; then
        mv $2 $DOTFILE_BACKUP_DIR/
        echo "[*] Backup created for $2"
    fi

    ln -s $1 $2
    if [ $? -ne 0 ]; then
        echo "[x] Failed to create link for $2"
	    return
    fi
    echo "[o] Link created for $2"
}

 removeLink(){
    rm -r $2
    if [ -e $1 ]; then
        mv $1 $2
        echo "[o] Backup $1 restored"
    else
        echo "[o] Link $2 removed"
    fi
}

dotfileInstall(){
    setupLink $DOTFILE_HOME_DIR/.vimrc $HOME_DIR/.vimrc

    setupLink $DOTFILE_CONFIG_DIR/gtk-3.0/ $CONFIG_DIR/gtk-3.0
    setupLink $DOTFILE_CONFIG_DIR/gtk-3.0/ $CONFIG_DIR/gtk-4.0
    setupLink $DOTFILE_CONFIG_DIR/niri/ $CONFIG_DIR/niri
    setupLink $DOTFILE_CONFIG_DIR/alacritty/ $CONFIG_DIR/alacritty
    setupLink $DOTFILE_CONFIG_DIR/waybar/ $CONFIG_DIR/waybar
    setupLink $DOTFILE_CONFIG_DIR/rofi/ $CONFIG_DIR/rofi
    setupLink $DOTFILE_CONFIG_DIR/swaylock/ $CONFIG_DIR/swaylock
}

dotfileRemove(){
    removeLink $DOTFILE_BACKUP_DIR/.vimrc $HOME_DIR/.vimrc

    removeLink $DOTFILE_BACKUP_DIR/gtk-3.0 $CONFIG_DIR/gtk-3.0
    removeLink $DOTFILE_BACKUP_DIR/gtk-4.0 $CONFIG_DIR/gtk-4.0
    removeLink $DOTFILE_BACKUP_DIR/niri $CONFIG_DIR/niri
    removeLink $DOTFILE_BACKUP_DIR/alacritty $CONFIG_DIR/alacritty
    removeLink $DOTFILE_BACKUP_DIR/waybar $CONFIG_DIR/waybar
    removeLink $DOTFILE_BACKUP_DIR/rofi $CONFIG_DIR/rofi
    removeLink $DOTFILE_BACKUP_DIR/swaylock $CONFIG_DIR/swaylock
}

case "$1" in
    "install")
        dotfileInstall ;;
    "remove")
        dotfileRemove ;;
    *)
        echo '[o] "install" and "remove" are available'
        exit 1;;
esac


