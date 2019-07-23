#!/bin/sh

folder=/Library/Company/SearchResults
file=checkKEXTs.csv
list=$( cat ${folder}/${file} )

if [[ ${list} == "" ]]; then
    echo "<result>"NoResult"</result>"
else
    echo "<result>"${list}"</result>"
fi