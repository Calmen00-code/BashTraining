#!/bin/bash

# This script create a new user on the local system
# Parameter 1: USER_NAME
# The rest of the parameters will be comment of the user
# Executable only on sudo privileges

if [[ "${UID}" -ne 0 ]]; then
    echo "Please execute this script with root privileges"
    exit 1
fi

if [[ "${#}" -lt 2 ]]; then
    echo "Usage: ${0} USER_NAME USER_NAME_COMMENT"
    exit 1
fi

USER_NAME="${1}"
shift
USER_COMMENT="${@}"


ACCOUNT_CREATE_STATUS=$(useradd "${USER_NAME}" -c "${USER_COMMENT}")
if [[ ${ACCOUNT_CREATE_STATUS} -ne 0 ]]; then
    echo "Failed to create user account!"
    exit 1
fi

# setting the password
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}
if [[ "${?}" -ne 0 ]]; then
    echo 'The password cannot be set'
    exit 1
fi

# force password change on first login
passwd -e ${USER_NAME}

echo "Added new user with the following information: "
echo "Username: ${USER_NAME}"
echo "User comment: ${USER_COMMENT}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
echo
