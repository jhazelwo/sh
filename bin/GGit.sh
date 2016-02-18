#!/bin/sh -ex
git add -A .
git commit -m "$(date)"
git push -u origin master

