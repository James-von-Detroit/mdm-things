#!/bin/bash

# Payload-free package to be used to set NoMAD preferences using /usr/bin/defaults

#get username
user=`stat -f "%Su" /dev/console`

# Set Active Directory Domain
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD ADDomain -string "DOMAIN"
# Set option for GetHelpType
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD GetHelpOptions -string "HELP OPTION"
# Determine type of GetHelp function
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD GetHelpType -string URL
# Hide Get Software menu
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD HideGetSoftware 1
# Hide Preferences menu
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD HidePrefs 1
# Quit Menu
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD HideQuit 1
# Keep local password in sync with AD Password
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD LocalPasswordSync 1
# Don't attempt to synchronize hidden admin
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD LocalPasswordSyncDontSyncLocalUsers -array admin
# Set text of Software menu
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD MenuGetSoftware -string "Self Service"
# Set text of Home Directory menu
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD MenuHomeDirectory -string "Home Drive"
# Set text in password change dialog
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD MessagePasswordChangePolicy -string "Please ensure your password is not one you've used previously and is a minimum of 8 characters including at least 3 of the following: upper case letter, lower case letter, number or symbol. Your password may not contain your username or any other common words."
# Display and persist password expiration countdown timer
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD PersistExpiration 1
# Change title of sign in window
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD TitleSignIn -string "Please Enter Your Network Account Credentials"
# Hide AD home share
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD ShowHome 0
# Force Sign In window to display when NoMAD launches
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD SignInWindowOnLaunch 1
# Alert for password changes not made in system
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD UPCAlert 1 
# Store Kerberos password in user keychain
sudo -u $user /usr/bin/defaults write com.trusourcelabs.NoMAD UseKeychain 1