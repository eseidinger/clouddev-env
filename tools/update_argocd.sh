#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ~/tools/argocd
bash ${SCRIPT_DIR}/argocd_cosign.sh
