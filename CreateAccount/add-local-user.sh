#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "You do not have the privileges to execute this script."
    exit 1
fi

# Gather username and password
read -p "Username: " USER_NAME
read -sp "Password: " PASSWORD
echo

# Create user account
sudo useradd -m $USER_NAME 1> /dev/null

SUCCESSFUL_USERNAME_CREATION=$?

if [ $SUCCESSFUL_USERNAME_CREATION -ne 0 ]; then
    echo "Failed to create account"
    exit 1
fi

# Assign user password
echo "${PASSWORD}" | passwd --stdin ${USER_NAME} 1> /dev/null

SUCCESSFUL_PASSWORD_CREATION=$?

if [ $SUCCESSFUL_PASSWORD_CREATION -ne 0 ]; then
    echo "Failed to assign password"
    exit 1
fi

# Reports
echo "Account created succesfully!"
echo "Username: ${USER_NAME}"
echo "Host: $(hostname)"

