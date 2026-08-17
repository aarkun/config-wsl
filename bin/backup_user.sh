#!/bin/sh
set -e

if [ $# -ne 1 ]; then
    printf "ERROR: Wrong number of arguments!\nUsage: %s <backup_dir>\n" "${0}"
    exit 1
fi
BACKUP_DIR="${1}"

echo "Start backup user environment into: $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"
tar -C ~ -cf "$BACKUP_DIR/backup_wsl2_$USER.tar" \
    -T "$(dirname "${0}")/../backup_user.txt"

echo 'Finished backup user environment'
