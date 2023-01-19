#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

source ~/.bashrc
~/tools/go/bin/go install sigs.k8s.io/kind@v${KIND_VERSION}
