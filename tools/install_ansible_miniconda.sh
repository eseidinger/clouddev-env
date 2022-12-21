#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

source ~/miniconda3/bin/activate base
pip3 install ansible==${ANSIBLE_VERSION}
