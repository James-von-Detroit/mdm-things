#!/bin/sh

# Get the current device's serial number
SERIAL="$(ioreg -l | grep IOPlatformSerialNumber | sed -e 's/.*\"\(.*\)\"/\1/')"

# Where the file will be saved using today's date. On date of writing would be /tmp/serials20190802.csv
OUTPUT=/tmp/serials$(date +%Y%m%d).csv

# Download the CSV from Google Drive, file must be set to Shared With Anyone with Link (or Shared with Anyone)
curl 'https://docs.google.com/spreadsheets/d/YOURGOOGLESHEETIDHERE/export?exportFormat=csv' -o $OUTPUT

# With much thanks to @Gerk and the rest of the crew on the MacAdmins #toronto channel, this now grabs the entire line from the CSV file 
LINE=$(grep $SERIAL $OUTPUT)

# This will grab all the text before the ,
ASSETTAG="$( cut -d ',' -f 1 <<< "$LINE" )"

# Set the ComputerName, HostName and LocalHostName
scutil --set ComputerName $ASSETTAG
scutil --set HostName $ASSETTAG
scutil --set LocalHostName $ASSETTAG