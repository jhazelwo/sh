#!/bin/sh
nice -n 19 cat /dev/urandom | hexdump -C | grep --color "ca fe"
