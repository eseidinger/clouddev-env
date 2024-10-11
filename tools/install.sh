#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

username=$1

set -x

mkdir ~/tools

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y jq zip unzip wget build-essential

# App requirements
bash ${SCRIPT_DIR}/install_psycopg_requirements.sh
bash ${SCRIPT_DIR}/install_cypress_requirements.sh

# Software development tools
bash ${SCRIPT_DIR}/install_miniconda.sh
bash ${SCRIPT_DIR}/install_node.sh
bash ${SCRIPT_DIR}/install_java.sh

# Docker tools
bash ${SCRIPT_DIR}/install_docker.sh
bash ${SCRIPT_DIR}/config_docker.sh
bash ${SCRIPT_DIR}/install_trivy.sh
bash ${SCRIPT_DIR}/install_cosign.sh
bash ${SCRIPT_DIR}/config_cosign.sh

# Kubernetes tools
bash ${SCRIPT_DIR}/install_microk8s.sh
bash ${SCRIPT_DIR}/config_microk8s.sh
bash ${SCRIPT_DIR}/install_kind.sh
bash ${SCRIPT_DIR}/config_kind.sh
bash ${SCRIPT_DIR}/install_kubectl.sh
bash ${SCRIPT_DIR}/config_kubectl.sh
bash ${SCRIPT_DIR}/install_helm.sh
bash ${SCRIPT_DIR}/config_helm.sh
bash ${SCRIPT_DIR}/install_k9s.sh
bash ${SCRIPT_DIR}/config_k9s.sh
bash ${SCRIPT_DIR}/install_istio.sh
bash ${SCRIPT_DIR}/config_istio.sh
bash ${SCRIPT_DIR}/install_argocd.sh
bash ${SCRIPT_DIR}/config_argocd.sh
bash ${SCRIPT_DIR}/install_tekton.sh
bash ${SCRIPT_DIR}/config_tekton.sh

# Provisioning tools
bash ${SCRIPT_DIR}/install_aws_cli.sh
bash ${SCRIPT_DIR}/install_azure_cli.sh
bash ${SCRIPT_DIR}/install_terraform.sh
bash ${SCRIPT_DIR}/config_terraform.sh
bash ${SCRIPT_DIR}/install_tofu.sh
bash ${SCRIPT_DIR}/install_ansible.sh

# Test tools
bash ${SCRIPT_DIR}/install_firefox.sh
bash ${SCRIPT_DIR}/install_zap.sh
bash ${SCRIPT_DIR}/config_zap.sh
bash ${SCRIPT_DIR}/install_sonar_cli.sh
bash ${SCRIPT_DIR}/config_sonar_cli.sh
