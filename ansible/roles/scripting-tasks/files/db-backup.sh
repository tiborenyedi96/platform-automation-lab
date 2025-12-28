#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_DIR="/opt/scripts/backups/${DATE}"

mkdir -p "${BACKUP_DIR}"

MYSQL_POD=$(kubectl get pods -n udemx -l app=incident-logger-mysql -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$MYSQL_POD" ]; then
    echo "ERROR: MySQL pod not found" >&2
    exit 1
fi

kubectl exec -n udemx ${MYSQL_POD} -- mysqldump -u root -prootpassword udemx_db > "${BACKUP_DIR}/backup.sql" 2>/dev/null

gzip "${BACKUP_DIR}/backup.sql"
