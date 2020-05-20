#!/bin/bash
# Quick and dirty checkin using date for commit name.

git add --all
git commit -m "`date '+%Y-%m-%d %T'`"
git push origin master
