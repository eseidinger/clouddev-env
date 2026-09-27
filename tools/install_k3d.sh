#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/bin
mkdir -p ~/tools/k3d

ARCH="$(dpkg --print-architecture)"

curl -Lo ~/tools/k3d/k3d https://github.com/k3d-io/k3d/releases/download/v${K3D_VERSION}/k3d-linux-${ARCH}
chmod +x ~/tools/k3d/k3d
rm -f ~/bin/k3d
ln -s ~/tools/k3d/k3d ~/bin/k3d