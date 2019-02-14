#!/bin/bash
################## Login.sh ##################
## Made by Martin Cech (IS-DE)
## admin is services management account

sudo dscl . -create /Users/admin UniqueID 505
sudo dscl . -create /Users/admin PrimaryGroupID 20
sudo dscl . -create /Users/admin NFSHomeDirectory /var/admin
sudo dscl . -create /Users/admin UserShell /bin/bash
sudo dscl . -create /Users/admin RealName "Admin"
sudo dscl . -passwd /Users/admin PASSWORD
sudo dscl . -append /Users/admin AuthenticationAuthority ';SecureToken;'
sudo mkdir /var/admin
sudo chown -R admin /var/admin
sudo dscl . append /Groups/admin GroupMembership admin
sudo defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool YES
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool TRUE
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array admin
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu
exit
