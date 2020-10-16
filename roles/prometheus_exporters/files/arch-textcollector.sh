#!/bin/bash

set -o errexit
set -o nounset

if (( $# != 1 )); then
  echo "Missing textcollector directory argument"
  exit 1
fi

TEXTFILE_COLLECTOR_DIR=${1}
PROM_FILE=$TEXTFILE_COLLECTOR_DIR/pacman.prom

TMP_FILE=$PROM_FILE.$$
[ -e $TMP_FILE ] && rm -f $TMP_FILE

trap "rm -f $TMP_FILE" EXIT

updates=$(/usr/bin/checkupdates | wc -l)
secupdates=$(/usr/bin/arch-audit -u | wc -l)

echo "# HELP pacman_updates_pending number of pending updates from pacman" >> $TMP_FILE
echo "# TYPE pacman_updates_pending gauge" >> $TMP_FILE
echo "pacman_updates_pending $updates" >> $TMP_FILE

echo "# HELP pacman_security_updates_pending number of pending updates from pacman" >> $TMP_FILE
echo "# TYPE pacman_security_updates_pending gauge" >> $TMP_FILE
echo "pacman_security_updates_pending $secupdates" >> $TMP_FILE

mv -f $TMP_FILE $PROM_FILE
