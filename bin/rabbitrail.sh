#!/bin/sh
#
# rabbitrail.sh -- Follow the Rabbit Trail
#
# Build a PID list starting with $1 following
# parents back to `init` and display as a forest.
#
# NOT compat with Solaris.
#
test -z "$1" && exit 1

index=$1
list=$index
while [ $index -gt 1 ]; do
    #Parent of given ($index) is this:
    ppid="`ps -p $index -o ppid --no-headers --forest | awk '{print $1}'`"
    #Add this ppid to list.
    list="${list} ${ppid}"
    #Update index.
    index=${ppid}
done
#Display the process tree from init to $1:
ps -o uid,pid,ppid,etime,stime,tty,cmd -p "${list}" --forest
