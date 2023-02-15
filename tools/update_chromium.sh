#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ~/tools/chrome-linux
bash ${SCRIPT_DIR}/install_chromium.sh
