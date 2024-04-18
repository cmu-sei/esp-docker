#!/bin/bash

# check that values present for user and group id
if [ "${UID}" -eq "0" ] || [ -z "$GID" ] ; then
    echo "Add -e UID=\$(id -u) -e GID=\$(id -g) to your docker run command."
    exit 1
fi
echo "Changing UID and GID for espuser to host values."
usermod -d /tmp/home/espuser espuser
usermod -u ${UID} espuser
groupmod -g ${GID} espuser
usermod -d /home/espuser espuser

echo "Setting permissions. This can take a few minutes."
chown espuser:espuser /home/espuser
chown espuser:espuser /home/espuser/.bash_aliases
chown -R espuser:espuser /home/espuser/env
chown    espuser:espuser /home/espuser/esp
chown -R espuser:espuser /home/espuser/esp/.cache
chown -R espuser:espuser /home/espuser/esp/accelerators
chown -R espuser:espuser /home/espuser/esp/socs
chown -R espuser:espuser /home/espuser/esp/soft/ariane/linux/usr
chown -R espuser:espuser /home/espuser/esp/tech
chown -R espuser:espuser /home/espuser/esp/utils
chown -R espuser:espuser /home/espuser/work

# change user
echo "Changing to espuser."
su espuser
