#!/bin/bash

INSTALL_DIR=/usr/local/bin
SCRIPT_NAME=locationchanger
LAUNCH_AGENTS_DIR=$HOME/Library/LaunchAgents
PLIST_NAME=$LAUNCH_AGENTS_DIR/LocationChanger.plist

echo "This will uninstall LocationChanger and its config files and scripts from your Mac.\n"
echo "Are you sure to uninstall LocationChanger (y/n)?"
read reply
if [ "$reply" != "y" ]; then
    echo "Aborting uninstall command."
    exit
fi

sudo rm "$INSTALL_DIR/$SCRIPT_NAME"

USERID=$SUDO_UID
[ -z "$USERID" ] && USERID=$UID
launchctl bootout gui/$USERID "$PLIST_NAME"

rm "$PLIST_NAME"
rm -rf "$HOME/Library/Application Support/LocationChanger"
rm -rf "$HOME/Library/Logs/LocationChanger.log"

echo "Uninstall complete."
