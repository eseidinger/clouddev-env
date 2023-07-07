#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

wget -q -P ~/tools/ https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
tar -C ~/tools/ -xzf ~/tools/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
rm ~/tools/istio-${ISTIO_VERSION}-linux-${ARCH}.tar.gz
mv ~/tools/istio-${ISTIO_VERSION} ~/tools/istio
