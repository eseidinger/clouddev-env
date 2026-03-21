#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/bin
mkdir -p ~/tools/hcloud

wget -q -P ~/ https://github.com/hetznercloud/cli/releases/download/v${HCLOUD_VERSION}/hcloud-linux-$(dpkg --print-architecture).tar.gz
tar -zxf ~/hcloud-linux-$(dpkg --print-architecture).tar.gz -C ~/tools/hcloud/
rm ~/hcloud-linux-$(dpkg --print-architecture).tar.gz
rm -f ~/bin/hcloud
ln -s ~/tools/hcloud/hcloud ~/bin/hcloud
