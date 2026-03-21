#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/bin
mkdir -p ~/tools/helm

wget -q -P ~/ https://get.helm.sh/helm-v${HELM_VERSION}-linux-$(dpkg --print-architecture).tar.gz
tar -zxf ~/helm-v${HELM_VERSION}-linux-$(dpkg --print-architecture).tar.gz -C ~/
rm ~/helm-v${HELM_VERSION}-linux-$(dpkg --print-architecture).tar.gz
mv ~/linux-$(dpkg --print-architecture)/helm ~/tools/helm/helm
rm -rf ~/linux-$(dpkg --print-architecture)
rm -f ~/bin/helm
ln -s ~/tools/helm/helm ~/bin/helm
