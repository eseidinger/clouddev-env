#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

mkdir -p ~/tools/cosign
wget  -q -P ~/ https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${ARCH}
mv ~/cosign-linux-${ARCH} ~/tools/cosign/cosign
chmod +x ~/tools/cosign/cosign
