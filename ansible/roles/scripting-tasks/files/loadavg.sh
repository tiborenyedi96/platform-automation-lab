#!/bin/bash

DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOAD=$(cat /proc/loadavg | awk '{print $1, $2, $3}')

echo "${TIMESTAMP} | Load: ${LOAD}" >> /var/log/loadavg-${DATE}.out
