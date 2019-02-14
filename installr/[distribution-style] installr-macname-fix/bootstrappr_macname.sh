#!/bin/sh

# This script is part of our bootstrappr workflow. It sets the Mac name.

ComputerName=`cat /Volumes/Macintosh\ HD/computer_name.txt`
Serial=`/usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d'"' -f4`

echo "ComputerName is $ComputerName"
echo "Serial is $Serial"

# Name the Mac 
/usr/sbin/scutil --set ComputerName "$ComputerName"
/usr/sbin/scutil --set HostName "$ComputerName"
/usr/sbin/scutil --set LocalHostName "$ComputerName"

echo "The Mac has been named to $ComputerName"