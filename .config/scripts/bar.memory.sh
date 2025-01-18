#!/usr/bin/sh

MFREE=$(free -m | awk 'NR==2 {print $7}')
echo "${MFREE}M"
echo "${MFREE}M"
[ $MFREE -le 500 ] && exit 33
[ $MFREE -le 1000 ] && echo "#f18e91"
exit 0
