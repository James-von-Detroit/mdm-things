#!/bin/bash
################## HideAdmin.sh ##################
## Made by Christian Bermejo (IS-PH)
## admin is services management account

sudo mkdir /var/admin
sudo chown -R admin /var/admin

sudo mv /Users/admin /var/admin
sudo dscl . create /Users/admin IsHidden 1
sudo dscl . -create /Users/admin NFSHomeDirectory /var/admin

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu
exit
