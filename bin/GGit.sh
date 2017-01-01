#!/bin/sh -ex
git add -A .
git commit -m "`TZ=UTC date`"
git push -u origin master

