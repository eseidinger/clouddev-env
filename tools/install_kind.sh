#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir ~/tools/kind

ARCH="$(dpkg --print-architecture)"

curl -Lo ~/tools/kind/kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-${ARCH}
chmod +x ~/tools/kind/kind
