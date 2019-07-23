#!/bin/sh
# Stealing @henry123's (Jamf Nation) command to compile list of TeamID/BundleID for KEXTs that have been approved (User Approved Kernel Extension Loading). 20180313 DM

# Create folder
/bin/mkdir -p /Library/Company/SearchResults/
/usr/sbin/chown root:admin /Library/Company/SearchResults/
/bin/chmod 755 /Library/Company/SearchResults/

# Get list

/usr/bin/sqlite3 -csv /var/db/SystemPolicyConfiguration/KextPolicy "select team_id,bundle_id from kext_policy" > /Library/Company/SearchResults/checkKEXTs.csv

exit 0