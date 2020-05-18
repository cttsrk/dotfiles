#!/bin/bash
# Quick installer script for a bunch of utils on Ubuntu/Debian/other apt-based distros.
# 
# Dependencies: bash, apt, awk, xargs
if ! [ -x "$(command -v apt)" ]; then
  echo "Error: This does not look like an apt system." >&2
  exit 1
fi

if ! [ $(id -u) = 0 ]; then
   echo "This script needs root!" >&2
   exit 1
fi

install_packages () {
	for i in $list; do
		if ! apt-cache show $i > /dev/null 2>&1
		then
			echo "Package $i does not exist" >&2
		else	
			packages="$packages $i"
		fi
	done
	apt-get install $packages
}

# Build command and pivot to package list
list=`awk "/#PackageListDivider/{y=1;next}y" ${0} | xargs`; install_packages $list ; exit
#PackageListDivider -- package names go below this divider
curl
git
man-db
neovim
python
screen
tmux
wget
aoeusnthaoeu
findutils
nmap
tree
vagrant
