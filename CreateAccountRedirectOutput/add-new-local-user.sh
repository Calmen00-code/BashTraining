#!/bin/bash

# Check for root access
if [[ "${UID}" -ne 0 ]]; then
    echo "Please run this script with root privilege"
fi

# Sanity check on how the user run the script
if [[ "$#" -lt 2 ]]; then
    echo "Usage: $0 [USER_NAME] [USER_COMMENT]"
fi

# Retrieve the username and user comment
USER_NAME=$1
shift
USER_COMMENT=$@

useradd "${USER_NAME}" -c "${USER_COMMENT}" 1>/dev/null 2>> /tmp/error
STATUS=$?

if [[ ${STATUS} -ne 0 && ${STATUS} -ne 9 ]]; then
    echo "Failed to create an account!"
    echo "$?"
    exit 1
fi 

# Assign password to the user
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}" | passwd --stdin ${USER_NAME} 1>/dev/null 2>> /tmp/error

if [[ "$?" -ne 0 ]]; then
    echo "Failed to generate password!"
    exit 1
fi

# Enforce password change on first login
passwd -e ${USER_NAME} 1>/dev/null 2>> /tmp/error

echo "Added new user with the following information: "
echo "Username: ${USER_NAME}"
echo "User comment: ${USER_COMMENT}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
echo
