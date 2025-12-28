#!/bin/bash

DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="/opt/scripts/output/last-three-mod-files-${DATE}.out"

mkdir -p /opt/scripts/output

ls -lt /var/log | grep "^-" | head -3 > "${OUTPUT_FILE}"
