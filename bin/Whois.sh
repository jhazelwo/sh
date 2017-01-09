#!/bin/sh
test -z "" && echo "usage: $0 (host|ip)";exit 1
docker run --rm=true -ti danstreeter/whois $1

