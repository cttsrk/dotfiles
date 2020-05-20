#!/bin/bash
# Quick and dirty checkin using date for commit name.

git add --all
git commit -m "quickcommit `date '+%Y-%m-%d %T'`"
git push origin master
