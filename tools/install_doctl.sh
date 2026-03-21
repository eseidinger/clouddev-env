#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/bin
mkdir -p ~/tools/doctl

wget -q -P ~/ https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-$(dpkg --print-architecture).tar.gz
tar -zxf ~/doctl-${DOCTL_VERSION}-linux-$(dpkg --print-architecture).tar.gz -C ~/tools/doctl/
rm ~/doctl-${DOCTL_VERSION}-linux-$(dpkg --print-architecture).tar.gz
rm -f ~/bin/doctl
ln -s ~/tools/doctl/doctl ~/bin/doctl