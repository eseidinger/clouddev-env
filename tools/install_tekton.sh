#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH=
dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in \
    amd64) ARCH='x86_64';; \
    arm64) ARCH='aarch64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
esac

mkdir -p ~/tools/tekton
wget  -q -P ~/ https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_${ARCH}.tar.gz
tar xvzf ~/tkn_${TEKTON_VERSION}_Linux_${ARCH}.tar.gz -C ~/tools/tekton tkn
rm ~/tkn_${TEKTON_VERSION}_Linux_${ARCH}.tar.gz
chmod +x ~/tools/tekton/tkn
