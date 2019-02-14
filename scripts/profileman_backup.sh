#!/bin/bash

# Backs up Profile Manager Database
# Pairs with cron/crontab to backup at night

# Define datetime variable for script

DATETIME="$(date +"%Y%m%d_%H%M%S")"

sudo -u _devicemgr pg_dump -h /Library/Server/ProfileManager/Config/var/PostgreSQL -U _devicemgr devicemgr_v2m0 -c -f /tmp/profileManager-$DATETIME.sql
sudo cp /tmp/profileManager-$DATETIME.sql /srv/profile_manager/
sudo rm /tmp/profileManager-$DATETIME.sql