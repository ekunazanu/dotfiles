#!/usr/bin/sh

DFREE=$(df -h / | awk 'NR==2 {print $4}')
echo "$DFREE"
echo "$DFREE"
[ ${DFREE%?} -le 10 ] && exit 33
[ ${DFREE%?} -le 30 ] && echo "#f18e91"
exit 0
