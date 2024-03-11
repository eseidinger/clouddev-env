#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

rm -rf ~/tools/kubectl
bash ${SCRIPT_DIR}/install_kubectl.sh
