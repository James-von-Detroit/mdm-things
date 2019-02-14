#!/bin/sh

# Macintosh HD is hard coded because new Macs have shipped with that HD name since forever
/usr/sbin/chroot /Volumes/Macintosh\ HD /Users/Shared/bootstrappr_macname.sh

/bin/sleep 10

# Clean up
/bin/rm /Volumes/Macintosh\ HD/computer_name.txt
/bin/rm /Volumes/Macintosh\ HD/Users/Shared/bootstrappr_macname.sh
