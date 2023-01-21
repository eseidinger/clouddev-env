#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH=
dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in \
    amd64) ARCH='x86_64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
esac

mkdir -p ~/tools/k9s
wget  -q -P ~/ https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${ARCH}.tar.gz
tar -C ~/tools/k9s -xzf ~/k9s_Linux_${ARCH}.tar.gz
rm ~/k9s_Linux_${ARCH}.tar.gz
