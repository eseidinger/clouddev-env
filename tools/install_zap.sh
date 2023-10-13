#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/tools
wget  -q -P ~/ https://github.com/zaproxy/zaproxy/releases/download/v${ZAP_VERSION}/ZAP_${ZAP_VERSION}_Linux.tar.gz
tar -C ~/tools -xzf ~/ZAP_${ZAP_VERSION}_Linux.tar.gz
mv ~/tools/ZAP_${ZAP_VERSION} ~/tools/zap
rm ~/ZAP_${ZAP_VERSION}_Linux.tar.gz
