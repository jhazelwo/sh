#!/bin/sh
# Blindly discard cache and upgrade this host.
# For use on cattle only.
#
test -x /usr/bin/apt-get && {
  sudo /usr/bin/apt-get clean && \
    sudo /usr/bin/apt-get update && \
    sudo /usr/bin/apt-get -y upgrade
  exit $?
}
test -x /usr/bin/yum && {
  sudo /usr/bin/yum -y clean all && \
    sudo /usr/bin/yum -y upgrade
  exit $?
}
exit 1
