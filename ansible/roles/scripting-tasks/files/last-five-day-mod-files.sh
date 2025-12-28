#!/bin/bash

DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="/opt/scripts/output/last-five-day-mod-files-${DATE}.out"

mkdir -p /opt/scripts/output

find /var/log -type f -mtime -5 > "${OUTPUT_FILE}"
