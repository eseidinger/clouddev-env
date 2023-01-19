#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

apt-get update && apt-get install -y --allow-downgrades kubectl=${KUBECTL_VERSION}
