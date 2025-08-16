#!/bin/bash

if [[ "${UID}" -ne 0 ]]; then
    echo "Permission denied"
    exit 1
fi

usage() {
    echo './disable-local-user.sh [OPTION]... [USER]'
    echo '  -d  Delete account instead of disabling them'
    echo '  -r  Removes the home directory associated with the account(s)'
    echo '  -a  Creates an archive of the home directory associated with the account(s) and stores the archive in the /archives directory'
    exit 1
}

while getopts dra OPTION; do
    case ${OPTION} in
        d) DELETE_USER='true' ;;
        r) DELETE_USER_DIR='true' ;;
        a) ARCHIVE='true' ;;
        *) usage ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

USER=$1
STATUS=$(sudo chage -E -0 ${USER})
if [[ ${STATUS} -ne 0 ]]; then
    echo "Failed to disable account for ${USER}"
    exit 1
fi

if [[ ${DELETE_USER} = 'true' ]]; then
    sudo userdel ${USER}
fi

if [[ ${DELETE_USER_DIR} = 'true' ]]; then
    sudo userdel -r ${USER}
fi

if [[ "${ARCHIVE}" = 'true' ]]; then
    # Extract the home directory of the user
    USER_HOME=$(cat /etc/passwd | grep "${USER}" | cut -d ':' -f 6)
    tar -cvzf "${USER_HOME}.tar.gz" "${USER_HOME}"
fi

exit 0
