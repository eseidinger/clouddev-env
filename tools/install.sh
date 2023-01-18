#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

username=$1

set -x

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y jq unzip wget build-essential
sudo bash ${SCRIPT_DIR}/install_docker.sh
sudo bash ${SCRIPT_DIR}/config_docker.sh $username
sudo bash ${SCRIPT_DIR}/install_microk8s.sh
sudo bash ${SCRIPT_DIR}/config_microk8s.sh $username
bash ${SCRIPT_DIR}/install_miniconda.sh
bash ${SCRIPT_DIR}/install_ansible_miniconda.sh
sudo bash ${SCRIPT_DIR}/install_go.sh
bash ${SCRIPT_DIR}/config_go.sh
bash ${SCRIPT_DIR}/install_kind.sh
sudo bash ${SCRIPT_DIR}/install_kubectl.sh
sudo bash ${SCRIPT_DIR}/install_helm.sh
sudo bash ${SCRIPT_DIR}/install_aws_cli.sh
sudo bash ${SCRIPT_DIR}/install_terraform.sh
sudo bash ${SCRIPT_DIR}/install_node.sh
bash ${SCRIPT_DIR}/config_node.sh
