#!/bin/bash
# by github.com/cttskr/dotfiles
# original by stackoverflow.com/users/88411/simon

echo
echo "  \${@}     arguments called with ____  ${@}"
echo "  \${1}     \$1 _______________________  ${1}"
echo "  \${2}     \$2 _______________________  ${2}"
echo "  \${0}     path to me _______________  ${0}"
echo "  \${0%/*}  parent path ______________  ${0%/*}"
echo "  \${0##*/} my name __________________  ${0##*/}"
echo
