#!/bin/bash

# Created December 12, 2017
# Edited September 3, 2018
# Created by Christian Bermejo

# This script uses loginwindow LoginHook to 
# get the first domain user to login and bind the laptop
# to the user (along with the local accounts)
# the script should then be removed from LoginHook and system
# September 2018 - also sets computer name based on first login
# To accommodate for installr workflow

# variable $1 supposedly returns short name of user who is logging in

if [ ! -f /private/var/db/dslocal/nodes/Default/groups/com.apple.loginwindow.netaccounts.plist ]; then
	echo "netaccounts group not found! creating group..."
	dscl . -create /Groups/com.apple.loginwindow.netaccounts
	dscl . -create /Groups/com.apple.loginwindow.netaccounts PrimaryGroupID 206
	dscl . -create /Groups/com.apple.loginwindow.netaccounts Password \*
	dscl . -create /Groups/com.apple.loginwindow.netaccounts RealName "Login Window's Custom Network Accounts"
fi

if [ ! -f /private/var/db/dslocal/nodes/Default/groups/com.apple.access_loginwindow.plist ]; then
	echo "loginwindow group not found! creating group..."
	dscl . -create /Groups/com.apple.access_loginwindow
	dscl . -create /Groups/com.apple.access_loginwindow PrimaryGroupID 223
	dscl . -create /Groups/com.apple.access_loginwindow Password \*
	dscl . -create /Groups/com.apple.access_loginwindow RealName "Login Window ACL"
fi

# get current user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# # get hardware device model
# deviceModel=`sysctl -n hw.model`


echo "current user is $loggedInUser"
echo "Adding $loggedInUser to netaccounts..."

dseditgroup -o edit -n /Local/Default -a $loggedInUser -t user com.apple.loginwindow.netaccounts

echo "Adding netaccounts to loginwindow..."
dseditgroup -o edit -n /Local/Default -a com.apple.loginwindow.netaccounts -t group com.apple.access_loginwindow

echo "Adding localaccounts to loginwindow..."
dseditgroup -o edit -n /Local/Default -a localaccounts -t group com.apple.access_loginwindow

echo "Setting user to admin..."
dseditgroup -o edit -a $loggedInUser -t user admin

echo "User Bind to Laptop successful!"

# echo "Setting computer name..."
#
# macName='ph-'$loggedInUser
#
# # determine if laptop or desktop
# if [[ $deviceModel =~ .*Book.* ]]
# then
# 	macName=$macName'-mb'
# else
# 	macName=$macName'-md'
# fi
#
# /usr/sbin/scutil --set ComputerName "$macName"
# /usr/sbin/scutil --set HostName "$macName"
# /usr/sbin/scutil --set LocalHostName "$macName"
#
# echo "Setting Computer Name successful! Cleaning up..."

defaults delete com.apple.loginwindow LoginHook

rm -f /Users/Shared/FirstLoginUserBindtoLaptop.sh




exit 1

