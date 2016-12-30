#!/bin/sh
#
# locker(.sh) -- Safely create a lockfile.
#
# Usage:
# locker PID /path/to/lockfile create
#
# Example:
# /path/to/locker.sh $$ /var/run/.myscript-lock create
#
# This is a more realistic example that will exit using locker's exit value.
# ./locker.sh $$ /tmp/my.lock create || exit $?
#
# Info:
# This script is meant to be called by other scripts. It is the job of the 
# caller to check the return/exit value "$?" of this script. This script is
# not designed to provide human-readable errors.
# When called with the 'create' option you must provide the PID of the script
# that calls this one. It's usually going to be '$$'
#
# Return values (NO ERROR MESSAGES GIVEN BY THIS PROGRAM):
# 0 [OK] Lock file created
# 1 [BAD] Failed to take requested action (indicates larger problem)
# 2 [BAD] Improper call, missing, malformed or duplicated argument given.
# 3 [BAD] Lock file already exists and the PID in the lock file is running.
# 4 [BAD] unable to write to lock file.
# 5 [BAD] The lock file ($2) exists and locker cannot write to it.
# 6 [BAD] The lock file exists and is empty.
# 
#
NAME=$1
FILE=$2
ACTION=$3
umask 0077
if [ "${NAME}" -a "${FILE}" -a "${ACTION}" ]; then
   if [ "${ACTION}" = "create" ]; then
       if [ -f ${FILE} ]; then
       #lock file exists
           #Check for write access to file.
           touch ${FILE} || exit 5
           if [ "`egrep '^[0-9]+$' ${FILE}`" ]; then
               #There is a PID in the lock file, get it.
               PROCSTAT="/proc/`egrep '^[0-9]+$' ${FILE}|head -1`/status"
           else
               #There is no PID in the lock file.
               exit 6
           fi
           if [ -f ${PROCSTAT} ]; then
               #Something with that PID is running
               exit 3
           fi
       fi
       #Write PID to lockfile
       echo "${NAME}" > ${FILE} || exit 4
       exit 0
   fi
else
   exit 2
fi
#If all else fails (or doesn't fail as expected) then
exit 1
