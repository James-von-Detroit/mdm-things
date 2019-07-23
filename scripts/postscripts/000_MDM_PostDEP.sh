#!/bin/bash

# Creator: Christian Bermejo
# Goal: Post DEP Installation items
# Executed at userland

if [[ $EUID != 0 ]] ; then
    echo "Post-DEP: Please run this as root, or via sudo."
    exit -1
fi

#Get username
user=`stat -f "%Su" /dev/console`
#Get serial number
serial=`/usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d'"' -f4`
#Get ModelIdentifier for setting computer name
model=`ioreg -l | awk '/product-name/ { split($0, line, "\""); printf("%s\n", line[4]); }'`

#Simple script to determine if it is a desktop (MacMini), 
#laptop (MacBook, MacBookPro)
#and define computer name properly
if [[ $model == *"Book"* ]]; 
then
	ComputerName="ph-$user-mb"
else
	ComputerName="ph-$user-md"
fi

#Set computer name using scutil
/usr/sbin/scutil --set ComputerName "$ComputerName"
/usr/sbin/scutil --set HostName "$ComputerName"
/usr/sbin/scutil --set LocalHostName "$ComputerName"

#set Apple Remote Desktop TextFields
#Computer Name, Serial Number,
sudo /usr/bin/defaults write /Library/Preferences/com.apple.RemoteDesktop.plist Text1 -string "$ComputerName"
sudo /usr/bin/defaults write /Library/Preferences/com.apple.RemoteDesktop.plist Text2 -string "$serial"
# /usr/bin/defaults write /Library/Preferences/com.apple.RemoteDesktop.plist Text3 -string "$3"
# /usr/bin/defaults write /Library/Preferences/com.apple.RemoteDesktop.plist Text4 -string "$4"

# kickstart Apple Remote Desktop for MDM admin
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# update NoMAD and update to get the preferences
/usr/bin/open nomad://update

# exit script
exit 0








