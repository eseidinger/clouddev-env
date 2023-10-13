#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH=
dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in \
    amd64) ARCH='x86_64';; \
    *) echo "unsupported architecture"; exit 0 ;; \
esac

mkdir -p ~/tools
wget  -q -P ~/ https://ftp.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/linux-${ARCH}/en-US/firefox-${FIREFOX_VERSION}.tar.bz2
tar -C ~/tools -xjf ~/firefox-${FIREFOX_VERSION}.tar.bz2
rm ~/firefox-${FIREFOX_VERSION}.tar.bz2
