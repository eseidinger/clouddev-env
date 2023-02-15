#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH=
dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in \
    amd64) ARCH='Linux_x64'; REVISION=${CHROMIUM_X64_REVISION};; \
    arm64) ARCH='Arm'; REVISION=${CHROMIUM_ARM_REVESION};; \
    *) echo "unsupported architecture"; exit 1 ;; \
esac


ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/${ARCH}%2F${REVISION}%2Fchrome-linux.zip?alt=media"

curl -s ${ZIP_URL} -o ~/chrome-linux.zip
unzip ~/chrome-linux.zip -d ~/tools
rm ~/chrome-linux.zip
