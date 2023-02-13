#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -x

sudo apt-get update
sudo apt-get upgrade -y
sudo bash ${SCRIPT_DIR}/update_docker.sh
sudo bash ${SCRIPT_DIR}/update_microk8s.sh
bash ${SCRIPT_DIR}/update_miniconda.sh
bash ${SCRIPT_DIR}/update_ansible_miniconda.sh
bash ${SCRIPT_DIR}/update_go.sh
bash ${SCRIPT_DIR}/update_kind.sh
sudo bash ${SCRIPT_DIR}/update_kubectl.sh
bash ${SCRIPT_DIR}/update_helm.sh
sudo bash ${SCRIPT_DIR}/update_aws_cli.sh
bash ${SCRIPT_DIR}/update_terraform.sh
bash ${SCRIPT_DIR}/update_node.sh
bash ${SCRIPT_DIR}/update_k9s.sh
bash ${SCRIPT_DIR}/update_java.sh
