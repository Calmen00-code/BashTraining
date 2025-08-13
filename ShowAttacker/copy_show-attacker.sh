#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: ./show-attacker.sh [LOG_FILE]"
    exit
fi

LOG_FILE=$1

if [[ ! -e ${LOG_FILE} ]]; then
    echo "Cannot open log file: ${LOG_FILE}"
    exit 1
fi

cat ${LOG_FILE} | awk -F ',' '{
    if (NR == 1) {
        print $0
    }
    else if ($1 > 10) {
        print $0
    }
}'
