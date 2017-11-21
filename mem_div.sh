#!/bin/bash

USERLIST=$(ps -ef --no-headers | awk '{ if($4>25){printf("%s\n", $1)}}' | sort -u | grep -v -E 'admin|avahi|daemon|Debian|message+|root|statd')

#$(ps hauxr | awk '{ print $1 }' | sort -u)

for u in ${USERLIST}
do
    ps -ef --no-headers | awk '{ if($4>25){ printf("%s\n", $1)} }' | grep "$u" | wc -l | awk  -v name=$u '{ printf "%s %d\t", name, $1}'
done
