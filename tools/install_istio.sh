#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

wget -q -P ~/ https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
tar -xzf ~/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
rm ~/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
mv istio-${ISTIO_VERSION} ~/tools/istio
