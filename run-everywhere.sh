#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo 'Permission denied: please execute the script with sudo privileges'
    exit 1
fi

# read from servers file where we have new line
IFS=$'\n' read -d '' -r -a SERVER_LIST < servers

while getopts "nsv:f" OPTION
do
    case ${OPTION} in
        f)
            echo "${OPTARG}"
            IFS=$'\n' read -d '' -r -a SERVER_LIST < "${OPTARG}"
            shift
            ;;
        n)
            DRYRUN=true
            shift
            ;;
        s)
            REMOTE_SUDO=true
            shift
            ;;
        v)
            VERBOSE=true
            shift
            ;;       
        *)
            echo 'Usage: ./run-everywhere.sh [OPTION]... [INPUT_FILE]'
            ;;
    esac
done

if [[ "${DRYRUN}" = true ]]; then
    CMD_LIST=("$@")
    for SERVER in "${SERVER_LIST[@]}"; do
        for CMD in "${CMD_LIST[@]}"; do
            echo "ssh -o ConnectTimeout=2 ${SERVER} ${CMD}"
        done
    done
fi

if [[ "${REMOTE_SUDO}" = true ]]; then
    CMD_LIST=("$@")
    for SERVER in "${SERVER_LIST[@]}"; do
        for CMD in "${CMD_LIST[@]}"; do
            RESULT=$(ssh -o ConnectTimeout=2 "${SERVER}" sudo "${CMD}")
            echo "${RESULT}"
        done
    done
fi

if [[ "${VERBOSE}" = true ]]; then
    CMD_LIST=("$@")
    for SERVER in "${SERVER_LIST[@]}"; do
        for CMD in "${CMD_LIST[@]}"; do
            (ssh -o ConnectTimeout=2 "${SERVER}" "${CMD}") > /dev/null
        done
        echo "Executed command on ${SERVER}"
    done
fi
