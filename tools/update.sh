#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -x

sudo apt-get update
sudo apt-get upgrade -y

# Software development tools
bash ${SCRIPT_DIR}/update_miniconda.sh
bash ${SCRIPT_DIR}/update_go.sh
bash ${SCRIPT_DIR}/install_node.sh
bash ${SCRIPT_DIR}/update_java.sh
# bash ${SCRIPT_DIR}/update_r.sh
# bash ${SCRIPT_DIR}/update_flutter.sh

# Docker tools
bash ${SCRIPT_DIR}/update_docker.sh
bash ${SCRIPT_DIR}/install_trivy.sh
bash ${SCRIPT_DIR}/update_cosign.sh

# Kubernetes tools
bash ${SCRIPT_DIR}/update_microk8s.sh
bash ${SCRIPT_DIR}/update_kind.sh
bash ${SCRIPT_DIR}/update_kubectl.sh
bash ${SCRIPT_DIR}/update_helm.sh
bash ${SCRIPT_DIR}/update_k9s.sh
bash ${SCRIPT_DIR}/update_istio.sh
bash ${SCRIPT_DIR}/update_argocd.sh
bash ${SCRIPT_DIR}/update_tekton.sh

# Provisioning tools
bash ${SCRIPT_DIR}/install_aws_cli.sh --update
bash ${SCRIPT_DIR}/install_azure_cli.sh
bash ${SCRIPT_DIR}/update_terraform.sh
bash ${SCRIPT_DIR}/install_ansible.sh

# Test tools
bash ${SCRIPT_DIR}/update_firefox.sh
bash ${SCRIPT_DIR}/update_zap.sh
bash ${SCRIPT_DIR}/update_sonar_cli.sh
