#!/bin/bash

grep "Failed" sample_auth.log | awk -F 'from ' '{print $2}' | cut -d ' ' -f 1 | sort | uniq -c | sort -nr |
while read line; do
    result=$(echo ${line} | cut -d ' ' -f 2)
    #GeoIP Country Edition: MY, Malaysia
    country=$(geoiplookup ${result} | cut -d ':' -f 2 | cut -d ',' -f 2 | cut -c 2-)
    echo ${line} | awk -F ' ' -v c="${country}" '{print $1","$2","c}'
done > output.csv

