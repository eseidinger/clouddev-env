#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

mkdir -p ~/tools/linkerd
wget -q -P ~/tools/linkerd/ https://github.com/linkerd/linkerd2/releases/download/stable-${LINKERD_VERSION}/linkerd2-cli-stable-${LINKERD_VERSION}-linux-${ARCH}
mv ~/tools/linkerd/linkerd2-cli-stable-${LINKERD_VERSION}-linux-${ARCH} ~/tools/linkerd/linkerd
chmod 755 ~/tools/linkerd/linkerd
