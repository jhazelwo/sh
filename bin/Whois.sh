#!/bin/sh
test -z "$1" && { echo "usage: $0 (host|ip)";exit 1;}
docker run --rm=true -ti danstreeter/whois $1

