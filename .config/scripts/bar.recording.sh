#!/usr/bin/sh

pgrep wf-recorder > /dev/null 2>&1 && echo "●" && echo "●" && echo "#f18e91"
exit 0
