#!/bin/zsh

INSTALL_DIR=/usr/local/bin
SCRIPT_NAME=locationchanger
LAUNCH_AGENTS_DIR=$HOME/Library/LaunchAgents
PLIST_NAME=$LAUNCH_AGENTS_DIR/de.lisanet.LocationChanger.plist
APP_SUPPORT_DIR="$HOME/Library/Application Support/LocationChanger"

echo "This will install LocationChanger."
echo "Proceed? (y/n)?"
read reply
if [ "$reply" != "y" ]; then
    echo "Aborting nstallation."
    exit
fi

echo "Please enter your admin password to install LocationChanger to /usr/local/bin"
sudo mkdir -p "$INSTALL_DIR"
sudo cp locationchanger "$INSTALL_DIR"
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# generate a default config file if it doesn't exists
if [ ! -e "$APP_SUPPORT_DIR/LocationChanger.conf" ]; then
mkdir -p "$APP_SUPPORT_DIR"

cat > "$APP_SUPPORT_DIR/LocationChanger.conf" << EOT
[General]
# specify the default Location to use. The default is 'Automatic'
#DEFAULT_LOCATION=Automatic
# To enable notifications, set to 1. For verbose notifications, set to 2. To disable, set to 0.
#ENABLE_NOTIFICATIONS=1

[Automatic]
# [Automatic] defines a mapping for Wi-Fi Network SSIDs to Location names as key-value pairs.
# Spaces are supported for both the SSID as well as the Location name, but all spaces
# around the '=' will be trimmed. Additionally, do not enclose the SSID or Location in quotes
# SSID=Location name

[Manual]
# This section contains a list of Location names for which autodetection and Location
# switching should be ignored.
# Wi-Fi Only

EOT
fi

cp uninstall.sh "$APP_SUPPORT_DIR"

mkdir -p "$LAUNCH_AGENTS_DIR"

cat > "$PLIST_NAME" << EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>de.lisanet.locationchanger</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/$SCRIPT_NAME</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Library/Preferences/SystemConfiguration/com.apple.wifi.message-tracer.plist</string>
    </array>
</dict>
</plist>
EOT

USERID=$SUDO_UID
[ -z "$USERID" ] && USERID=$UID
launchctl bootstrap gui/$USERID "$PLIST_NAME"

echo "Installation successfull."
echo
echo "If you want to unsintall LocationChanger, run the uninstall script by typing"
echo "zsh $APP_SUPPORT_DIR/uninstall.h"
echo
