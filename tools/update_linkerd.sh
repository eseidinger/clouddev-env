#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ~/tools/linkerd
bash ${SCRIPT_DIR}/install_linkerd.sh
