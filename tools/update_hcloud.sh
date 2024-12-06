#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ~/tools/hcloud
bash ${SCRIPT_DIR}/install_hcloud.sh
