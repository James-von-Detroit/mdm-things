#!/bin/bash

# lego certificate renewal script used with cron
# runs every 3 months (as LetsEncrypt certificates expire every 90 days)
# on the first day of each day, at 3:00AM (defined on cron)

# Cron script (alternatives)
# 00 03 01 Jan,Apr,Jul,Oct * /path/to/script
# 00 03 01 */3 * /path/to/script

# temporarily stop server -- needs to stop since lego needs 443 port to renew
sudo /usr/bin/systemctl stop micromdm.service

# attempt to renew on the same folder
sudo /usr/local/bin/lego --domains DOMAIN --email EMAIL --path /path/to/certs renew

# restart server
sudo /usr/bin/systemctl start micromdm.service

# attempt to curl a zoom webhook to say that an attempt has been made
# TODO: find a way to get error codes and customize webhook message
/usr/bin/curl -X POST -H "X-zoom-token:ZOOMTOKENHERE" -H "Content-Type: application/json" -H "Accept: application/json" -d "{'body':'An attempt for SSL certificate renewal for Apple MDM has finished. Please verify by visiting the MDM domain','title':'Lego Cert Renewal','summary':'Lego SSL Certificate Renewal Attempt'}" 'https://addon.zoom.us/webhook/incoming/ZOOMCHANNELID'