#!/bin/bash

# Enable Kernel Extensions - no DEP / no User Approved MDM
# Christian Bermejo May 7, 2018 #
# Script courtesy of Graham Gilbert

# According to docs, you can only whitelist KextPolicy db in /var/db/SystemPolicyConfiguration
# When one is booted from Recovery HD - or a Recovery-like operating system - of which a NetInstall is one.
#  If you are using either the default NBI from Imagr or one created with NBICreator, you will be running a NetInstall.
# This means you can script the addition of these Team IDs during your provisioning workflow.

# And if you are using Imagr, note that it has had the first_boot option set to false - we need this to run during the NetInstall session.

# Trend Micro Inc.
/usr/sbin/spctl kext-consent add E8P47U2H32

# Zoom.us
/usr/sbin/spctl kext-consent add BJ4HAAB9B3
