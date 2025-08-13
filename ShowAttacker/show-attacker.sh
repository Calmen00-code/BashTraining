#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: ./show-attacker.sh [LOG_FILE] [OUTPUT_FILE]"
    exit
fi

LOG_FILE=$1
OUTPUT_FILE=$2

if [[ ! -e ${LOG_FILE} ]]; then
    echo "Cannot open log file: ${LOG_FILE}"
    exit 1
fi

echo "Count,IP,Location" > ${OUTPUT_FILE}
cat ${LOG_FILE} | grep "Failed" | sort | uniq -c | sort -n |
awk -F ' ' '{
    if ($1 > 10)
    {
        print $1","$9
    }
}' |
while read line; do
    ip=$(echo "${line}" | cut -d ',' -f 2)
    country=$(geoiplookup ${ip} | cut -d ',' -f 2 | cut -c 2-)
    echo "${line},${country}"
done | sort -nr > ${OUTPUT_FILE} 

echo "Generated log: ${OUTPUT_FILE}"

