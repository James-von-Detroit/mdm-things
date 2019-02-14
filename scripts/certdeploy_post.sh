#!/bin/bash

# Base Script to deploy certificates within macOS devices
# Post-install script

# Preliminary clean-up
rm -rf "/Users/Shared/certs"

# Unzip new certs zip file - force overwrite
unzip -o /Users/Shared/certs.zip -d /Users/Shared

# Checks if certs folder is present in /Users/Shared/certs
 if [ -d "/Users/Shared/certs" ]
 then
    echo "Directory /Users/Shared/certs exists"
    for file in $(find /Users/Shared/certs/* 2> /dev/null); do
    # Add certificate as trusted by user
    sudo /usr/bin/security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" $file
    done
else
    echo "Directory /Users/Shared/certs does not exist"
 fi

# Post cleanup
rm -rf "/Users/Shared/certs"
rm -rf "/Users/Shared/certs.zip"

exit
