#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir ~/tools/kind

# for Intel Linux
[ $(uname -m) = x86_64 ] && curl -Lo ~/tools/kind/kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64
# for M1 / ARM Linux
[ $(uname -m) = arm64 ] && curl -Lo ~/tools/kind/kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-arm64
chmod +x ~/tools/kind/kind
