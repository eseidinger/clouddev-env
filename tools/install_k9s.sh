#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/tools/k9s
wget  -q -P ~/ https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_$(uname -m).tar.gz
tar -C ~/tools/k9s -xzf ~/k9s_Linux_$(uname -m).tar.gz
rm ~/k9s_Linux_$(uname -m).tar.gz

echo "export PATH=\"\${HOME}/tools/k9s:\${PATH}\"" >> ~/.bashrc
