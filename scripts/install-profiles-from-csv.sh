#!/bin/bash

# Created by Christian Bermejo
# April 8, 2019
# Script tailored to install a profile in bulk from a CSV file
# Parameters
# 1 - file to read CSV from
# 2 - profile to install
# CSV must be formatted that the UDID must be on the first column

FILE=$1
PROFILE=$2

while IFS=, read -ra arr; do
	# read the first column from the row
   echo "processing ${arr[0]}"
   ~/Documents/mdm/micromdm/tools/api/commands/install_profile ${arr[0]} $PROFILE
done < $FILE