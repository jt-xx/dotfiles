#!/bin/sh

DATE=$(date +%Y%m%dT%H%M%S)
HOSTNAME=$(hostname)
INSTANT_SELECTION="dpkg-${DATE}.selections"
LATEST_SELECTION="${HOSTNAME}.latest-selections"

echo "# ${HOSTNAME} ${DATE}" > ${INSTANT_SELECTION}
dpkg --get-selections >> ${INSTANT_SELECTION}
cp -fu ${INSTANT_SELECTION} ${LATEST_SELECTION}

