#!/bin/bash

usage() {
    echo 'Usage: ./show-attacker [FILE]'
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

FILE=$1
if [[ ! -f ${FILE} ]]; then
    echo "File ${FILE} does not exist"
    exit 1;
fi

# 8 = IP
# 4 = name
echo "Count,User,IP,Location" > attacker_log.csv
grep -i "Failed" ${FILE} | awk -F ' ' '{ print $6","$8 }' |
while IFS=',' read USER IP; do
    IP_DETAILS=$(geoiplookup ${IP})
    LOCATION=$(echo "${IP_DETAILS}" | awk -F ', ' '{ print $2 }')
    echo "${USER},${IP},${LOCATION}"
done | sort | uniq -c | sort -n -k1 -r | sed -E 's/^[ ]+//' | sed -E 's/ /,/' |
awk -F ',' '{
    if ($1 > 10) {
        print $0
    }
}' >> attacker_log.csv
