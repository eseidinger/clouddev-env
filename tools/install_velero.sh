#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

mkdir -p ~/bin
mkdir -p ~/tools
wget  -q -P ~/ https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-${ARCH}.tar.gz
tar -xzf ~/velero-v${VELERO_VERSION}-linux-${ARCH}.tar.gz -C ~/tools/
mv ~/tools/velero-v${VELERO_VERSION}-linux-${ARCH} ~/tools/velero
rm ~/velero-v${VELERO_VERSION}-linux-${ARCH}.tar.gz
chmod +x ~/tools/velero/velero
rm -f ~/bin/velero
ln -s ~/tools/velero/velero ~/bin/velero