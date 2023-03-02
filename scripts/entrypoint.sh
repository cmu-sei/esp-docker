#!/bin/bash

# check that values present for user id
if [ -z "${UID}" ]; then
    echo "Add -e UID=\$(id -u) to your docker run command."
    exit 1
fi
echo "Changing UID for espuser to host UID. This can take a few minutes."
usermod -u ${UID} espuser
echo "Setting permissions."
chown -R espuser:espuser /home/espuser

# change user
echo "Changing to espuser."
su espuser
