#!/bin/sh
set -e

BACKUP_DIR="${1:-.}"
ARCHIVE_TAR="$BACKUP_DIR/backup_wsl2_$USER.tar"

echo "Start backup user environment: $ARCHIVE_TAR"

mkdir -p "$BACKUP_DIR"
tar -C ~ -cf $ARCHIVE_TAR \
    -T "$(dirname "${0}")/../backup_user.txt"
find ~/work -name 'gitconfig*.inc' -exec \
     tar --transform "s|home/$USER/||" -rf $ARCHIVE_TAR {} \;

echo 'Finished backup user environment'
