#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

mkdir -p ~/tools/kubectl
wget -q -P ~/ https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl
mv ~/kubectl ~/tools/kubectl/kubectl
chmod +x ~/tools/kubectl/kubectl
