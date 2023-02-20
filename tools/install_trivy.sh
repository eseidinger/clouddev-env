#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

ARCH=
dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in \
    amd64) ARCH='64bit';; \
    arm64) ARCH='ARM64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
esac

FILENAME="trivy_${TRIVY_VERSION}_Linux-${ARCH}.deb"
URL="https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/${FILENAME}"

wget -q -P ~/ ${URL}
${SUDO} dpkg -i ~/${FILENAME}
${SUDO} apt-get install -f
rm ~/${FILENAME}
