#!/bin/bash

# Version 0.5
# com.trendph.mountsmb
# Mount personal folder from ph.trendnet.org SMB share to a folder in /tmp/
# Requirements: Password of username/service account should be in Keychain Access
# How to add: https://serverfault.com/a/368527

# Create folders
# mkdir ~/mac-sync
# mkdir ~/mac-readiness

# Mount mac-readiness share
mount_smbfs -d 755 -f 755 //su-ph_mac_cfgsync@ph.trendnet.org/fs/Department/PHIT/ChrisB/mac-readiness ~/mac-readiness

# Mount mac-sync share
mount_smbfs -d 755 -f 755 //su-ph_mac_cfgsync@ph.trendnet.org/fs/Department/PHIT/ChrisB/mac-sync ~/mac-sync