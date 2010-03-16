#!/bin/sh

DATE=$(date +%Y%m%dT%H%M%S)
dpkg --get-selections > dpkg-${DATE}.selections
cp -fu dpkg-${DATE}.selections latest-selections

